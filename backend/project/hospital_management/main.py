import logging

import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from project.hospital_management.controllers.docs import custom_openapi
from project.hospital_management.insert_records_vercel.insert_records import insert_records
from project.hospital_management.routers import router
from project.hospital_management.settings.database import create_database
from project.hospital_management.settings.settings import get_settings
from project.shared.logs.log import setup_logging

app = FastAPI(title='API Hospital Management', docs_url=None, redoc_url=None)
app.include_router(router)
settings = get_settings()
setup_logging()

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def main() -> None:
    create_database()
    insert_records()
    custom_openapi(
        app,
        description='API Hospital Management',
        version='1.0.0',
    )


def setup_fastapi() -> None:
    logger = logging.getLogger(__name__)
    logger.info(
        f'Starting FastAPI at {settings.fastapi_settings.host}:{settings.fastapi_settings.port}'
    )
    uvicorn.run(app,
                host=settings.fastapi_settings.host,
                port=settings.fastapi_settings.port)


main()

if __name__ == "__main__":
    setup_fastapi()
