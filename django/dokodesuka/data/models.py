from django.contrib.auth.models import User
from django.db import models
from django.utils import timezone

class Meta:
    verbose_name = "Daten"

class Location(models.Model):
    title = models.CharField(max_length=255)
    description = models.CharField(max_length=4096)
    picture = models.FileField(max_length=255)
    latitude = models.FloatField()
    longitude = models.FloatField()
    users = models.ManyToManyField(User, related_name="users_attracted")
    created_user = models.ForeignKey(User, related_name="user_created")
    created_date = models.DateTimeField(auto_now_add=True)
    class Meta:
        verbose_name = "location"
        verbose_name_plural = "locations"
    def __unicode__(self):
       return unicode(self.title)

