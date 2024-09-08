import logging
import os
from datetime import datetime
from typing import Optional

from project.hospital_management.settings.settings import get_settings
from project.shared.utils.environment import get_environment


class ColorfulFormatter(logging.Formatter):
    grey = "\x1b[38;20m"
    yellow = "\x1b[33;20m"
    red = "\x1b[31;20m"
    bold_red = "\x1b[31;1m"
    blue = "\x1b[34;20m"
    reset = "\x1b[0m"
    format = "%(asctime)s - [%(name)s.%(levelname)s] - %(message)s (%(filename)s:%(lineno)d)"

    FORMATS = {
        logging.DEBUG: grey + format + reset,
        logging.INFO: blue + format + reset,
        logging.WARNING: yellow + format + reset,
        logging.ERROR: red + format + reset,
        logging.CRITICAL: bold_red + format + reset
    }

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt, datefmt='%Y-%m-%d %H:%M:%S')
        return formatter.format(record)


def get_log_file_path() -> str:
    settings = get_settings()
    now_br_date = datetime.now().strftime("%Y%m%d")
    if not os.path.exists(settings.log_settings.log_path):
        logging.info("Create Folder")
        os.makedirs(settings.log_settings.log_path)
    return f"{settings.log_settings.log_path}/{now_br_date}.log"


def setup_logging(level: Optional[int] = logging.INFO) -> None:
    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(ColorfulFormatter())

    handlers = [stream_handler]

    if get_environment() != 'VERCEL':
        handlers.append(logging.FileHandler(get_log_file_path(), 'a'))

    logging.basicConfig(
        level=level,
        encoding='utf-8',
        format=
        '%(asctime)s - [%(name)s.%(levelname)s] - %(message)s (%(filename)s:%(lineno)d)',
        datefmt='%Y-%m-%d %H:%M:%S',
        handlers=handlers)


setup_logging()
