from django.db import models
from django.contrib.auth.models import User


class Map(models.Model):

    owner = models.ForeignKey(User)
    name = models.CharField(max_length=255)

    last_modified = models.DateTimeField(auto_now=True)
    data = models.TextField(max_length=1000)
    version = models.PositiveIntegerField(default=1)
    is_private = models.BooleanField(default=True)


    def __unicode__(self):
        return self.name
        

    class Meta:
        verbose_name_plural = 'Maps'
        ordering = ['-last_modified']


class UserMap(models.Model):

    user = models.ForeignKey(User)
    map = models.ForeignKey(Map)

    last_modified = models.DateTimeField(auto_now=True, null=True)

    def __unicode__(self):
        return '%s by %s' % (self.user, self.name)


