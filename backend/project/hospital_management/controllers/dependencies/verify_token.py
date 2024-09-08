from datetime import datetime, timezone

from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import jwt

from project.hospital_management.settings.settings import get_settings
from project.shared.exceptions.exceptions import TokenExpiredException

security = HTTPBearer(scheme_name='Token')
settings = get_settings()


async def verify_token(credentials: HTTPAuthorizationCredentials = Depends(
    security)) -> dict:
    token = credentials.credentials

    if token is None:
        raise HTTPException(status_code=401,
                            msg="Token não informado!",
                            data='')
    try:
        exp_token: dict = jwt.decode(
            token,
            settings.token_settings.jwt_secret_key,
            algorithms=settings.token_settings.secret_algorithm)

        exp_datetime = datetime.fromtimestamp(exp_token.get("exp"),
                                              tz=timezone.utc)

        if exp_datetime < datetime.now(timezone.utc):
            raise TokenExpiredException()

        return exp_token

    except TokenExpiredException:
        raise TokenExpiredException()

    except Exception as e:
        raise HTTPException(status_code=401, detail=f"Token inválido! - {e}")
