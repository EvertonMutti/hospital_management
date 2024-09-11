from fastapi import APIRouter

from project.hospital_management.controllers import bed, client, docs, sector

router = APIRouter()

router.include_router(docs.router,
                      prefix="",
                      tags=['Doc'],
                      include_in_schema=False)
router.include_router(client.router, prefix="/client", tags=['Client'])
router.include_router(bed.router, prefix="/bed", tags=['Bed'])
router.include_router(sector.router, prefix="/sector", tags=['Sector'])
