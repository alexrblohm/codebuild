from setuptools import setup, find_packages

with open('README.md') as readme_file:
    readme = readme_file.read()

setup(
    author='Alex Team',
    author_email='alexrblohm@gmail.com',
    classifiers=[
        'Natural Language :: English',
        'Programming Language :: Python :: 3.7',
    ],
    description='Orchestration of tools and scripts'
                'for the pipeline.',
    entry_points={
        'console_scripts': [
            'pipelinectl=pipeline.cli:cli',
        ],
    },
    # install_requires=[
    #     'click'
    # ],
    long_description=readme,
    include_package_data=True,
    keywords='pipeline',
    name='pipeline',
    packages=find_packages(),
    test_suite='tests',
    version='0.0.0',
    zip_safe=False,
)
