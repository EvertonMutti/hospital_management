import logging
from typing import Optional

from sqlalchemy.orm import Session

from project.shared.entities.entities import Admission, Bed, Hospital, Sector
from project.shared.utils.retry import RetryBase

logger = logging.getLogger(__name__)


class AdmissionDataSource(RetryBase):

    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, admission_id: int,
                  tax_number: str) -> Optional[Admission]:
        return (self.db.query(Admission).join(Bed).join(Sector).join(
            Hospital).filter(Hospital.tax_number == tax_number).filter(
                Admission.id == admission_id).first())

    def get_open_admission_by_bed_id(self, bed_id: int,
                                     tax_number: str) -> Optional[Admission]:
        return (self.db.query(Admission).join(Bed).join(Sector).join(
            Hospital).filter(Bed.id == bed_id).filter(
                Admission.discharge_date.is_(None)).filter(
                    Hospital.tax_number == tax_number).first())

    def get_admissions_by_bed_id(self, bed_id: int):
        return self.db.query(Admission).filter(
            Admission.bed_id == bed_id).all()
