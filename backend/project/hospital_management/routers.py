from fastapi import APIRouter

from project.hospital_management.controllers import (admission,
                                                     average_free_time, bed,
                                                     client, docs, hospital,
                                                     sector)

router = APIRouter()

router.include_router(docs.router,
                      prefix="",
                      tags=['Doc'],
                      include_in_schema=False)
router.include_router(client.router, prefix="/client", tags=['Client'])
router.include_router(average_free_time.router, prefix="/bed", tags=['Bed'])
router.include_router(bed.router, prefix="/bed", tags=['Bed'])
router.include_router(admission.router, prefix="", tags=['Admission'])
router.include_router(sector.router, prefix="/sector", tags=['Sector'])
router.include_router(hospital.router, prefix="/hospitals", tags=['Hospital'])
