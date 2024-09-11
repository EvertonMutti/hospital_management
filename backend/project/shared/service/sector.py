import logging
from typing import List
from sqlalchemy.orm import Session
from project.hospital_management.schemas.sector import SectorCreate, SectorUpdate
from project.shared.datasource.sector import SectorDataSource
from project.shared.entities.entities import Sector
from project.shared.exceptions.exceptions import ServiceUnavailableException

logger = logging.getLogger(__name__)

class SectorService:

    def __init__(self, session: Session, sector_data_source: SectorDataSource):
        self.db = session
        self.sector_data_source = sector_data_source(session)
        
    def get_all_sectors(self) -> List[Sector]:
        try:
            return self.db.query(Sector).all()
        except Exception as e:
            logger.error(f"Error fetching all sectors: {e}")
            raise

    def create_sector(self, sector_create: SectorCreate):
        try:
            sector = self.sector_data_source.create_sector(sector_create)
            logger.info(f"Created sector: {sector}")
            return sector
        except Exception as e:
            logger.error(f"Error creating sector: {e}")
            raise ServiceUnavailableException()

    def get_sector(self, sector_id: int):
        try:
            sector = self.sector_data_source.get_sector_by_id(sector_id)
            if not sector:
                raise ServiceUnavailableException(f"Sector with id {sector_id} not found")
            logger.info(f"Fetched sector: {sector}")
            return sector
        except Exception as e:
            logger.error(f"Error fetching sector: {e}")
            raise ServiceUnavailableException()

    def update_sector(self, sector_id: int, sector_update: SectorUpdate):
        try:
            sector = self.get_sector(sector_id)
            sector_updated = self.sector_data_source.update_sector(sector, sector_update)
            logger.info(f"Updated sector: {sector_updated}")
            return sector_updated
        except Exception as e:
            logger.error(f"Error updating sector: {e}")
            raise ServiceUnavailableException()

    def delete_sector(self, sector_id: int):
        try:
            sector = self.get_sector(sector_id)
            self.sector_data_source.delete_sector(sector)
            logger.info(f"Deleted sector with id: {sector_id}")
        except Exception as e:
            logger.error(f"Error deleting sector: {e}")
            raise ServiceUnavailableException()
