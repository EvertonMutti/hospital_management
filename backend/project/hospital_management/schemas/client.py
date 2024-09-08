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


class Login(BaseModel):
    email: str = Field(...,
                       description="O endereço de e-mail do usuário.",
                       example="joaodasilva@example.com")
    password: str = Field(...,
                          description="A senha da conta do usuário.",
                          example="s3cr3tP@ssw0rd")


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


class TokenResponse(BaseModel):
    status: bool = Field(..., description="Status", example=True)
    sub: Optional[str] = Field(None,
                               description="Token",
                               example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9")
