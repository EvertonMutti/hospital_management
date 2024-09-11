import logging
from typing import Optional

from sqlalchemy import func
from sqlalchemy.orm import Session

from project.hospital_management.schemas.bed import BedCreate, BedUpdate
from project.shared.entities.entities import Bed, Sector
from project.shared.enum.enums import BedStatus  # type: ignore

logger = logging.getLogger(__name__)


class BedDataSource:

    def __init__(self, db: Session):
        self.db = db

    def count_beds_by_status(self):
        try:
            counts = {status: 0 for status in BedStatus}

            query = (self.db.query(Bed.status, func.count(Bed.id)).group_by(
                Bed.status).all())

            for status, count in query:
                if status in counts:
                    counts[status] = count

            return counts
        except Exception as e:
            logger.error(f"Error counting beds by status: {e}")
            raise

    def get_beds_grouped_by_sector(self):
        try:
            query = (self.db.query(Sector.name, func.count(Bed.id)).join(
                Bed, Bed.sector_id == Sector.id).group_by(Sector.name).all())

            return query
        except Exception as e:
            logger.error(f"Error fetching beds grouped by sector: {e}")
            raise

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

    def get_bed_by_id(self, bed_id: int) -> Optional[Bed]:
        return self.db.query(Bed).filter(Bed.id == bed_id).first()

    def update_bed(self, bed: Bed, bed_update: BedUpdate):
        for field, value in bed_update.model_dump().items():
            setattr(bed, field, value)
        self.db.commit()
        self.db.refresh(bed)
        return bed

    def delete_bed(self, bed: Bed):
        self.db.delete(bed)
        self.db.commit()
