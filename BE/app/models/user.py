from pydantic import BaseModel, Field
from typing import Optional

class User(BaseModel):

    username: Optional[str] = None
    avatar: Optional[str] = None
    active: Optional[bool] = False
    phonenumber: str = Field(..., regex="^0\d{9}$")
    password: str = Field(..., regex="^.{6,10}$")
    uuid: str = Field(...)

    def to_dict(self):
        return vars(self)

    @staticmethod
    def from_dict(source):
        pass
    def __repr__(self) -> str:
        return(
            f'User(\
                phonenumber={self.phonenumber}, \
                password={self.password}, \
                uuid={self.uuid}, \
            )'
        )
    