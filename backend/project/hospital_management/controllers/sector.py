import logging
from typing import List

from fastapi import APIRouter, Depends, Path
from starlette.status import (HTTP_200_OK, HTTP_201_CREATED,
                              HTTP_204_NO_CONTENT, HTTP_401_UNAUTHORIZED,
                              HTTP_404_NOT_FOUND, HTTP_409_CONFLICT, HTTP_503_SERVICE_UNAVAILABLE)

from project.application.service.sector import SectorService
from project.hospital_management.controllers.dependencies.api_check import \
    verify_api_key
from project.hospital_management.controllers.dependencies.checks import \
    check_cnpj
from project.hospital_management.controllers.dependencies.dependencies import \
    get_sector_service
from project.hospital_management.controllers.dependencies.verify_token import \
    verify_token
from project.shared.schemas.client import VerifyClientResponse
from project.shared.schemas.exceptions import (
    ConflictExceptionResponse, NotFoundExceptionResponse, ServiceUnavailableExceptionResponse,
    UnauthorizedExceptionResponse)
from project.shared.schemas.sector import (SectorCreate, SectorResponse,
                                           SectorUpdate)

router = APIRouter()
logger = logging.getLogger(__name__)
TAX_NUMBER_DESCRIPTION = 'Número de identificação único'


@router.get(
    '/{tax_number}',
    status_code=HTTP_200_OK,
    response_model=List[SectorResponse],
    dependencies=[Depends(check_cnpj),
                  Depends(verify_api_key),
                  Depends(verify_token)],
    responses={
        HTTP_401_UNAUTHORIZED: {
            'model': UnauthorizedExceptionResponse,
        },
        HTTP_503_SERVICE_UNAVAILABLE: {
            'model': ServiceUnavailableExceptionResponse
        }
    },
)
async def get_all_sectors(
        tax_number: str = Path(...,
                               title="CNPJ",
                               description=TAX_NUMBER_DESCRIPTION,
                               min_length=14,
                               max_length=14),
        sector_service: SectorService = Depends(get_sector_service)):
    logger.info("Request to get all sectors")
    sectors = sector_service.get_all_sectors(tax_number)
    logger.info(f"Fetched sectors: {sectors}")
    return sectors


@router.post('/{tax_number}',
             dependencies=[Depends(check_cnpj),
                           Depends(verify_api_key),
                           Depends(verify_token)],
             status_code=HTTP_201_CREATED,
             response_model=SectorResponse,
             responses={
                 HTTP_401_UNAUTHORIZED: {
                     'model': UnauthorizedExceptionResponse,
                 },
                 HTTP_503_SERVICE_UNAVAILABLE: {
                     'model': ServiceUnavailableExceptionResponse,
                 }
             })
async def create_sector(
    sector_create: SectorCreate,
    tax_number: str = Path(...,
                           title="CNPJ",
                           description=TAX_NUMBER_DESCRIPTION,
                           min_length=14,
                           max_length=14),
    sector_service: SectorService = Depends(get_sector_service)):
    logger.info("Request to create a sector")
    return sector_service.create_sector(sector_create, tax_number)


@router.get('/{tax_number}/{sector_id}',
            dependencies=[Depends(check_cnpj),
                          Depends(verify_api_key),
                          Depends(verify_token)],
            status_code=HTTP_200_OK,
            response_model=SectorResponse,
            responses={
                HTTP_401_UNAUTHORIZED: {
                    'model': UnauthorizedExceptionResponse,
                },
                HTTP_404_NOT_FOUND: {
                    'model': NotFoundExceptionResponse,
                },
                HTTP_503_SERVICE_UNAVAILABLE: {
                    'model': ServiceUnavailableExceptionResponse,
                }
            })
async def get_sector(
    sector_id: int,
    tax_number: str = Path(...,
                           title="CNPJ",
                           description=TAX_NUMBER_DESCRIPTION,
                           min_length=14,
                           max_length=14),
    sector_service: SectorService = Depends(get_sector_service)):
    logger.info(f"Request to get sector with id: {sector_id}")
    return sector_service.get_sector_by_id_and_tax_number(
        sector_id, tax_number=tax_number)


@router.put('/{tax_number}/{sector_id}',
            dependencies=[Depends(check_cnpj),
                          Depends(verify_api_key),
                          Depends(verify_token)],
            status_code=HTTP_200_OK,
            response_model=SectorResponse,
            responses={
                HTTP_401_UNAUTHORIZED: {
                    'model': UnauthorizedExceptionResponse,
                },
                HTTP_404_NOT_FOUND: {
                    'model': NotFoundExceptionResponse,
                },
                HTTP_503_SERVICE_UNAVAILABLE: {
                    'model': ServiceUnavailableExceptionResponse,
                }
            })
async def update_sector(
    sector_id: int,
    sector_update: SectorUpdate,
    tax_number: str = Path(...,
                           title="CNPJ",
                           description=TAX_NUMBER_DESCRIPTION,
                           min_length=14,
                           max_length=14),
    sector_service: SectorService = Depends(get_sector_service)):
    logger.info(f"Request to update sector with id: {sector_id}")
    return sector_service.update_sector(sector_id, tax_number, sector_update)


@router.delete('/{tax_number}/{sector_id}',
               dependencies=[Depends(check_cnpj),
                             Depends(verify_api_key),
                             Depends(verify_token)],
               status_code=HTTP_204_NO_CONTENT,
               responses={
                   HTTP_401_UNAUTHORIZED: {
                       'model': UnauthorizedExceptionResponse,
                   },
                   HTTP_404_NOT_FOUND: {
                       'model': NotFoundExceptionResponse,
                   },
                   HTTP_409_CONFLICT: {
                       'model': ConflictExceptionResponse,
                   },
                   HTTP_503_SERVICE_UNAVAILABLE: {
                       'model': ServiceUnavailableExceptionResponse,
                   }
               })
async def delete_sector(
    sector_id: int,
    tax_number: str = Path(...,
                           title="CNPJ",
                           description=TAX_NUMBER_DESCRIPTION,
                           min_length=14,
                           max_length=14),
    sector_service: SectorService = Depends(get_sector_service)):
    logger.info(f"Request to delete sector with id: {sector_id}")
    sector_service.delete_sector(sector_id, tax_number)
