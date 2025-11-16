# ⚡ Quick Admin Dashboard Start

Get your admin dashboard running in 3 commands!

## 🚀 Super Quick Setup

```bash
# 1. Install & Setup Everything (one command!)
cd backend
npm install
npm run setup-admin

# 2. Start Server
npm run dev

# 3. Run Flutter App (in new terminal)
cd ..
flutter pub get
flutter run
```

## 🔐 Login Credentials

**Admin Account:**
- Email: `admin@example.com`
- Password: `admin123`

**Test User Account:**
- Email: `test@example.com`
- Password: `password123`

## 📱 Access Admin Dashboard

1. Open the Flutter app
2. Login with admin credentials
3. Tap **Profile** tab (bottom navigation)
4. Tap **Admin Dashboard** (purple button)

## ✨ What You Get

- ✅ Admin user created
- ✅ Test user created
- ✅ 8 sample products
- ✅ 5 test orders
- ✅ Revenue data
- ✅ Full admin access

## 🎯 Admin Features

### Dashboard
- View statistics (products, orders, users, revenue)
- See recent orders
- Quick action buttons

### Manage Products
- Create new products
- Edit existing products
- Delete products

### Manage Orders
- View all orders
- Update order status
- See customer details

### Manage Users
- View all users
- Grant/revoke admin access

## 🔧 Individual Commands

If you need to run things separately:

```bash
# Create admin only
npm run create-admin

# Create test orders only
npm run create-orders

# Seed products only
npm run setup
```

## 🐛 Troubleshooting

**Revenue shows $0.00?**
```bash
npm run create-orders
```

**Admin button not showing?**
- Logout and login again
- Make sure you're using admin credentials

**Can't connect to backend?**
- Check `lib/services/api_service.dart`
- Android Emulator: `http://10.0.2.2:3000/api`
- iOS Simulator: `http://localhost:3000/api`

## 📚 More Help

- [ADMIN_SETUP.md](ADMIN_SETUP.md) - Detailed setup guide
- [ADMIN_GUIDE.md](ADMIN_GUIDE.md) - Feature documentation
- [README.md](README.md) - General documentation

---

**That's it!** Your admin dashboard is ready to use. 🎉
