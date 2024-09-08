from functools import lru_cache

from fastapi import Depends
from pytest import Session

from project.hospital_management.datasource.client import ClientDataSource
from project.hospital_management.service.client import ClientService
from project.hospital_management.settings.database import get_session


@lru_cache
def get_client_datasource() -> ClientDataSource:
    return ClientDataSource


@lru_cache
def get_client_service(db: Session = Depends(get_session),
                       client_data_source: ClientDataSource = Depends(
                           get_client_datasource)) -> ClientService:
    return ClientService(db, client_data_source)
