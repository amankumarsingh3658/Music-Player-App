from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token = Header()):
    try:
        # get the user token from headers
        if not x_auth_token:
            raise HTTPException(401 , "No auth token, Access Denied")
        # decode the token
        verified_token = jwt.decode(x_auth_token,'password_key',['HS256'])
        if not verified_token:
            raise HTTPException(401 , "Token Verification Failed , authorization Failed")
        # get the id from the token that is the payload
        uid = verified_token.get('id')
        return {'uid': uid, 'token': x_auth_token}
        # get the user info from postgresql using token
    except jwt.PyJWTError:
        raise HTTPException(401 , "Token is invalid, Authorisation failed")