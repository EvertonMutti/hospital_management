import logging
from typing import Optional

from sqlalchemy.orm import Session

from project.shared.entities.entities import Admission, Bed, Hospital, Sector

logger = logging.getLogger(__name__)


class AdmissionDataSource:

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
                Hospital.tax_number == tax_number)
                .first())
