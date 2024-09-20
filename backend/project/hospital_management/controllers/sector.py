# controllers/sector.py
import logging
from typing import List

from fastapi import APIRouter, Depends
from starlette.status import (HTTP_200_OK, HTTP_201_CREATED,
                              HTTP_204_NO_CONTENT, HTTP_503_SERVICE_UNAVAILABLE)

from project.application.service.sector import SectorService
from project.hospital_management.controllers.dependencies.dependencies import \
    get_sector_service
from project.hospital_management.controllers.dependencies.verify_token import \
    verify_token
from project.shared.schemas.client import VerifyClientResponse
from project.shared.schemas.exceptions import \
    ServiceUnavailableExceptionResponse
from project.shared.schemas.sector import (SectorCreate, SectorResponse,
                                           SectorUpdate)

router = APIRouter()
logger = logging.getLogger(__name__)


@router.get(
    '',
    status_code=HTTP_200_OK,
    response_model=List[SectorResponse],
    responses={
        HTTP_503_SERVICE_UNAVAILABLE: {
            'model': ServiceUnavailableExceptionResponse
        }
    },
)
async def get_all_sectors(
        sector_service: SectorService = Depends(get_sector_service)):
    logger.info("Request to get all sectors")
    sectors = sector_service.get_all_sectors()
    logger.info(f"Fetched sectors: {sectors}")
    return sectors


@router.post('', status_code=HTTP_201_CREATED, response_model=SectorResponse)
async def create_sector(
    sector_create: SectorCreate,
    user: VerifyClientResponse = Depends(verify_token),
    sector_service: SectorService = Depends(get_sector_service)):
    logger.info("Request to create a sector")
    return sector_service.create_sector(sector_create, user)


@router.get('/{sector_id}',
            status_code=HTTP_200_OK,
            response_model=SectorResponse)
async def get_sector(
    sector_id: int,
    sector_service: SectorService = Depends(get_sector_service)):
    logger.info(f"Request to get sector with id: {sector_id}")
    return sector_service.get_sector_by_id(sector_id)


@router.put('/{sector_id}',
            status_code=HTTP_200_OK,
            response_model=SectorResponse)
async def update_sector(
    sector_id: int,
    sector_update: SectorUpdate,
    sector_service: SectorService = Depends(get_sector_service)):
    logger.info(f"Request to update sector with id: {sector_id}")
    return sector_service.update_sector(sector_id, sector_update)


@router.delete('/{sector_id}', status_code=HTTP_204_NO_CONTENT)
async def delete_sector(
    sector_id: int,
    sector_service: SectorService = Depends(get_sector_service)):
    logger.info(f"Request to delete sector with id: {sector_id}")
    sector_service.delete_sector(sector_id)
