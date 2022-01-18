from app.db_connect import db

reported_post_ref = db.collection(u'reported_post')

def save(report_post : dict):
    reported_post_ref.document().set(report_post)
