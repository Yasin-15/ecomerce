# Quick Start Guide 🚀

Get the app running in 5 minutes!

## Step 1: Backend Setup (2 minutes)

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Create .env file
copy .env.example .env

# Edit .env and set:
# MONGODB_URI=mongodb://localhost:27017/ecommerce
# JWT_SECRET=your_secret_key_here

# Run setup (creates test user + seeds products)
npm run setup

# Start server
npm run dev
```

✅ Backend running on http://localhost:3000

## Step 2: Flutter Setup (2 minutes)

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Step 3: Test the App (1 minute)

### Option 1: Use Test Account
- Email: `test@example.com`
- Password: `password123`

### Option 2: Create New Account
- Click "Sign Up"
- Fill in your details
- Start shopping!

## What You Get

✅ **3 Onboarding Screens** - Beautiful splash screens
✅ **Authentication** - Sign In, Sign Up, Forgot Password
✅ **Product Catalog** - 8 sample products with real images
✅ **Categories** - Filter by Electronics, Fashion, Home, Sports
✅ **Search** - Find products quickly
✅ **Shopping Cart** - Add/remove items
✅ **Checkout** - Complete order flow
✅ **Order History** - Track your orders
✅ **User Profile** - Manage your account

## Troubleshooting

### Backend won't start?
```bash
# Make sure MongoDB is running
mongod

# Check if port 3000 is free
# Windows: netstat -ano | findstr :3000
# Mac/Linux: lsof -i :3000
```

### Flutter build errors?
```bash
flutter clean
flutter pub get
flutter run
```

### Can't connect to backend from app?
Edit `lib/services/api_service.dart`:
- **Android Emulator**: `http://10.0.2.2:3000/api`
- **iOS Simulator**: `http://localhost:3000/api`
- **Physical Device**: `http://YOUR_COMPUTER_IP:3000/api`

## Next Steps

1. **Customize Products**: Edit `backend/utils/seedData.js`
2. **Change Theme**: Edit `lib/theme/app_theme.dart`
3. **Add Features**: Check `SETUP.md` for detailed docs
4. **Deploy**: See production deployment guide in `SETUP.md`

## API Testing

Use the included `test_api.http` file with REST Client extension in VS Code to test all endpoints.

## Need Help?

Check the detailed `SETUP.md` for:
- Complete API documentation
- Deployment guides
- Advanced configuration
- Troubleshooting tips

Happy coding! 🎉
