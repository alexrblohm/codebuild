import os
import logging
import click
from pipeline.process import ProcessData

logger = logging.getLogger(__name__)

ENVIRONMENT = os.environ.get('ENVIRONMENT', None)


@click.command()
@click.option('--root_path', default='root', help='The root folder for all files in s3.')  # noqa: E501
def process(root_path):
    """Run the process command(s)."""
    logger.info('Here are the parameters passed.')
    logger.info(f"root_path: {root_path}")

    logger.info('Instantiating ProcessData class.')
    processor = ProcessData(root_path)

    logger.info("Processing module complete")
