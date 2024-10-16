from pydantic import BaseModel, Field


class HospitalBase(BaseModel):
    name: str = Field(...,
                      description="Nome do hospital",
                      example="Hospital São Paulo")
    tax_number: str = Field(...,
                            description="CNPJ do hospital",
                            example="15398562478915")
    address: str = Field(...,
                         description="Endereço do hospital",
                         example="Rua das Flores, 123")


class HospitalCreate(HospitalBase):
    pass


class HospitalResponse(HospitalBase):
    id: int = Field(..., description="ID do hospital", example=1)
    unique_code: str = Field(...,
                             description="Código único do hospital",
                             example="asda651")

    class Config:
        from_attributes = True


class ClientHospitalLink(BaseModel):
    client_id: int = Field(..., description="ID do cliente", example=1)
    hospital_id: int = Field(..., description="ID do hospital", example=1)
