from datetime import datetime, timezone

from jose import jwt

from project.hospital_management.settings.settings import get_settings

settings = get_settings().token_settings


def create_acess_token(data: dict):
    data_copy = data.copy()
    expiration = datetime.now(timezone.utc) + settings.token_expiration
    data_copy.update({'exp': expiration})
    token_jwt = jwt.encode(data_copy,
                           settings.jwt_secret_key,
                           algorithm=settings.secret_algorithm)

    return token_jwt


def verify_acess_token(token: str):
    payload = jwt.decode(token,
                         settings.secret_key,
                         algorithms=[settings.secret_algorithm])
    return payload.get('sub')
