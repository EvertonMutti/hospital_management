# datasource/sector.py
import logging

from sqlalchemy.orm import Session

from project.shared.entities.entities import Sector
from project.shared.schemas.sector import SectorCreate, SectorUpdate

logger = logging.getLogger(__name__)


class SectorDataSource:

    def __init__(self, db: Session):
        self.db = db

    def get_all_sectors(self):
        return self.db.query(Sector).all()

    def create_sector(self, sector_create: SectorCreate):
        try:
            sector = Sector(name=sector_create.name,
                            hospital_id=sector_create.hospital_id)
            self.db.add(sector)
            self.db.commit()
            self.db.refresh(sector)
            return sector
        except Exception as e:
            logger.error(f"Error creating sector: {e}")
            self.db.rollback()
            raise

    def get_sector_by_id(self, sector_id: int):
        return self.db.query(Sector).filter(Sector.id == sector_id).first()

    def update_sector(self, sector: Sector, sector_update: SectorUpdate):
        for field, value in sector_update.dict().items():
            setattr(sector, field, value)
        self.db.commit()
        self.db.refresh(sector)
        return sector

    def delete_sector(self, sector: Sector):
        self.db.delete(sector)
        self.db.commit()
