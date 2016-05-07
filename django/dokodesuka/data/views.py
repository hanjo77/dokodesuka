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
