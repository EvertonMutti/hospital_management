import logging

from sqlalchemy.orm import Session

from project.shared.entities.entities import Patient, Admission, Bed, Hospital, Sector

logger = logging.getLogger(__name__)


class PatientDataSource:

    def __init__(self, db: Session):
        self.db = db

    def get_unadmitted_patients(self, tax_number: str):
        return (self.db.query(Patient).outerjoin(Admission).join(Hospital).filter(
                Hospital.tax_number == tax_number).filter(~Patient.admissions.any(Admission.discharge_date.is_(None)))).all()
