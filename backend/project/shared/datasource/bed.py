import logging
from collections import defaultdict
from typing import Optional

from sqlalchemy import func
from sqlalchemy.orm import Session, aliased

from project.shared.entities.entities import Bed, Hospital, Sector
from project.shared.enum.enums import BedStatus, SectorStatus  # type: ignore
from project.shared.schemas.bed import BedCreate, BedUpdate
from project.shared.utils.retry import RetryBase

logger = logging.getLogger(__name__)


class BedDataSource(RetryBase):

    def __init__(self, db: Session):
        self.db = db

    def count_beds_by_status(self, tax_number):
        counts = {status: 0 for status in BedStatus}
        try:
            query = (self.db.query(Bed.status, func.count(
                Bed.id)).join(Sector).join(Hospital).group_by(
                    Bed.status).filter(
                        Hospital.tax_number == tax_number).filter(
                            Bed.status != BedStatus.DELETED).filter(
                                Sector.status != SectorStatus.DELETED).all())

            for status, count in query:
                if status in counts:
                    counts[status.value] = count

            return counts
        except Exception as e:
            logger.error(f"Error counting beds by status: {e}")
            raise
    
    def get_beds_by_tax_number(self, tax_number: str):
        return (self.db.query(Bed)
                .join(Sector).join(Hospital)
                .filter(Hospital.tax_number == tax_number).all())

    def get_beds_grouped_by_sector(self, tax_number: str):
        BedAlias = aliased(Bed)
        SectorAlias = aliased(Sector)
        query = (self.db.query(SectorAlias.name, BedAlias).join(
            BedAlias, BedAlias.sector_id == SectorAlias.id).join(
                Hospital, SectorAlias.hospital_id ==
                Hospital.id).filter(Hospital.tax_number == tax_number).filter(
                    BedAlias.status != BedStatus.DELETED).order_by(
                        SectorAlias.name).filter(
                            SectorAlias.status != SectorStatus.DELETED).all())
        grouped_beds = defaultdict(list)
        for sector_name, bed in query:
            grouped_beds[sector_name].append({
                "id": bed.id,
                "bed_number": bed.bed_number,
                "status": bed.status.name,
                "sector_id": bed.sector_id
            })

        result = [{
            "sector_name": sector_name,
            "beds": beds
        } for sector_name, beds in grouped_beds.items()]

        return result

    def get_beds_by_sector(self, tax_number: str, sector_id: str):
        return (self.db.query(Bed).join(Sector).join(Hospital).filter(
            Hospital.tax_number == tax_number).filter(
                Sector.id == sector_id).filter(
                    Bed.status != BedStatus.DELETED).filter(
                        Sector.status != SectorStatus.DELETED).order_by(
                            Sector.name).all())

    def create_bed(self, bed_create: BedCreate):
        try:
            bed = Bed(bed_number=bed_create.bed_number,
                      sector_id=bed_create.sector_id,
                      status=BedStatus.FREE)
            self.db.add(bed)
            self.db.commit()
            self.db.refresh(bed)
            return bed
        except Exception as e:
            logger.error(f"Error creating bed: {e}")
            self.db.rollback()
            raise

    def get_bed_by_id_and_tax_number(self, bed_id: int,
                                     tax_number: str) -> Optional[Bed]:
        return (self.db.query(Bed)
                .join(Sector).join(Hospital).filter(Hospital.tax_number == tax_number)
                .filter(Bed.id == bed_id).filter(
                    Bed.status != BedStatus.DELETED).filter(
                        Sector.status != SectorStatus.DELETED).first())

    def update_bed(self, bed: Bed, bed_update: BedUpdate):
        for field, value in bed_update.model_dump().items():
            setattr(bed, field, value)
        self.db.add(bed)
        self.db.commit()
        self.db.refresh(bed)
        return bed

    def delete_bed(self, bed: Bed):
        bed.status = BedStatus.DELETED
        self.db.add(bed)
        self.db.commit()
