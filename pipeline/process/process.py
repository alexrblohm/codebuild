import logging
import os

logger = logging.getLogger(__name__)

ENVIRONMENT = os.environ.get('ENVIRONMENT', 'local')


class ProcessData:
    """Data ETL

    :param root_path: declared in commands via click
    :type root_path: str
    """

    def __init__(self, root_path):
        pass
