from django.test import TestCase
from rest_framework.test import APIClient

from .models import User, PushSubscription
from .serializers import UserCreateSerializer
from .views import EmailTokenObtainPairSerializer


class AccountAuthTests(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_login_accepts_username_or_email(self):
        user = User.objects.create_user(
            username='thang_ld',
            email='dinh.vu.thang@caungolanh.gov.vn',
            password='StrongPass123',
            role='lanh_dao',
            display_name='Đinh Vũ Thắng',
            unit='Ban lãnh đạo phường',
        )

        data_by_username = EmailTokenObtainPairSerializer().validate({
            'username': 'thang_ld',
            'password': 'StrongPass123',
        })
        data_by_email = EmailTokenObtainPairSerializer().validate({
            'username': 'dinh.vu.thang@caungolanh.gov.vn',
            'password': 'StrongPass123',
        })

        self.assertIn('access', data_by_username)
        self.assertIn('refresh', data_by_username)
        self.assertIn('access', data_by_email)
        self.assertIn('refresh', data_by_email)
        self.assertEqual(user.username, 'thang_ld')

    def test_create_account_allows_custom_username(self):
        serializer = UserCreateSerializer(data={
            'username': 'thang_ld',
            'email': 'dinh.vu.thang@caungolanh.gov.vn',
            'password': 'StrongPass123',
            'role': 'lanh_dao',
            'display_name': 'Đinh Vũ Thắng',
            'unit': 'Ban lãnh đạo phường',
            'member_name': 'Đinh Vũ Thắng',
            'member_title': 'Phó Chủ tịch UBND phường',
        })

        self.assertTrue(serializer.is_valid(), serializer.errors)
        user = serializer.save()
        self.assertEqual(user.username, 'thang_ld')
        self.assertEqual(user.email, 'dinh.vu.thang@caungolanh.gov.vn')

    def test_admin_can_delete_another_account(self):
        admin = User.objects.create_user(
            username='admin_delete', email='admin_delete@example.com',
            password='StrongPass123', role='quan_tri', display_name='Admin',
            unit='Văn phòng HĐND-UBND',
        )
        target = User.objects.create_user(
            username='target_delete', email='target_delete@example.com',
            password='StrongPass123', role='thanh_vien', display_name='Target',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=admin)

        response = self.client.delete(f'/api/accounts/{target.id}/')

        self.assertEqual(response.status_code, 204)
        self.assertFalse(User.objects.filter(id=target.id).exists())

    def test_admin_cannot_delete_current_account(self):
        admin = User.objects.create_user(
            username='admin_self', email='admin_self@example.com',
            password='StrongPass123', role='quan_tri', display_name='Admin',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=admin)

        response = self.client.delete(f'/api/accounts/{admin.id}/')

        self.assertEqual(response.status_code, 400)
        self.assertTrue(User.objects.filter(id=admin.id).exists())

    def test_non_admin_cannot_delete_account(self):
        clerk = User.objects.create_user(
            username='clerk_delete', email='clerk_delete@example.com',
            password='StrongPass123', role='phong_ban', display_name='Clerk',
            unit='Văn phòng HĐND-UBND',
        )
        target = User.objects.create_user(
            username='target_forbidden', email='target_forbidden@example.com',
            password='StrongPass123', role='thanh_vien', display_name='Target',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=clerk)

        response = self.client.delete(f'/api/accounts/{target.id}/')

        self.assertEqual(response.status_code, 403)
        self.assertTrue(User.objects.filter(id=target.id).exists())

    def test_admin_can_reset_password_to_default(self):
        admin = User.objects.create_user(
            username='admin_reset', email='admin_reset@example.com',
            password='StrongPass123', role='quan_tri', display_name='Admin',
            unit='Văn phòng HĐND-UBND',
        )
        target = User.objects.create_user(
            username='target_reset', email='target_reset@example.com',
            password='OldPass123', role='thanh_vien', display_name='Target',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=admin)

        # Gui kem 1 mat khau tuy y de xac nhan backend BO QUA no, luon dat
        # ve mac dinh admin@123 (yeu cau 22/09/2026: doi tinh nang thanh
        # "reset ve mac dinh" thay vi "cap mat khau tuy y").
        response = self.client.post(
            f'/api/accounts/{target.id}/reset_password/',
            {'password': 'NewPass456'},
        )

        self.assertEqual(response.status_code, 200)
        target.refresh_from_db()
        self.assertTrue(target.check_password('admin@123'))
        self.assertFalse(target.check_password('NewPass456'))

    def test_non_admin_cannot_reset_password(self):
        clerk = User.objects.create_user(
            username='clerk_reset', email='clerk_reset@example.com',
            password='StrongPass123', role='phong_ban', display_name='Clerk',
            unit='Văn phòng HĐND-UBND',
        )
        target = User.objects.create_user(
            username='target_reset2', email='target_reset2@example.com',
            password='OldPass123', role='thanh_vien', display_name='Target',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=clerk)

        response = self.client.post(f'/api/accounts/{target.id}/reset_password/')

        self.assertEqual(response.status_code, 403)
        target.refresh_from_db()
        self.assertTrue(target.check_password('OldPass123'))

    def test_admin_can_update_account_info(self):
        admin = User.objects.create_user(
            username='admin_edit', email='admin_edit@example.com',
            password='StrongPass123', role='quan_tri', display_name='Admin',
            unit='Văn phòng HĐND-UBND',
        )
        target = User.objects.create_user(
            username='target_edit', email='target_edit@example.com',
            password='OldPass123', role='thanh_vien', display_name='Target Old',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=admin)

        response = self.client.post(
            f'/api/accounts/{target.id}/update_info/',
            {
                'display_name': 'Target New',
                'username': 'target_new_username',
                'email': 'target.new@example.com',
            },
        )

        self.assertEqual(response.status_code, 200)
        target.refresh_from_db()
        self.assertEqual(target.display_name, 'Target New')
        self.assertEqual(target.username, 'target_new_username')
        self.assertEqual(target.email, 'target.new@example.com')

    def test_update_account_info_rejects_duplicate_username(self):
        admin = User.objects.create_user(
            username='admin_edit2', email='admin_edit2@example.com',
            password='StrongPass123', role='quan_tri', display_name='Admin',
            unit='Văn phòng HĐND-UBND',
        )
        User.objects.create_user(
            username='taken_username', email='taken@example.com',
            password='StrongPass123', role='thanh_vien', display_name='Taken',
            unit='Văn phòng HĐND-UBND',
        )
        target = User.objects.create_user(
            username='target_edit2', email='target_edit2@example.com',
            password='OldPass123', role='thanh_vien', display_name='Target',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=admin)

        response = self.client.post(
            f'/api/accounts/{target.id}/update_info/',
            {
                'display_name': 'Target',
                'username': 'taken_username',
                'email': 'target_edit2@example.com',
            },
        )

        self.assertEqual(response.status_code, 400)
        target.refresh_from_db()
        self.assertEqual(target.username, 'target_edit2')

    def test_non_admin_cannot_update_account_info(self):
        clerk = User.objects.create_user(
            username='clerk_edit', email='clerk_edit@example.com',
            password='StrongPass123', role='phong_ban', display_name='Clerk',
            unit='Văn phòng HĐND-UBND',
        )
        target = User.objects.create_user(
            username='target_edit3', email='target_edit3@example.com',
            password='OldPass123', role='thanh_vien', display_name='Target',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=clerk)

        response = self.client.post(
            f'/api/accounts/{target.id}/update_info/',
            {
                'display_name': 'Hacked',
                'username': 'hacked_username',
                'email': 'hacked@example.com',
            },
        )

        self.assertEqual(response.status_code, 403)
        target.refresh_from_db()
        self.assertEqual(target.display_name, 'Target')


class PushSubscriptionTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='push_user', email='push_user@example.com',
            password='StrongPass123', role='thanh_vien', display_name='Push User',
            unit='Văn phòng HĐND-UBND',
        )
        self.client.force_authenticate(user=self.user)

    def test_vapid_public_key_returned(self):
        response = self.client.get('/api/push/vapid-public-key/')
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.data['publicKey'])

    def test_subscribe_creates_subscription(self):
        response = self.client.post('/api/push/subscribe/', {
            'endpoint': 'https://fcm.googleapis.com/fcm/send/abc123',
            'keys': {'p256dh': 'fake-p256dh-key', 'auth': 'fake-auth-key'},
        }, format='json')

        self.assertEqual(response.status_code, 201)
        self.assertEqual(PushSubscription.objects.count(), 1)
        sub = PushSubscription.objects.first()
        self.assertEqual(sub.user, self.user)
        self.assertEqual(sub.endpoint, 'https://fcm.googleapis.com/fcm/send/abc123')

    def test_subscribe_same_endpoint_updates_not_duplicates(self):
        endpoint = 'https://fcm.googleapis.com/fcm/send/abc123'
        self.client.post('/api/push/subscribe/', {
            'endpoint': endpoint,
            'keys': {'p256dh': 'key-1', 'auth': 'auth-1'},
        }, format='json')
        self.client.post('/api/push/subscribe/', {
            'endpoint': endpoint,
            'keys': {'p256dh': 'key-2', 'auth': 'auth-2'},
        }, format='json')

        self.assertEqual(PushSubscription.objects.count(), 1)
        self.assertEqual(PushSubscription.objects.first().p256dh, 'key-2')

    def test_subscribe_rejects_missing_fields(self):
        response = self.client.post('/api/push/subscribe/', {
            'endpoint': '', 'keys': {},
        }, format='json')
        self.assertEqual(response.status_code, 400)
        self.assertEqual(PushSubscription.objects.count(), 0)

    def test_unsubscribe_removes_subscription(self):
        endpoint = 'https://fcm.googleapis.com/fcm/send/abc123'
        PushSubscription.objects.create(
            user=self.user, endpoint=endpoint, p256dh='k', auth='a',
        )

        response = self.client.post('/api/push/unsubscribe/', {
            'endpoint': endpoint,
        }, format='json')

        self.assertEqual(response.status_code, 200)
        self.assertEqual(PushSubscription.objects.count(), 0)

    def test_unsubscribe_only_removes_own_subscription(self):
        other = User.objects.create_user(
            username='push_other', email='push_other@example.com',
            password='StrongPass123', role='thanh_vien', display_name='Other',
            unit='Văn phòng HĐND-UBND',
        )
        endpoint = 'https://fcm.googleapis.com/fcm/send/other-endpoint'
        PushSubscription.objects.create(
            user=other, endpoint=endpoint, p256dh='k', auth='a',
        )

        response = self.client.post('/api/push/unsubscribe/', {
            'endpoint': endpoint,
        }, format='json')

        self.assertEqual(response.status_code, 200)
        self.assertEqual(PushSubscription.objects.count(), 1)

    def test_anonymous_cannot_use_push_endpoints(self):
        anon_client = APIClient()
        response = anon_client.get('/api/push/vapid-public-key/')
        self.assertEqual(response.status_code, 401)
