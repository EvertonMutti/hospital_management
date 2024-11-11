import logging
from datetime import datetime

from sqlalchemy.orm import Session

from project.shared.datasource.admission import \
    AdmissionDataSource  # type: ignore
from project.shared.datasource.bed import BedDataSource
from project.shared.datasource.sector import SectorDataSource
from project.shared.entities.entities import Admission
from project.shared.enum.enums import BedStatus
from project.shared.exceptions.exceptions import (BedNotFoundException,
                                                  ConflictException,
                                                  SectorNotFoundException,
                                                  ServiceUnavailableException)
from project.shared.schemas.bed import BedCreate, BedUpdate

logger = logging.getLogger(__name__)


class BedService:

    def __init__(self, session: Session, bed_data_source: BedDataSource,
                 admission_data_source: AdmissionDataSource,
                 sector_data_source: SectorDataSource):
        self.db = session
        self.bed_data_source: BedDataSource = bed_data_source(session)
        self.admission_data_source: AdmissionDataSource = admission_data_source(
            session)
        self.sector_data_source: SectorDataSource = sector_data_source(session)

    def calculate_average_free_time(self, tax_number: str):
        beds = self.bed_data_source.get_beds_by_tax_number(tax_number)
        total_free_time = 0
        total_beds = 0

        for bed in beds:
            admissions = self.admission_data_source.get_admissions_by_bed_id(
                bed.id)
            last_discharge_date = None

            for admission in admissions:
                if last_discharge_date:
                    free_time = (admission.admission_date -
                                 last_discharge_date).total_seconds() / 3600
                    total_free_time += free_time
                    total_beds += 1

                last_discharge_date = admission.discharge_date

            if last_discharge_date:
                free_time = (datetime.now() -
                             last_discharge_date).total_seconds() / 3600
                total_free_time += free_time
                total_beds += 1

        average_free_time = total_free_time / total_beds if total_beds > 0 else 0

        average_days = int(average_free_time // 24)
        average_hours = int(average_free_time % 24)

        return {"days": average_days, "hours": average_hours}

    def count_beds_by_status(self, tax_number: str):
        try:
            counts = self.bed_data_source.count_beds_by_status(tax_number)
            logger.info(f"Bed counts by status: {counts}")
            return counts
        except Exception as e:
            logger.error(f"Error fetching bed counts by status: {e}")
            raise ServiceUnavailableException()

    def get_beds_grouped_by_sector(self, tax_number: str):
        try:
            beds_grouped = self.bed_data_source.get_beds_grouped_by_sector(
                tax_number)
            logger.info(f"Beds grouped by sector: {beds_grouped}")
            return beds_grouped
        except Exception as e:
            logger.error(f"Error fetching beds grouped by sector: {e}")
            raise ServiceUnavailableException()

    def create_bed(self, bed_create: BedCreate, tax_number: str):
        try:
            if not self.sector_data_source.get_sector_by_id_and_tax_number(
                    bed_create.sector_id, tax_number):
                raise SectorNotFoundException(
                    f"Setor com id {bed_create.sector_id} não encontrado")
            bed = self.bed_data_source.create_bed(bed_create)
            logger.info(f"Created bed: {bed}")
            return bed
        except SectorNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error creating bed: {e}")
            raise ServiceUnavailableException()

    def get_bed_by_id_and_tax_number(self, bed_id: int, tax_number: str):
        try:
            bed = self.bed_data_source.get_bed_by_id_and_tax_number(
                bed_id, tax_number)
            if not bed:
                raise BedNotFoundException(
                    f"Leito com ID {bed_id} não encontrada")
            logger.info(f"Fetched bed: {bed}")
            return bed
        except BedNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error fetching bed: {e}")
            raise ServiceUnavailableException()

    def update_bed(self, bed_id: int, tax_number: str, bed_update: BedUpdate):
        try:
            bed = self.get_bed_by_id_and_tax_number(bed_id, tax_number)
            bed_updated = self.bed_data_source.update_bed(bed, bed_update)
            logger.info(f"Updated bed: {bed}")
            return bed_updated
        except BedNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error updating bed: {e}")
            raise

    def delete_bed(self, bed_id: int, tax_number: str):
        try:
            bed = self.get_bed_by_id_and_tax_number(bed_id, tax_number)
            self.bed_data_source.delete_bed(bed)
            logger.info(f"Deleted bed with id: {bed_id}")
        except BedNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error deleting bed: {e}")
            raise

    def admit_patient(self, bed_id: int, tax_number: str, patient_id: int):
        try:
            bed = self.get_bed_by_id_and_tax_number(bed_id, tax_number)
            if bed.status == BedStatus.OCCUPIED:
                raise ConflictException(
                    f"Leito {bed.bed_number} já está ocupado")

            admission = Admission(patient_id=patient_id, bed_id=bed_id)
            self.db.add(admission)

            bed.status = BedStatus.OCCUPIED
            self.db.add(bed)
            self.db.commit()

            logger.info(f"Patient {patient_id} admitted to bed {bed_id}")
            return admission
        except ConflictException:
            raise
        except Exception as e:
            logger.error(f"Error admitting patient: {e}")
            raise

    def discharge_patient(self, bed_id: int, tax_number: str) -> Admission:
        try:
            admission = self.admission_data_source.get_open_admission_by_bed_id(
                bed_id, tax_number)
            if not admission or admission.discharge_date:
                raise BedNotFoundException(
                    "Admissão não encontrada ou já foi dada alta")

            admission.discharge_date = datetime.now()

            bed = self.get_bed_by_id_and_tax_number(admission.bed_id,
                                                    tax_number)
            bed.status = BedStatus.CLEANING_REQUIRED

            self.db.add(admission)
            self.db.add(bed)
            self.db.commit()
            logger.info(
                f"Patient {admission.patient_id} discharged from bed {admission.bed_id}"
            )
            return admission
        except Exception as e:
            logger.error(f"Error discharging patient: {e}")
            raise
