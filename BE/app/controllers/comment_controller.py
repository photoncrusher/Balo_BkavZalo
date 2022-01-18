from app.schemas.comment import CommentRequest, EditCommentRequest, GetCommentRequest, DeleteCommentRequest
from app.repositories import comment_repo, user_repo, post_repo
from app.auth.auth import AuthHandler
from app.utils.response import ResponseModel, ErrorResponseModel

auth_handler = AuthHandler()

def create(comment_req : CommentRequest):
    if post_repo.find_by_id(comment_req.id) is None:
		# raise HTTPException(status_code=400, detail='9992')
        return ErrorResponseModel(None, 9992, message='9992')
    comment_dict = vars(comment_req)
    comment_dict['post_id'] = comment_req.id
    comment_dict.pop('index', None)
    comment_dict.pop('count', None)
    final_res = gen_comment_response(comment_dict, comment_dict['token'], 'create')
    return ResponseModel(1000,'Success',data=final_res)

def get_list_comment(get_comment_req : GetCommentRequest):
    get_comment_dict = vars(get_comment_req)
    if post_repo.find_by_id(get_comment_dict['id']) is None:
		# raise HTTPException(status_code=400, detail='9992')
        return ErrorResponseModel(None, 9992,message='9992')
    results = comment_repo.get_list_comment(get_comment_dict['id'], None, get_comment_dict['count'])
    list_comment_res = []
    for result in results:
        comment_response = gen_comment_response(result.to_dict(),get_comment_dict['token'],'get_list')
        list_comment_res.append(comment_response)
    return ResponseModel(1000,'Success',data=list_comment_res)

def delete_comment(del_comment_req : DeleteCommentRequest):
    if post_repo.find_by_id(del_comment_req.id) is None:
		# raise HTTPException(status_code=400, detail='9992')
        return ErrorResponseModel(None, 9992,message='9992')
    cur_user = auth_handler.decode_token(del_comment_req.token)
    cur_comment = comment_repo.find_comment_by_id(del_comment_req.id_com)
    if cur_comment['post_id'] == del_comment_req.id and cur_user['phonenumber'] == cur_comment['poster']['id']:
        comment_repo.delete_comment(del_comment_req.id_com)
        return ResponseModel(1000,'Success',data=None)
    else: 
        return ErrorResponseModel(None,1009,message='1009')

def edit_comment(edit_comment_req : EditCommentRequest):
    if post_repo.find_by_id(edit_comment_req.id) is None:
		# raise HTTPException(status_code=400, detail='9992')
        return ErrorResponseModel(None,9992,message='9992')
    try:
        edit_comment_dict = vars(edit_comment_req)
        cur_comment = comment_repo.find_comment_by_id(edit_comment_dict['id_com'])
        cur_user = auth_handler.decode_token(edit_comment_dict['token'])
        if (cur_user['phonenumber'] == cur_comment['poster']['id']):
            comment_repo.edit_comment(edit_comment_dict['id_com'], edit_comment_dict['comment'])
            return ResponseModel(1000,'Success',data=None)
    except:
        return ErrorResponseModel(None,9999,message='9999')

def gen_comment_response(comment_dict : dict, token: str, process : str):
    payload = auth_handler.decode_token(token)
    comment_poster = user_repo.find_by_phonenumber(payload['phonenumber']).to_dict()
    
    if process == 'create':
        comment_dict['poster'] = {
            'id' : comment_poster['phonenumber'],
            'name' : comment_poster['username'],
            'avatar' : comment_poster['avatar']
        }
        cur_post = post_repo.find_by_id(comment_dict['id'])
    else: 
        cur_post = post_repo.find_by_id(comment_dict['post_id'])
    post_author = user_repo.find_by_phonenumber(cur_post['author']['id']).to_dict()
    res = comment_dict
    if process == 'create':
        comment_dict.pop('token', None)
        res = comment_repo.create(comment_dict)
    res['is_blocked'] = 'true' if comment_poster['phonenumber'] in post_author['block_list'] else 'false'
    return res