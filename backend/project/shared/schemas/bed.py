from pydantic import BaseModel, Field

from project.shared.enum.enums import BedStatus


class BedBase(BaseModel):
    bed_number: str = Field(...,
                            description="O número da cama.",
                            example="C001")
    sector_id: int = Field(...,
                           description="O identificador do setor.",
                           example=1)
    status: BedStatus = Field(BedStatus.FREE,
                              description="O status da cama.",
                              example=BedStatus.FREE.value)


class BedCreate(BaseModel):
    bed_number: str = Field(...,
                            description="O número da cama a ser criada.",
                            example="C001")
    sector_id: int = Field(
        ...,
        description="O identificador do setor da cama criada.",
        example=250)


class BedUpdate(BedBase):
    pass


class Bed(BedBase):
    id: int = Field(..., description="O identificador da cama.", example=1)


class SectorResponse(BaseModel):
    sector_name: str = Field(...,
                             description="O nome do setor.",
                             example="Cardiologia")
    beds: list[Bed] = Field(..., description="Lista de camas no setor.")


class AverageFreeTimeResponse(BaseModel):
    days: int = Field(..., description="Número de dias de tempo livre médio.")
    hours: int = Field(...,
                       description="Número de horas de tempo livre médio.")


class BedStatusModel(BaseModel):
    FREE: int = Field(0, description="Número de leitos disponíveis")
    OCCUPIED: int = Field(0, description="Número de leitos ocupados")
    MAINTENANCE: int = Field(0, description="Número de leitos em manutenção")
    CLEANING: int = Field(0, description="Número de leitos em limpeza")
    CLEANING_REQUIRED: int = Field(0, description="Número de leitos que necessitam de limpeza")