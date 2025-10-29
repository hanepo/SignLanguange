# SIGNLINK - Quick Reference Guide

## 🚀 Getting Started

### First Run
1. Run: `flutter pub get`
2. Run: `flutter run`
3. Login with default admin:
   - Email: `admin@signlink.com`
   - Password: `admin123`

## 👥 User Roles

### Admin
**Full Access:**
- ✅ Manage all user accounts
- ✅ CRUD sign language modules
- ✅ CRUD learning modules
- ✅ View all content
- ✅ System administration

### User
**Limited Access:**
- ✅ Create own account
- ✅ View/edit own profile
- ✅ Change password
- ✅ View sign language modules
- ✅ Use translation feature
- ❌ Cannot manage other users
- ❌ Cannot manage content

## 📱 Key Screens

### For Admins
1. **Admin Dashboard** - Central hub for all management tasks
2. **Manage Users** - Create/view/update/delete user accounts
3. **Manage Sign Modules** - CRUD for BIM signs
4. **Manage Learning Modules** - CRUD for educational content

### For Users
1. **User Dashboard** - Access to features
2. **Profile** - Manage account settings
3. **Translate** - Real-time BIM to text
4. **Learn BIM** - Browse sign language modules

## 🗄️ Database

**Location:** App's local storage (SQLite)
**Tables:** users, sign_language_modules, learning_modules

### Default Data
- 1 Admin account
- 6 Sign language modules (HELLO, THANK YOU, YES, NO, I LOVE YOU, EAT)

## 🔑 Common Tasks

### Create New Admin Account
1. Login as admin
2. Go to "Manage Users"
3. Click "Add User"
4. Fill form and select "Admin" role
5. Click "Create User"

### Add New Sign Module
1. Login as admin
2. Go to "Sign Language Modules"
3. Click "Add Module"
4. Enter: word, description, asset path
5. Click "Create Module"

### Create Learning Module
1. Login as admin
2. Go to "Learning Modules"
3. Click "Add Module"
4. Enter: title, content, difficulty, order
5. Click "Create Module"

### User Registration
1. From login screen, click "Create Account"
2. Fill registration form
3. Account created with 'user' role
4. Auto-login to User Dashboard

## 📁 File Locations

### Models
- `lib/models/user.dart`
- `lib/models/sign_language_module.dart`
- `lib/models/learning_module.dart`

### Services
- `lib/services/auth_service.dart` - Authentication
- `lib/services/database_helper.dart` - Database operations

### Admin Screens
- `lib/screens/admin/admin_dashboard.dart`
- `lib/screens/admin/manage_users_screen.dart`
- `lib/screens/admin/manage_sign_modules_screen.dart`
- `lib/screens/admin/manage_learning_modules_screen.dart`

### User Screens
- `lib/screens/user/user_dashboard.dart`
- `lib/screens/user/user_profile_screen.dart`

## 🎨 UI Components

### Form Fields
- All forms include validation
- Required fields marked
- Error messages displayed inline

### Lists
- Swipe or click icons to edit/delete
- Confirmation dialogs for deletions
- Empty states when no data

### Buttons
- **Filled** - Primary actions (Save, Create)
- **Outlined** - Secondary actions (Cancel)
- **Icon** - Quick actions (Edit, Delete)

## ⚠️ Important Notes

### Security
- **Passwords are NOT encrypted** in current version
- For production, implement password hashing
- Add email verification
- Implement session tokens

### Data Persistence
- All data stored locally in SQLite
- Database created on first app launch
- Survives app restarts
- No cloud backup (add if needed)

### Asset Management
- Images must be in `assets/` folder
- Update `pubspec.yaml` when adding assets
- Use relative paths: `assets/filename.png`

## 🐛 Troubleshooting

### Can't login
- Check credentials (case-sensitive)
- Use default admin: admin@signlink.com / admin123

### Database errors
- Clear app data and reinstall
- Database will recreate with defaults

### Image not showing
- Verify asset path in pubspec.yaml
- Check file exists in assets folder
- Use error placeholder icon

### Build errors
- Run: `flutter clean`
- Run: `flutter pub get`
- Run: `flutter run`

## 📊 Use Case Checklist

### Admin Features
- [x] Create user accounts
- [x] View all users
- [x] Update user information
- [x] Delete users
- [x] Add sign language modules
- [x] View sign modules
- [x] Update sign modules
- [x] Delete sign modules
- [x] Add learning modules
- [x] View learning modules
- [x] Update learning modules
- [x] Delete learning modules

### User Features
- [x] Register account
- [x] View own profile
- [x] Update own profile
- [x] Change password
- [x] View sign language modules
- [x] Use translation feature

## 🔄 Navigation Shortcuts

From **Admin Dashboard:**
- Users icon → Manage Users
- Sign icon → Manage Sign Modules
- School icon → Manage Learning Modules
- Profile icon → Admin profile
- Logout icon → Back to login

From **User Dashboard:**
- Translate card → Camera translation
- Learn BIM card → Browse signs
- Profile icon → Edit profile
- Logout icon → Back to login

## 💡 Tips

1. **Default Admin**: Always available as backup
2. **Role Assignment**: Only admins can create other admins
3. **Order Index**: Use for sorting learning modules
4. **Difficulty Levels**: Beginner (green), Intermediate (orange), Advanced (red)
5. **Asset Paths**: Follow pattern `assets/word.png`

## 📞 Support

For issues or questions:
1. Check IMPLEMENTATION_SUMMARY.md for details
2. Review this guide
3. Check Flutter console for error messages
4. Verify database setup and migrations
