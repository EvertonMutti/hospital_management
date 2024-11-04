import logging

from sqlalchemy.orm import Session

from project.shared.datasource.client import ClientDataSource
from project.shared.datasource.hospital import HospitalDataSource
from project.shared.entities.entities import Client
from project.shared.exceptions.exceptions import (HospitalNotFoundException,
                                                  InvalidCredentialsException,
                                                  ServiceUnavailableException,
                                                  UserAlreadyExistsException,
                                                  UserNotFoundException)
from project.shared.schemas.client import (ClientInput, ClientResponse, Login,
                                           TokenResponse)
from project.shared.security.hash_provider import (get_password_hash,
                                                   verify_password)
from project.shared.security.token_provider import create_acess_token

logger = logging.getLogger(__name__)


class ClientService():

    def __init__(self, session: Session, client_data_source: ClientDataSource,
                 hospital_data_source: HospitalDataSource):
        self.db = session
        self.client_data_source: ClientDataSource = client_data_source(session)
        self.hospital_data_source: HospitalDataSource = hospital_data_source(
            session)

    def create_client(self, user: ClientInput) -> ClientResponse:
        try:
            if self.client_data_source.get_client_by_email(user.email):
                logger.warning(f"User with email {user.email} already exists")
                raise UserAlreadyExistsException()

            user.password = get_password_hash(user.password)
            if hospital := self.hospital_data_source.get_hospital_by_unique_code(
                    user.hospital_unique_code):
                client_response = ClientResponse(
                    **self.client_data_source.create_client(user).__dict__)
                self.client_data_source.link_hospital_to_client(
                    client_response.id, hospital.id)
                return client_response
            raise HospitalNotFoundException()

        except (HospitalNotFoundException, UserAlreadyExistsException) as error:
            raise
        except Exception as error:
            logger.error(f"Failed to create client: {error}")
            raise ServiceUnavailableException()

    def get_client_by_id(self, id: str) -> Client:
        try:
            logger.info(f"Fetching client by ID: {id}")
            if not (client := self.client_data_source.get_client_by_id(id)):
                raise UserNotFoundException()
            return client
        except UserNotFoundException:
            raise
        except Exception as error:
            logger.error(f"Failed to fetch client by ID {id}: {error}")
            raise ServiceUnavailableException()

    def get_client_by_email(self, email: str) -> Client:
        try:
            logger.info(f"Fetching client by email: {email}")
            if not (client :=
                    self.client_data_source.get_client_by_email(email)):
                raise UserNotFoundException()
            return client
        except UserNotFoundException:
            raise
        except Exception as error:
            logger.error(f"Failed to fetch client by email {email}: {error}")
            raise ServiceUnavailableException()

    def login(self, login: Login):
        try:
            client = self.get_client_by_email(login.email)
            if not verify_password(login.password, client.password):
                logger.warning(f"Invalid credentials for email: {login.email}")
                raise InvalidCredentialsException()

            token = create_acess_token({
                'id': client.id,
                'email': client.email,
                'username': client.name,
                'phone': client.phone,
                'tax_number': client.tax_number,
                'position': client.position.value,
                'permission': client.permission.value,
            })
            logger.info(f"Login successful for email: {login.email}")
            return TokenResponse(sub=token)

        except UserNotFoundException:
            raise
        except InvalidCredentialsException:
            logger.warning(
                f"Login failed due to invalid credentials for email: {login.email}"
            )
            raise
        except Exception:
            raise ServiceUnavailableException()

    def update_client(self, client_id: int,
                      client_data: ClientInput) -> ClientResponse:
        try:
            client = self.get_client_by_id(client_id)

            client.name = client_data.name
            client.email = client_data.email
            client.password = get_password_hash(client_data.password)
            client.tax_number = client_data.tax_number
            client.phone = client_data.phone

            self.db.add(client)

            self.db.commit()
            self.db.refresh(client)

            logger.info(f"Client with ID {client_id} updated successfully.")
            return ClientResponse(**client.__dict__)

        except UserNotFoundException:
            raise
        except Exception as error:
            logger.error(f"Failed to update client: {error}")
            raise ServiceUnavailableException()
