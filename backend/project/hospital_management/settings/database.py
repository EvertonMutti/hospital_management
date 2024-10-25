from sqlalchemy import create_engine, inspect
from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy.pool import StaticPool
from sqlalchemy.exc import SQLAlchemyError
from project.hospital_management.settings.settings import get_settings

settings = get_settings().database_settings
if 'memory' in settings.database_url:
    engine = create_engine(settings.database_url,
                           future=True,
                           connect_args={"check_same_thread": False},
                           poolclass=StaticPool)
else:
    engine = create_engine(settings.database_url, future=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def list_tables():
    inspector = inspect(engine)
    tables = inspector.get_table_names()
    return tables


def create_database():
    Base.metadata.create_all(bind=engine)
    print("Tabelas criadas. Listando tabelas:")
    print(list_tables())


def drop_database():
    Base.metadata.drop_all(engine)


def reset_database():
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(bind=engine)


def get_session():
    db = SessionLocal()
    try:
        yield db
    except SQLAlchemyError as e:
        print(f"Error accessing database: {e}")
        db.rollback()
    finally:
        db.close()
