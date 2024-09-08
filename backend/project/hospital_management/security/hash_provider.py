from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["sha256_crypt"])


def verify_password(text: str, hash) -> bool:
    return pwd_context.verify(text, hash)


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)
