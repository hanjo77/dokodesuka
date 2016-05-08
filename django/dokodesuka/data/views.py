import json
import datetime
from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from data.models import Location
from django.views import generic
from django.core import serializers
from django import http
from django.views.decorators.csrf import csrf_exempt

class JSONListMixin(object):
    def date_handler(self, obj):
        return obj.isoformat() if hasattr(obj, 'isoformat') else obj
    def get(self, request, *args, **kwargs):
        raw_data = serializers.serialize('python', self.get_queryset())
        return http.HttpResponse(json.dumps([d['fields'] for d in raw_data], default=self.date_handler))

class JSONDetailMixin(object):
    def date_handler(self, obj):
        return obj.isoformat() if hasattr(obj, 'isoformat') else obj
    def post(self, request, *args, **kwargs):
        raw_data = serializers.serialize('python', self.get_queryset())
        return http.HttpResponse(json.dumps([d['fields'][0] for d in raw_data], default=self.date_handler))

class LocationJsonView(JSONListMixin, generic.ListView):
    def get_queryset(self):
        queryset = Location.objects.all()
        return queryset

class LoginView(JSONDetailMixin, generic.DetailView):
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
                message = json.dumps({
                        "id": user.id,
                        "user_name": user.username,
                        "email": user.email,
                        "first_name": user.first_name,
                        "last_name": user.last_name
                    })
            else:
                message = json.dumps({
                        "error": "The password is valid, but the account has been disabled!"
                    })
        else:
            # the authentication system was unable to verify the username and password
            message = json.dumps({
                    "error": "The username and password were incorrect."
                })
        return http.HttpResponse(message)

class AddUserView(JSONDetailMixin, generic.DetailView):
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
        message = json.dumps({
                "id": user.id,
                "user_name": user.username,
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name
            })
        return http.HttpResponse(message)
