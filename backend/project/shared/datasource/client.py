import logging
from typing import Optional

from sqlalchemy import insert, select
from sqlalchemy.orm import Session

from project.shared.entities.entities import Client, client_hospital
from project.shared.schemas.client import ClientInput

logger = logging.getLogger(__name__)


class ClientDataSource():

    def __init__(self, db: Session):
        self.db: Session = db

    def create_client(self, client: ClientInput) -> Client:
        db_Client = Client(name=client.name,
                           email=client.email,
                           password=client.password)

        self.db.add(db_Client)
        self.db.commit()
        self.db.refresh(db_Client)
        logger.info(f"Client created successfully with email: {client.email}")
        return db_Client

    def link_hospital_to_client(self, client_id: int, hospital_id: int):
        query = insert(client_hospital).values(client_id=client_id,
                                               hospital_id=hospital_id)
        self.db.execute(query)
        self.db.commit()

    def get_client_by_email(self, email: str) -> Optional[Client]:
        query = select(Client.__table__).where((Client.email == email))
        return self.db.execute(query).first()

    def get_client_by_id(self, id: str) -> Optional[Client]:
        query = select(Client.__table__).where((Client.id == id))
        client = self.db.execute(query).first()
        if not client:
            logger.warning(f"No client found with id: {id}")
        return client