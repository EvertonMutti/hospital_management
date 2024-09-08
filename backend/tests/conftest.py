from project.shared.dependencies import get_client_datasource
from tests.utils.override_database import settings
from fastapi.testclient import TestClient
from project.hospital_management.entities.client import Client
from project.hospital_management.schemas.client import ClientInput
from project.hospital_management.security.token_provider import create_acess_token
from project.hospital_management.service.client import ClientService
import pytest  
from project.hospital_management.main import app
from project.hospital_management.settings.database import get_session, reset_database


@pytest.fixture(scope="function") 
def client():
    with next(get_session()) as session:
        user = {"name": "admin", "email": "admin@admin.com", "password": "mypassword"}
        existing_user  = session.query(Client).filter(Client.email == user.get('email')).first()
        if not existing_user:
            client_service = ClientService(session, get_client_datasource())
            client_service.create_client(ClientInput(**user))
        token = create_acess_token({'sub': "admin@admin.com"})
    with TestClient(app) as client:
        client.headers["Authorization"] = f"Bearer {token}"
        client.headers["api-key"] = "AntedegueMutti"
        yield client
 
 
@pytest.fixture(scope="function", autouse=True)
def setup_database():
    reset_database()
    yield
    reset_database()

