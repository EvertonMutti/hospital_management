from fastapi import Depends
from project.application.service.client import ClientService
from project.hospital_management.controllers.dependencies.dependencies import get_client_service
from project.hospital_management.controllers.dependencies.verify_token import verify_token
from project.shared.enum.enums import PositionEnum, ScopesStatus
from project.shared.exceptions.exceptions import UnauthorizedException
from project.shared.schemas.client import VerifyClientResponse


async def verify_nurse_or_admin(user: VerifyClientResponse = Depends(verify_token), 
                                client_service: ClientService = Depends(get_client_service)) -> bool:
    client = client_service.get_client_by_id(user.id)
    if client.position == PositionEnum.NURSE or client.permission == ScopesStatus.ADMIN:
        return True
    raise UnauthorizedException(
        detail='Somente enfermeiros podem dar alta aos pacientes')