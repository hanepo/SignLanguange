# SIGNLINK - System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         SIGNLINK APP                             │
│                   Malaysian Sign Language App                    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      AUTHENTICATION LAYER                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐      ┌──────────────┐                        │
│  │ LoginScreen  │─────▶│ AuthService  │                        │
│  └──────────────┘      └──────┬───────┘                        │
│         │                      │                                │
│         │                      ▼                                │
│  ┌──────────────┐      ┌──────────────┐                        │
│  │RegisterScreen│      │DatabaseHelper│                        │
│  └──────────────┘      └──────────────┘                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                           │
                           │ Role Check
                           │
          ┌────────────────┴────────────────┐
          │                                  │
          ▼                                  ▼
┌─────────────────────┐          ┌─────────────────────┐
│    ADMIN PORTAL     │          │    USER PORTAL      │
├─────────────────────┤          ├─────────────────────┤
│                     │          │                     │
│ ┌─────────────────┐ │          │ ┌─────────────────┐ │
│ │ AdminDashboard  │ │          │ │ UserDashboard   │ │
│ └────────┬────────┘ │          │ └────────┬────────┘ │
│          │          │          │          │          │
│   ┌──────┴──────┐   │          │   ┌──────┴──────┐   │
│   │             │   │          │   │             │   │
│   ▼             ▼   │          │   ▼             ▼   │
│ ┌─────┐    ┌──────┐│          │ ┌──────┐   ┌──────┐ │
│ │Users│    │Signs ││          │ │Profile   │Learn │ │
│ │Mgmt │    │Mgmt  ││          │ │Screen│   │Screen│ │
│ └─────┘    └──────┘│          │ └──────┘   └──────┘ │
│   │           │     │          │    │          │     │
│   ▼           ▼     │          │    │          │     │
│ ┌──────┐  ┌──────┐ │          │    │          │     │
│ │Learn │  │User  │ │          │    │          │     │
│ │Mgmt  │  │Form  │ │          │    ▼          ▼     │
│ └──────┘  └──────┘ │          │ ┌───────────────┐   │
│                     │          │ │ Translation   │   │
│ Full CRUD Access    │          │ │ Screen        │   │
│                     │          │ └───────────────┘   │
│                     │          │                     │
│                     │          │ Read-Only Access    │
└─────────────────────┘          └─────────────────────┘
          │                                  │
          │                                  │
          └────────────┬─────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────────────────────────┐         │
