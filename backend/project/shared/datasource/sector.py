# datasource/sector.py
import logging

from sqlalchemy.orm import Session, aliased

from project.shared.entities.entities import Hospital, Sector
from project.shared.enum.enums import SectorStatus
from project.shared.schemas.sector import SectorCreate, SectorUpdate

logger = logging.getLogger(__name__)


class SectorDataSource:

    def __init__(self, db: Session):
        self.db = db

    def get_all_sectors(self, tax_number: str):
        SectorAlias = aliased(Sector)
        return (self.db.query(SectorAlias).join(
            Hospital, Hospital.id == SectorAlias.hospital_id).filter(
                Hospital.tax_number == tax_number)
            .filter(
                    SectorAlias.status != SectorStatus.DELETED).all())

    def create_sector(self, sector_create: SectorCreate, hospital: Hospital):
        try:
            sector = Sector(name=sector_create.name, hospital_id=hospital.id)
            self.db.add(sector)
            self.db.commit()
            self.db.refresh(sector)
            return sector
        except Exception as e:
            logger.error(f"Error creating sector: {e}")
            self.db.rollback()
            raise

    def get_sector_by_id_and_tax_number(self, sector_id: int, tax_number: str):
        SectorAlias = aliased(Sector)
        return (self.db.query(SectorAlias).join(
            Hospital, Hospital.id == SectorAlias.hospital_id).filter(
                Hospital.tax_number == tax_number).filter(
                    SectorAlias.id == sector_id)
                .filter(
                    SectorAlias.status != SectorStatus.DELETED).first())

    def update_sector(self, sector: Sector, sector_update: SectorUpdate):
        for field, value in sector_update.dict().items():
            setattr(sector, field, value)
        self.db.add(sector)
        self.db.commit()
        self.db.refresh(sector)
        return sector

    def delete_sector(self, sector: Sector):
        sector.status = SectorStatus.DELETED
        self.db.add(sector)
        self.db.commit()
