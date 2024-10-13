from enum import Enum


class BaseEnum(Enum):
    ...


class BedStatus(Enum):
    FREE = "FREE"  # Livre
    OCCUPIED = "OCCUPIED"  # Ocupado
    MAINTENANCE = "MAINTENANCE"  # Manutenção
    CLEANING = "CLEANING"  # Em limpeza

    @classmethod
    def get_status_options(cls):
        return [status.value for status in cls]


class ScopesStatus(Enum):
    ADMIN = "ADMIN"
    USER = "USER"

    @classmethod
    def get_status_options(cls):
        return [status.value for status in cls]


class PositionEnum(Enum):
    NURSE = "NURSE"
    CUSTODIAN = "CUSTODIAN"

    @classmethod
    def get_status_options(cls):
        return [status.value for status in cls]


class SectorEnum(Enum):
    A = "A"
    B = "B"
    C = "C"
