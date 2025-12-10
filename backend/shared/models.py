from pydantic import BaseModel, HttpUrl

class CreateURLRequest(BaseModel):
    long_url: HttpUrl