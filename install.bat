@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ============================================
echo   CAI DAT DU AN LICH HOP - LAN DAU
echo ============================================
echo.

REM --- Kiem tra Python ---
python --version >nul 2>&1
if errorlevel 1 (
    echo [LOI] Chua tim thay Python.
    echo       Hay cai Python 3.12+ tu python.org truoc,
    echo       nho tick "Add python.exe to PATH" khi cai, roi chay lai file nay.
    pause
    exit /b 1
)

set "ROOT=%~dp0"
set "BACKEND=%ROOT%django_backend"
set "VENV=%ROOT%.venv"

REM --- Cau hinh database cho Django (MySQL root khong mat khau) ---
set "DB_NAME=lichhop_django"
set "DB_USER=root"
set "DB_PASSWORD="
set "DB_HOST=localhost"
set "DB_PORT=3306"

REM --- Don cache Python cu (tranh chay nham code cu neu source duoc chep tu noi khac) ---
for /f "delims=" %%D in ('dir /s /b /ad "%ROOT%__pycache__" 2^>nul') do rd /s /q "%%D"

REM --- Tao virtual environment ---
if not exist "%VENV%\Scripts\python.exe" (
    echo [1/6] Tao virtual environment...
    python -m venv "%VENV%"
) else (
    echo [1/6] Virtual environment da co san, bo qua.
)

REM --- Cai thu vien ---
echo [2/6] Cai thu vien Python ^(co the mat 2-5 phut^)...
call "%VENV%\Scripts\activate.bat"
python -m pip install --upgrade pip >nul
pip install -r "%BACKEND%\requirements.txt"
if errorlevel 1 (
    echo [LOI] Cai thu vien that bai. Kiem tra ket noi mang roi chay lai file nay.
    pause
    exit /b 1
)

REM --- Bat MySQL (XAMPP) ---
echo [3/6] Khoi dong MySQL...
if exist "C:\xampp\mysql_start.bat" (
    start "" /min "C:\xampp\mysql_start.bat"
    timeout /t 4 >nul
) else (
    echo [CANH BAO] Khong tim thay XAMPP o C:\xampp
    echo            Hay cai XAMPP truoc ^(xem HUONG_DAN_CAI_WIN11.md^),
    echo            hoac tu bat MySQL bang XAMPP Control Panel roi bam phim bat ky de tiep tuc.
    pause
)

REM --- Tao database + user ---
echo [4/6] Tao database va user MySQL...
if exist "C:\xampp\mysql\bin\mysql.exe" (
    "C:\xampp\mysql\bin\mysql.exe" -h localhost -u root -e "CREATE DATABASE IF NOT EXISTS lichhop_django CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    if errorlevel 1 (
        echo [CANH BAO] Tao database/user that bai. Co the MySQL chua chay,
        echo            hay tu tao qua phpMyAdmin theo HUONG_DAN_CAI_WIN11.md
    ) else (
        echo       Da tao xong database "lichhop_django".
    )
) else (
    echo [CANH BAO] Khong tim thay mysql.exe, hay tu tao database qua phpMyAdmin
    echo            theo huong dan trong HUONG_DAN_CAI_WIN11.md
)

REM --- Tao file .env neu chua co ---
echo [5/6] Kiem tra file .env...
if not exist "%BACKEND%\.env" (
    if exist "%BACKEND%\.env.example" (
        copy "%BACKEND%\.env.example" "%BACKEND%\.env" >nul
        echo       Da tao backend\.env tu .env.example.
        echo       *** Nho mo file nay, kiem tra DB_USER=django va DB_PASSWORD= ^(de trong^) ***
    )
) else (
    echo       File .env da co san, bo qua.
)

REM --- Du lieu: import file mau hoac tao schema trong ---
echo [6/6] Thiet lap du lieu...
echo.
if exist "%ROOT%lichhop_django.sql" (
    set /p CHOICE="Tim thay file lichhop_django.sql. Import du lieu mau nay vao khong? (Y/N): "
) else (
    set "CHOICE=N"
)
if /I "!CHOICE!"=="Y" (
    echo Dang import du lieu tu lichhop_django.sql ...
    "C:\xampp\mysql\bin\mysql.exe" -h localhost -u root lichhop_django < "%ROOT%lichhop_django.sql"
    if errorlevel 1 (
        echo [LOI] Import that bai. Kiem tra lai MySQL da chay chua.
    ) else (
        echo Import thanh cong. Bo qua migrate vi bang da co san.
    )
) else (
    echo Dang tao schema trong ^(migrate^)...
    pushd "%BACKEND%"
    python manage.py migrate
    popd
    set /p SUPERUSER="Tao tai khoan admin ngay bay gio khong? (Y/N): "
    if /I "!SUPERUSER!"=="Y" (
        pushd "%BACKEND%"
        python manage.py createsuperuser
        popd
    )
)

echo.
echo ============================================
echo   CAI DAT XONG!
echo   Lan sau chi can chay start.bat de mo ung dung.
echo ============================================
pause
