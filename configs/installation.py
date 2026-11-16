from os import environ

DEBUG = False

SECRET_KEY = environ['SECRET_KEY']
SECURITY_PASSWORD_SALT = environ['SECURITY_PASSWORD_SALT']

SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://{user}:{password}@{host}:{port}/{name}'.format(
    user=environ.get('DB_USER', 'postgres'),
    password=environ['DB_PASS'],
    host=environ.get('DB_HOST', 'db'),
    port=environ.get('DB_PORT', '5432'),
    name=environ.get('DB_NAME', 'scalargis'),
)

SCALARGIS_DB_SCHEMA = 'scalargis'
SCALARGIS_HOST_URL = ''
SCALARGIS_BASE_URL = ''

SCALARGIS_PLUGINS = ['proxy', 'geonames', 'spatial_toolbox']
SCALARGIS_EXTENSIONS = []

SCALARGIS_ROUTE_GEOSERVER = [
    ['/geoserver/', 'http://geoserver:8080/geoserver/', 'start'],
]

SCALARGIS_PROXY_CORS = []
