import logging

from fastapi import APIRouter, Depends
from starlette.status import (HTTP_201_CREATED, HTTP_400_BAD_REQUEST,
                              HTTP_404_NOT_FOUND, HTTP_503_SERVICE_UNAVAILABLE)

from project.application.service.client import ClientService
from project.hospital_management.controllers.dependencies.dependencies import \
    get_client_service
from project.shared.schemas.client import (ClientInput, ClientResponse, Login,
                                           TokenResponse)
from project.shared.schemas.exceptions import (
    NotFoundExceptionResponse, ServiceUnavailableExceptionResponse,
    UserAlreadyExistsResponse, UserNotFoundResponse)

router = APIRouter()
logger = logging.getLogger(__name__)


@router.post('/signup',
             status_code=HTTP_201_CREATED,
             response_model=ClientResponse,
             responses={
                 HTTP_503_SERVICE_UNAVAILABLE: {
                     'model': ServiceUnavailableExceptionResponse,
                 },
                 HTTP_400_BAD_REQUEST: {
                     'model': UserAlreadyExistsResponse
                 },
                 HTTP_404_NOT_FOUND: {
                     'model': NotFoundExceptionResponse
                 }
             })
async def signup(user: ClientInput,
                 client_service: ClientService = Depends(get_client_service)):
    logger.info(f"Signup requested for user: {user}")
    client = client_service.create_client(user)
    logger.info(f"Client created successfully: {client}")
    return client


@router.post("/login",
             response_model=TokenResponse,
             responses={
                 HTTP_400_BAD_REQUEST: {
                     'model': UserNotFoundResponse
                 },
                 HTTP_503_SERVICE_UNAVAILABLE: {
                     'model': ServiceUnavailableExceptionResponse
                 }
             })
async def login(login: Login,
                client_service: ClientService = Depends(get_client_service)):
    logger.info(f"Login requested for username: {login.email}")
    token = client_service.login(login)
    return token
