from app.db_connect import db
from firebase_admin import firestore

user_ref = db.collection(u"users")

def create(user: dict):
	user['active'] = False
	user['avatar'] = None
	user['username'] = user['username']
	user['block_list'] = []
	user['friend_list'] = []
	user['chat_rooms'] = []
	user_ref.document(user['phonenumber']).set(user)
	print("created a new user")

def find_by_phonenumber(phonenumber: str):
	user_doc = user_ref.document(phonenumber).get()
	return user_doc
def find_all():
	user_docs = user_ref.get()
	result = []
	for user in user_docs:
		result.append(user.to_dict())
	return result

def add_friend(user_id : str, request_id: str):
	user_ref.document(user_id).update({u'friend_list': firestore.ArrayUnion([request_id])})
	user_ref.document(request_id).update({u'friend_list': firestore.ArrayUnion([user_id])})