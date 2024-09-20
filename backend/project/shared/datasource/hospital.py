import logging
from typing import List, Optional

from sqlalchemy.orm import Session

from project.shared.entities.entities import Client, Hospital
from project.shared.schemas.hospital import HospitalCreate

logger = logging.getLogger(__name__)


class HospitalDataSource:

    def __init__(self, db: Session):
        self.db: Session = db

    def create_hospital(self, hospital: HospitalCreate) -> Hospital:
        new_hospital = Hospital(**hospital.__dict__)
        self.db.add(new_hospital)
        self.db.commit()
        self.db.refresh(new_hospital)
        logger.info(f"Hospital created: {new_hospital.name}")
        return new_hospital

    def get_hospital_by_id(self, hospital_id: int) -> Optional[Hospital]:
        return self.db.query(Hospital).filter(
            Hospital.id == hospital_id).first()

    def get_hospital_by_unique_code(self,
                                    unique_code: str) -> Optional[Hospital]:
        return self.db.query(Hospital).filter(
            Hospital.unique_code == unique_code).first()

    def get_hospital_by_tax_number(self,
                                   tax_number: str) -> Optional[Hospital]:
        return self.db.query(Hospital).filter(
            Hospital.tax_number == tax_number).first()

    def get_hospitals(self, user_id: int) -> List[Hospital]:
        return self.db.query(Hospital).join(
            Client.hospitals).filter(Client.id == user_id).all()
