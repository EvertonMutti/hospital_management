from sqlalchemy.orm import Session

from project.shared.datasource.patient import PatientDataSource


class PatientService:

    def __init__(self, session: Session,
                 patient_data_source: PatientDataSource):
        self.db = session
        self.patient_data_source: PatientDataSource = patient_data_source(
            session)

    def get_unadmitted_patients(self, tax_number: str):
        return self.patient_data_source.get_unadmitted_patients(tax_number)
