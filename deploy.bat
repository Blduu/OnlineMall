@echo off
setlocal EnableDelayedExpansion

REM Set default values
set VERSION=1.0.0
set SERVER_IP=
set SERVER_USER=root
set SERVER_PASSWORD=

REM Parse arguments
:parse
if "%~1"=="" goto :validate
if /i "%~1"=="-v" set VERSION=%~2&shift&shift&goto :parse
if /i "%~1"=="-i" set SERVER_IP=%~2&shift&shift&goto :parse
if /i "%~1"=="-u" set SERVER_USER=%~2&shift&shift&goto :parse
if /i "%~1"=="-p" set SERVER_PASSWORD=%~2&shift&shift&goto :parse
shift
goto :parse

:validate
REM Check for required parameters
if "%SERVER_IP%"=="" (
    echo ERROR: Server IP is required. Use -i parameter.
    goto :usage
)

REM If password not provided as parameter, ask for it
if "%SERVER_PASSWORD%"=="" (
    set /p SERVER_PASSWORD=Enter server password:
)

REM Initialize log
set LOG_FILE=deploy.log
echo [%date% %time%] [INFO] Starting OnlineMall deployment, version: %VERSION% > %LOG_FILE%

REM 1. Build backend
echo [%date% %time%] [INFO] Building backend project... >> %LOG_FILE%
cd OnlineMall-backend
call mvn clean package -DskipTests
if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] [ERROR] Backend build failed >> %LOG_FILE%
    exit /b 1
)
echo [%date% %time%] [INFO] Backend build successful >> %LOG_FILE%
cd ..

REM 2. Build frontend
echo [%date% %time%] [INFO] Building frontend project... >> %LOG_FILE%
cd OnlineMall-frontend
call npm install
if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] [ERROR] Frontend dependency installation failed >> %LOG_FILE%
    exit /b 1
)
call npm run build
if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] [ERROR] Frontend build failed >> %LOG_FILE%
    exit /b 1
)
echo [%date% %time%] [INFO] Frontend build successful >> %LOG_FILE%
cd ..

REM 3. Build Docker images
echo [%date% %time%] [INFO] Building Docker images... >> %LOG_FILE%

REM Build backend image
docker build -t onlinemall-backend:%VERSION% ./OnlineMall-backend
if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] [ERROR] Backend Docker image build failed >> %LOG_FILE%
    exit /b 1
)

REM Build frontend image
docker build -t onlinemall-frontend:%VERSION% ./OnlineMall-frontend
if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] [ERROR] Frontend Docker image build failed >> %LOG_FILE%
    exit /b 1
)

echo [%date% %time%] [INFO] Docker images built successfully >> %LOG_FILE%

REM 4. Pull and save base images (MySQL and Redis)
echo [%date% %time%] [INFO] Pulling MySQL and Redis images from Docker Hub... >> %LOG_FILE%
docker pull mysql:8.4.5
if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] [ERROR] Failed to pull MySQL image >> %LOG_FILE%
    exit /b 1
)

docker pull redis:8.0.1
if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] [ERROR] Failed to pull Redis image >> %LOG_FILE%
    exit /b 1
)

REM 5. Save all Docker images
echo [%date% %time%] [INFO] Saving Docker images to files... >> %LOG_FILE%
docker save -o onlinemall-backend-%VERSION%.tar onlinemall-backend:%VERSION%
docker save -o onlinemall-frontend-%VERSION%.tar onlinemall-frontend:%VERSION%
docker save -o mysql-8.4.5.tar mysql:8.4.5
docker save -o redis-8.0.1.tar redis:8.0.1
echo [%date% %time%] [INFO] Images saved successfully >> %LOG_FILE%

REM 6. Create a temp directory for files
mkdir temp 2>nul

REM Update docker-compose.yml to remove version field
powershell -Command "(Get-Content docker-compose.yml) -replace 'version: ''3.8''(\r?\n)', '' | Set-Content temp\docker-compose.yml"

REM 7. Transfer Files to Server
echo [%date% %time%] [INFO] Preparing to connect to server... >> %LOG_FILE%

REM Create script to upload files
echo @echo off > temp\scp.bat
echo echo %SERVER_PASSWORD%| ssh %SERVER_USER%@%SERVER_IP% "mkdir -p /root/deploy /root/OnlineMall-backend/avatar /root/OnlineMall-backend/file /root/OnlineMall-backend/sql" >> temp\scp.bat
echo echo %SERVER_PASSWORD%| scp onlinemall-backend-%VERSION%.tar %SERVER_USER%@%SERVER_IP%:/root/deploy/ >> temp\scp.bat
echo echo %SERVER_PASSWORD%| scp onlinemall-frontend-%VERSION%.tar %SERVER_USER%@%SERVER_IP%:/root/deploy/ >> temp\scp.bat
echo echo %SERVER_PASSWORD%| scp mysql-8.4.5.tar %SERVER_USER%@%SERVER_IP%:/root/deploy/ >> temp\scp.bat
echo echo %SERVER_PASSWORD%| scp redis-8.0.1.tar %SERVER_USER%@%SERVER_IP%:/root/deploy/ >> temp\scp.bat
echo echo %SERVER_PASSWORD%| scp temp\docker-compose.yml %SERVER_USER%@%SERVER_IP%:/root/ >> temp\scp.bat
echo echo %SERVER_PASSWORD%| scp OnlineMall-backend\sql\DB_OnlineMall.sql %SERVER_USER%@%SERVER_IP%:/root/OnlineMall-backend/sql/ >> temp\scp.bat
echo echo %SERVER_PASSWORD%| scp OnlineMall-backend\avatar\*.* %SERVER_USER%@%SERVER_IP%:/root/OnlineMall-backend/avatar/ >> temp\scp.bat
echo echo %SERVER_PASSWORD%| scp OnlineMall-backend\file\*.* %SERVER_USER%@%SERVER_IP%:/root/OnlineMall-backend/file/ >> temp\scp.bat

