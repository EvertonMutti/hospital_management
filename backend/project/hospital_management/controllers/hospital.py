import logging

from fastapi import APIRouter, Depends, HTTPException
from starlette.status import (HTTP_201_CREATED, HTTP_404_NOT_FOUND, HTTP_401_UNAUTHORIZED,
                              HTTP_503_SERVICE_UNAVAILABLE)

from project.application.service.hospital import HospitalService
from project.hospital_management.controllers.dependencies.api_check import verify_api_key
from project.hospital_management.controllers.dependencies.dependencies import \
    get_hospital_service
from project.hospital_management.controllers.dependencies.verify_token import \
    verify_token
from project.shared.schemas.client import VerifyClientResponse
from project.shared.schemas.exceptions import (
    UnauthorizedExceptionResponse, NotFoundExceptionResponse, ServiceUnavailableExceptionResponse)
from project.shared.schemas.hospital import HospitalCreate, HospitalResponse

router = APIRouter()
logger = logging.getLogger(__name__)


@router.post('/',
             status_code=HTTP_201_CREATED,
             dependencies=[Depends(verify_api_key)],
             response_model=HospitalResponse,
             responses={
                 HTTP_401_UNAUTHORIZED: {
                    'model': UnauthorizedExceptionResponse,
                },
                 HTTP_503_SERVICE_UNAVAILABLE: {
                     'model': ServiceUnavailableExceptionResponse,
                 }
             })
async def create_hospital(
    hospital: HospitalCreate,
    hospital_service: HospitalService = Depends(get_hospital_service)):

    logger.info(f"Create hospital requested with data: {hospital}")
    hospital_response = hospital_service.create_hospital(hospital)
    logger.info(f"Hospital created successfully: {hospital_response}")
    return hospital_response


@router.get('/',
            dependencies=[Depends(verify_api_key)],
            response_model=list[HospitalResponse],
            responses={
                HTTP_401_UNAUTHORIZED: {
                    'model': UnauthorizedExceptionResponse,
                },
                HTTP_503_SERVICE_UNAVAILABLE: {
                    'model': ServiceUnavailableExceptionResponse,
                }
            })
async def list_hospitals(
        user: VerifyClientResponse = Depends(verify_token),
        hospital_service: HospitalService = Depends(get_hospital_service)):
    logger.info("List hospitals requested")
    hospitals = hospital_service.list_hospitals(user.id)
    logger.info(f"Retrieved hospitals: {hospitals}")
    return hospitals


@router.get('/{unique_code}',
            dependencies=[Depends(verify_api_key)],
            response_model=HospitalResponse,
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
async def get_hospital(
    unique_code: str,
    hospital_service: HospitalService = Depends(get_hospital_service)):

    logger.info(f"Fetch hospital requested with unique_code: {unique_code}")
    hospital_response = hospital_service.get_hospital_by_code(unique_code)
    if not hospital_response:
        logger.warning(f"Hospital not found with unique_code: {unique_code}")
        raise HTTPException(status_code=HTTP_404_NOT_FOUND,
                            detail="Hospital not found")
    logger.info(f"Hospital found: {hospital_response}")
    return hospital_response
