from pydantic import BaseModel, Field


class HMBaseModel(BaseModel):
    detail: str = Field(...,
                        description="Descrição detalhada do erro ocorrido.")


class ExceptionResponse(HMBaseModel):
    detail: str = Field(description='Erro interno do servidor.')


class UserAlreadyExistsResponse(HMBaseModel):
    detail: str = Field(description='Já existe um usuário com este e-mail.')
