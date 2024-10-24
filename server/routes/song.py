import uuid
import cloudinary
from fastapi import APIRouter, Depends, File, Form, UploadFile
from database import get_db
from middleware.auth_middleware import auth_middleware
import cloudinary.uploader
from models.song import SongTable

router = APIRouter()

cloudinary.config( 
    cloud_name = "dfzg0rpng", 
    api_key = "791336848523646",
    api_secret = "aEPRHCuZjFiFn-zJhT-L1M-QKpI",
    secure=True
)

@router.post("/upload", status_code= 201)
def upload_song(song: UploadFile = File(...), thumbnail: UploadFile = File(...), artist: str = Form(...), song_name: str = Form(...), hex_code:str = Form(...) , db = Depends(get_db) , user_dict = Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type = 'auto', folder = f'songs/{song_id}')
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file , resource_type = 'image', folder = f'songs/{song_id}')
    new_song = SongTable(id = song_id , song_name = song_name,hex_code = hex_code, artist = artist ,song_url = song_res['url'] , thumbnail_url = thumbnail_res['url'])
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    pass

@router.get('/list')
def list_songs(db = Depends(get_db), auth_details = Depends(auth_middleware)):
    songs = db.query(SongTable).all()
    return songs
    pass