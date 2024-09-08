import os


def get_environment() -> str:
    return os.environ.get('ENVIRONMENT', 'DEV')
