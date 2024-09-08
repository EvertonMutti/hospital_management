import logging
from datetime import datetime, timedelta
from functools import lru_cache

from dotenv import load_dotenv
from pydantic_settings import BaseSettings

from project.shared.utils.environment import get_environment

load_dotenv()


class LogSettings(BaseSettings):
    log_level: int = logging.INFO if get_environment(
    ) == 'DEV' else logging.ERROR
    log_path: str = f'logs/{datetime.now().strftime("%Y/%m/%d")}'


class StaticContentSettings(BaseSettings):
    image_path: str = f'static/images/{datetime.now().strftime("%Y/%m/%d")}'


class DatabaseSettings(BaseSettings):
    database_url: str


class FastAPISettings(BaseSettings):
    host: str = '0.0.0.0'
    port: int = 8080
    url_favicon: str
    reload: bool = True


class TokenSettings(BaseSettings):
    jwt_secret_key: str
    token_expiration: timedelta = timedelta(hours=1)
    api_key: str
    secret_algorithm: str


class Settings(BaseSettings):
    log_settings: LogSettings = LogSettings()
    database_settings: DatabaseSettings = DatabaseSettings()
    fastapi_settings: FastAPISettings = FastAPISettings()
    token_settings: TokenSettings = TokenSettings()
    static_content_settings: StaticContentSettings = StaticContentSettings()

    class Config:
        extra = "forbid"


@lru_cache
def get_settings():
    return Settings()
