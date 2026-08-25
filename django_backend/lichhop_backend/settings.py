from pathlib import Path
from datetime import timedelta
import os

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY', 'django-insecure-t(aq+#s9hsj#39_uk^9ot+x@s=(ksgbw^o$@9#6wen@rdf-_ad')

DEBUG = os.environ.get('DJANGO_DEBUG', '1') == '1'

ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'unfold',
    'unfold.contrib.filters',
    'unfold.contrib.forms',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
    'django_filters',
    'core',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'lichhop_backend.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'lichhop_backend.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.environ.get('DB_NAME', 'lichhop_django'),
        'USER': os.environ.get('DB_USER', 'root'),
        'PASSWORD': os.environ.get('DB_PASSWORD', ''),
        'HOST': os.environ.get('DB_HOST', '127.0.0.1'),
        'PORT': os.environ.get('DB_PORT', '3306'),
        'OPTIONS': {
            'charset': 'utf8mb4',
        },
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]

LANGUAGE_CODE = 'vi'
TIME_ZONE = 'Asia/Ho_Chi_Minh'
USE_I18N = True
USE_TZ = True

STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
STORAGES = {
    'staticfiles': {
        'BACKEND': 'whitenoise.storage.CompressedManifestStaticFilesStorage',
    },
}
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'
DATA_UPLOAD_MAX_MEMORY_SIZE = 20 * 1024 * 1024  # 20MB - theo bien ban hop 22/08/2026
FILE_UPLOAD_MAX_MEMORY_SIZE = 20 * 1024 * 1024
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# ===== DRF / JWT =====
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_FILTER_BACKENDS': ('django_filters.rest_framework.DjangoFilterBackend',),
}

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(hours=12),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=30),
    'ROTATE_REFRESH_TOKENS': True,
}

# ===== CORS =====
CORS_ALLOW_ALL_ORIGINS = True

AUTH_USER_MODEL = 'core.User'

# ===== Giao dien Django Admin hien dai (Unfold - Tailwind, co Dark mode) =====
from django.templatetags.static import static  # noqa: E402
from django.urls import reverse_lazy  # noqa: E402

UNFOLD = {
    'SITE_TITLE': 'Quản trị Lịch họp UBND',
    'SITE_HEADER': 'Lịch họp – P. Cầu Ông Lãnh',
    'SITE_SUBHEADER': 'UBND Phường Cầu Ông Lãnh',
    'SITE_SYMBOL': 'calendar_month',
    'SHOW_HISTORY': True,
    'SHOW_VIEW_ON_SITE': False,
    'SHOW_LANGUAGES': False,
    'BORDER_RADIUS': '8px',
    'COLORS': {
        'primary': {
            '50': '238 242 251', '100': '221 230 247', '200': '187 205 240',
            '300': '154 179 232', '400': '87 128 218', '500': '53 103 210',
            '600': '38 78 175', '700': '30 62 140', '800': '26 39 68',
            '900': '20 30 52', '950': '13 20 35',
        },
    },
    'SIDEBAR': {
        'show_search': True,
        'show_all_applications': True,
        'navigation': [
            {
                'title': 'Lịch họp',
                'separator': True,
                'items': [
                    {'title': 'Tổng quan', 'icon': 'dashboard', 'link': reverse_lazy('admin:index')},
                    {'title': 'Lịch họp', 'icon': 'event', 'link': reverse_lazy('admin:core_meeting_changelist')},
                    {'title': 'Phòng họp', 'icon': 'meeting_room', 'link': reverse_lazy('admin:core_room_changelist')},
                    {'title': 'Điểm danh', 'icon': 'fact_check', 'link': reverse_lazy('admin:core_checkinrecord_changelist')},
                    {'title': 'Thông báo', 'icon': 'notifications', 'link': reverse_lazy('admin:core_notification_changelist')},
                ],
            },
            {
                'title': 'Con người',
                'separator': True,
                'items': [
                    {'title': 'Tài khoản đăng nhập', 'icon': 'admin_panel_settings', 'link': reverse_lazy('admin:core_user_changelist')},
                    {'title': 'Danh bạ nhân sự', 'icon': 'badge', 'link': reverse_lazy('admin:core_member_changelist')},
                ],
            },
        ],
    },
}

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {'class': 'logging.StreamHandler'},
    },
    'loggers': {
        'django.request': {
            'handlers': ['console'],
            'level': 'ERROR',
            'propagate': False,
        },
    },
}
