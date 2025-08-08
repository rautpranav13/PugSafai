# 📋 Flutter App Development Checklist — Registration & Auth Flow

## ✅ 1. Models
- [x] **Create models** for:
    - [x] `User`
    - [x] `Location`
    - [x] `CleanerReview`
    - [x] `ChecklistItem`
- [ ] **Update models to handle int/string mismatches**
    - [ ] Use `.toString()` for IDs that might come as int
    - [ ] Null-safe parsing for optional fields

---

## ✅ 2. API Service Setup
- [x] Define `baseUrl` correctly (`https://safai-index-backend.onrender.com/api`)
- [ ] Centralize endpoints in a single constants file
- [x] Implement `registerUser` method
    - [x] Include `role_id` for cleaner accounts (`role_id = 2`)
    - [ ] Only send `age` if not null
    - [ ] Return backend error messages to the UI
- [x] Implement `loginUser` method
    - [x] Store logged-in user in `SharedPreferences`

---

## ✅ 3. Auth Provider
- [x] Implement `login()` method
- [x] Implement `register()` method
    - [ ] Pass backend error messages up to UI
- [ ] Implement `logout()` to clear `SharedPreferences` as well

---

## ✅ 4. Register Screen
- [x] Build form UI
    - [x] Name, Email, Phone, Password, Age, Role ID
- [ ] Add form validation for:
    - [ ] Email format
    - [ ] Phone format (`+91XXXXXXXXXX`)
    - [ ] Password length ≥ 6
- [ ] Show actual backend error message instead of generic `"Registration failed"`
- [ ] Auto-fill `role_id = 2` by default for cleaner registration

---

## ✅ 5. Login Screen
- [x] Build form UI
    - [x] Email, Password
- [ ] Show actual backend error message on failure
- [ ] Redirect to dashboard on success

---

## ⏳ 6. Dashboard Screen (Post-login)
- [ ] Create placeholder `DashboardScreen`
- [ ] Display logged-in user's name & role
- [ ] Add logout button

---

## ⏳ 7. Others
- [ ] 
- [ ] 
- [ ] 
- [ ] 

---
