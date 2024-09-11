import logging

from fastapi import APIRouter, Depends
from starlette.status import (HTTP_200_OK, HTTP_201_CREATED,
                              HTTP_204_NO_CONTENT, HTTP_404_NOT_FOUND,
                              HTTP_503_SERVICE_UNAVAILABLE)

from project.hospital_management.schemas.bed import Bed, BedCreate, BedUpdate
from project.shared.dependencies import get_bed_service
from project.shared.schemas.exceptions import ExceptionResponse
from project.shared.service.bed import BedService

router = APIRouter()
logger = logging.getLogger(__name__)


@router.get(
    '',
    status_code=HTTP_200_OK,
    response_model=dict,
    responses={HTTP_503_SERVICE_UNAVAILABLE: {
        'model': ExceptionResponse,
    }})
async def get_beds_grouped_by_sector(
        bed_service: BedService = Depends(get_bed_service)):
    logger.info("Request to get beds grouped by sector")
    beds_grouped = bed_service.get_beds_grouped_by_sector()
    logger.info(f"Beds grouped by sector: {beds_grouped}")
    return beds_grouped


@router.post('', status_code=HTTP_201_CREATED, response_model=Bed)
async def create_bed(bed_create: BedCreate,
                     bed_service: BedService = Depends(get_bed_service)):
    logger.info("Request to create a bed")
    return bed_service.create_bed(bed_create)


@router.get(
    '/status/count',
    status_code=HTTP_200_OK,
    response_model=dict,
    responses={HTTP_503_SERVICE_UNAVAILABLE: {
        'model': ExceptionResponse,
    }})
async def count_beds_by_status(
        bed_service: BedService = Depends(get_bed_service)):
    logger.info("Request to count beds by status")
    counts = bed_service.count_beds_by_status()
    logger.info(f"Bed counts by status: {counts}")
    return counts


@router.get('/{bed_id}',
            status_code=HTTP_200_OK,
            response_model=Bed,
            responses={HTTP_404_NOT_FOUND: {
                "description": "Bed not found"
            }})
async def get_bed(bed_id: int,
                  bed_service: BedService = Depends(get_bed_service)):
    logger.info(f"Request to get bed with id: {bed_id}")
    return bed_service.get_bed(bed_id)


@router.put('/{bed_id}',
            status_code=HTTP_200_OK,
            response_model=Bed,
            responses={HTTP_404_NOT_FOUND: {
                "description": "Bed not found"
            }})
async def update_bed(bed_id: int,
                     bed_update: BedUpdate,
                     bed_service: BedService = Depends(get_bed_service)):
    logger.info(f"Request to update bed with id: {bed_id}")
    return bed_service.update_bed(bed_id, bed_update)


@router.delete(
    '/{bed_id}',
    status_code=HTTP_204_NO_CONTENT,
    responses={HTTP_404_NOT_FOUND: {
        "description": "Bed not found"
    }})
async def delete_bed(bed_id: int,
                     bed_service: BedService = Depends(get_bed_service)):
    logger.info(f"Request to delete bed with id: {bed_id}")
    bed_service.delete_bed(bed_id)
