from fastapi import APIRouter, Depends, Request, Header
from app.controllers import chat_controller
from app.schemas.chat import ListConversationRequest, GetMessageRequest
router = APIRouter(tags=["chat"])

@router.post("/get_list_conversation")
async def get_list_conversation(request: ListConversationRequest):
	return chat_controller.get_list_conversation(request)

@router.post("/get_list_message")
async def get_list_message(request: GetMessageRequest):
	return chat_controller.get_list_message(request)