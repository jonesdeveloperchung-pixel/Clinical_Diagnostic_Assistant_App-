@echo off
echo Testing Direct Service Endpoints...
echo.

echo Testing User Registration (Direct)...
curl -X POST http://localhost:3002/register -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\",\"role\":\"physician\"}"
echo.
echo.

echo Testing User Registration (Via Gateway)...
curl -X POST http://localhost:3000/api/users/register -H "Content-Type: application/json" -d "{\"email\":\"test2@example.com\",\"password\":\"password123\",\"role\":\"physician\"}"
echo.
echo.

pause