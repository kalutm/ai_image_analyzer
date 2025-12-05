from pydantic_settings import BaseSettings
from pydantic import Field

class Settings(BaseSettings):
    # JWT / auth
    HF_TOKEN: str = Field(..., env="HF_TOKEN")
    MODEL: str = Field(..., env="MODEL")
    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        extra = "ignore"

settings = Settings()