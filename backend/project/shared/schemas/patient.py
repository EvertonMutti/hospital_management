from pydantic import BaseModel


class PatientResponse(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True
