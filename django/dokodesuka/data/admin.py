from django.contrib import admin

from .models import Location

class AppConfigAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def changelist_view(self, request, extra_context=None):
        return self.change_view(request, '1', '', extra_context)

admin.site.register(Location)