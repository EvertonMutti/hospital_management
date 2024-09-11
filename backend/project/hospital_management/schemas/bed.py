from pydantic import BaseModel

from project.shared.enum.enums import BedStatus


class BedBase(BaseModel):
    bed_number: str
    sector_id: int
    status: BedStatus = BedStatus.FREE


class BedCreate(BedBase):
    bed_number: str
    sector_id: int


class BedUpdate(BedBase):
    pass


class Bed(BedBase):
    id: int

    class Config:
        orm_mode = True
