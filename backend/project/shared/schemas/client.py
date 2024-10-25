from typing import Optional

from pycpfcnpj import cpf
from pydantic import BaseModel, EmailStr, Field, field_validator

from project.shared.enum.enums import PositionEnum


class ClientInput(BaseModel):
    name: str = Field(..., description="O nome do cliente.", example="João")
    password: str = Field(...,
                          description="A senha do cliente.",
                          example="s3cr3tP@ssw0rd")
    email: EmailStr = Field(...,
                            description="O endereço de e-mail do cliente.",
                            example="joaodasilva@example.com")
    phone: str = Field(...,
                       description="O número de telefone.",
                       example="71984659415")
    tax_number: str = Field(
        ...,
        description="O número de identificação único do cliente.",
        examples=["72166670695", '54286704360'])
    hospital_unique_code: str = Field(...,
                                      description="Código único do hospital",
                                      example="abcd1234")
    position: Optional[str] = Field(PositionEnum.NURSE.value,
                          description="Posição do cliente no hospital",
                          examples=["NURSE", "CLEANER"])

    @field_validator('tax_number')
    def validate_tax_number(cls, value):
        if not cpf.validate(value):
            raise ValueError(
                'O número de identificação deve ter 11 dígitos (CPF) ou 14 dígitos (CNPJ).'
            )
        return value


class ClientResponse(BaseModel):
    id: Optional[int] = Field(default=None,
                              description="O identificador único do cliente.",
                              example="1")
    name: str = Field(...,
                      description="O nome do cliente.",
                      example="João da Silva")
    email: str = Field(...,
                       description="O endereço de e-mail do cliente.",
                       example="joaodasilva@example.com")


class Login(BaseModel):
    email: str
    password: str


class TokenResponse(BaseModel):
    sub: Optional[str] = Field(None,
                               description="Token",
                               example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")


class VerifyClientResponse(BaseModel):
    id: Optional[int] = Field(default=None,
                              description="O identificador único do cliente.",
                              example="1")
    username: str = Field(...,
                      description="O nome do cliente.",
                      example="João da Silva")
    email: str = Field(...,
                       description="O endereço de e-mail do cliente.",
                       example="joaodasilva@example.com")


class UpdateClient(BaseModel):
    name: str = Field(..., description="O nome do cliente.", example="João")
    password: str = Field(...,
                          description="A senha do cliente.",
                          example="s3cr3tP@ssw0rd")
    email: str = Field(...,
                       description="O endereço de e-mail do cliente.",
                       example="joaodasilva@example.com")
    phone: str = Field(...,
                       description="O número de telefone.",
                       example="71984659415")
    tax_number: str = Field(
        ...,
        description="O número de identificação único do cliente.",
        examples=["53071916000", '12745866000100'])


login_openapi_examples = {
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
}
