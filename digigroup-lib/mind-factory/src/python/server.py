# Copyright (c) The PyAMF Project.
# See LICENSE.txt for details.

"""
Simple PyAMF server.

@see: U{Simple Example<http://pyamf.org/tutorials/actionscript/simple.html>} documentation.
@since: 0.5
"""

import logging
from wsgiref import simple_server

import pyamf
from pyamf import amf3
from pyamf.remoting.gateway.wsgi import WSGIGateway


#: namespace used in the Adobe Flash Player client's [RemoteClass] mapping
AMF_NAMESPACE = 'org.pyamf.examples.simple'

#: Host and port to run the server on
#host_info = ['localhost', 8000]
host_info = ['labs.digigroupinc.com', 8001]

logging.basicConfig(level=logging.DEBUG,
        format='%(asctime)s %(levelname)-5.5s [%(name)s] %(message)s')


def create_user(username, password, email):
    """
    Create a user object setting attributes to values passed as
    arguments.
    """
    user = User(username, password, email)
    return user

class Map(object):
	"""
	Models information associated with a map object.
	"""
	# we need a default constructor (e.g. a paren-paren constructor)
	def __init__(self, id=None, name=None, lastModified=None,mapData=None, version=None, isPrivate=None):
        	"""
        	Create an instance of a map object.
        	"""
        	self.id = id
        	self.name = name
        	self.lastModified = lastModified
        	self.mapData = mapData
        	self.version = version
        	self.isPrivate = isPrivate
class User(object):
    """
    Models information associated with a simple user object.
    """
    # we need a default constructor (e.g. a paren-paren constructor)
    def __init__(self, username=None, password=None, email=None):
        """
        Create an instance of a user object.
        """
        self.username = username
        self.password = password
        self.email = email


class MapService(object):
    """
    Provide map related services.
    """
    def __init__(self, maps):
        """
        Create an instance of the map service.
        """
        self.maps = maps

    def get_maps(self, username):
        """
        Fetch all maps w/o mapData Info
        """
        result = []
        for map in self.maps:
            newmap = Map(map.id,map.name,map.lastModified,None, map.version, map.isPrivate)
            result.append(newmap)
            try:
                return result
            except KeyError:
                return "Maps for '%s' not found" % username
    def get_map(self, username, id):
        """
        Fetch all maps w/o mapData Info
        """
        for map in self.maps:
            print "%s %s %s %s %s %s"%(map.id, map.name, map.lastModified, None,map.version,map.isPrivate)
            if map.id == id:
                print "%s equals %s"%(id,map.id)
                return map
        for map in self.maps:
            if map.id == id:
                return map
            else:
                return None
    def put_map(self, id=None, name=None, lastModified=None,mapData=None, version=None, isPrivate=None):
        newmap = Map(id,name,lastModified, mapData,version,isPrivate)
        self.maps.append(newmap)
        """
        for map in self.maps:
            print "%s %s %s %s %s %s"%(map.id, map.name, map.lastModified, None,version,isPrivate)
        quit()
        """
        return True



class UserService(object):
    """
    Provide user related services.
    """
    def __init__(self, users):
        """
        Create an instance of the user service.
        """
        self.users = users

    def get_user(self, username):
        """
        Fetch a user object by C{username}.
        """
        try:
            return self.users[username]
        except KeyError:
            return "Username '%s' not found" % username


class EchoService(object):
    """
    Provide a simple server for testing.
    """
    def echo(self, data):
        """
        Return data with chevrons surrounding it.
        """
        return '<<%s>>' % data


def register_classes():
    """
    Register domain objects with PyAMF.
    """
    # set this so returned objects and arrays are bindable
    amf3.use_proxies_default = True

    # register domain objects that will be used with PyAMF
    pyamf.register_class(User, '%s.User' % AMF_NAMESPACE)


def main():
    """
    Create a WSGIGateway application and serve it.
    """
    # register class on the AMF namespace so that it is passed marshaled
    register_classes()

    # use a dict in leiu of sqlite or an actual database to store users
    # re passwords: plain-text in a production would be bad
    users = {
        'lenards': User('lenards', 'f00f00', 'lenards@ndy.net'),
        'lisa': User('lisa', 'h1k3r', 'lisa@pwns.net'),
    }
    testmap = """
<graph version="1.1">
 <node id="1">
    <data>
     <Task>
       <actualHours>NaN</actualHours>
       <assignedTo/>
       <committed>false</committed>
       <complexity>0</complexity>
       <date>null</date>
       <description/>
       <done>0</done>
       <estimatedHours>NaN</estimatedHours>
       <name>test</name>
       <priority>0</priority>
       <reviewed>false</reviewed>
     </Task>
    </data>
    <relations>
     <relation targetNodeId="2" type="child"/>
     <relation targetNodeId="3" type="child"/>
    </relations>
 </node>
 <node id="2">
    <data>
     <Task>
       <actualHours>0.1</actualHours>
       <assignedTo>V</assignedTo>
       <committed>false</committed>
       <complexity>0</complexity>
       <date>null</date>
       <description/>
       <done>1</done>
       <estimatedHours>0.2</estimatedHours>
       <name>task2</name>
       <priority>0</priority>
       <reviewed>false</reviewed>
     </Task>
    </data>
 </node>
 <node id="3">
    <data>
     <Task>
       <actualHours>NaN</actualHours>
       <assignedTo/>
       <committed>false</committed>
       <complexity>0</complexity>
       <date>null</date>
       <description/>
       <done>0</done>
       <estimatedHours>NaN</estimatedHours>
       <name>task3</name>
       <priority>0</priority>
       <reviewed>false</reviewed>
     </Task>
    </data>
 </node>
</graph>
"""
    maps = [
	Map('1', "first Map", "2012-01-16" ,testmap, 0, 0),
	Map('2', "second Map", "2012-01-16" ,testmap, 0, 0),
	Map('3', "third Map", "2012-01-16" ,testmap, 0, 0),
	Map('4', "forth Map", "2012-01-16" ,testmap, 0, 0),
    ]
    # our gateway will have two services
    services = {
        'echo': EchoService,
        'user': UserService(users),
        'map': MapService(maps)
    }

    # setup our server
    application = WSGIGateway(services, logger=logging)
    httpd = simple_server.WSGIServer(host_info,
                simple_server.WSGIRequestHandler)
    httpd.set_app(application)
    
    try:
        # open for business
        print "Running Simple PyAMF gateway on http://%s:%d" % (
            host_info[0], host_info[1])
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    from optparse import OptionParser

    parser = OptionParser()
    parser.add_option("-p", "--port", default=host_info[1],
        dest="port", help="port number [default: %default]")
    parser.add_option("--host", default=host_info[0],
        dest="host", help="host address [default: %default]")
    (options, args) = parser.parse_args()

    host_info = (options.host, options.port)

    # now we rock the code
    main()

