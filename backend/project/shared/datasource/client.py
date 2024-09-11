import logging

from sqlalchemy import select
from sqlalchemy.orm import Session

from project.hospital_management.schemas.client import ClientInput
from project.shared.entities.entities import Client

logger = logging.getLogger(__name__)


class ClientDataSource():

    def __init__(self, db: Session):
        self.db: Session = db

    def create_client(self, client: ClientInput) -> Client:
        db_Client = Client(**client.__dict__)

        self.db.add(db_Client)
        self.db.commit()
        self.db.refresh(db_Client)
        logger.info(f"Client created successfully with email: {client.email}")
        return db_Client

    def get_client_by_email(self, email: str) -> Client:
        query = select(Client.__table__).where((Client.email == email))
        return self.db.execute(query).first()

    def get_client_by_id(self, id: str) -> Client:
        query = select(Client.__table__).where((Client.id == id))
        client = self.db.execute(query).first()
        if not client:
            logger.warning(f"No client found with id: {id}")
        return client