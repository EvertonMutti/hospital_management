from datetime import datetime

from sqlalchemy import Column, DateTime, Enum, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from project.hospital_management.settings.database import Base
from project.shared.enum.enums import BedStatus


class Client(Base):
    __tablename__ = 'client'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100))
    email = Column(String(100))
    password = Column(String(100))

    hospital_id = Column(Integer,
                         ForeignKey('hospital.id'),
                         unique=True,
                         nullable=False)
    hospital = relationship('Hospital', back_populates='client', uselist=False)


#hospitalization
class Admission(Base):
    __tablename__ = 'admission'

    id = Column(Integer, primary_key=True, autoincrement=True)
    patient_id = Column(Integer, ForeignKey('patient.id'), nullable=False)
    bed_id = Column(Integer, ForeignKey('bed.id'), nullable=False)
    admission_date = Column(DateTime, default=func.now())
    discharge_date = Column(DateTime, nullable=True)

    # Relacionamento com paciente
    patient = relationship('Patient', back_populates='admissions')

    # Relacionamento com leito
    bed = relationship('Bed', back_populates='admissions')

    def discharge(self):
        self.discharge_date = datetime.now()
        self.bed.status = BedStatus.FREE  # Leito fica livre


class Bed(Base):
    __tablename__ = 'bed'

    id = Column(Integer, primary_key=True, autoincrement=True)
    bed_number = Column(String, nullable=False)
    sector_id = Column(Integer, ForeignKey('sector.id'), nullable=False)
    status = Column(Enum(BedStatus), default=BedStatus.FREE)

    # Relacionamento com setor
    sector = relationship('Sector', back_populates='beds')

    # Um leito pode ter várias admissões
    admissions = relationship('Admission', back_populates='bed')


class Hospital(Base):
    __tablename__ = 'hospital'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    address = Column(String, nullable=False)

    sectors = relationship('Sector', back_populates='hospital')

    # Client relationship (1:1)
    client = relationship('Client', back_populates='hospital', uselist=False)


# Entidade Paciente
class Patient(Base):
    __tablename__ = 'patient'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    document = Column(String, nullable=False, unique=True)  # Exemplo: CPF

    # Um paciente pode ter várias admissões
    admissions = relationship('Admission', back_populates='patient')


class Sector(Base):
    __tablename__ = 'sector'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    hospital_id = Column(Integer, ForeignKey('hospital.id'), nullable=False)

    beds = relationship('Bed', back_populates='sector')
    hospital = relationship('Hospital', back_populates='sectors')
