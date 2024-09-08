import logging

from sqlalchemy.orm import Session

from project.hospital_management.datasource.client import ClientDataSource
from project.hospital_management.schemas.client import (ClientInput,
                                                        ClientResponse, Login,
                                                        TokenResponse)
from project.hospital_management.security.hash_provider import (
    get_password_hash, verify_password)
from project.hospital_management.security.token_provider import \
    create_acess_token
from project.shared.exceptions.exceptions import (InvalidCredentialsException,
                                                  ServiceUnavailableException,
                                                  UserAlreadyExistsException)

logger = logging.getLogger(__name__)


class ClientService():

    def __init__(self, session: Session, client_data_source: ClientDataSource):
        self.db = session
        self.client_data_source = client_data_source(session)

    def create_client(self, user: ClientInput) -> ClientResponse:
        try:
            if self.client_data_source.get_client_by_email(user.email):
                logger.warning(f"User with email {user.email} already exists")
                raise UserAlreadyExistsException()

            user.password = get_password_hash(user.password)
            client_response = ClientResponse(
                **self.client_data_source.create_client(user).__dict__)
            return client_response
        except UserAlreadyExistsException:
            raise
        except Exception as error:
            logger.error(f"Failed to create client: {error}")
            raise ServiceUnavailableException()

    def get_client_by_id(self, id: str):
        try:
            logger.info(f"Fetching client by ID: {id}")
            return self.client_data_source.get_client_by_id(id)
        except Exception as error:
            logger.error(f"Failed to fetch client by ID {id}: {error}")
            raise ServiceUnavailableException()

    def get_client_by_email(self, email: str):
        try:
            logger.info(f"Fetching client by email: {email}")
            return self.client_data_source.get_client_by_email(email)
        except Exception as error:
            logger.error(f"Failed to fetch client by email {email}: {error}")
            raise ServiceUnavailableException()

    def login(self, login: Login):
        try:
            client = self.client_data_source.get_client_by_email(login.email)
            if not client or not verify_password(login.password,
                                                 client.password):
                logger.warning(f"Invalid credentials for email: {login.email}")
                raise InvalidCredentialsException()

            token = create_acess_token({
                'id': client.id,
                'email': client.email,
                'name': client.name
            })
            logger.info(f"Login successful for email: {login.email}")
            return TokenResponse(status=True, sub=token)

        except InvalidCredentialsException:
            logger.warning(
                f"Login failed due to invalid credentials for email: {login.email}"
            )
            raise

        except Exception:
            raise InvalidCredentialsException()
