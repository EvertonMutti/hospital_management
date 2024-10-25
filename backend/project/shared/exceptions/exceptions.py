from fastapi import HTTPException
from starlette.status import (HTTP_400_BAD_REQUEST, HTTP_401_UNAUTHORIZED,
                              HTTP_403_FORBIDDEN, HTTP_404_NOT_FOUND,
                              HTTP_409_CONFLICT, HTTP_503_SERVICE_UNAVAILABLE)


class UnauthorizedException(HTTPException):

    def __init__(self, detail: str = "O cliente não está habilitado"):
        super().__init__(status_code=HTTP_401_UNAUTHORIZED, detail=detail)


class MissingScopeException(HTTPException):

    def __init__(self, detail: str = "Token sem escopo necessário"):
        super().__init__(status_code=HTTP_401_UNAUTHORIZED, detail=detail)


class TokenExpiredException(HTTPException):

    def __init__(self, detail: str = "O token expirou!"):
        super().__init__(status_code=HTTP_403_FORBIDDEN, detail=detail)


class InvalidApiKeyException(HTTPException):

    def __init__(self, detail: str = "Chave de API inválida"):
        super().__init__(status_code=HTTP_401_UNAUTHORIZED, detail=detail)


class UserAlreadyExistsException(HTTPException):

    def __init__(self, detail: str = "Já existe um usuário com este e-mail."):
        super().__init__(status_code=HTTP_400_BAD_REQUEST, detail=detail)


class HospitalAlreadyExistsException(HTTPException):

    def __init__(self, detail: str = "Já existe um Hospital com este cnpj."):
        super().__init__(status_code=HTTP_400_BAD_REQUEST, detail=detail)


class InvalidCredentialsException(HTTPException):

    def __init__(self, detail: str = "E-mail ou senha inválidos"):
        super().__init__(status_code=HTTP_400_BAD_REQUEST, detail=detail)


class ServiceUnavailableException(HTTPException):

    def __init__(
        self,
        detail:
        str = "O serviço está indisponível no momento. Por favor, tente novamente mais tarde."
    ):
        super().__init__(status_code=HTTP_503_SERVICE_UNAVAILABLE,
                         detail=detail)


#class UniqueConstraintViolationException(HTTPException):
#
#    def __init__(
#            self,
#            detail: str = "A supplier with this tax number already exists."):
#        super().__init__(status_code=HTTP_400_BAD_REQUEST, detail=detail)


class BedNotFoundException(HTTPException):

    def __init__(self, detail: str = "Leito não encontrada"):
        super().__init__(status_code=HTTP_404_NOT_FOUND, detail=detail)


class UserNotFoundException(HTTPException):

    def __init__(self, detail: str = "Usuário não encontrado"):
        super().__init__(status_code=HTTP_404_NOT_FOUND, detail=detail)


class HospitalNotFoundException(HTTPException):

    def __init__(self, detail: str = "Hospital não encontrado"):
        super().__init__(status_code=HTTP_404_NOT_FOUND, detail=detail)


class SectorNotFoundException(HTTPException):

    def __init__(self, detail: str = "Setor não encontrado"):
        super().__init__(status_code=HTTP_404_NOT_FOUND, detail=detail)


class BadRequestException(HTTPException):

    def __init__(
            self,
            detail: str = 'Requisição inválida. Verifique os dados fornecidos.'
    ):
        super().__init__(status_code=HTTP_400_BAD_REQUEST, detail=detail)


class ConflictException(HTTPException):

    def __init__(self, detail: str = "Conflito Ocorreu"):
        super().__init__(status_code=HTTP_409_CONFLICT, detail=detail)
