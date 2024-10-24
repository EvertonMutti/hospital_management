from datetime import datetime

from fastapi import APIRouter, Depends, Path
from sqlalchemy.orm import Session, aliased
from starlette.status import (HTTP_401_UNAUTHORIZED, HTTP_404_NOT_FOUND,
                              HTTP_503_SERVICE_UNAVAILABLE)

from project.hospital_management.controllers.dependencies.api_check import \
    verify_api_key
from project.hospital_management.controllers.dependencies.checks import \
    check_cnpj
from project.hospital_management.controllers.dependencies.verify_token import verify_token
from project.hospital_management.settings.database import get_session
from project.shared.entities.entities import Admission, Bed, Hospital, Sector
from project.shared.schemas.bed import AverageFreeTimeResponse
from project.shared.schemas.exceptions import (
    NotFoundExceptionResponse, ServiceUnavailableExceptionResponse,
    UnauthorizedExceptionResponse)

router = APIRouter()


@router.get("/{tax_number}/average-free-time",
            dependencies=[Depends(check_cnpj),
                          Depends(verify_api_key),
                          Depends(verify_token)],
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
                          db: Session = Depends(get_session)):
    BedAlias = aliased(Bed)
    SectorAlias = aliased(Sector)
    beds = (db.query(BedAlias).join(
        SectorAlias, BedAlias.sector_id == SectorAlias.id).join(
            Hospital, SectorAlias.hospital_id == Hospital.id).filter(
                Hospital.tax_number == tax_number).all())

    total_free_time = 0
    total_beds = 0

    for bed in beds:
        admissions = db.query(Admission).filter(
            Admission.bed_id == bed.id).all()

        last_discharge_date = None
        for admission in admissions:
            if last_discharge_date:
                free_time = (admission.admission_date -
                             last_discharge_date).total_seconds() / 3600
                total_free_time += free_time
                total_beds += 1

            last_discharge_date = admission.discharge_date

        if last_discharge_date:
            free_time = (datetime.now() -
                         last_discharge_date).total_seconds() / 3600
            total_free_time += free_time
            total_beds += 1

    average_free_time = total_free_time / total_beds if total_beds > 0 else 0

    average_days = int(average_free_time // 24)
    average_hours = int(average_free_time % 24)

    return {"days": average_days, "hours": average_hours}
