from fastapi import APIRouter, Depends, Path
from starlette.status import (HTTP_201_CREATED, HTTP_204_NO_CONTENT,
                              HTTP_401_UNAUTHORIZED, HTTP_404_NOT_FOUND,
                              HTTP_409_CONFLICT, HTTP_503_SERVICE_UNAVAILABLE)

from project.application.service.bed import BedService
from project.hospital_management.controllers.dependencies.api_check import \
    verify_api_key
from project.hospital_management.controllers.dependencies.checks import \
    check_cnpj
from project.hospital_management.controllers.dependencies.dependencies import \
    get_bed_service
from project.shared.schemas.exceptions import (
    ConflictExceptionResponse, NotFoundExceptionResponse,
    ServiceUnavailableExceptionResponse, UnauthorizedExceptionResponse)

router = APIRouter()
TAX_NUMBER_DESCRIPTION = 'Número de identificação único'


@router.post('/admission/{tax_number}/{bed_id}/{patient_id}',
             status_code=HTTP_201_CREATED,
             dependencies=[Depends(check_cnpj),
                           Depends(verify_api_key)],
             responses={
                 HTTP_401_UNAUTHORIZED: {
                     'model': UnauthorizedExceptionResponse,
                 },
                 HTTP_409_CONFLICT: {
                     'model': ConflictExceptionResponse,
                 },
                 HTTP_503_SERVICE_UNAVAILABLE: {
                     'model': ServiceUnavailableExceptionResponse,
                 }
             })
async def admit_patient_to_bed(
    bed_id: int,
    patient_id: int,
    tax_number: str = Path(...,
                           title="CNPJ",
                           description=TAX_NUMBER_DESCRIPTION,
                           min_length=14,
                           max_length=14),
    bed_service: BedService = Depends(get_bed_service)):
    return bed_service.admit_patient(bed_id, tax_number, patient_id)


@router.put('/discharge/{tax_number}/{bed_id}',
            status_code=HTTP_204_NO_CONTENT,
            dependencies=[Depends(check_cnpj),
                          Depends(verify_api_key)],
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
async def discharge_patient(
    bed_id: int,
    tax_number: str = Path(...,
                           title="CNPJ",
                           description=TAX_NUMBER_DESCRIPTION,
                           min_length=14,
                           max_length=14),
    bed_service: BedService = Depends(get_bed_service)):
    bed_service.discharge_patient(bed_id, tax_number)
