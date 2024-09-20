from datetime import datetime

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from project.hospital_management.settings.database import get_db
from project.shared.entities.entities import Admission, Bed

router = APIRouter()


@router.get("/beds/average-free-time")
def get_average_free_time(db: Session = Depends(get_db)):
    beds = db.query(Bed).all()

    total_free_time = 0
    total_beds = 0

    for bed in beds:
        admissions = db.query(Admission).filter(
            Admission.bed_id == bed.id).all()

        last_discharge_date = None
        for admission in admissions:
            if last_discharge_date:
                free_time = (admission.admission_date -
                             last_discharge_date).total_seconds() / 3600
                total_free_time += free_time
                total_beds += 1

            last_discharge_date = admission.discharge_date

        if last_discharge_date:
            free_time = (datetime.now() -
                         last_discharge_date).total_seconds() / 3600
            total_free_time += free_time
            total_beds += 1

    average_free_time = total_free_time / total_beds if total_beds > 0 else 0

    average_days = int(average_free_time // 24)
    average_hours = int(average_free_time % 24)

    return {
        "average_free_time": {
            "days": average_days,
            "hours": average_hours
        }
    }
