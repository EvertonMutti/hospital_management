from functools import lru_cache

from fastapi import Depends
from pytest import Session

from project.application.service.bed import BedService
from project.application.service.client import ClientService
from project.application.service.hospital import HospitalService
from project.application.service.patient import PatientService
from project.application.service.sector import SectorService
from project.hospital_management.settings.database import get_session, list_tables
from project.shared.datasource.admission import AdmissionDataSource
from project.shared.datasource.bed import BedDataSource
from project.shared.datasource.client import ClientDataSource
from project.shared.datasource.hospital import HospitalDataSource
from project.shared.datasource.patient import PatientDataSource
from project.shared.datasource.sector import SectorDataSource


def get_client_datasource() -> ClientDataSource:
    return ClientDataSource


def get_hospital_datasource() -> HospitalDataSource:
    return HospitalDataSource


def get_bed_datasource() -> BedDataSource:
    return BedDataSource


def get_sector_datasource() -> SectorDataSource:
    return SectorDataSource


def get_admission_datasource() -> AdmissionDataSource:
    return AdmissionDataSource


def get_patient_datasource() -> PatientDataSource:
    return PatientDataSource


def get_client_service(db: Session = Depends(get_session),
                       client_data_source: ClientDataSource = Depends(
                           get_client_datasource),
                       hospital_data_source: HospitalDataSource = Depends(
                           get_hospital_datasource)) -> ClientService:
    return ClientService(db, client_data_source, hospital_data_source)


def get_bed_service(
        db: Session = Depends(get_session),
        bed_data_source: BedDataSource = Depends(get_bed_datasource),
        admission_data_source: AdmissionDataSource = Depends(
            get_admission_datasource),
        sector_data_source: SectorDataSource = Depends(get_sector_datasource)
) -> ClientService:
    return BedService(db, bed_data_source, admission_data_source,
                      sector_data_source)


def get_sector_service(db: Session = Depends(get_session),
                       sector_data_source: SectorDataSource = Depends(
                           get_sector_datasource),
                       hospital_data_source: HospitalDataSource = Depends(
                           get_hospital_datasource),
                       bed_datasource: BedDataSource = Depends(get_bed_datasource)) -> SectorService:
    return SectorService(db, sector_data_source, hospital_data_source, bed_datasource)


def get_hospital_service(db: Session = Depends(get_session),
                         hospital_data_source: HospitalDataSource = Depends(
                             get_hospital_datasource)) -> HospitalService:
    return HospitalService(db, hospital_data_source)


def get_patient_service(db: Session = Depends(get_session),
                         patient_data_source: PatientDataSource = Depends(
                             get_patient_datasource)) -> PatientService:
    return PatientService(db, patient_data_source)

