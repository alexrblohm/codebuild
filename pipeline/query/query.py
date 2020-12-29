import logging
import os

logger = logging.getLogger(__name__)

ENVIRONMENT = os.environ.get('ENVIRONMENT', 'local')


class QuerySnowflakePutS3:
    """This class sends the output of the queries into an s3 bucket."""

    def __init__(self):
        pass
