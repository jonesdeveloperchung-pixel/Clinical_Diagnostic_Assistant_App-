# Clinical Diagnostic Assistant App - MVP

A comprehensive clinical diagnostic assistant application with Flutter frontend and Node.js microservices backend.

## Architecture

### Backend Services
- **API Gateway** (Port 3000): Routes requests to microservices
- **Diagnostic Engine** (Port 3001): Processes symptoms and returns diagnoses
- **User Management** (Port 3002): Handles authentication and user management
- **Reporting Service** (Port 3003): Generates PDF reports and sends emails

### Frontend
- **Flutter App**: Cross-platform mobile application with diagnosis interface

## Features

### Core Functionality
- ✅ User authentication (login/register)
- ✅ Medical specialty selection (Internal Medicine, Psychiatry, Dermatology)
- ✅ Symptom input with specialty-specific options
- ✅ AI-powered diagnostic suggestions with confidence scores
- ✅ PDF report generation
- ✅ Email report delivery
- ✅ Audit logging

### Diagnostic Engine
- Rule-based diagnosis system using JSON configuration
- Confidence scoring based on symptom matches
- Support for required vs optional symptoms
- ICD-10 code integration
- Treatment recommendations

## Quick Start

### Prerequisites
- Node.js (v16 or higher)
- Flutter SDK
- Git

### Installation

1. **Setup Dependencies**
   ```bash
   setup.bat
   ```

2. **Start Backend Services**
   ```bash
   start-backend.bat
   ```

3. **Test API Endpoints**
   ```bash
   test-endpoints.bat
   ```

4. **Start Frontend App**
   ```bash
   start-frontend.bat
   # Or for Windows desktop app:
   cd clinical_diagnostic_app
   flutter run -d windows
   ```

### Network Configuration

For Windows Flutter apps, update the IP address in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_LOCAL_IP:3000/api';
```

Find your local IP with: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)

### Manual Setup

#### Backend
```bash
# Install dependencies for each service
cd backend/gateway && npm install
cd ../diagnostic-engine && npm install
cd ../user-management && npm install
cd ../reporting && npm install

# Start services (in separate terminals)
cd backend/gateway && npm start          # Port 3000
cd backend/diagnostic-engine && npm start # Port 3001
cd backend/user-management && npm start   # Port 3002
cd backend/reporting && npm start         # Port 3003
```

#### Frontend
```bash
cd clinical_diagnostic_app
flutter pub get
flutter run
```

## Usage

1. **Register/Login**: Create an account or login with existing credentials
2. **Select Specialty**: Choose from Internal Medicine, Psychiatry, or Dermatology
3. **Input Symptoms**: Select relevant symptoms from the specialty-specific list
4. **Get Diagnosis**: Receive ranked diagnostic suggestions with confidence scores
5. **Generate Report**: Create PDF reports and email them to patients/colleagues

## API Endpoints

### Authentication
- `POST /api/users/register` - Register new user
- `POST /api/users/login` - User login
- `GET /api/users/profile` - Get user profile

### Diagnosis
- `POST /api/diagnosis/diagnose` - Get diagnostic suggestions

### Reporting
- `POST /api/reports/generate` - Generate PDF report
- `POST /api/reports/email` - Email report

## Configuration

### Environment Variables
Create `.env` files in each backend service directory:

```env
# User Management Service
JWT_SECRET=your-jwt-secret-key

# Reporting Service
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
```

### Diagnostic Rules
Edit `backend/diagnostic-engine/rules.json` to add new diagnostic rules:

```json
{
  "id": "R005",
  "diagnosis": "New Condition",
  "specialty": "Internal Medicine",
  "icd10": "A00.0",
  "criteria": [
    { "symptom": "symptom1", "required": true },
    { "symptom": "symptom2", "required": false }
  ],
  "minRequired": 1,
  "minTotal": 2,
  "recommendations": ["Treatment 1", "Treatment 2"]
}
```

## Testing

### API Endpoint Testing
Run the test script to verify all services are working:
```bash
test-endpoints.bat
```

### Manual Testing Commands
```bash
# Test registration
curl -X POST http://localhost:3000/api/users/register -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\",\"role\":\"physician\"}"

# Test login
curl -X POST http://localhost:3000/api/users/login -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"

# Test diagnosis
curl -X POST http://localhost:3000/api/diagnosis/diagnose -H "Content-Type: application/json" -d "{\"symptoms\":[\"fever\",\"cough\"],\"specialty\":\"Internal Medicine\"}"
```

### Troubleshooting
- **Connection refused**: Ensure all backend services are running
- **Flutter Windows app can't connect**: Update IP address in `api_service.dart`
- **CORS errors**: Check API Gateway CORS configuration

## Development

### Adding New Specialties
1. Update `specialties` list in `diagnosis_provider.dart`
2. Add symptoms to `symptomsBySpecialty` map
3. Create diagnostic rules in `rules.json`

### Adding New Features
- Backend: Add new services in `backend/` directory
- Frontend: Add new screens in `lib/screens/`
- Update API Gateway routing as needed

## Security Features

- JWT-based authentication
- Password hashing with bcrypt
- Rate limiting on API Gateway
- CORS protection
- Input validation
- Audit logging

## Future Enhancements

- FHIR integration for EMR systems
- Machine learning diagnostic models
- Multi-language support
- Advanced reporting templates
- Real-time collaboration features
- Mobile push notifications

## License

This project is licensed under the MIT License.