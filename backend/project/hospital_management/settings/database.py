from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

from project.hospital_management.settings.settings import get_settings

settings = get_settings().database_settings

engine = create_engine(settings.database_url, future=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def create_database():
    Base.metadata.create_all(bind=engine)


def drop_database():
    Base.metadata.drop_all(engine)


def reset_database():
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(bind=engine)


def get_session():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
