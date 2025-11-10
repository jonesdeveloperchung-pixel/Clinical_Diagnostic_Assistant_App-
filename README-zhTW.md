
# 臨床診斷輔助應用程式 - MVP

一款全面性的臨床診斷輔助應用程式，採用 Flutter 前端與 Node.js 微服務後端架構。

## 系統架構

### 後端服務
- **API 閘道**（埠號 3000）：負責將請求導向至各微服務
- **診斷引擎**（埠號 3001）：處理症狀並回傳診斷結果
- **使用者管理**（埠號 3002）：處理認證與使用者管理
- **報告服務**（埠號 3003）：產生 PDF 報告並寄送電子郵件

### 前端
- **Flutter 應用程式**：跨平台行動應用，提供診斷介面

## 功能特色

### 核心功能
- ✅ 使用者認證（登入／註冊）
- ✅ 醫學專科選擇（內科、精神科、皮膚科）
- ✅ 根據專科輸入症狀選項
- ✅ AI 驅動診斷建議與信心分數
- ✅ PDF 報告產生
- ✅ 電子郵件報告寄送
- ✅ 稽核日誌記錄

### 診斷引擎
- 使用 JSON 設定的規則式診斷系統
- 根據症狀匹配計算信心分數
- 支援必要與選填症狀
- 整合 ICD-10 疾病代碼
- 提供治療建議

## 快速開始

### 先決條件
- Node.js（版本 16 或以上）
- Flutter SDK
- Git

### 安裝步驟

1. **安裝相依套件**
   ```bash
   setup.bat
   ```

2. **啟動後端服務**
   ```bash
   start-backend.bat
   ```

3. **測試 API 端點**
   ```bash
   test-endpoints.bat
   ```

4. **啟動前端應用程式**
   ```bash
   start-frontend.bat
   # 或 Windows 桌面應用程式：
   cd clinical_diagnostic_app
   flutter run -d windows
   ```

### 網路設定

若使用 Windows Flutter 應用程式，請更新 `lib/services/api_service.dart` 中的 IP 位址：
```dart
static const String baseUrl = 'http://YOUR_LOCAL_IP:3000/api';
```

查詢本機 IP：Windows 使用 `ipconfig`，Mac/Linux 使用 `ifconfig`

### 手動設定

#### 後端
```bash
# 安裝各服務相依套件
cd backend/gateway && npm install
cd ../diagnostic-engine && npm install
cd ../user-management && npm install
cd ../reporting && npm install

# 分別啟動各服務（需開啟多個終端機）
cd backend/gateway && npm start          # 埠號 3000
cd backend/diagnostic-engine && npm start # 埠號 3001
cd backend/user-management && npm start   # 埠號 3002
cd backend/reporting && npm start         # 埠號 3003
```

#### 前端
```bash
cd clinical_diagnostic_app
flutter pub get
flutter run
```

## 使用方式

1. **註冊／登入**：建立帳號或使用現有帳號登入
2. **選擇專科**：選擇內科、精神科或皮膚科
3. **輸入症狀**：從專科對應的症狀清單中選擇
4. **取得診斷**：獲得排序後的診斷建議與信心分數
5. **產生報告**：建立 PDF 報告並寄送給病患或同事

## API 端點

### 認證
- `POST /api/users/register` - 註冊新使用者
- `POST /api/users/login` - 使用者登入
- `GET /api/users/profile` - 取得使用者資料

### 診斷
- `POST /api/diagnosis/diagnose` - 取得診斷建議

### 報告
- `POST /api/reports/generate` - 產生 PDF 報告
- `POST /api/reports/email` - 寄送報告電子郵件

## 設定

### 環境變數
在每個後端服務目錄中建立 `.env` 檔案：

```env
# 使用者管理服務
JWT_SECRET=your-jwt-secret-key

# 報告服務
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
```

### 診斷規則
編輯 `backend/diagnostic-engine/rules.json` 以新增診斷規則：

```json
{
  "id": "R005",
  "diagnosis": "新疾病",
  "specialty": "內科",
  "icd10": "A00.0",
  "criteria": [
    { "symptom": "症狀1", "required": true },
    { "symptom": "症狀2", "required": false }
  ],
  "minRequired": 1,
  "minTotal": 2,
  "recommendations": ["治療方式1", "治療方式2"]
}
```

## 測試

### API 端點測試
執行測試腳本以驗證所有服務是否正常運作：
```bash
test-endpoints.bat
```

### 手動測試指令
```bash
# 測試註冊
curl -X POST http://localhost:3000/api/users/register -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\",\"role\":\"physician\"}"

# 測試登入
curl -X POST http://localhost:3000/api/users/login -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"

# 測試診斷
curl -X POST http://localhost:3000/api/diagnosis/diagnose -H "Content-Type: application/json" -d "{\"symptoms\":[\"fever\",\"cough\"],\"specialty\":\"Internal Medicine\"}"
```

### 疑難排解
- **連線被拒絕**：請確認所有後端服務已啟動
- **Flutter Windows 應用無法連線**：請更新 `api_service.dart` 中的 IP 位址
- **CORS 錯誤**：請檢查 API 閘道的 CORS 設定

## 開發指南

### 新增專科
1. 更新 `diagnosis_provider.dart` 中的 `specialties` 清單
2. 在 `symptomsBySpecialty` 映射中新增症狀
3. 在 `rules.json` 中建立診斷規則

### 新增功能
- 後端：在 `backend/` 目錄中新增服務
- 前端：在 `lib/screens/` 中新增畫面
- 視需要更新 API 閘道路由設定

## 安全性功能

- 基於 JWT 的認證機制
- 使用 bcrypt 進行密碼雜湊
- API 閘道速率限制
- CORS 保護
- 輸入驗證
- 稽核日誌記錄

## 未來增強項目

- 整合 FHIR 與電子病歷系統
- 機器學習診斷模型
- 多語言支援
- 進階報告模板
- 即時協作功能
- 行動推播通知

## 授權

本專案採用 MIT 授權條款。
