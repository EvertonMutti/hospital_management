from fastapi import APIRouter, FastAPI
from fastapi.openapi.docs import get_redoc_html, get_swagger_ui_html
from fastapi.openapi.utils import get_openapi

from project.hospital_management.settings.settings import get_settings

router = APIRouter()
settings = get_settings()


def custom_openapi(app: FastAPI, description: str, version: str):

    def _custom_openapi():
        if app.openapi_schema:
            return app.openapi_schema
        openapi_schema = get_openapi(
            version=version,
            description=description,
            routes=app.routes,
        )
        openapi_schema["info"]["servers"] = []
        openapi_schema["info"]["x-logo"] = {
            "url": settings.fastapi_settings.url_favicon
        }
        app.openapi_schema = openapi_schema

        return app.openapi_schema

    return _custom_openapi


@router.get('/redoc', include_in_schema=False)
def get_custom_redoc():
    return get_redoc_html(
        openapi_url='/openapi.json',
        title='API Hospital Management - ReDoc',
        redoc_favicon_url=settings.fastapi_settings.url_favicon)


@router.get('/docs', include_in_schema=False)
def get_custom_doc():
    return get_swagger_ui_html(
        openapi_url='/openapi.json',
        title='API Hospital Management - Swagger UI',
        swagger_favicon_url=settings.fastapi_settings.url_favicon)


@router.get('/', include_in_schema=False)
def overridden_root():
    return get_custom_doc()
