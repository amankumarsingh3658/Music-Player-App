import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import UserTable
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
import jwt
from pydantic_schemas.user_login import UserLogin

router = APIRouter()

@router.post('/signup',status_code= 201)
def signup_user(user: UserCreate , db=Depends(get_db)):
    # check if the user already exist in db
    user_db = db.query(UserTable).filter(UserTable.email == user.email).first()

    if user_db:
        raise HTTPException(400 , 'User with same email already exist!') 
    # add the user to db if not present
    hashed_password = bcrypt.hashpw(password=user.password.encode() , salt= bcrypt.gensalt())
    new_user = UserTable(id= str(uuid.uuid4()),name=user.name, email=user.email,password = hashed_password)
    db.add(new_user)
    db.commit()

    db.refresh(new_user)
    return new_user
    pass
 

@router.post('/login')
def login_user(user :UserLogin, db = Depends(get_db)):
    # Check if the user with the same email alread exist or not
    user_db = db.query(UserTable).filter(UserTable.email== user.email).first()

    if not user_db:
        raise HTTPException(400 , 'User with this email doesnot exist')
    # if password is match Login
    is_match = bcrypt.checkpw(user.password.encode() , user_db.password)
    # return User Data if successfull login
    if not is_match:
        raise HTTPException(400 , 'Incorrect Password')

    #jwt takes two primary fields 1-> Payload
    token = jwt.encode({'id': user_db.id},'password_key')

    return {'token': token , 'user': user_db}
    pass

@router.get('/')
def current_user_data(db = Depends(get_db) , x_auth_token = Header(), user_dict = Depends(auth_middleware)):
    user = db.query(UserTable).filter(UserTable.id == user_dict['uid']).first()
    if not user:
        raise HTTPException(404 , "User not found")
    return user
    pass