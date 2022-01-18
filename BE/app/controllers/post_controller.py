from app.schemas.post import ReportPost, PostRequest, ListPostRequest, LikePost
from app.repositories import post_repo, reported_post_repo, user_repo
from app.auth.auth import AuthHandler
from app.utils.response import ResponseModel, ErrorResponseModel

auth_handle = AuthHandler()

def ok(data = None):
	res = {'code': '1000', 'message': 'OK'}
	if data is not None:
		res['data'] = data
	return res

def create_post(post_req : PostRequest):
	post_dict = vars(post_req)
	payload = auth_handle.decode_token(post_dict['token'])
	author = user_repo.find_by_phonenumber(payload['phonenumber']).to_dict()
	post_dict['author'] = {
		'id' : author['phonenumber'],
		'name': author['username'],
		'avatar' : author['avatar']
	}
	post_dict['can_comment'] = True
	post_dict.pop('token',None)
	res = post_repo.create(post_dict)
	return ResponseModel(code=1000, message='Success', data={
		'id' : res['id'],
		'url' : 'url'
	})

def find_by_id(id : str, token : str):
	if post_repo.find_by_id(id) is None:
		# raise HTTPException(status_code=400, detail='9992')
		return ErrorResponseModel(None, 9992, message='9992')
	post_dict = process_post_reponse(id, token)
	return ResponseModel(code=1000, message='Success', data=post_dict)

def update_post(id : str, post_req : PostRequest):
	if post_repo.find_by_id(id) is None:
		# raise HTTPException(status_code=400, detail='9992')
		return ErrorResponseModel(None, 9992, message='9992')
	post_dict = vars(post_req)
	post_dict.pop('token', None)
	post_repo.update(id, post_dict)
	return ResponseModel(code=1000, message='Success', data=post_dict)

def get_list_post(list_post_req : ListPostRequest):
	request_dict = vars(list_post_req)
	if ('last_id' in request_dict.keys()) and request_dict['last_id'] is not None:
		if (post_repo.find_by_id(request_dict['last_id']) is None) and (len(request_dict['last_id']) > 0):
		# raise HTTPException(status_code=400, detail='9992')
			return ErrorResponseModel(None, 9992, message='9992')
		results = post_repo.get_list_post(request_dict['last_id'], None, request_dict['count'])
	else: 
		results = post_repo.get_list_post(None, None, request_dict['count'])
	list_post_res = []
	for post_result in results:
		post_response = process_post_reponse(post_result.to_dict()['id'], request_dict['token'])
		list_post_res.append(post_response)
	# print(list_post_res)
	return ResponseModel(code=1000, message='Success', data=list_post_res)

def delete_post(post_id : str):
	try:
		post_repo.delete_post(post_id)
		comment_repo.delete_by_post_id(post_id)
		return ok()
	except:
		return ErrorResponseModel(None,9999,message='9999')

def report_post(report_post_req : ReportPost):
	if post_repo.find_by_id(id) is None:
		# raise HTTPException(status_code=400, detail='9992')
		return ErrorResponseModel(None, 9992, message='9992')
	reported_post_repo.save(report_post_req.dict())
	return ResponseModel(code=1000, message='Success', data=None)

def like_post(like_post : LikePost):
	if post_repo.find_by_id(like_post.id) is None:
		# raise HTTPException(status_code=400, detail='9992')
		return ErrorResponseModel(None, 9992, message='9992')
	payload = auth_handle.decode_token(like_post.token)
	post_repo.like_post(like_post.id, payload['phonenumber'])


# post_detail_response = {
#     'id' : None,
#     'describle' : None,
#     'created' : None,
#     'modified' : None,
#     'like' : None,
#     'comment': None,
#     'is_liked': None,
#     'image': None,
#     'video': None,
#     'author': {
#         'id' : None,
#         'name' : None,
#         'avatar' : None
#     },
#     'is_blocked' : None,
#     'can_edit': None,
#     'can_comment' : None
# }


def process_post_reponse(id : str, token: str):
	post_res = post_repo.find_by_id(id)
	payload = auth_handle.decode_token(token)
	cur_user = user_repo.find_by_phonenumber(payload['phonenumber']).to_dict()
	
	post_detail_response = {}
	post_detail_response['id'] = post_res['id'],
	post_detail_response['describle'] = post_res['describle']
	post_detail_response['created'] = post_res['created']
	post_detail_response['modified'] = post_res['modified']
	post_detail_response['like'] = len(post_res['like'])
	post_detail_response['comment'] = str(post_res['comment']) if 'comment' in post_res else None
	post_detail_response['is_liked'] = 'false' if  payload['phonenumber'] in post_res['like'] else 'true'
	post_detail_response['image'] = str(post_res['image']) if 'image' in post_res else None
	post_detail_response['video'] = str(post_res['video']) if 'video' in post_res else None
	post_detail_response['author'] = post_res['author']
	post_detail_response['can_edit'] = 'true' if post_res['author']['id'] ==  cur_user['phonenumber'] else 'false',
	post_detail_response['is_blocked'] = 'false' if payload['phonenumber'] in cur_user['block_list'] else 'true'
	post_detail_response['can_comment'] = str(post_res['can_comment'])
	return post_detail_response