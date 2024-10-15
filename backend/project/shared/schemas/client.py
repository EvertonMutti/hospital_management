from typing import Optional

from pydantic import BaseModel, Field


class ClientInput(BaseModel):
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
    hospital_unique_code: str = Field(...,
                                      description="Código único do hospital",
                                      example="abcd1234")


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
    email: str = Field(...,
                       description="O endereço de e-mail do usuário.",
                       example="joaodasilva@example.com")
    password: str = Field(...,
                          description="A senha da conta do usuário.",
                          example="s3cr3tP@ssw0rd")


class TokenResponse(BaseModel):
    sub: Optional[str] = Field(None,
                               description="Token",
                               example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")


class VerifyClientResponse(BaseModel):
    id: Optional[int] = Field(default=None,
                              description="O identificador único do cliente.",
                              example="1")
    name: str = Field(...,
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
