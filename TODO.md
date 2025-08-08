# Pug Safai Flutter App – Development To-Do

## 1. Models ✅
- [ ] **User Model**
  - Fields: `id`, `name`, `email`, `phone`, `age`, `roleId`
  - From API login response
- [ ] **ChecklistItem Model**
  - Fields: `id`, `key`, `label`, `category`
  - From API `/checklist` endpoint
- [ ] **CleanerReview Model**
  - Fields: `id`, `name`, `phone`, `siteId`, `userId`, `taskIds[]`, `remarks`, `latitude`, `longitude`, `address`, `images[]`, `createdAt`, `status`

---

## 2. Services
- [ ] **ApiService**
  - [ ] `registerUser()`
  - [ ] `loginUser()`
  - [ ] `getLocations()`
  - [ ] `getChecklistItems()`
  - [ ] `getCleanerReviews(userId)` → separate ongoing & completed
  - [ ] `postCleanerReview()` → start or complete task

---

## 3. Providers
- [ ] **AuthProvider**
  - [ ] Store & manage user data
  - [ ] Handle login/register/logout
- [ ] **TaskProvider**
  - [ ] Fetch ongoing & completed work
  - [ ] Start new cleaning task
  - [ ] Complete an ongoing task
  - [ ] Sync with API

---

## 4. Screens
- [ ] **RegisterScreen**
  - [ ] Form inputs: Name, Email, Phone, Password, Age, Role (optional)
  - [ ] Submit to API
  - [ ] Navigate to LoginScreen on success
- [ ] **LoginScreen**
  - [ ] Email, Password
  - [ ] Save logged-in user
  - [ ] Navigate to DashboardScreen
- [ ] **DashboardScreen**
  - [ ] Profile header
  - [ ] Ongoing Work section
  - [ ] Completed Work section
  - [ ] Start New Cleaning Task button
- [ ] **StartTaskScreen**
  - [ ] Select site (dropdown from API)
  - [ ] Select checklist tasks (multi-select)
  - [ ] Remarks (before cleaning)
  - [ ] Capture GPS coordinates
  - [ ] Pick images (before cleaning)
  - [ ] Submit to API → Add to ongoing tasks
- [ ] **CompleteTaskScreen**
  - [ ] Show selected site & pre-filled checklist
  - [ ] Remarks (after cleaning)
  - [ ] Capture GPS coordinates
  - [ ] Pick images (after cleaning)
  - [ ] Submit to API → Move to completed tasks

---

## 5. Utilities
- [ ] GPS Helper (`geolocator`)
- [ ] Image Picker Helper (`image_picker`)
- [ ] Local Storage (SharedPreferences / Hive)
- [ ] API Error Handler

---

## 6. Testing & Validation
- [ ] Test API endpoints in Postman before integration
- [ ] Test register/login flow
- [ ] Test start → complete task flow
- [ ] Test image uploads
- [ ] Test GPS coordinate capture
- [ ] Verify ongoing/completed tasks display correctly

---

## 7. Deployment
- [ ] Update `build.gradle` with correct NDK version
- [ ] Build APK
- [ ] Deploy to internal testers
