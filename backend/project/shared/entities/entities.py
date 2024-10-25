import uuid

from sqlalchemy import (Column, DateTime, Enum, ForeignKey, Integer, String,
                        Table)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from project.hospital_management.settings.database import Base
from project.shared.enum.enums import (BedStatus, PositionEnum, ScopesStatus,
                                       SectorStatus)

client_hospital = Table(
    'client_hospital', Base.metadata,
    Column('client_id', Integer, ForeignKey('client.id'), primary_key=True),
    Column('hospital_id', Integer, ForeignKey('hospital.id'),
           primary_key=True))


class Client(Base):
    __tablename__ = 'client'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    email = Column(String(100), nullable=False, unique=True)
    password = Column(String(100), nullable=False)
    phone = Column(String(20))
    tax_number = Column(String(14), nullable=False, unique=True)
    position = Column(Enum(PositionEnum), default=PositionEnum.NURSE)
    permission = Column(Enum(ScopesStatus), default=ScopesStatus.USER)

    hospitals = relationship('Hospital',
                             secondary=client_hospital,
                             back_populates='clients')


class Admission(Base):
    __tablename__ = 'admission'

    id = Column(Integer, primary_key=True, autoincrement=True)
    patient_id = Column(Integer, ForeignKey('patient.id'), nullable=False)
    bed_id = Column(Integer, ForeignKey('bed.id'), nullable=False)
    admission_date = Column(DateTime, default=func.now())
    discharge_date = Column(DateTime, nullable=True)

    patient = relationship('Patient', back_populates='admissions')
    bed = relationship('Bed', back_populates='admissions')


class Bed(Base):
    __tablename__ = 'bed'

    id = Column(Integer, primary_key=True, autoincrement=True)
    bed_number = Column(String, nullable=False)
    sector_id = Column(Integer, ForeignKey('sector.id'), nullable=False)
    status = Column(Enum(BedStatus), default=BedStatus.FREE)

    sector = relationship('Sector', back_populates='beds')
    admissions = relationship('Admission', back_populates='bed')


class Hospital(Base):
    __tablename__ = 'hospital'

    id = Column(Integer, primary_key=True, autoincrement=True, index=True)
    name = Column(String(100))
    tax_number = Column(String(14), unique=True)
    unique_code = Column(String(6),
                         unique=True,
                         index=True,
                         default=lambda: str(uuid.uuid4().hex[:6]))
    address = Column(String)

    sectors = relationship('Sector', back_populates='hospital')
    clients = relationship('Client',
                           secondary=client_hospital,
                           back_populates='hospitals')
    patients = relationship('Patient', back_populates='hospital')


class Patient(Base):
    __tablename__ = 'patient'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    tax_number = Column(String(14), unique=True)
    hospital_id = Column(Integer, ForeignKey('hospital.id'), nullable=False)

    admissions = relationship('Admission', back_populates='patient')
    hospital = relationship('Hospital', back_populates='patients')


class Sector(Base):
    __tablename__ = 'sector'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    hospital_id = Column(Integer, ForeignKey('hospital.id'))
    status = Column(Enum(SectorStatus), default=SectorStatus.WORKING)

    beds = relationship('Bed', back_populates='sector')
    hospital = relationship('Hospital', back_populates='sectors')

    #UTI
    #CTI
