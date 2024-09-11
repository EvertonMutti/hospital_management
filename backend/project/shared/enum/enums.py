from enum import Enum


class BedStatus(Enum):
    FREE = "FREE"  # Livre
    OCCUPIED = "OCCUPIED"  # Ocupado
    MAINTENANCE = "MAINTENANCE"  # Manutenção
    CLEANING = "CLEANING"  # Em limpeza
    NEEDS_CLEANING = "NEEDS_CLEANING"  # Necessário limpeza

    @classmethod
    def get_status_options(cls):
        return [status.value for status in cls]


class SectorEnum(Enum):
    A = "A"
    B = "B"
    C = "C"
