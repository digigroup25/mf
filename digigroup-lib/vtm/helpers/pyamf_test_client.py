# Copyright (c) 2009 Mads Sulau Joergensen <mads@sulau.dk>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

from pyamf import remoting
from pyamf.remoting import client

class Client(client.RemotingService):
    """
    A PyAMF test client that integrates into Django's test framework.
    
    An example of using it would be:
    
    import unittest
    from django.test.client import Client as DjangoClient
    
    class ServiceTest(unittest.TestCase):
        def setUp(self):
            self.amf_client = Client(DjangoClient())
            self.service = self.amf_client.getService('my_service')

        def test_my_service(self):
            response_data = self.service.my_test_method()
            self.failUnlessEqual(response_data, True)
    """
    def __init__(self, django_client, gateway_url='/gateway/', **kwargs):
        super(Client, self).__init__(gateway_url, **kwargs)
        
        self.django_client = django_client

    def _setUrl(self, url):
        if self.logger:
            self.logger.debug('Setting url to: %s' % url)
        self._root_url = url
    
    def execute_single(self, request):
        if self.logger:
            self.logger.debug('Executing single request: %s' % request)
        body = remoting.encode(self.getAMFRequest([request]), strict=self.strict)
        if self.logger:
            self.logger.debug('Sending POST request to %s' % self._root_url)
        response = self.django_client.post(self._root_url,
            body.getvalue(),
            content_type=remoting.CONTENT_TYPE,
            **self._get_execute_headers()
        )

        envelope = self._getResponse(response)
        self.removeRequest(request)

        return envelope[request.id]

    def _getResponse(self, response):
        response = remoting.decode(response.content, strict=self.strict)
        if self.logger:
            self.logger.debug('Response: %s' % response)

        if remoting.APPEND_TO_GATEWAY_URL in response.headers:
            self.original_url += response.headers[remoting.APPEND_TO_GATEWAY_URL]

            self._setUrl(self.original_url)
        elif remoting.REPLACE_GATEWAY_URL in response.headers:
            self.original_url = response.headers[remoting.REPLACE_GATEWAY_URL]

            self._setUrl(self.original_url)

        if remoting.REQUEST_PERSISTENT_HEADER in response.headers:
            data = response.headers[remoting.REQUEST_PERSISTENT_HEADER]

            for k, v in data.iteritems():
                self.headers[k] = v

        return response
