"""Top-level package for Pipeline."""

__author__ = """Forecasting Team"""
__version__ = '0.0.0'

import os
import logging
from time import gmtime

LOGLEVEL = os.environ.get('LOGLEVEL', 'INFO')

_logger = logging.getLogger(__name__)
_logger.setLevel(LOGLEVEL)

_formatter = logging.Formatter(
    '%(asctime)s.%(msecs)03d - %(name)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
_formatter.converter = gmtime

_handler = logging.StreamHandler()
_handler.setFormatter(_formatter)

_logger.addHandler(_handler)
