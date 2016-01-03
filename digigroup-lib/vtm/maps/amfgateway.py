import pyamf
from pyamf.flex import ArrayCollection, ObjectProxy
from pyamf.remoting.gateway.django import DjangoGateway

from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.db.models import Q
from django.conf import settings

from maps.models import Map, UserMap
from maps.views import login_user, logout_user

class AMFMap(object):
        """
        Models information associated with a map object.
        """
        # we need a default constructor (e.g. a paren-paren constructor)
        def __init__(self, map=None, include_data=True, owner=None, id=None, name=None, lastModified=None,mapData=None, version=None, isPrivate=None):
        
            #import ipdb; ipdb.set_trace()
            if map:
                self.owner = map.owner.username
                self.id = map.id
                self.name = map.name
                self.lastModified = map.last_modified
                if include_data:
                    self.mapData = map.data
                else:
                    self.mapData = None
                self.version = map.version
                self.isPrivate = map.is_private
            else:
                self.owner = owner
                self.id = id
                self.name = name
                self.lastModified = lastModified
                if include_data:
                    self.mapData = mapData
                else:
                    self.mapData = None
                self.version = version
                self.isPrivate = isPrivate

pyamf.register_class(AMFMap, '%s.Map' % settings.AMF_NAMESPACE)


class AMFUser(object):
    """
    Models information associated with a simple user object.
    """
    # we need a default constructor (e.g. a paren-paren constructor)
    def __init__(self, user=None, username=None, password=None, email=None):
        if user:
            self.username = user.username
            self.email = user.email        
        else:
            self.username = username
            self.password = password
            self.email = email


pyamf.register_class(AMFUser, '%s.User' % settings.AMF_NAMESPACE)


def auth(username, password):
    import ipdb; ipdb.set_trace()
    user = authenticate(username=username, password=password)
    if user is not None:
        login(request, user)
        return True
    return False
                

class UserService(object):
    """
    Provide user related services.
    """
    def __init__(self, user=None, username=None, password=None, email=None):
        pass    


    def login_user(self, request, username=None, password=None):

        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            return AMFUser(user)
        return None

    def logout_user(self, request):
        logout(request)
        return True    


    def get_logged_in_user(self, request):

        #import ipdb; ipdb.set_trace()
        if request.user.is_authenticated():
            return AMFUser(request.user)
        else:
            return None


    def get_user(self, request, username):

        #import ipdb; ipdb.set_trace()
        try:
            return AMFUser(User.objects.get(username=username))
        except User.DoesNotExist:
            return None


    def put_user(self, request, username=None, password=None, email=None):
        #import ipdb; ipdb.set_trace()
        user, created = User.objects.get_or_create(username=username)
        user.email = email
        user.set_password(password)
        user.save()
        return AMFUser(user)


class MapService(object):
    """
    Provide map related services.
    """
    def __init__(self):
        pass

    def get_maps(self, request, username=None):

        if username:
            user = User.objects.get(username=username)
        else:
            user = request.user

        maps = Map.objects.filter(Q(owner=user) | Q(usermap__user=user))

        return [AMFMap(map=map, include_data=False) for map in maps] 


    def get_map(self, request, username, id):
        
        if username:
            user = User.objects.get(username=username)
        else:
            user = request.user

        try:
            return AMFMap(Map.objects.get(Q(owner=user) | Q(usermap__user=user), id=id))
        except Map.DoesNotExist:
            return None


    def put_map(self, request, username, name, last_modified, data, version, is_private):

        if username:
            user = User.objects.get(username=username)
        else:
            user = request.user

        map = Map.objects.create(owner=user, name=name, last_modified=last_modified, data=data, version=version, is_private=is_private)

        return AMFMap(map)
    
    def delete_map(self, request, username, id):

        if username:
            user = User.objects.get(username=username)
        else:
            user = request.user

        try:
            map = Map.objects.get(Q(owner=user) | Q(usermap__user=user), id=id)
            UserMap.objects.filter(map=map).delete()
            map.delete()
            return True
        except Map.DoesNotExist:
            return False


    def share_map_with(self, request, map_id, usernames):

        if not request.user.is_authenticated():
            return False

        map = Map.objects.get(id=map_id)

        if map.owner != request.user and not UserMap.objects.filter(map=map, user=request.user).exists():
            return False


        for username in usernames:
            user = User.objects.get(username=username)
            user_map, created = UserMap.objects.get_or_create(user=user, map=map)
        
        return True


    def unshare_map_with(self, request, map_id, usernames):

        if not request.user.is_authenticated():
            return False
            
        map = Map.objects.get(id=map_id)

        if map.owner != request.user and not UserMap.objects.filter(map=map, user=request.user).exists():
            return False

        for username in usernames:
            if map.owner == request.user or username == request.user.username:
                user = User.objects.get(username=username)
                UserMap.objects.filter(user=user, map=map).delete()
        
        return True

services = {
    'user': UserService(),
    'map': MapService()
}


myGateway = DjangoGateway(services, expose_request=True)