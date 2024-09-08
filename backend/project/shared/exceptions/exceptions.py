from fastapi import HTTPException
from starlette.status import (HTTP_400_BAD_REQUEST, HTTP_401_UNAUTHORIZED,
                              HTTP_403_FORBIDDEN, HTTP_404_NOT_FOUND,
                              HTTP_503_SERVICE_UNAVAILABLE)


class UnauthorizedException(HTTPException):

    def __init__(self, detail: str = "Client is not enabled"):
        super().__init__(status_code=HTTP_401_UNAUTHORIZED, detail=detail)


class MissingScopeException(HTTPException):

    def __init__(self, detail: str = "Token missing required scope"):
        super().__init__(status_code=HTTP_401_UNAUTHORIZED, detail=detail)


class TokenExpiredException(HTTPException):

    def __init__(self, detail: str = "Token expired!"):
        super().__init__(status_code=HTTP_403_FORBIDDEN, detail=detail)


class InvalidApiKeyException(HTTPException):

    def __init__(self, detail: str = "Invalid API key"):
        super().__init__(status_code=HTTP_401_UNAUTHORIZED, detail=detail)


class UserAlreadyExistsException(HTTPException):

    def __init__(self, detail: str = "A user with this email already exists"):
        super().__init__(status_code=HTTP_400_BAD_REQUEST, detail=detail)


class InvalidCredentialsException(HTTPException):

    def __init__(self, detail: str = "Invalid email or password"):
        super().__init__(status_code=HTTP_400_BAD_REQUEST, detail=detail)


class SupplierNotFoundException(HTTPException):

    def __init__(self, detail: str = "Supplier not found"):
        super().__init__(status_code=HTTP_404_NOT_FOUND, detail=detail)


class ServiceUnavailableException(HTTPException):

    def __init__(
        self,
        detail:
        str = "Service is currently unavailable. Please try again later."):
        super().__init__(status_code=HTTP_503_SERVICE_UNAVAILABLE,
                         detail=detail)


class UniqueConstraintViolationException(HTTPException):

    def __init__(
            self,
            detail: str = "A supplier with this tax number already exists."):
        super().__init__(status_code=HTTP_400_BAD_REQUEST, detail=detail)
