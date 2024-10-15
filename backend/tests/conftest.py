from tests.utils.override_database import settings
from project.application.service.hospital import HospitalService
from project.hospital_management.controllers.dependencies.dependencies import get_hospital_datasource, get_client_datasource
from project.shared.schemas.hospital import HospitalCreate
from fastapi.testclient import TestClient
from project.shared.entities.entities import Client, Hospital
from project.shared.schemas.client import ClientInput
from project.shared.security.token_provider import create_acess_token
from project.application.service.client import ClientService
import pytest
from project.hospital_management.main import app
from project.hospital_management.settings.database import get_session, reset_database


@pytest.fixture(scope="function")
def get_hospital() -> Hospital:
    with next(get_session()) as session:
        hospital_service = HospitalService(session, get_hospital_datasource())
        hospital = hospital_service.get_hospital_by_tax_number(
            "48292152000131")
        return hospital


@pytest.fixture(scope="function")
def client():
    with next(get_session()) as session:
        user = {"name": "admin", "email": "admin@admin.com",
                "password": "mypassword", "hospital_unique_code": "123654",
                'phone': '71984659415', 'tax_number': '53071916000'}
        hospital = {"name": "hospital",
                    "tax_number": "48292152000131", "address": "address"}
        hospital_service = HospitalService(session, get_hospital_datasource())
        hospital_service.create_hospital(HospitalCreate(**hospital))
        session.commit()
        hospital = hospital_service.get_hospital_by_tax_number(
            "48292152000131")
        user_with_hospital_code = {
            **user, "hospital_unique_code": hospital.unique_code}
        client_service = ClientService(
            session, get_client_datasource(), get_hospital_datasource())
        new_client = client_service.create_client(
            ClientInput(**user_with_hospital_code))
        session.commit()
        token = create_acess_token({'id': new_client.id,
                                    'email': new_client.email,
                                    'name': new_client.name})
    with TestClient(app) as client:
        client.headers["Authorization"] = f"Bearer {token}"
        client.headers["api-key"] = "AntedegueMutti"
        yield client


@pytest.fixture(scope="function", autouse=True)
def setup_database():
    reset_database()
    yield
    reset_database()