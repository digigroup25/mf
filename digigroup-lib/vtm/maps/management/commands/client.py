import datetime
import logging

from django.conf import settings
from django.core.management.base import BaseCommand


import pyamf
from pyamf.remoting.client import RemotingService

import os
import sys


logging.basicConfig(
            level=logging.DEBUG,
            format='%(asctime)s %(levelname)-5.5s [%(name)s] %(message)s')




class Command(BaseCommand):
    help = "This doesn't do anything yet"
    
    def handle(self, *args, **options):

        url = 'http://%s:%d/gateway' % (settings.HOST_INFO[0], settings.HOST_INFO[1])
        client = RemotingService(url, logger=logging)
        print "Client running - pointing to server at %s" % url

        #import ipdb; ipdb.set_trace()

        user_service = client.getService('user')
        map_service = client.getService('map')
        testerA = user_service.put_user('tester1', 'test', 'tester1@gmail.com')
        testerB = user_service.get_user('tester1')

        map = map_service.put_map("tester1", "test map 1", datetime.datetime.now(), "test data", 1, False)

        map_1 = map_service.get_map('tester1', map['id'])

