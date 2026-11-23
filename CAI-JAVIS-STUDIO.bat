@echo off
chcp 65001 >nul
title CAI DAT JAVIS STUDIO - TPW GROUP
echo ==============================================
echo   CAI DAT JAVIS STUDIO (TPW GROUP)
echo   Cai 1 lan - sau nay phan mem tu cap nhat.
echo ==============================================
echo.
set "DEST=%LOCALAPPDATA%\JavisStudio"
set "NGUON=https://raw.githubusercontent.com/tandatnguyen1994-collab/javis-studio/main"
set "PY="
rem --- tim Python that (bo qua ban gia cua Microsoft Store) ---
py -3 -c "import sys" >nul 2>nul && set "PY=py -3"
if not defined PY python -c "import sys" >nul 2>nul && set "PY=python"
if not defined PY if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" set "PY=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
if defined PY goto co_py
echo [1/4] May chua co Python - dang cai Python 3.12 (2-3 phut)...
winget install -e --id Python.Python.3.12 --scope user --silent --accept-package-agreements --accept-source-agreements
if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" set "PY=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
if defined PY goto co_py
echo.
echo  KHONG CAI DUOC PYTHON TU DONG.
echo  Mo trang python.org - tai ban moi nhat - khi cai NHO TICK "Add python.exe to PATH" - roi chay lai file nay.
start "" https://www.python.org/downloads/
pause
exit /b 1
:co_py
echo [1/4] Python: %PY%
echo [2/4] Cai thu vien (reportlab, pillow, cryptography, pypdfium2)...
%PY% -m pip install --quiet --disable-pip-version-check --upgrade reportlab pillow
echo [3/4] Tai Javis Studio ban moi nhat...
if not exist "%DEST%" mkdir "%DEST%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol='Tls12'; $m=Invoke-RestMethod ('%NGUON%/manifest.json?t='+[DateTime]::Now.Ticks); $z=Join-Path $env:TEMP $m.goi; Invoke-WebRequest ('%NGUON%/'+$m.goi) -OutFile $z -UseBasicParsing; if((Get-FileHash $z -Algorithm SHA256).Hash.ToLower() -ne $m.sha256){throw 'Goi tai ve bi loi, chay lai file nay.'}; Expand-Archive $z -DestinationPath '%DEST%' -Force; Remove-Item $z; Write-Host ('   Da tai ban '+$m.phien_ban)"
if errorlevel 1 (echo  !! TAI KHONG DUOC - kiem tra mang roi chay lai. & pause & exit /b 1)
if not exist "%DEST%\vetu.py" (echo  !! Loi giai nen. & pause & exit /b 1)
rem --- tim pythonw.exe de chay khong hien cua so den ---
for /f "delims=" %%i in ('%PY% -c "import sys,os;p=sys.executable;w=os.path.join(os.path.dirname(p),'pythonw.exe');print(w if os.path.isfile(w) else p)"') do set "PYW=%%i"
echo [4/4] Tao icon "Javis Studio" ngoai Desktop...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\Javis Studio.lnk'); $s.TargetPath='%PYW%'; $s.Arguments='\"%CHAY%\"'; if(Test-Path '%DEST%\javis-studio.ico'){$s.IconLocation='%DEST%\javis-studio.ico'}; $s.WorkingDirectory='%DEST%'; $s.Description='Javis Studio - TPW GROUP'; $s.Save()"
echo.
echo  XONG! Dang mo Javis Studio...
echo  Lan dau: dan MA KICH HOAT anh Tan gui vao o roi bam "Kich hoat".
echo  Lan sau: bam icon "Javis Studio" ngoai Desktop. Phan mem tu cap nhat khi co ban moi.
start "" "%PYW%" "%CHAY%"
echo.
pause
