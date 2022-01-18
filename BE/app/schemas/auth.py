from pydantic import BaseModel, Field

class SignupRequest(BaseModel):
	username: str = Field(..., regex="^\w{1,20}$")
	phonenumber : str = Field(..., regex="^0\d{9}$")
	password : str = Field(..., regex="^\w{6,10}$")
	username: str = Field(..., regex="^[a-zA-Z0-9]$")
	uuid: str = Field(...)

class LoginRequest(BaseModel):
	phonenumber : str = Field(..., regex="^0\d{9}$")
	password : str = Field(..., regex="^\w{6,10}$")
	
