import firebase_admin
from firebase_admin import credentials, storage


class StorageManager:
    def __init__(self):
        # Replace the projectID eg.
        self.bucket_name = 'app-project-7050d.appspot.com'
        # self.bucket_name = '<projectID>.appspot.com'

        # You need to download the serviceaccount.json
        self.fb_cred = 'key.json'
        cred = credentials.Certificate(self.fb_cred)
        firebase_admin.initialize_app(cred, {
            'storageBucket': self.bucket_name
        })

    def exists_on_cloud(self, filename):
        bucket = storage.bucket()
        blob = bucket.blob(filename)
        if blob.exists():
            return blob.public_url
        else:
            return False

    def upload_file(self, firebase_path, local_path):
        url = self.exists_on_cloud(firebase_path)
        if not url:
            bucket = storage.bucket()
            blob = bucket.blob(firebase_path)
            blob.upload_from_filename(local_path)
            # with open(local_path, 'rb') as fp:
            #     blob.upload_from_file(fp)
            print('This file is uploaded to cloud.')
            blob.make_public()
            url = blob.public_url
        return url
