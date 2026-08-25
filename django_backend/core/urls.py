from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register('members', views.MemberViewSet, basename='member')
router.register('rooms', views.RoomViewSet, basename='room')
router.register('meetings', views.MeetingViewSet, basename='meeting')
router.register('meeting-attendees', views.MeetingAttendeeViewSet, basename='meeting-attendee')
router.register('meeting-files', views.MeetingFileViewSet, basename='meeting-file')
router.register('checkin-records', views.CheckinRecordViewSet, basename='checkin-record')
router.register('accounts', views.UserAccountViewSet, basename='account')
router.register('notifications', views.NotificationViewSet, basename='notification')
router.register('conflict-acknowledgements', views.ConflictAcknowledgementViewSet, basename='conflict-ack')

urlpatterns = [
    path('auth/login/', views.EmailTokenObtainPairView.as_view(), name='login'),
    path('auth/refresh/', views.SafeTokenRefreshView.as_view(), name='token_refresh'),
    path('me/', views.MeView.as_view(), name='me'),
    path('vanthu-contact/', views.VanThuContactView.as_view(), name='vanthu-contact'),
    path('', include(router.urls)),
]
