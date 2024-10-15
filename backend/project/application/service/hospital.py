import logging
from typing import List, Optional

from sqlalchemy.orm import Session

from project.shared.datasource.hospital import HospitalDataSource
from project.shared.exceptions.exceptions import (
    HospitalAlreadyExistsException, HospitalNotFoundException,
    ServiceUnavailableException)
from project.shared.schemas.hospital import HospitalCreate, HospitalResponse

logger = logging.getLogger(__name__)


class HospitalService:

    def __init__(self, session: Session,
                 hospital_data_source: HospitalDataSource):
        self.db = session
        self.hospital_data_source: HospitalDataSource = hospital_data_source(
            session)

    def create_hospital(self, hospital: HospitalCreate) -> HospitalResponse:
        try:
            if self.hospital_data_source.get_hospital_by_tax_number(
                    hospital.tax_number):
                logger.warning(
                    f"Hospital with tax_number {hospital.tax_number} already exists"
                )
                raise HospitalAlreadyExistsException()
            return HospitalResponse(
                **self.hospital_data_source.create_hospital(hospital).__dict__)
        except HospitalAlreadyExistsException:
            raise
        except Exception as error:
            logger.error(f"Failed to create client: {error}")
            raise ServiceUnavailableException()

    def get_hospital_by_code(self,
                             unique_code: str) -> Optional[HospitalResponse]:
        try:
            if not (hospital := self.hospital_data_source.
                    get_hospital_by_unique_code(unique_code)):
                raise HospitalNotFoundException()
            return HospitalResponse(**hospital.__dict__)
        except HospitalNotFoundException:
            raise
        except Exception as error:
            logger.error(
                f"Failed to get hospital by unique_code {unique_code}: {error}"
            )
            raise ServiceUnavailableException()

    def get_hospital_by_tax_number(
            self, tax_number: str) -> Optional[HospitalResponse]:
        try:
            if not (hospital := self.hospital_data_source.
                    get_hospital_by_tax_number(tax_number)):
                raise HospitalNotFoundException()
            return HospitalResponse(**hospital.__dict__)
        except HospitalNotFoundException:
            raise
        except Exception as error:
            logger.error(
                f"Failed to get hospital by tax_number {tax_number}: {error}")
            raise ServiceUnavailableException()

    def list_hospitals(self, user_id: int) -> List[HospitalResponse]:
        try:
            hospitals = self.hospital_data_source.get_hospitals(user_id)
            return [
                HospitalResponse.model_validate(hospital)
                for hospital in hospitals
            ]
        except Exception:
            raise ServiceUnavailableException()
