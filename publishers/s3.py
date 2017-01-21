#from: https://gist.github.com/evz/3849704
from hyde.publisher import Publisher
from boto.s3.connection import S3Connection
from boto.s3.key import Key
import os


class S3CredentialsError(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)


class S3(Publisher):
    def initialize(self, settings):
        self.settings = settings
        self.key = getattr(settings, 'key', None)
        self.secret = getattr(settings, 'secret', None)
        self.bucket = getattr(settings, 'bucket', None)
        reds = getattr(settings, 'redirects', None)
        self.redirects = []
        if reds:
            for redirect in reds:
                f, t = redirect.split(' => ')
                self.redirects.append({'from': f, 'to': t})
        if not self.key or not self.secret:
            try:
                self.key = os.environ['AWS_ACCESS_KEY_ID']
                self.secret = os.environ['AWS_SECRET_ACCESS_KEY']
            except KeyError:
                raise S3CredentialsError('You need to define both an AWS key and secret in your site.yaml or as environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY')

    def publish(self):
        super(S3, self).publish()
        conn = S3Connection(self.key, self.secret)
        bucket = conn.get_bucket(self.bucket)
        k = Key(bucket)
        root = self.site.config.deploy_root_path
        for item in root.walker.walk_files():
            redirect_meta = None
            if self.redirects:
                for redirect in self.redirects:
                    if redirect['from'] in item.path:
                        redirect_meta = redirect['to']
            k.key = item.path.replace(str(root), '')
            kmd5 = bucket.get_key(item.path.replace(str(root), '')).etag[1:-1]
            #print 'f:', `kmd5, k.compute_md5(open(item.path))[0]`
            if kmd5 != k.compute_md5(open(item.path))[0]:
                print 'updating:', `item.path.replace(str(root), '')`
                k.set_contents_from_filename(item.path)
            if redirect_meta:
                k.set_metadata('website-redirect-location', redirect_meta)
