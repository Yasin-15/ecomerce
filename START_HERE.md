# 🎯 START HERE - Admin Dashboard

## 🚀 Get Everything Working in 5 Minutes

### Step 1: Setup Backend (2 minutes)

Open terminal in the `backend` folder:

```bash
cd backend
npm install
npm run setup-admin
```

You should see:
```
✅ Admin Dashboard Setup Complete!

🔐 Admin Credentials:
   Email: admin@example.com
   Password: admin123
```

### Step 2: Start Server (30 seconds)

Keep the same terminal open:

```bash
npm run dev
```

You should see:
```
Server running on port 3000
```

**✅ Backend is ready!** Keep this terminal running.

### Step 3: Run Flutter App (2 minutes)

Open a **NEW terminal** in the project root:

```bash
flutter pub get
flutter run
```

Select your device when prompted.

**✅ App is running!**

### Step 4: Login & Access Admin (30 seconds)

1. In the app, tap **Sign In**
2. Enter:
   - Email: `admin@example.com`
   - Password: `admin123`
3. Tap **Sign In**
4. Tap **Profile** tab (bottom right)
5. Tap **Admin Dashboard** (purple button at top)

**🎉 You're in the admin dashboard!**

## 📊 What You Should See

### Dashboard Screen
- **Total Products**: 8
- **Total Orders**: 5
- **Total Users**: 2
- **Revenue**: $XXX.XX (not $0.00)
- **Recent Orders**: List of 5 orders

### Quick Actions
- Manage Products
- Manage Orders
- Manage Users

## 🎮 Try These Features

### 1. Create a Product
1. Tap **Manage Products**
2. Tap the **+** button (bottom right)
3. Fill in:
   - Name: "Test Product"
   - Description: "This is a test"
   - Price: 99.99
   - Stock: 10
   - Category: "Electronics"
   - Image URL: (use any product image URL)
4. Tap **Save**

**✅ Product created!**

### 2. Update Order Status
1. Go back to dashboard
2. Tap **Manage Orders**
3. Tap on any order to expand
4. Tap a different status chip (e.g., "shipped")

**✅ Order status updated!**

### 3. Grant Admin Access
1. Go back to dashboard
2. Tap **Manage Users**
3. Find "Test User"
4. Toggle the switch ON
5. Confirm

**✅ User is now admin!**

## 🐛 Something Not Working?

### Issue: Revenue shows $0.00

**Fix:**
```bash
cd backend
npm run create-orders
```

Then refresh the admin dashboard.

### Issue: Admin button not showing

**Fix:**
1. Logout from the app
2. Login again with admin credentials
3. Check Profile screen

### Issue: Can't connect to backend

**Fix:** Update `lib/services/api_service.dart`:

```dart
// For Android Emulator
static const String baseUrl = 'http://10.0.2.2:3000/api';

// For iOS Simulator
static const String baseUrl = 'http://localhost:3000/api';

// For Physical Device (replace with your computer's IP)
static const String baseUrl = 'http://192.168.1.XXX:3000/api';
```

### Issue: MongoDB not running

**Fix:**
```bash
# Start MongoDB
mongod

# Or if using Homebrew on Mac
brew services start mongodb-community
```

## 📚 Next Steps

Once everything is working:

1. ✅ **Explore all admin features**
   - Create, edit, delete products
   - Update order statuses
   - Manage user permissions

2. ✅ **Test with test user**
   - Logout
   - Login as: test@example.com / password123
   - Verify admin button is hidden
   - Place some orders

3. ✅ **Read the documentation**
   - [ADMIN_GUIDE.md](ADMIN_GUIDE.md) - Feature details
   - [ADMIN_CHECKLIST.md](ADMIN_CHECKLIST.md) - Verify everything works

4. ✅ **Customize for your needs**
   - Change admin credentials
   - Add your own products
   - Customize the UI

## 🎯 Quick Reference

### Admin Credentials
- Email: `admin@example.com`
- Password: `admin123`

### Test User Credentials
- Email: `test@example.com`
- Password: `password123`

### Useful Commands
```bash
# Backend
npm run setup-admin     # Complete setup
npm run dev            # Start server
npm run create-orders  # Add more orders

# Flutter
flutter run           # Run app
flutter clean         # Clean build
```

### API Base URLs
- Android Emulator: `http://10.0.2.2:3000/api`
- iOS Simulator: `http://localhost:3000/api`
- Physical Device: `http://YOUR_IP:3000/api`

## ✅ Success Checklist

- [ ] Backend running on port 3000
- [ ] Flutter app running
- [ ] Logged in as admin
- [ ] Admin dashboard accessible
- [ ] Statistics showing data (not $0.00)
- [ ] Can create products
- [ ] Can update orders
- [ ] Can manage users

## 🆘 Still Need Help?

Check these files in order:

1. **[QUICK_ADMIN_START.md](QUICK_ADMIN_START.md)** - Quick setup
2. **[ADMIN_SETUP.md](ADMIN_SETUP.md)** - Detailed setup
3. **[ADMIN_GUIDE.md](ADMIN_GUIDE.md)** - Feature guide
4. **[ADMIN_CHECKLIST.md](ADMIN_CHECKLIST.md)** - Troubleshooting

---

**Ready to go!** Follow the steps above and you'll have a fully functional admin dashboard. 🚀
