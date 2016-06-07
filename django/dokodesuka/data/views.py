from __future__ import unicode_literals
import json
import simplejson
import datetime
from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from data.models import Location
from django.views import generic
from django.core import serializers
from django.forms.models import model_to_dict
from django import http
from django.views.decorators.csrf import csrf_exempt
from base64 import b64decode
from django.core.files.images import ImageFile
from django.core.files.base import ContentFile
from django.core.serializers.json import DjangoJSONEncoder
from django.contrib.sites.shortcuts import get_current_site

class DokoDesuKaMixin(object):
    def date_handler(self, obj):
        return obj.isoformat() if hasattr(obj, 'isoformat') else obj
    def json_dumps(self, obj, *args, **kwargs):
        return json.dumps(obj, default=self.date_handler)
    def get_location_dict(self, obj):
        request = None
        _dict = model_to_dict(obj, exclude="picture")
        _dict["picture"] = obj.picture.name.replace("./", "")
        _dict["created_user"] = self.get_user_dict(User.objects.get(id=obj.created_user_id))
        return _dict
    def get_user_dict(self, obj):
        request = None
        _dict = model_to_dict(obj, exclude="password")
        return _dict
    def post(self, request, *args, **kwargs):
        raw_data = serializers.serialize('python', self.get_queryset())
        return http.HttpResponse(self.json_dumps([d['fields'][0] for d in raw_data]))

class LocationJsonView(DokoDesuKaMixin, generic.View):
    def get(self, request, *args, **kwargs):
        queryset = Location.objects.all()
        locations = []
        for location in queryset:
            locations.append(self.get_location_dict(location))
        return http.HttpResponse(self.json_dumps(locations))

class UserLocationJsonView(DokoDesuKaMixin, generic.View):
    def get(self, request, *args, **kwargs):
        queryset = Location.objects.filter(created_user_id=self.kwargs['pk'])
        locations = []
        for location in queryset:
            locations.append(self.get_location_dict(location))
        return http.HttpResponse(self.json_dumps(locations))

class LoginView(DokoDesuKaMixin, generic.DetailView):
    def get_queryset(self):
        queryset = User.objects.all()
        return queryset
    def post(self, request, *args, **kwargs):
        message = ""
        postData = json.loads(request.body)
        user = authenticate(username=postData.get('user_name', ''), password=postData.get('password', ''))
        if user is not None:
            # the password verified for the user
            if user.is_active:
                message = self.json_dumps(self.get_user_dict(user))
            else:
                message = self.json_dumps({
                        "error": "The password is valid, but the account has been disabled!"
                    })
        else:
            # the authentication system was unable to verify the username and password
            message = self.json_dumps({
                    "error": "The username and password were incorrect."
                })
        return http.HttpResponse(message)

class AddUserView(DokoDesuKaMixin, generic.DetailView):
    def post(self, request, *args, **kwargs):
        message = ""
        postData = json.loads(request.body)
        user = User.objects.filter(username=postData.get('user_name', ''))
        if not user.exists():
            user = User.objects.filter(email=postData.get('email', ''))
        user_id = None;
        obj = {}
        if user.exists():
            user_id = user.first().pk
            user = user.first()
        else:
            user = User.objects.create_user(
                postData.get('user_name', ''), 
                postData.get('email', ''), 
                postData.get('password', ''))
            user.first_name=postData.get('first_name', '')
            user.last_name=postData.get('last_name', '')
            user.save()
            user_id = user.pk
        message = self.json_dumps(self.get_user_dict(user))
        return http.HttpResponse(message)

class AddLocationView(DokoDesuKaMixin, generic.DetailView):
    def post(self, request, *args, **kwargs):
        message = ""
        postData = json.loads(request.body)
        location = Location.objects.filter(id=int(postData.get('id', '-1')))
        location_id = None;
        obj = {}
        if location.exists():
            location_id = location.first().pk
            location = location.first()
            location.title=postData.get('title', '')
            location.description=postData.get('description', '')
            location.latitude=postData.get('latitude', '')
            location.longitude=postData.get('longitude', '')
        else:
            location = Location(
                title=postData.get('title', ''), 
                description=postData.get('description', ''), 
                latitude=postData.get('latitude', ''),
                longitude=postData.get('longitude', ''),
                created_user_id=postData.get('created_user_id', ''))
        base64img = postData.get('image', '')
        if base64img != '':
            image_data = b64decode(base64img)
            location.picture.save(location.title+'.jpg', ContentFile(image_data), save=False)
        location.save()
        location_id = location.pk
        message = self.json_dumps(self.get_location_dict(location))
        return http.HttpResponse(message)
