# 🛍️ E-Commerce Full Stack App

Complete e-commerce application built with **Flutter**, **Node.js**, **Express**, and **MongoDB**.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)
![MongoDB](https://img.shields.io/badge/MongoDB-5.0+-brightgreen.svg)

## ✨ Features

### 🎨 Frontend (Flutter)
- ✅ Beautiful splash/onboarding screens
- ✅ Complete authentication flow (Sign In, Sign Up, Forgot Password)
- ✅ Social login UI (Google, Apple, Facebook)
- ✅ Product catalog with category filters
- ✅ Product search functionality
- ✅ Product detail pages
- ✅ Shopping cart management
- ✅ Complete checkout flow
- ✅ **Multiple Payment Methods** (Credit/Debit Card, PayPal, Apple Pay, Google Pay, Bank Transfer, Cash on Delivery)
- ✅ Order history and tracking
- ✅ User profile management
- ✅ Bottom navigation
- ✅ Drawer menu
- ✅ **Admin Dashboard** with full management capabilities

### 🔧 Backend (Node.js/Express)
- ✅ RESTful API architecture
- ✅ JWT authentication
- ✅ User management
- ✅ Product CRUD operations
- ✅ Shopping cart system
- ✅ Order processing
- ✅ **Payment Processing** with multiple payment gateways
- ✅ Category filtering
- ✅ Product search
- ✅ Secure password hashing
- ✅ Error handling middleware
- ✅ **Admin API** with role-based access control

### 🔒 Security
- ✅ JWT token authentication
- ✅ bcrypt password hashing
- ✅ Secure token storage (flutter_secure_storage)
- ✅ HTTPS images from Unsplash
- ✅ Input validation
- ✅ Protected API routes

## 🚀 Quick Start

**New to the project?** → [START_HERE.md](START_HERE.md) - Get admin dashboard running in 5 minutes!

**Regular setup:** → [QUICKSTART.md](QUICKSTART.md) - Standard 5-minute setup guide

### Backend
```bash
cd backend
npm install
npm run setup    # Creates test user + seeds products
npm run dev      # Start server on port 3000
```

**Test Credentials:**
- Email: `test@example.com`
- Password: `password123`

**Quick Admin Setup (Recommended):**
```bash
npm run setup-admin  # Creates admin, test user, products & orders
```

**Or Create Admin Only:**
```bash
npm run create-admin                                    # Default admin
npm run create-admin admin@example.com admin123 "Admin" # Custom admin
```

See [QUICK_ADMIN_START.md](QUICK_ADMIN_START.md) for complete admin setup.

### Flutter
```bash
flutter pub get
flutter run
```

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Get started in 5 minutes
- **[QUICK_ADMIN_START.md](QUICK_ADMIN_START.md)** - ⚡ Admin dashboard in 3 commands
- **[ADMIN_SETUP.md](ADMIN_SETUP.md)** - Complete admin setup guide
- **[ADMIN_GUIDE.md](ADMIN_GUIDE.md)** - Admin features documentation
- **[SETUP.md](SETUP.md)** - Complete setup and deployment guide
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Architecture and code organization
- **[test_api.http](test_api.http)** - API endpoint testing
- **[test_admin_api.http](test_admin_api.http)** - Admin API testing

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter, Provider (State Management) |
| **Backend** | Node.js, Express.js |
| **Database** | MongoDB |
| **Authentication** | JWT, bcrypt |
| **Storage** | flutter_secure_storage |
| **Images** | Unsplash (HTTPS) |
| **HTTP Client** | http package |

## 📱 Screenshots

The app includes:
- 3 onboarding/splash screens
- Sign In / Sign Up / Forgot Password screens
- Home screen with product grid
- Category filters
- Search functionality
- Product details
- Shopping cart
- Checkout flow
- Order success screen
- Order history
- User profile

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/forgot-password` - Password reset

### Products
- `GET /api/products` - Get all products
- `GET /api/products?category=Electronics` - Filter by category
- `GET /api/products?search=phone` - Search products
- `GET /api/products/:id` - Get product details

### Cart
- `GET /api/cart` - Get user cart
- `POST /api/cart/add` - Add item to cart
- `DELETE /api/cart/remove/:productId` - Remove item

### Orders
- `GET /api/orders` - Get user orders
- `POST /api/orders` - Create new order
- `GET /api/orders/:id` - Get order details

### User
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update profile

### Admin (Protected)
- `GET /api/admin/stats` - Get dashboard statistics
- `POST /api/admin/products` - Create product
- `PUT /api/admin/products/:id` - Update product
- `DELETE /api/admin/products/:id` - Delete product
- `GET /api/admin/orders` - Get all orders
- `PUT /api/admin/orders/:id/status` - Update order status
- `GET /api/admin/users` - Get all users
- `PUT /api/admin/users/:id/admin` - Toggle admin status

## 🌐 Configuration

### Backend API URL
Edit `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://YOUR_IP:3000/api';
```

- **Android Emulator**: `http://10.0.2.2:3000/api`
- **iOS Simulator**: `http://localhost:3000/api`
- **Physical Device**: `http://YOUR_COMPUTER_IP:3000/api`

### Environment Variables
Create `backend/.env`:
```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/ecommerce
JWT_SECRET=your_secret_key_here
JWT_EXPIRE=7d
```

## 📦 Project Structure

```
├── backend/              # Node.js/Express backend
│   ├── config/          # Database configuration
│   ├── middleware/      # Auth & error handling
│   ├── models/          # MongoDB schemas
│   ├── routes/          # API routes
│   ├── scripts/         # Setup scripts
│   └── utils/           # Utilities & seed data
├── lib/                 # Flutter application
│   ├── models/          # Data models
│   ├── providers/       # State management
│   ├── screens/         # UI screens
│   ├── services/        # API services
│   ├── theme/           # App theme
│   └── widgets/         # Reusable widgets
└── docs/                # Documentation
```

## 🧪 Testing

Use the included `test_api.http` file with REST Client extension in VS Code to test all API endpoints.

## 🚢 Deployment

### Backend
- Deploy to Heroku, AWS, DigitalOcean, or Railway
- Use MongoDB Atlas for database
- Set environment variables
- Enable HTTPS

### Flutter
- Update API baseUrl to production URL
- Build release APK/IPA
- Test on real devices
- Submit to Play Store/App Store

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 🆘 Support

For issues and questions:
1. Check [SETUP.md](SETUP.md) for detailed troubleshooting
2. Review [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for architecture details
3. Test API endpoints using [test_api.http](test_api.http)

## 🎯 Roadmap

- [ ] Payment gateway integration
- [ ] Push notifications
- [ ] Wishlist functionality
- [ ] Product reviews and ratings
- [x] Admin dashboard
- [ ] Real-time order tracking
- [ ] Multiple payment methods
- [ ] Coupon/discount system

---

Made with ❤️ using Flutter and Node.js
