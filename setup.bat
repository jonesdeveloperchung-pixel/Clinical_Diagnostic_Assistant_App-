@echo off
echo Setting up Clinical Diagnostic Assistant App...

echo.
echo Installing backend dependencies...
cd backend\gateway
call npm install
cd ..\diagnostic-engine
call npm install
cd ..\user-management
call npm install
cd ..\reporting
call npm install
cd ..\..

echo.
echo Installing Flutter dependencies...
cd clinical_diagnostic_app
call flutter pub get
cd ..

echo.
echo Setup complete!
echo.
echo To start the application:
echo 1. Run start-backend.bat to start all backend services
echo 2. Run start-frontend.bat to start the Flutter app
echo.
pause