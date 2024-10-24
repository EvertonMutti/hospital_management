from enum import Enum


class SectorsEnum(Enum):
    WITHOUT_SECTOR = "SEM SETOR"


class BedStatus(Enum):
    FREE = "FREE"  # Livre
    OCCUPIED = "OCCUPIED"  # Ocupado
    MAINTENANCE = "MAINTENANCE"  # Manutenção
    CLEANING = "CLEANING"  # Em limpeza
    CLEANING_REQUIRED = "CLEANING_REQUIRED"  # Limpeza necessária
    DELETED = "DELETED"  # Deletado

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
    CLEANER = "CLEANER"

    @classmethod
    def get_status_options(cls):
        return [status.value for status in cls]


class SectorStatus(Enum):
    WORKING = "WORKING"
    DELETED = "DELETED"
