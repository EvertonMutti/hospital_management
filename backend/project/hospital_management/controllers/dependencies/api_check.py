import logging
from typing import Literal

from fastapi import Depends
from fastapi.security import APIKeyHeader

from project.hospital_management.settings.settings import get_settings
from project.shared.exceptions.exceptions import InvalidApiKeyException

api_key_scheme = APIKeyHeader(name="api-key")
settings = get_settings()


async def verify_api_key(key: str = Depends(api_key_scheme)) -> Literal[True]:
    if key != settings.token_settings.api_key:
        logging.info(f'Error 401 - Invalid api-key: {key}')
        raise InvalidApiKeyException()
    return True
