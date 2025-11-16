# Complete Setup Guide

## Prerequisites
- Node.js (v16+)
- MongoDB (local or Atlas)
- Flutter SDK (3.0+)
- Android Studio / Xcode (for mobile development)

## Backend Setup

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Configure Environment
```bash
# Copy example env file
copy .env.example .env

# Edit .env file with your settings:
PORT=3000
MONGODB_URI=mongodb://localhost:27017/ecommerce
JWT_SECRET=your_super_secret_jwt_key_change_this
JWT_EXPIRE=7d
```

### 3. Start MongoDB
**Local MongoDB:**
```bash
mongod
```

**Or use MongoDB Atlas:**
- Create account at mongodb.com/cloud/atlas
- Create cluster
- Get connection string
- Update MONGODB_URI in .env

### 4. Start Backend Server
```bash
npm run dev
```

Server will run on http://localhost:3000

### 5. Seed Sample Products
```bash
# Using curl
curl -X POST http://localhost:3000/api/products/seed

# Or using Postman
POST http://localhost:3000/api/products/seed
```

## Flutter Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure API URL
Edit `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP:3000/api';
```

**For Android Emulator:** Use `http://10.0.2.2:3000/api`
**For iOS Simulator:** Use `http://localhost:3000/api`
**For Physical Device:** Use your computer's IP address

### 3. Run the App
```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Or just run
flutter run
```

## Testing the App

### 1. Create Account
- Open app
- Go through splash screens
- Click "Sign Up"
- Enter details and register

### 2. Browse Products
- View products on home screen
- Filter by category
- Search products
- View product details

### 3. Shopping Flow
- Add products to cart
- View cart
- Proceed to checkout
- Enter shipping address
- Select payment method
- Place order

### 4. View Orders
- Go to Profile
- Click "My Orders"
- View order history

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/forgot-password` - Request password reset

### Products
- `GET /api/products` - Get all products
- `GET /api/products?category=Electronics` - Filter by category
- `GET /api/products?search=phone` - Search products
- `GET /api/products/:id` - Get single product
- `POST /api/products/seed` - Seed sample products

### Cart
- `GET /api/cart` - Get user cart
- `POST /api/cart/add` - Add item to cart
- `DELETE /api/cart/remove/:productId` - Remove item
- `DELETE /api/cart/clear` - Clear cart

### Orders
- `GET /api/orders` - Get user orders
- `POST /api/orders` - Create new order
- `GET /api/orders/:id` - Get order details

### User
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update profile

## Troubleshooting

### Backend Issues

**MongoDB Connection Error:**
```bash
# Check if MongoDB is running
mongod --version

# Start MongoDB service
# Windows: net start MongoDB
# Mac: brew services start mongodb-community
# Linux: sudo systemctl start mongod
```

**Port Already in Use:**
```bash
# Change PORT in .env file
PORT=3001
```

### Flutter Issues

**Network Error:**
- Check API baseUrl in `api_service.dart`
- Ensure backend is running
- For Android: Add internet permission (already added)
- For iOS: Update Info.plist for HTTP (if needed)

**Build Errors:**
```bash
flutter clean
flutter pub get
flutter run
```

**Dependency Issues:**
```bash
flutter pub upgrade
```

## Features Implemented

### Frontend (Flutter)
✅ Splash/Onboarding screens
✅ Authentication (Sign In, Sign Up, Forgot Password)
✅ Social login UI (Google, Apple, Facebook)
✅ Product listing with categories
✅ Product search
✅ Product details
✅ Shopping cart
✅ Checkout flow
✅ Order management
✅ User profile
✅ Bottom navigation
✅ Drawer menu
✅ Secure token storage

### Backend (Node.js/Express)
✅ JWT authentication
✅ User management
✅ Product CRUD
✅ Cart management
✅ Order processing
✅ Category filtering
✅ Product search
✅ Password hashing (bcrypt)
✅ Error handling
✅ CORS enabled

### Security
✅ JWT tokens
✅ Password hashing
✅ Secure storage (flutter_secure_storage)
✅ HTTPS images (Unsplash)
✅ Input validation
✅ Protected routes

## Production Deployment

### Backend
1. Use environment variables
2. Enable HTTPS
3. Set secure JWT secret
4. Use MongoDB Atlas
5. Add rate limiting
6. Enable logging
7. Deploy to Heroku/AWS/DigitalOcean

### Flutter
1. Update API baseUrl to production
2. Build release APK/IPA
3. Test on real devices
4. Submit to Play Store/App Store

## Support
For issues, check:
- Backend logs in terminal
- Flutter debug console
- MongoDB logs
- Network requests in browser DevTools
