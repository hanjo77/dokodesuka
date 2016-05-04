import json
import datetime
from django.shortcuts import render
from data.models import Location
from django.views import generic
from django.core import serializers
from django import http
from django.views.decorators.csrf import ensure_csrf_cookie

class JSONListMixin(object):
    def date_handler(self, obj):
        return obj.isoformat() if hasattr(obj, 'isoformat') else obj
    def get(self, request, *args, **kwargs):
        raw_data = serializers.serialize('python', self.get_queryset())
        return http.HttpResponse(json.dumps([d['fields'] for d in raw_data], default=self.date_handler))

class JSONDetailMixin(object):
    def date_handler(self, obj):
        return obj.isoformat() if hasattr(obj, 'isoformat') else obj
    def get(self, request, *args, **kwargs):
        raw_data = serializers.serialize('python', self.get_queryset())
        return http.HttpResponse(json.dumps([d['fields'] for d in raw_data][0], default=self.date_handler))

class LocationJsonView(JSONListMixin, generic.ListView):
    def get_queryset(self):
        queryset = Location.objects.all()
        return queryset
