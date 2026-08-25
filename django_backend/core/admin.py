from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from unfold.admin import ModelAdmin, TabularInline
from .models import (
    User, Member, Room, Meeting, MeetingAttendee, MeetingFile, CheckinRecord,
    Notification, ConflictAcknowledgement,
)


@admin.register(User)
class CustomUserAdmin(UserAdmin, ModelAdmin):
    list_display = ('email', 'display_name', 'role', 'unit', 'can_manage_rooms', 'is_active')
    list_filter = ('role', 'unit', 'can_manage_rooms')
    fieldsets = UserAdmin.fieldsets + (
        ('Vai trò hệ thống', {'fields': ('role', 'member', 'display_name', 'unit', 'can_manage_rooms')}),
    )
    add_fieldsets = UserAdmin.add_fieldsets + (
        ('Vai trò hệ thống', {'fields': ('email', 'role', 'member', 'display_name', 'unit', 'can_manage_rooms')}),
    )


@admin.register(Member)
class MemberAdmin(ModelAdmin):
    list_display = ('name', 'title', 'unit', 'phone', 'email')
    search_fields = ('name', 'unit')


@admin.register(Room)
class RoomAdmin(ModelAdmin):
    list_display = ('name', 'location', 'capacity')


class AttendeeInline(TabularInline):
    model = MeetingAttendee
    extra = 0


@admin.register(Meeting)
class MeetingAdmin(ModelAdmin):
    list_display = ('title', 'meeting_date', 'start_time', 'level', 'unit', 'room', 'is_draft', 'postponed')
    list_filter = ('level', 'session', 'meeting_date', 'is_draft', 'postponed')
    search_fields = ('title',)
    inlines = [AttendeeInline]


@admin.register(MeetingFile)
class MeetingFileAdmin(ModelAdmin):
    list_display = ('name', 'meeting', 'kind', 'size_bytes', 'uploaded_at')


@admin.register(ConflictAcknowledgement)
class ConflictAcknowledgementAdmin(ModelAdmin):
    list_display = ('meeting_a', 'meeting_b', 'acknowledged_by', 'created_at')


@admin.register(CheckinRecord)
class CheckinRecordAdmin(ModelAdmin):
    list_display = ('meeting', 'member', 'checkin_time')
    list_filter = ('meeting',)


@admin.register(Notification)
class NotificationAdmin(ModelAdmin):
    list_display = ('title', 'recipient', 'meeting', 'is_read', 'created_at')
    list_filter = ('is_read',)
