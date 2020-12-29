import logging
import click

from pipeline.query import QuerySnowflakePutS3

logger = logging.getLogger(__name__)


@click.command()
@click.option('--root_path', default='root', help='The root folder for all files in s3.')  # noqa: E501
def query(root_path):
    """Run the query command(s)."""
    logger.info('Here are the parameters passed.')
    logger.info(f'root_path: {root_path}')

    logger.info('Instantiating QuerySnowflakePutS3 class.')
    q = QuerySnowflakePutS3()

    logger.info("query module complete")
