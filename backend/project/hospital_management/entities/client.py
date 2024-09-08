from sqlalchemy import VARCHAR, Column, Integer

from project.hospital_management.settings.database import Base


class Client(Base):
    __tablename__ = 'Client'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(VARCHAR(100))