│  │             SQLite Database (Local)                 │         │
│  ├────────────────────────────────────────────────────┤         │
│  │                                                     │         │
│  │  ┌───────────┐  ┌──────────────┐  ┌────────────┐  │         │
│  │  │   users   │  │sign_language │  │  learning  │  │         │
│  │  │           │  │   _modules   │  │  _modules  │  │         │
│  │  ├───────────┤  ├──────────────┤  ├────────────┤  │         │
│  │  │id         │  │id            │  │id          │  │         │
│  │  │email      │  │word          │  │title       │  │         │
│  │  │password   │  │description   │  │content     │  │         │
│  │  │fullName   │  │assetPath     │  │difficulty  │  │         │
│  │  │role       │  │videoPath     │  │orderIndex  │  │         │
│  │  │createdAt  │  │createdAt     │  │createdAt   │  │         │
│  │  │updatedAt  │  │updatedAt     │  │updatedAt   │  │         │
│  │  └───────────┘  └──────────────┘  └────────────┘  │         │
│  │                                                     │         │
│  └────────────────────────────────────────────────────┘         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    EXISTING FEATURES LAYER                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐    ┌──────────────────┐                  │
│  │  HandStream      │◀───│ TranslationScreen│                  │
│  │  (MediaPipe)     │    └──────────────────┘                  │
│  └────────┬─────────┘                                           │
│           │                                                     │
│           ▼                                                     │
│  ┌──────────────────┐    ┌──────────────────┐                  │
│  │ GestureRules     │───▶│ GestureSmoother  │                  │
│  │ (Classification) │    │ (Stabilization)  │                  │
│  └──────────────────┘    └──────────────────┘                  │
│                                                                  │
│  Camera ──▶ MediaPipe ──▶ Rules ──▶ Smoother ──▶ Text Output   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        USE CASE MATRIX                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Feature                           │ Admin │ User │             │
│  ─────────────────────────────────┼───────┼──────┤             │
│  Create User Account              │  ✓    │  ✓*  │             │
│  View User Accounts               │  ✓    │  ✗   │             │
│  Update User Accounts             │  ✓    │  ✓** │             │
│  Delete User Accounts             │  ✓    │  ✗   │             │
│  Add Sign Language Modules        │  ✓    │  ✗   │             │
│  View Sign Language Modules       │  ✓    │  ✓   │             │
│  Update Sign Language Modules     │  ✓    │  ✗   │             │
│  Delete Sign Language Modules     │  ✓    │  ✗   │             │
│  Add Learning Modules             │  ✓    │  ✗   │             │
│  View Learning Modules            │  ✓    │  ✗   │             │
│  Update Learning Modules          │  ✓    │  ✗   │             │
│  Delete Learning Modules          │  ✓    │  ✗   │             │
│  Use Translation Feature          │  ✓    │  ✓   │             │
│  Use Learn Feature                │  ✓    │  ✓   │             │
│                                                                  │
│  * User can only create their own account via registration      │
│  ** User can only update their own account                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     STATE MANAGEMENT                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│         ┌────────────────────────────────┐                      │
│         │  Provider (ChangeNotifier)     │                      │
│         └────────────┬───────────────────┘                      │
│                      │                                          │
│                      ▼                                          │
│         ┌────────────────────────────────┐                      │
│         │      AuthService               │                      │
│         │  ─────────────────────         │                      │
│         │  - currentUser                 │                      │
│         │  - isLoggedIn                  │                      │
│         │  - isAdmin                     │                      │
│         │  - login()                     │                      │
│         │  - logout()                    │                      │
│         │  - register()                  │                      │
│         │  - updateProfile()             │                      │
│         └────────────────────────────────┘                      │
│                      │                                          │
│                      │ Notifies Listeners                       │
│                      │                                          │
│                      ▼                                          │
│         All screens consuming AuthService                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    NAVIGATION FLOW                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                    LoginScreen                                   │
│                         │                                        │
│                ┌────────┴────────┐                              │
│                │                 │                              │
│          Role: Admin       Role: User                           │
│                │                 │                              │
│                ▼                 ▼                              │
│         AdminDashboard    UserDashboard                         │
│                │                 │                              │
│        ┌───────┼───────┐    ┌───┴────┐                         │
│        │       │       │    │        │                         │
│        ▼       ▼       ▼    ▼        ▼                         │
│     Users   Signs   Learn Profile  Features                    │
│      Mgmt   Mgmt    Mgmt           (Translate/Learn)           │
│        │       │       │                                        │
│        ▼       ▼       ▼                                        │
│     Forms   Forms   Forms                                       │
│    (CRUD)   (CRUD)  (CRUD)                                      │
│                                                                  │
│  All paths can navigate back or logout to LoginScreen          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                   KEY DEPENDENCIES                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  flutter           - Core framework                             │
│  provider          - State management                           │
│  sqflite           - Local database                             │
│  path_provider     - File system access                         │
│  path              - Path manipulation                          │
│  camera            - Camera access                              │
│                                                                  │
│  Native (Android): MediaPipe HandLandmarker                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Color Coding Legend

```
Admin Features: 🔴 Full Control
User Features:  🟢 Limited Access
Shared Features: 🟡 Available to Both
```

## Security Model

```
┌──────────────────────────────────────┐
│          Security Layers             │
├──────────────────────────────────────┤
│ 1. Login Authentication              │
│    - Email/Password verification     │
│    - Session management via Provider │
│                                      │
│ 2. Role-Based Access Control         │
│    - Admin vs User permissions       │
│    - UI routes based on role         │
│                                      │
│ 3. Form Validation                   │
│    - Input sanitization              │
│    - Required field checks           │
│                                      │
│ 4. Confirmation Dialogs              │
│    - Delete operations               │
│    - Destructive actions             │
│                                      │
│ ⚠️  TODO for Production:             │
│    - Password encryption             │
│    - JWT/Token authentication        │
│    - Email verification              │
│    - Rate limiting                   │
└──────────────────────────────────────┘
```

## Data Flow Example: Adding a Sign Module

```
1. Admin logs in ──▶ AdminDashboard
                           │
2. Clicks "Sign Language Modules" 
                           │
3. Opens ──▶ ManageSignModulesScreen
                           │
4. Clicks "Add Module"
                           │
5. Opens ──▶ SignModuleFormScreen
                           │
6. Fills form: word, description, asset path
                           │
7. Clicks "Create Module"
                           │
8. Form validation passes
                           │
9. DatabaseHelper.createSignModule()
                           │
10. Insert into sign_language_modules table
                           │
11. Returns to ManageSignModulesScreen
                           │
12. Reload list ──▶ Show new module
                           │
13. User can now see it in LearnScreen
```
