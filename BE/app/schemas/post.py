from typing import Optional
from pydantic import BaseModel, Field

class ListPostRequest(BaseModel):
	count : str = Field(...)
	last_id : Optional[str]
	index : str = Field(...)
	token : str = Field(...)

class PostRequest(BaseModel):
	describle : str = Field(...)
	video : Optional[str]
	image : Optional[list]
	token : str = Field(...)

class ReportPost(BaseModel):
	token : str = Field(...)
	id : str = Field(...)
	subject : str = Field(...)
	details : str = Field(...)

class LikePost(BaseModel):
	token : str = Field(...)
	id : str = Field(...)