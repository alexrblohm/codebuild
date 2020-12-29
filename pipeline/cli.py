import click
import pipeline
from pipeline.query.commands import query
from pipeline.process.commands import process


@click.group()
def cli():
    """Set of tools for the pipeline."""
    return 0


@cli.command()
def version():
    """Print the version and exit."""
    click.echo(pipeline.__version__)


cli.add_command(query)
cli.add_command(process)
