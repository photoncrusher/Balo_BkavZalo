from app.auth.auth import AuthHandler
from app.schemas.friend import SetRequestFriend, GetRequestedFriend, SetAcceptFriend
from app.repositories import friend_request_repo, user_repo
from app.utils.response import ResponseModel, ErrorResponseModel


auth_handler = AuthHandler()


def set_request_friend(set_request_friend : SetRequestFriend):
    if user_repo.find_by_phonenumber(set_request_friend.user_id) is None:
        return ErrorResponseModel(None,9995,message='9995')
    set_request_friend = vars(set_request_friend)
    cur_user = auth_handler.decode_token(set_request_friend['token'])
    set_request_friend['request_id'] = cur_user['phonenumber']
    set_request_friend.pop('token', None)
    friend_request_repo.create_friend_request(set_request_friend)
    return ResponseModel(code=1000, message='Success', data=None)

def get_requested_friend(get_requested_friend : GetRequestedFriend):

    # if user_repo.find_by_phonenumber(set_request_friend.user_id) is None:
    #     return ErrorResponseModel(None,9995,message='9995')
    get_requested_friend = vars(get_requested_friend)
    cur_user = auth_handler.decode_token(get_requested_friend['token'])
    results = friend_request_repo.find_all_requested_friend(cur_user['phonenumber'],get_requested_friend['count'])
    list_request = []
    for result in results:
        request = result.to_dict()
        cur_request_user = user_repo.find_by_phonenumber(request['request_id']).to_dict()
        request['id'] = cur_request_user['phonenumber']
        request['username'] = cur_request_user['username']
        request['avatar'] = cur_request_user['avatar']
        request.pop('request_id', None)
        request.pop('user_id', None)
        list_request.append(request)
    return ResponseModel(code=1000, message='Success', data=list_request)


def set_accept_friend(set_accept_friend : SetAcceptFriend):
    set_accept_friend = vars(set_accept_friend)
    cur_user = auth_handler.decode_token(set_accept_friend['token'])
    if set_accept_friend['is_accept'] == '0':
        friend_request_repo.delete(set_accept_friend['user_id'], cur_user['phonenumber'])
        return ResponseModel(code=1000, message='Success', data=None)
    elif set_accept_friend['is_accept'] == '1':
        friend_request_repo.delete(set_accept_friend['user_id'], cur_user['phonenumber'])
        user_repo.add_friend(cur_user['phonenumber'], set_accept_friend['user_id'])
        return ResponseModel(code=1000, message='Success', data=None)








