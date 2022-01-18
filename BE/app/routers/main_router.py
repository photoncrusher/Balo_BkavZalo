from fastapi import FastAPI
from app.routers import auth_router, post_router, comment_router, friend_router, chat_router
from app.utils.exception_handler import custom_exception_handler
from app.utils.cors_handler import handle_cors
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()
app.include_router(auth_router.router, prefix= "/it4788")
app.include_router(post_router.router, prefix= "/it4788")
app.include_router(comment_router.router, prefix= "/it4788")
app.include_router(friend_router.router, prefix= "/it4788")
app.include_router(chat_router.router, prefix= "/it4788")
handle_cors(app)
custom_exception_handler(app)
