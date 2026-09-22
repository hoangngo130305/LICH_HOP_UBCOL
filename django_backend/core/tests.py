from django.test import TestCase
from rest_framework.test import APIClient

from .models import User
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

    def test_admin_can_reset_password(self):
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

        response = self.client.post(
            f'/api/accounts/{target.id}/reset_password/',
            {'password': 'NewPass456'},
        )

        self.assertEqual(response.status_code, 200)
        target.refresh_from_db()
        self.assertTrue(target.check_password('NewPass456'))

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

        response = self.client.post(
            f'/api/accounts/{target.id}/reset_password/',
            {'password': 'NewPass456'},
        )

        self.assertEqual(response.status_code, 403)
        target.refresh_from_db()
        self.assertTrue(target.check_password('OldPass123'))
