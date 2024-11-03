from datetime import datetime

from fastapi import APIRouter, Depends, Path
from sqlalchemy.orm import Session, aliased
from starlette.status import (HTTP_401_UNAUTHORIZED, HTTP_404_NOT_FOUND,
                              HTTP_503_SERVICE_UNAVAILABLE)

from project.application.service.bed import BedService
from project.hospital_management.controllers.dependencies.api_check import \
    verify_api_key
from project.hospital_management.controllers.dependencies.checks import \
    check_cnpj
from project.hospital_management.controllers.dependencies.dependencies import get_bed_service
from project.hospital_management.controllers.dependencies.verify_token import \
    verify_token
from project.hospital_management.settings.database import get_session
from project.shared.entities.entities import Admission, Bed, Hospital, Sector
from project.shared.schemas.bed import AverageFreeTimeResponse
from project.shared.schemas.exceptions import (
    NotFoundExceptionResponse, ServiceUnavailableExceptionResponse,
    UnauthorizedExceptionResponse)

router = APIRouter()


@router.get("/{tax_number}/average-free-time",
            dependencies=[
                Depends(check_cnpj),
                Depends(verify_api_key),
                Depends(verify_token)
            ],
            response_model=AverageFreeTimeResponse,
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
def get_average_free_time(tax_number: str = Path(
    ...,
    title="CNPJ",
    description='Número de identificação único',
    min_length=14,
    max_length=14),
                          bed_service: BedService = Depends(get_bed_service)):
    return bed_service.calculate_average_free_time(tax_number)
