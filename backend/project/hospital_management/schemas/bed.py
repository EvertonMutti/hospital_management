from pydantic import BaseModel, Field
from project.shared.enum.enums import BedStatus

class BedBase(BaseModel):
    bed_number: str = Field(..., description="O número da cama.", example="101")
    sector_id: int = Field(..., description="O identificador do setor.", example=1)
    status: BedStatus = Field(BedStatus.FREE, description="O status da cama.", example=BedStatus.FREE.value)

class BedCreate(BedBase):
    bed_number: str = Field(..., description="O número da cama a ser criada.", example="110")
    sector_id: int = Field(..., description="O identificador do setor da cama criada.", example=250)

class BedUpdate(BedBase):
    pass
class Bed(BedBase):
    id: int = Field(..., description="O identificador da cama.", example=1)

    class Config:
        orm_mode = True
