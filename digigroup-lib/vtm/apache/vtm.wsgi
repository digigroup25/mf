import os, site, sys

site.addsitedir('/home/vlad/pyamf/envs/pyamf/lib/python2.6/site-packages')

apache_configuration= os.path.dirname(__file__)
project = os.path.dirname(apache_configuration)
workspace = os.path.dirname(project)
sys.path.append(workspace)

sys.path.append('/usr/local/lib/python2.6/dist-packages/django/')
#sys.path.append('/var/www/labs/pyamf2')
sys.path.append('/home/vtm-server/vtm/')
#sys.path.append('/home/vlad/pyamf/envs/pyamf/')

os.environ['DJANGO_SETTINGS_MODULE'] = 'vtm.settings'
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()


