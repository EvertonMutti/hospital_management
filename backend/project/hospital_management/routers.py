from fastapi import APIRouter

from project.hospital_management.controllers import client, docs

router = APIRouter()

router.include_router(docs.router,
                      prefix="",
                      tags=['Doc'],
                      include_in_schema=False)
router.include_router(client.router, prefix="/client", tags=['Client'])
