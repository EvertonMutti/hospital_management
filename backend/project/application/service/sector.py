import logging
from typing import List

from sqlalchemy.orm import Session

from project.shared.datasource.bed import BedDataSource
from project.shared.datasource.hospital import HospitalDataSource
from project.shared.datasource.sector import SectorDataSource
from project.shared.entities.entities import Sector
from project.shared.exceptions.exceptions import (ConflictException,
                                                  SectorNotFoundException,
                                                  ServiceUnavailableException)
from project.shared.schemas.sector import SectorCreate, SectorUpdate

logger = logging.getLogger(__name__)


class SectorService:

    def __init__(self, session: Session, sector_data_source: SectorDataSource,
                 hospital: HospitalDataSource, bed_data_source: BedDataSource):
        self.db = session
        self.sector_data_source: SectorDataSource = sector_data_source(session)
        self.hospital: HospitalDataSource = hospital(session)
        self.bed_data_source: BedDataSource = bed_data_source(session)

    def get_all_sectors(self, tax_number: str) -> List[Sector]:
        try:
            sectors = self.sector_data_source.get_all_sectors(tax_number)
            logger.info(f"Sectors obtained: {sectors}")
            return sectors
        except Exception as e:
            logger.error(f"Error fetching all sectors: {e}")
            raise ServiceUnavailableException()

    def create_sector(self, sector_create: SectorCreate, tax_number: str):
        try:
            hospital = self.hospital.get_hospital_by_tax_number(tax_number)
            sector = self.sector_data_source.create_sector(
                sector_create, hospital)
            logger.info(f"Setor criado: {sector}")
            return sector
        except Exception as e:
            logger.error(f"Error creating sector: {e}")
            raise ServiceUnavailableException()

    def get_sector_by_id_and_tax_number(self, sector_id: int, tax_number: str):
        try:
            sector = self.sector_data_source.get_sector_by_id_and_tax_number(
                sector_id, tax_number)
            if not sector:
                raise SectorNotFoundException(
                    f"Setor com id {sector_id} não encontrado")
            logger.info(f"Fetched sector: {sector}")
            return sector
        except SectorNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error fetching sector: {e}")
            raise ServiceUnavailableException()

    def update_sector(self, sector_id: int, tax_number: str,
                      sector_update: SectorUpdate):
        try:
            sector = self.get_sector_by_id_and_tax_number(
                sector_id, tax_number)
            sector_updated = self.sector_data_source.update_sector(
                sector, sector_update)
            logger.info(f"Updated sector: {sector_updated}")
            return sector_updated
        except Exception as e:
            logger.error(f"Error updating sector: {e}")
            raise ServiceUnavailableException()

    def delete_sector(self, sector_id: int, tax_number: str):
        try:
            sector = self.get_sector_by_id_and_tax_number(
                sector_id, tax_number)
            if (self.bed_data_source.get_beds_by_sector(tax_number,
                                                        sector_id)):
                raise ConflictException(
                    "Não é possível excluir o setor com leitos atribuídos ao mesmo."
                )
            self.sector_data_source.delete_sector(sector)
            logger.info(f"Deleted sector with id: {sector_id}")
        except SectorNotFoundException:
            raise
        except Exception as e:
            logger.error(f"Error deleting sector: {e}")
            raise ServiceUnavailableException()
