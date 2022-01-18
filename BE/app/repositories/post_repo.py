from firebase_admin import firestore
from app.db_connect import db

post_ref = db.collection(u"posts")

def create(post : dict):
	post['created'] = firestore.SERVER_TIMESTAMP
	post['modified'] = firestore.SERVER_TIMESTAMP
	post['like'] = []
	print("created a new post")
	post_doc = post_ref.document()
	post['id'] = post_doc.id
	post_doc.set(post)
	return post_doc.get().to_dict()

def update(id :str, post : dict):
	if find_by_id(id) is None:
		return None
	post['modified'] = firestore.SERVER_TIMESTAMP
	post_ref.document(id).set(post, merge=True)

def find_by_id(id : str):
	post_doc = post_ref.document(id).get()
	return post_doc.to_dict()

def get_list_post(last_id : str, index : int, count : int):
	if last_id == None:
		query = post_ref.order_by(
			u'created', direction=firestore.Query.DESCENDING).limit(int(count))
		results = query.stream()
		return results
	else:
		snapshot = post_ref.document(last_id).get()
		query = post_ref.order_by(
			u'created', direction=firestore.Query.DESCENDING).start_at(snapshot).limit(int(count))
		results = query.stream()
		print(results)
		return results
	
def delete_post(post_id : str):
	post_ref.document(post_id).delete()

def like_post(post_id : str, phonenumber: str):
	post_ref.document(post_id).update({u'like':firestore.ArrayUnion([phonenumber])})