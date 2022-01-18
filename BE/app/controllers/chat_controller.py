from app.schemas.chat import ListConversationRequest, GetMessageRequest
from app.repositories import chat_repo, user_repo
from app.auth.auth import AuthHandler
from app.utils.response import ResponseModel, ErrorResponseModel
from operator import itemgetter

auth_handler = AuthHandler()

def get_list_conversation(list_conversation_req : ListConversationRequest):
    request_dict = vars(list_conversation_req)
    payload = auth_handler.decode_token(request_dict['token'])
    results = chat_repo.get_all_conversation(payload['phonenumber'])
    list_conversation_res = []
    for conversation in results:
        conversation_dict = conversation.to_dict()
        partner = user_repo.find_by_phonenumber(conversation_dict['partner_id']).to_dict()
        conversation_dict['id'] = conversation.id
        conversation_dict['partner'] = {
            "id": partner['phonenumber'],
            "username": partner['username'],
            "avatar": partner['avatar']
        }
        last_message = max(conversation_dict['message'], key=itemgetter('created'))
        conversation_dict['last_message'] = {
            "message" : last_message['content'],
            "created" : last_message['created'],
            "unread" : last_message['unread']
        }
        conversation_dict.pop('message', None)
        list_conversation_res.append(conversation_dict)
    return ResponseModel(1000,'Success',data=list_conversation_res)

def get_list_message(get_message_req : GetMessageRequest):
    request_dict = vars(get_message_req)
    payload = auth_handler.decode_token(request_dict['token'])
    if get_message_req.partner_id != None:
        results = chat_repo.get_conversation_by_partner(payload['phonenumber'],request_dict['partner_id'])
    else:
        results = chat_repo.get_conversation_by_id(payload['phonenumber'],request_dict['conversation_id'])
    response_data = {}
    for conversation in results:
        conversation_dict = conversation.to_dict()
        list_message = []
        for message in conversation_dict['message']:
            sender =  user_repo.find_by_phonenumber(message['user_id']).to_dict()
            message['sender'] = {
                "id": sender['phonenumber'],
                "username": sender['username'],
                "avatar": sender['avatar']
            }
            message['message'] = message['content']
            message['message_id'] = message['uid']
            message.pop('user_id',None)
            message.pop('uid', None)
            message.pop('content', None)
            list_message.append(message)
        response_data['conversation'] = list_message
    return ResponseModel(1000,'Success',data=response_data)
