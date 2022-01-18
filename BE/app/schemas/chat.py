from pydantic import BaseModel, Field
from typing import Optional

class ListConversationRequest(BaseModel):
    token : str = Field(...)
    index : str = Field(...)
    count: str = Field(...)

class GetMessageRequest(BaseModel):
    token : str = Field(...)
    index : str = Field(...)
    count: str = Field(...)
    partner_id : Optional[str]
    conversation_id : Optional[str]