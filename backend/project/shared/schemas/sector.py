from pydantic import BaseModel, Field


class SectorBase(BaseModel):
    id: int = Field(..., description="ID do setor.", example=1)
    name: str = Field(...,
                      description="Nome do setor.",
                      example="Centro Cirúrgico")
    hospital_id: int = Field(
        ..., description="ID do hospital ao qual o setor pertence.", example=1)


class SectorCreate(BaseModel):
    name: str = Field(...,
                      description="Nome do setor.",
                      example="Centro Cirúrgico")
    hospital_id: int = Field(
        ..., description="ID do hospital ao qual o setor pertence.", example=1)


class SectorUpdate(SectorCreate):
    pass


class SectorResponse(SectorBase):
    pass

    class Config:
        from_attributes = True
