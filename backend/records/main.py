from datetime import datetime
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../')))


from project.shared.enum.enums import BedStatus


from project.hospital_management.settings.database import get_session
from project.shared.entities.entities import Admission, Bed, Hospital, Patient, Sector


hospitals = [
    Hospital(
        name="Hospital Central",
        tax_number="12345678000101",
        address="Rua Principal, 123, Centro",
    ),
    Hospital(
        name="Hospital São Lucas",
        tax_number="98765432000111",
        address="Avenida Secundária, 456, Bairro Novo",
    ),
    Hospital(
        name="Clínica Vida Saudável",
        tax_number="11122233000144",
        address="Rua das Flores, 789, Jardim Alegria",
    )
]

sectors = [
    Sector(name="Cardiologia", hospital_id=1),
    Sector(name="Oncologia", hospital_id=1),
    Sector(name="Pediatria", hospital_id=2),
]

beds = [
    Bed(bed_number="C001", sector_id=1, status=BedStatus.FREE),
    Bed(bed_number="C002", sector_id=1, status=BedStatus.OCCUPIED),
    Bed(bed_number="O001", sector_id=2, status=BedStatus.FREE),
    Bed(bed_number="P001", sector_id=3, status=BedStatus.OCCUPIED),
]

patients = [
    Patient(name="João Silva", tax_number="12345678901"),
    Patient(name="Maria Oliveira", tax_number="98765432100"),
    Patient(name="Pedro Santos", tax_number="11122233344"),
]

admissions = [
    Admission(patient_id=1, bed_id=2, admission_date=datetime(2024, 9, 1)),
    Admission(patient_id=2, bed_id=4, admission_date=datetime(2024, 9, 5)),
    Admission(patient_id=3, bed_id=3, admission_date=datetime(2024, 9, 10)),
]

with next(get_session()) as session:
    session.add_all(hospitals)
    session.add_all(sectors)
    session.add_all(beds)
    session.add_all(patients)
    session.add_all(admissions)
    session.commit()