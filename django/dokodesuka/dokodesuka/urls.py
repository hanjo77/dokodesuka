"""dokodesuka URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.8/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add an import:  from blog import urls as blog_urls
    2. Add a URL to urlpatterns:  url(r'^blog/', include(blog_urls))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.conf.urls import include, url
from django.contrib import admin
from data import views
from django.views.decorators.csrf import csrf_exempt

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    url(r'^locations/(?P<pk>[0-9]*)', views.UserLocationJsonView.as_view(), name='user_locations'),
    url(r'^locations', views.LocationJsonView.as_view(), name='locations'),
    url(r'^users', views.UserJsonView.as_view(), name='users'),
    url(r'^login', csrf_exempt(views.LoginView.as_view()), name='login'),
    url(r'^add_user', csrf_exempt(views.AddUserView.as_view()), name='add_user'),
    url(r'^add_location', csrf_exempt(views.AddLocationView.as_view()), name='add_location'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)