@echo off
setlocal
title He thong Quan ly Lich hop - Web
cd /d "%~dp0WEBSITE"

set PORT=8843

where python >nul 2>nul
if %errorlevel%==0 (
  echo Dang khoi dong may chu tai http://127.0.0.1:%PORT%/ ...
  start "" http://127.0.0.1:%PORT%/
  python -m http.server %PORT%
  goto :eof
)

where py >nul 2>nul
if %errorlevel%==0 (
  echo Dang khoi dong may chu tai http://127.0.0.1:%PORT%/ ...
  start "" http://127.0.0.1:%PORT%/
  py -m http.server %PORT%
  goto :eof
)

echo Khong tim thay Python tren may nay.
echo Hay cai Python (https://www.python.org/downloads/) roi chay lai file nay,
echo hoac dua thu muc WEBSITE nay len bat ky may chu web tinh nao (IIS, Nginx, Netlify...).
pause
