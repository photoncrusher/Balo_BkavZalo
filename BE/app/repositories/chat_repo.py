from firebase_admin import firestore
from app.db_connect import db

chat_ref = db.collection(u'chat_rooms')

def get_all_conversation(user_id : str):
    query = chat_ref.where(u'user_id','==',user_id).order_by(
			u'modified', direction=firestore.Query.DESCENDING)
    results = query.stream()
    return results

def get_conversation_by_partner(user_id : str, partner_id : str):
    query = chat_ref.where(u'user_id','==',user_id).where(u'partner_id','==',partner_id)
    results = query.stream()
    return results

def get_conversation_by_id(user_id : str, conversation_id : str):
    query = chat_ref.where(u'user_id','==',user_id).where(u'id','==',conversation_id)
    results = query.stream()
    return results