import logging

from fastapi import APIRouter, Depends, Path
from starlette.status import (HTTP_200_OK, HTTP_201_CREATED,
                              HTTP_204_NO_CONTENT, HTTP_401_UNAUTHORIZED,
                              HTTP_404_NOT_FOUND, HTTP_503_SERVICE_UNAVAILABLE)

from project.application.service.bed import BedService
from project.hospital_management.controllers.dependencies.api_check import \
    verify_api_key
from project.hospital_management.controllers.dependencies.checks import \
    check_cnpj
from project.hospital_management.controllers.dependencies.dependencies import \
    get_bed_service
from project.hospital_management.controllers.dependencies.verify_token import \
    verify_token
from project.shared.schemas.bed import (Bed, BedCreate, BedStatusModel,
                                        BedUpdate, SectorResponse)
from project.shared.schemas.exceptions import (
    NotFoundExceptionResponse, ServiceUnavailableExceptionResponse,
    UnauthorizedExceptionResponse)

router = APIRouter()
logger = logging.getLogger(__name__)
TAX_NUMBER_DESCRIPTION = 'Número de identificação único'


@router.get('/{tax_number}',
            status_code=HTTP_200_OK,
            dependencies=[
                Depends(check_cnpj),
                Depends(verify_api_key),
                Depends(verify_token)
            ],
            response_model=list[SectorResponse],
            responses={
                HTTP_401_UNAUTHORIZED: {
                    'model': UnauthorizedExceptionResponse,
                },
                HTTP_503_SERVICE_UNAVAILABLE: {
                    'model': ServiceUnavailableExceptionResponse,
                }
            })
async def get_beds_grouped_by_sector(
        tax_number: str = Path(...,
                               title="CNPJ",
                               description=TAX_NUMBER_DESCRIPTION,
                               min_length=14,
                               max_length=14),
        bed_service: BedService = Depends(get_bed_service)):

    logger.info("Request to get beds grouped by sector")
    beds_grouped = bed_service.get_beds_grouped_by_sector(tax_number)
    logger.info(f"Beds grouped by sector: {beds_grouped}")
    return beds_grouped


@router.post('/{tax_number}',
             status_code=HTTP_201_CREATED,
             dependencies=[
                 Depends(check_cnpj),
                 Depends(verify_api_key),
                 Depends(verify_token)
             ],
             response_model=Bed,
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
async def create_bed(bed_create: BedCreate,
                     tax_number: str = Path(...,
                                            title="CNPJ",
                                            description=TAX_NUMBER_DESCRIPTION,
                                            min_length=14,
                                            max_length=14),
                     bed_service: BedService = Depends(get_bed_service)):
    logger.info("Request to create a bed")
    return bed_service.create_bed(bed_create, tax_number)


@router.get('/status/count/{tax_number}',
            status_code=HTTP_200_OK,
            dependencies=[
                Depends(check_cnpj),
                Depends(verify_api_key),
                Depends(verify_token)
            ],
            response_model=BedStatusModel,
            responses={
                HTTP_401_UNAUTHORIZED: {
                    'model': UnauthorizedExceptionResponse,
                },
                HTTP_503_SERVICE_UNAVAILABLE: {
                    'model': ServiceUnavailableExceptionResponse,
                }
            })
async def count_beds_by_status(
        tax_number: str = Path(...,
                               title="CNPJ",
                               description=TAX_NUMBER_DESCRIPTION,
                               min_length=14,
                               max_length=14),
        bed_service: BedService = Depends(get_bed_service)):
    logger.info("Request to count beds by status")
    counts = bed_service.count_beds_by_status(tax_number)
    logger.info(f"Bed counts by status: {counts}")
    return counts


@router.get('/{tax_number}/{bed_id}',
            status_code=HTTP_200_OK,
            dependencies=[
                Depends(check_cnpj),
                Depends(verify_api_key),
                Depends(verify_token)
            ],
            response_model=Bed,
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
async def get_bed(bed_id: int,
                  tax_number: str = Path(...,
                                         title="CNPJ",
                                         description=TAX_NUMBER_DESCRIPTION,
                                         min_length=14,
                                         max_length=14),
                  bed_service: BedService = Depends(get_bed_service)):
    logger.info(f"Request to get bed with id: {bed_id}")
    return bed_service.get_bed_by_id_and_tax_number(bed_id, tax_number)


@router.put('/{tax_number}/{bed_id}',
            status_code=HTTP_200_OK,
            dependencies=[
                Depends(check_cnpj),
                Depends(verify_api_key),
                Depends(verify_token)
            ],
            response_model=Bed,
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
async def update_bed(
        bed_id: int,
        bed_update: BedUpdate,
        tax_number: str = Path(...,
                               title="CNPJ",
                               description=TAX_NUMBER_DESCRIPTION,
                               min_length=14,
                               max_length=14),
        bed_service: BedService = Depends(get_bed_service),
):
    logger.info(f"Request to update bed with id: {bed_id}")
    return bed_service.update_bed(bed_id, tax_number, bed_update)


# @router.put('/{tax_number}/{bed_id}',
#             status_code=HTTP_200_OK,
#             dependencies=[
#                 Depends(check_cnpj),
#                 Depends(verify_api_key),
#                 Depends(verify_token)
#             ],
#             response_model=Bed,
#             responses={
#                 HTTP_401_UNAUTHORIZED: {
#                     'model': UnauthorizedExceptionResponse,
#                 },
#                 HTTP_404_NOT_FOUND: {
#                     'model': NotFoundExceptionResponse,
#                 },
#                 HTTP_503_SERVICE_UNAVAILABLE: {
#                     'model': ServiceUnavailableExceptionResponse,
#                 }
#             })
# async def update_bed(
#         bed_id: int,
#         bed_update: BedUpdate,
#         tax_number: str = Path(...,
#                                title="CNPJ",
#                                description=TAX_NUMBER_DESCRIPTION,
#                                min_length=14,
#                                max_length=14),
#         bed_service: BedService = Depends(get_bed_service),
# ):
#     logger.info(f"Request to update bed with id: {bed_id}")
#     return bed_service.update_bed(bed_id, tax_number, bed_update)


@router.delete('/{tax_number}/{bed_id}',
               status_code=HTTP_204_NO_CONTENT,
               dependencies=[
                   Depends(check_cnpj),
                   Depends(verify_api_key),
                   Depends(verify_token)
               ],
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
async def delete_bed(bed_id: int,
                     tax_number: str = Path(...,
                                            title="CNPJ",
                                            description=TAX_NUMBER_DESCRIPTION,
                                            min_length=14,
                                            max_length=14),
                     bed_service: BedService = Depends(get_bed_service)):
    logger.info(f"Request to delete bed with id: {bed_id}")
    try:
        bed_service.discharge_patient(bed_id, tax_number)
    except Exception as e:
        logger.warning(f"Error discharging patient: {e}")
    bed_service.delete_bed(bed_id, tax_number)
