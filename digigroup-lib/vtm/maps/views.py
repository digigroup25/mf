# Create your views here.

from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User


def login_user(request, username=None, password=None):
    import ipdb; ipdb.set_trace()
    user = authenticate(username=username, password=password)
    if user is not None:
        login(request, user)
        return user
    return None

def logout_user(request):
    logout(request)
    return True    