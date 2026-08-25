# LỊCH HỌP UBND

Hệ thống quản lý lịch họp UBND Phường Cầu Ông Lãnh.

## Cấu trúc dự án

- `django_backend/` — Backend Django + DRF (MySQL/MariaDB), chạy cổng **8005**.
- `WEBSITE/` — Bản build web (Flutter web) để phục vụ tĩnh, chạy cổng **8085**.
- `lich_hop_app/` — Mã nguồn ứng dụng Flutter (mobile + web).
- `lichhop_django.sql` — Bản dump database (phpMyAdmin/MariaDB) để import.
- `docx/` — Tài liệu hướng dẫn sử dụng.

## Triển khai (tóm tắt)

### Backend (port 8005)

```bash
cd django_backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
# import database:
mysql -u <user> -p lichhop_django < ../lichhop_django.sql
# cấu hình biến môi trường DB_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT, DJANGO_SECRET_KEY, DJANGO_DEBUG
python manage.py runserver 0.0.0.0:8005
```

### Frontend (port 8085)

```bash
cd WEBSITE
python3 -m http.server 8085
```
