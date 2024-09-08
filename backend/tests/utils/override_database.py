import os
os.environ['DATABASE_URL'] = "sqlite:///./test.db"
from project.hospital_management.settings.settings import get_settings
settings = get_settings().database_settings