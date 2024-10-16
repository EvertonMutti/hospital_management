import logging
from typing import Annotated

from fastapi import APIRouter, Body, Depends
from starlette.status import (HTTP_201_CREATED, HTTP_400_BAD_REQUEST,
                              HTTP_401_UNAUTHORIZED, HTTP_404_NOT_FOUND,
                              HTTP_503_SERVICE_UNAVAILABLE)

from project.application.service.client import ClientService
from project.hospital_management.controllers.dependencies.api_check import \
    verify_api_key
from project.hospital_management.controllers.dependencies.dependencies import \
    get_client_service
from project.hospital_management.controllers.dependencies.verify_token import \
    verify_token
from project.shared.schemas.client import (ClientInput, ClientResponse, Login,
                                           TokenResponse, UpdateClient,
                                           VerifyClientResponse)
from project.shared.schemas.exceptions import (
    NotFoundExceptionResponse, ServiceUnavailableExceptionResponse,
    UnauthorizedExceptionResponse, UserAlreadyExistsResponse,
    UserNotFoundResponse)

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
async def login(login: Annotated[
    Login,
    Body(openapi_examples={
        "admin": {
            "summary": "Exemplo de admin",
            "description":
            "Este é um exemplo de login para um **administrador**, que tem acesso total ao sistema.",
            "value": {
                "email": "carlos.admin@example.com",
                "password": "admin123"
            }
        },
        "nurse": {
            "summary": "Exemplo de enfermeira",
            "description":
            "Este é um exemplo de login para uma **enfermeira**, que pode acessar informações de pacientes e realizar tarefas administrativas.",
            "value": {
                "email": "juliana.nurse@example.com",
                "password": "nurse123"
            }
        },
        "cleanner": {
            "summary": "Exemplo de faxineiro",
            "description":
            "Este é um exemplo de login para um **faxineiro**, que tem acesso limitado para realizar suas atividades de limpeza.",
            "value": {
                "email": "fernando.cleaner@example.com",
                "password": "cleaner123"
            }
        }
    }, )],
                client_service: ClientService = Depends(get_client_service)):
    logger.info(f"Login requested for username: {login.email}")
    token = client_service.login(login)
    return token


@router.put('',
            response_model=ClientResponse,
            dependencies=[Depends(verify_api_key)],
            responses={
                HTTP_401_UNAUTHORIZED: {
                    'model': UnauthorizedExceptionResponse,
                },
                HTTP_404_NOT_FOUND: {
                    'model': UserNotFoundResponse,
                },
                HTTP_503_SERVICE_UNAVAILABLE: {
                    'model': ServiceUnavailableExceptionResponse,
                }
            })
async def update_client(
    client_data: UpdateClient,
    user: VerifyClientResponse = Depends(verify_token),
    client_service: ClientService = Depends(get_client_service)):

    logger.info(f"Update requested for client ID: {user.id}")
    updated_client = client_service.update_client(user.id, client_data)
    logger.info(f"Client updated successfully: {updated_client}")

    return updated_client
