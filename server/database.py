from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


DATABASE_URL = 'postgresql://postgres:test123@localhost:5432/flutter_music_app'

engine = create_engine(DATABASE_URL) #starting point of sqlalchemy

SessionLocal = sessionmaker(autoflush= False, autocommit = False , bind= engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally: 
        db.close()