from pydantic import BaseModel, Field


class HMBaseModel(BaseModel):
    detail: str = Field(...,
                        description="Descrição detalhada do erro ocorrido.",
                        example='exemplo.')


class BadRequestExceptionResponse(HMBaseModel):
    detail: str = Field(description='Requisição inválida.',
                        example='Requisição inválida.')


class UnauthorizedExceptionResponse(HMBaseModel):
    detail: str = Field(
        description=
        "Não autorizado. As credenciais fornecidas são inválidas ou estão ausentes.",
        example="Não autorizado. Token de autenticação inválido ou ausente.")


class ServiceUnavailableExceptionResponse(HMBaseModel):
    detail: str = Field(description='Serviço não disponível.',
                        example='Serviço não disponível.')


class NotFoundExceptionResponse(HMBaseModel):
    detail: str = Field(description='Recurso não encontrado.',
                        example='Recurso não encontrado.')


class UserAlreadyExistsResponse(HMBaseModel):
    detail: str = Field(description='Já existe um usuário com este e-mail.',
                        example='Já existe um usuário com este e-mail.')


class UserNotFoundResponse(HMBaseModel):
    detail: str = Field(description='Usuário não encontrado.',
                        example='Usuário não encontrado.')


class ConflictExceptionResponse(BaseModel):
    detail: str = Field(
        description='Detalhe do conflito ocorrido.',
        example='O recurso já existe ou há um conflito com outro recurso.')