REM Create deployment script
echo #!/bin/bash > temp\deploy_script.sh
echo set -e >> temp\deploy_script.sh
echo echo "Starting deployment process..." >> temp\deploy_script.sh
echo mkdir -p /root/OnlineMall-backend/sql >> temp\deploy_script.sh
echo mkdir -p /root/OnlineMall-backend/avatar >> temp\deploy_script.sh
echo mkdir -p /root/OnlineMall-backend/file >> temp\deploy_script.sh
echo echo "Loading Docker images..." >> temp\deploy_script.sh
echo docker load -i /root/deploy/onlinemall-backend-%VERSION%.tar >> temp\deploy_script.sh
echo docker load -i /root/deploy/onlinemall-frontend-%VERSION%.tar >> temp\deploy_script.sh
echo docker load -i /root/deploy/mysql-8.4.5.tar >> temp\deploy_script.sh
echo docker load -i /root/deploy/redis-8.0.1.tar >> temp\deploy_script.sh
echo export VERSION=%VERSION% >> temp\deploy_script.sh
echo echo "Stopping old containers..." >> temp\deploy_script.sh
echo docker-compose -f /root/docker-compose.yml down ^|^| true >> temp\deploy_script.sh
echo echo "Starting new containers..." >> temp\deploy_script.sh
echo docker-compose -f /root/docker-compose.yml up -d mysql >> temp\deploy_script.sh
echo echo "Waiting for MySQL to initialize (60 seconds)..." >> temp\deploy_script.sh
echo sleep 60 >> temp\deploy_script.sh
echo docker-compose -f /root/docker-compose.yml up -d redis >> temp\deploy_script.sh
echo sleep 10 >> temp\deploy_script.sh
echo docker-compose -f /root/docker-compose.yml up -d backend frontend >> temp\deploy_script.sh
echo echo "Cleaning up..." >> temp\deploy_script.sh
echo rm -rf /root/deploy >> temp\deploy_script.sh
echo docker image prune -f >> temp\deploy_script.sh
echo echo "Deployment completed successfully!" >> temp\deploy_script.sh

REM Fix line endings (convert CRLF to LF)
powershell -Command "(Get-Content temp\deploy_script.sh) -replace '\r\n', '\n' | Set-Content -NoNewline temp\deploy_script.sh"

REM 7. Create directory on server
echo [%date% %time%] [INFO] Creating directory on server... >> %LOG_FILE%
echo %SERVER_PASSWORD%| ssh %SERVER_USER%@%SERVER_IP% "mkdir -p /root/deploy /root/OnlineMall-backend/avatar /root/OnlineMall-backend/file /root/OnlineMall-backend/sql"

REM 8. Upload files
echo [%date% %time%] [INFO] Uploading files to server (this may take a while)... >> %LOG_FILE%
call temp\scp.bat
echo %SERVER_PASSWORD%| scp temp\deploy_script.sh %SERVER_USER%@%SERVER_IP%:/root/deploy_script.sh

REM 9. Execute deployment script
echo [%date% %time%] [INFO] Executing deployment script on server... >> %LOG_FILE%
echo %SERVER_PASSWORD%| ssh %SERVER_USER%@%SERVER_IP% "chmod +x /root/deploy_script.sh && /root/deploy_script.sh"

if %ERRORLEVEL% neq 0 (
    echo [%date% %time%] [ERROR] Deployment failed >> %LOG_FILE%
    goto :cleanup
)

echo [%date% %time%] [INFO] Deployment completed successfully! >> %LOG_FILE%
echo [%date% %time%] [INFO] Frontend access URL: http://%SERVER_IP% >> %LOG_FILE%
echo [%date% %time%] [INFO] Backend access URL: http://%SERVER_IP%:8080 >> %LOG_FILE%

:cleanup
REM Clean up temporary files
rmdir /s /q temp
del onlinemall-backend-%VERSION%.tar
del onlinemall-frontend-%VERSION%.tar
del mysql-8.4.5.tar
del redis-8.0.1.tar

exit /b %ERRORLEVEL%

:usage
echo Usage: deploy.bat -i SERVER_IP [-u SERVER_USER] [-p SERVER_PASSWORD] [-v VERSION]
echo Example: deploy.bat -i 192.168.1.100 -u root -v 1.0.0
exit /b 1 