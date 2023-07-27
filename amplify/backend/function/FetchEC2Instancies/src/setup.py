from distutils.core import setup

setup(
    name='src', 
    version='1.0',
    install_requires=[
        "boto3",
        "unittest",
        "moto"
    ]
)
