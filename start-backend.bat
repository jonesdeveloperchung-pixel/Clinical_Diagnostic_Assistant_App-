@echo off
echo Starting Clinical Diagnostic Assistant Backend Services...

start "API Gateway" cmd /k "cd backend\gateway && npm start"
timeout /t 2 /nobreak > nul

start "Diagnostic Engine" cmd /k "cd backend\diagnostic-engine && npm start"
timeout /t 2 /nobreak > nul

start "User Management" cmd /k "cd backend\user-management && npm start"
timeout /t 2 /nobreak > nul

start "Reporting Service" cmd /k "cd backend\reporting && npm start"

echo.
echo All backend services are starting...
echo API Gateway: http://localhost:3000
echo Diagnostic Engine: http://localhost:3001
echo User Management: http://localhost:3002
echo Reporting Service: http://localhost:3003
echo.
pause