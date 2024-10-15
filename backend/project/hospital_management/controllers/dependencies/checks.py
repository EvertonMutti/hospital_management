from pycpfcnpj import cnpj

from project.shared.exceptions.exceptions import BadRequestException


def check_cnpj(tax_number: str):
    if not cnpj.validate(tax_number):
        raise BadRequestException(detail='Path parameter is not a valide cnpj')
