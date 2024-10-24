from project.shared.enum.enums import PositionEnum, ScopesStatus
from project.shared.security.hash_provider import get_password_hash
from tests.utils.override_database import settings
from project.application.service.hospital import HospitalService
from project.hospital_management.controllers.dependencies.dependencies import get_hospital_datasource, get_client_datasource
from project.shared.schemas.hospital import HospitalCreate
from fastapi.testclient import TestClient
from project.shared.entities.entities import Client, Hospital, client_hospital
from project.shared.schemas.client import ClientInput
from project.shared.security.token_provider import create_acess_token
from project.application.service.client import ClientService
import pytest
from sqlalchemy import insert
from project.hospital_management.main import app
from project.hospital_management.settings.database import get_session, reset_database


HOSPITAL_TAX_NUMBER = '27171473000108'

@pytest.fixture(scope="function")
def create_records() -> Hospital:
    from records.main import admissions, patients, beds, sectors
    with next(get_session()) as session:
        session.add_all(sectors)
        session.add_all(beds)
        session.add_all(patients)
        session.add_all(admissions)
        session.commit()

@pytest.fixture(scope="function")
def get_hospital() -> Hospital:
    with next(get_session()) as session:
        hospital_service = HospitalService(session, get_hospital_datasource())
        hospital = hospital_service.get_hospital_by_tax_number(
            HOSPITAL_TAX_NUMBER)
        return hospital


@pytest.fixture(scope="function")
def client():
    with next(get_session()) as session:
        client = Client(name="Carlos Alberto", email="carlos.admin@example.com", password="admin123", phone="11987654321", tax_number="01234567890", position=PositionEnum.NURSE, permission=ScopesStatus.ADMIN)
        client.password = get_password_hash(client.password)
        hospital = Hospital( name="Hospital Central", tax_number="27171473000108", address="Rua Principal, 123, Centro",)
        session.add(client)
        session.add(hospital)
        session.flush()
        
        link_hospital_with_client = insert(client_hospital).values(client_id=client.id,
                                               hospital_id=hospital.id)
        session.execute(link_hospital_with_client)
        session.commit()
        
        token = create_acess_token({
                'id': client.id,
                'email': client.email,
                'username': client.name,
                'phone': client.phone,
                'tax_number': client.tax_number,
                'position': client.position.value,
                'permission': client.permission.value,
            })
    with TestClient(app) as client:
        client.headers["Authorization"] = f"Bearer {token}"
        client.headers["api-key"] = "AntedegueMutti"
        yield client



@pytest.fixture(scope="function", autouse=True)
def setup_database():
    reset_database()
    yield
    reset_database()