@echo off
echo Testing Clinical Diagnostic Assistant API Endpoints...
echo.

echo Testing API Gateway Health...
curl http://localhost:3000/health
echo.
echo.

echo Testing User Management Service Health...
curl http://localhost:3002/health
echo.
echo.

echo Testing Diagnostic Engine Health...
curl http://localhost:3001/health
echo.
echo.

echo Testing Reporting Service Health...
curl http://localhost:3003/health
echo.
echo.

echo Testing User Registration...
curl -X POST http://localhost:3000/api/users/register -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\",\"role\":\"physician\"}"
echo.
echo.

echo Testing User Login...
curl -X POST http://localhost:3000/api/users/login -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"
echo.
echo.

echo Testing Diagnosis Engine...
curl -X POST http://localhost:3000/api/diagnosis/diagnose -H "Content-Type: application/json" -d "{\"symptoms\":[\"fever\",\"cough\"],\"specialty\":\"Internal Medicine\"}"
echo.
echo.

pause