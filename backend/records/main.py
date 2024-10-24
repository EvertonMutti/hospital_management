from datetime import datetime
import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../')))


from project.shared.enum.enums import BedStatus, PositionEnum, ScopesStatus

from project.shared.security.hash_provider import get_password_hash

from project.hospital_management.settings.database import create_database, get_session
from project.shared.entities.entities import Admission, Bed, Client, Hospital, Patient, Sector, client_hospital
from sqlalchemy import insert


hospitals = [
    Hospital(
        name="Hospital São Lucas",
        tax_number="84777486000169",
        address="Avenida Secundária, 456, Bairro Novo",
    ),
    Hospital(
        name="Clínica Vida Saudável",
        tax_number="98193544000111",
        address="Rua das Flores, 789, Jardim Alegria",
    )
]

sectors = [
    Sector(name="Cardiologia", hospital_id=1),
    Sector(name="Oncologia", hospital_id=1),
    Sector(name="Pediatria", hospital_id=1),
    Sector(name="Emergência", hospital_id=1),
    Sector(name="Neurologia", hospital_id=1),
    Sector(name="Cirurgia Geral", hospital_id=1),
]

beds = [
    Bed(bed_number="C001", sector_id=1, status=BedStatus.FREE),
    Bed(bed_number="C002", sector_id=1, status=BedStatus.FREE),
    Bed(bed_number="O001", sector_id=2, status=BedStatus.FREE),
    Bed(bed_number="O001", sector_id=2, status=BedStatus.FREE),
    Bed(bed_number="P001", sector_id=3, status=BedStatus.FREE),
    Bed(bed_number="P002", sector_id=3, status=BedStatus.FREE),
    Bed(bed_number="E001", sector_id=4, status=BedStatus.FREE),
    Bed(bed_number="E002", sector_id=4, status=BedStatus.FREE),
    Bed(bed_number="N001", sector_id=5, status=BedStatus.FREE),
    Bed(bed_number="N002", sector_id=5, status=BedStatus.FREE),
    Bed(bed_number="G001", sector_id=6, status=BedStatus.FREE),
    Bed(bed_number="G002", sector_id=6, status=BedStatus.FREE),
]

patients = [
    Patient(name="João Silva", tax_number="22366076444", hospital_id=1),
    Patient(name="Maria Oliveira", tax_number="94776522535", hospital_id=1),
    Patient(name="Pedro Santos", tax_number="48818166832", hospital_id=1),
    Patient(name="Ana Costa", tax_number="12345678901", hospital_id=1),
    Patient(name="Lucas Almeida", tax_number="23456789012", hospital_id=1),
    Patient(name="Fernanda Lima", tax_number="34567890123", hospital_id=1),
    Patient(name="Ricardo Fernandes", tax_number="45678901234", hospital_id=1),
    Patient(name="Sofia Souza", tax_number="56789012345", hospital_id=1),
]

# admissions = [
#     Admission(patient_id=1, bed_id=2, admission_date=datetime(2024, 9, 1)),
#     Admission(patient_id=2, bed_id=4, admission_date=datetime(2024, 9, 5), discharge_date=datetime(2024, 9, 10)),
#     Admission(patient_id=3, bed_id=6, admission_date=datetime(2024, 9, 10)),
#     Admission(patient_id=4, bed_id=1, admission_date=datetime(2024, 9, 12)),
#     Admission(patient_id=5, bed_id=2, admission_date=datetime(2024, 9, 15)),
#     Admission(patient_id=6, bed_id=3, admission_date=datetime(2024, 9, 18)),
#     Admission(patient_id=7, bed_id=4, admission_date=datetime(2024, 9, 20)),
# ]

clients = [
    Client(name="Carlos Alberto", email="carlos.admin@example.com", password=get_password_hash("admin123"), phone="11987654321", tax_number="01234567890", position=PositionEnum.NURSE, permission=ScopesStatus.ADMIN),
    Client(name="Juliana Mendes", email="juliana.nurse@example.com", password=get_password_hash("nurse123"), phone="11998765432", tax_number="09876543210", position=PositionEnum.NURSE, permission=ScopesStatus.USER),
    Client(name="Fernando Lima", email="fernando.cleaner@example.com", password=get_password_hash("cleaner123"), phone="11912345678", tax_number="56789012345", position=PositionEnum.CLEANER, permission=ScopesStatus.USER),
]

if __name__ == '__main__':
    create_database()

    with next(get_session()) as session:
        hospital = Hospital(name="Hospital Central",tax_number="27171473000108",address="Rua Principal, 123, Centro",)
        session.add_all(clients)
        session.add(hospital)
        session.flush()
        for client in clients:
            link_hospital_with_client = insert(client_hospital).values(client_id=client.id,
                                                hospital_id=hospital.id)
            session.execute(link_hospital_with_client)
        session.commit()
        session.add_all(hospitals)
        session.add_all(sectors)
        session.add_all(beds)
        session.add_all(patients)
        # session.add_all(admissions)
        session.commit()