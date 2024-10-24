from fastapi import APIRouter, Depends, Path

from project.application.service.patient import PatientService
from project.hospital_management.controllers.dependencies.api_check import verify_api_key
from project.hospital_management.controllers.dependencies.dependencies import \
    get_patient_service
from project.hospital_management.controllers.dependencies.verify_token import verify_token
from project.shared.schemas.patient import PatientResponse

router = APIRouter()
TAX_NUMBER_DESCRIPTION = 'Número de identificação único'


@router.get("/{tax_number}/unadmitted", dependencies=[Depends(verify_token), Depends(verify_api_key)],response_model=list[PatientResponse])
def list_unadmitted_patients(
        tax_number: str = Path(...,
                               title="CNPJ",
                               description=TAX_NUMBER_DESCRIPTION,
                               min_length=14,
                               max_length=14),
        patient_service: PatientService = Depends(get_patient_service)):
    return patient_service.get_unadmitted_patients(tax_number)
