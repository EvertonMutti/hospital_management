from pydantic import BaseModel, Field

class SectorBase(BaseModel):
    id: int
    name: str = Field(..., description="Nome do setor.", example="Centro Cirúrgico")
    hospital_id: int = Field(..., description="ID do hospital ao qual o setor pertence.", example=1)

class SectorCreate(SectorBase):
    name: str = Field(..., description="Nome do setor.", example="Centro Cirúrgico")
    hospital_id: int = Field(..., description="ID do hospital ao qual o setor pertence.", example=1)

class SectorUpdate(SectorBase):
    pass

class SectorResponse(SectorBase):
    id: int = Field(..., description="ID do setor.", example=1)

    class Config:
        orm_mode = True
