import logging

from fastapi import APIRouter, Depends, HTTPException
from starlette.status import (HTTP_201_CREATED, HTTP_404_NOT_FOUND,
                              HTTP_500_INTERNAL_SERVER_ERROR)

from project.application.service.hospital import HospitalService
from project.hospital_management.controllers.dependencies.dependencies import \
    get_hospital_service
from project.hospital_management.controllers.dependencies.verify_token import \
    verify_token
from project.shared.schemas.client import VerifyClientResponse
from project.shared.schemas.hospital import (HospitalCreate,
                                             HospitalListResponse,
                                             HospitalResponse)

router = APIRouter(prefix='/hospitals')
logger = logging.getLogger(__name__)


@router.post(
    '/',
    status_code=HTTP_201_CREATED,
    response_model=HospitalResponse,
    responses={
        HTTP_500_INTERNAL_SERVER_ERROR: {
            'model':
            HospitalResponse,  # Placeholder for actual error response model
        }
    })
async def create_hospital(
    hospital: HospitalCreate,
    hospital_service: HospitalService = Depends(get_hospital_service)):
    try:
        logger.info(f"Create hospital requested with data: {hospital}")
        hospital_response = hospital_service.create_hospital(hospital)
        logger.info(f"Hospital created successfully: {hospital_response}")
        return hospital_response
    except Exception as e:
        logger.error(f"Failed to create hospital: {e}")
        raise HTTPException(status_code=HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=str(e))


@router.get(
    '/{unique_code}',
    response_model=HospitalResponse,
    responses={
        HTTP_404_NOT_FOUND: {
            'model':
            HospitalResponse,  # Placeholder for actual error response model
        },
        HTTP_500_INTERNAL_SERVER_ERROR: {
            'model':
            HospitalResponse,  # Placeholder for actual error response model
        }
    })
async def get_hospital(
    unique_code: str,
    hospital_service: HospitalService = Depends(get_hospital_service)):
    try:
        logger.info(
            f"Fetch hospital requested with unique_code: {unique_code}")
        hospital_response = hospital_service.get_hospital_by_code(unique_code)
        if not hospital_response:
            logger.warning(
                f"Hospital not found with unique_code: {unique_code}")
            raise HTTPException(status_code=HTTP_404_NOT_FOUND,
                                detail="Hospital not found")
        logger.info(f"Hospital found: {hospital_response}")
        return hospital_response
    except Exception as e:
        logger.error(f"Failed to fetch hospital: {e}")
        raise HTTPException(status_code=HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=str(e))


@router.get(
    '/',
    response_model=HospitalListResponse,
    responses={
        HTTP_500_INTERNAL_SERVER_ERROR: {
            'model':
            HospitalListResponse,  # Placeholder for actual error response model
        }
    })
async def list_hospitals(
        user: VerifyClientResponse = Depends(verify_token),
        hospital_service: HospitalService = Depends(get_hospital_service)):
    try:
        logger.info("List hospitals requested")
        hospitals = hospital_service.list_hospitals(user.id)
        logger.info(f"Retrieved hospitals: {hospitals}")
        return HospitalListResponse(hospitals=hospitals)
    except Exception as e:
        logger.error(f"Failed to list hospitals: {e}")
        raise HTTPException(status_code=HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=str(e))
