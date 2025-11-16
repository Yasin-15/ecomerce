# Project Structure

## Backend (Node.js/Express/MongoDB)

```
backend/
├── config/
│   └── db.js                 # Database connection
├── middleware/
│   ├── auth.js              # JWT authentication middleware
│   └── errorHandler.js      # Global error handler
├── models/
│   ├── User.js              # User schema
│   ├── Product.js           # Product schema
│   ├── Cart.js              # Cart schema
│   └── Order.js             # Order schema
├── routes/
│   ├── auth.js              # Authentication routes
│   ├── products.js          # Product routes
│   ├── cart.js              # Cart routes
│   ├── orders.js            # Order routes
│   └── users.js             # User profile routes
├── scripts/
│   └── setup.js             # Database setup script
├── utils/
│   └── seedData.js          # Sample product data
├── .env.example             # Environment variables template
├── .gitignore
├── package.json
├── README.md
└── server.js                # Main server file
```

## Frontend (Flutter)

```
lib/
├── models/
│   ├── product.dart         # Product model
│   └── user.dart            # User model
├── providers/
│   ├── auth_provider.dart   # Authentication state
│   ├── cart_provider.dart   # Cart state
│   └── product_provider.dart # Product state
├── screens/
│   ├── splash_screen.dart   # Onboarding screens
│   ├── signin_screen.dart   # Sign in
│   ├── signup_screen.dart   # Sign up
│   ├── forgot_password_screen.dart
│   ├── main_screen.dart     # Bottom nav container
│   ├── home_screen.dart     # Product listing
│   ├── search_screen.dart   # Product search
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart     # Shopping cart
│   ├── checkout_screen.dart # Checkout flow
│   ├── orders_screen.dart   # Order history
│   ├── order_success_screen.dart
│   └── profile_screen.dart  # User profile
├── services/
│   └── api_service.dart     # API client
├── theme/
│   └── app_theme.dart       # App theme
├── utils/
│   └── constants.dart       # App constants
├── widgets/
│   ├── bottom_nav_bar.dart  # Bottom navigation
│   └── category_chip.dart   # Category filter chip
└── main.dart                # App entry point
```

## Key Features by File

### Backend

**server.js**
- Express app setup
- Middleware configuration
- Route mounting
- Error handling

**models/User.js**
- User schema with password hashing
- Email validation
- Password comparison method

**models/Product.js**
- Product schema
- Category and stock management
- Rating system

**routes/auth.js**
- User registration
- Login with JWT
- Password reset

**routes/products.js**
- Get all products
- Filter by category
- Search functionality
- Product seeding

**routes/cart.js**
- Get user cart
- Add/remove items
- Update quantities
- Calculate totals

**routes/orders.js**
- Create orders
- Get order history
- Order status tracking

### Frontend

**main.dart**
- App initialization
- Provider setup
- Route configuration
- Theme setup

**providers/auth_provider.dart**
- User authentication state
- Login/logout logic
- Token management

**providers/cart_provider.dart**
- Cart state management
- Add/remove items
- Total calculation

**screens/splash_screen.dart**
- 3 onboarding pages
- Page indicators
- Navigation to sign in

**screens/signin_screen.dart**
- Email/password login
- Social login UI
- Form validation

**screens/home_screen.dart**
- Product grid
- Category filters
- Drawer navigation
- Add to cart

**screens/product_detail_screen.dart**
- Product images
- Description
- Quantity selector
- Add to cart

**screens/cart_screen.dart**
- Cart items list
- Remove items
- Total display
- Checkout button

**screens/checkout_screen.dart**
- Shipping address
- Payment method
- Order summary
- Place order

**services/api_service.dart**
- HTTP client
- Token management
- API endpoints
- Error handling

## Data Flow

### Authentication Flow
1. User enters credentials → `signin_screen.dart`
2. Calls `auth_provider.dart` → `login()`
3. Makes API request → `api_service.dart`
4. Backend validates → `routes/auth.js`
5. Returns JWT token
6. Token stored → `flutter_secure_storage`
7. Navigate to home

### Shopping Flow
1. Browse products → `home_screen.dart`
2. View details → `product_detail_screen.dart`
3. Add to cart → `cart_provider.dart`
4. API call → `routes/cart.js`
5. View cart → `cart_screen.dart`
6. Checkout → `checkout_screen.dart`
7. Create order → `routes/orders.js`
8. Success → `order_success_screen.dart`

## State Management

**Provider Pattern:**
- `AuthProvider` - User authentication state
- `CartProvider` - Shopping cart state
- `ProductProvider` - Product listing state

**Local Storage:**
- JWT tokens → `flutter_secure_storage`
- User preferences → `shared_preferences`

## API Communication

**Base URL:** `http://localhost:3000/api`

**Headers:**
- `Content-Type: application/json`
- `Authorization: Bearer <token>` (for protected routes)

**Response Format:**
```json
{
  "data": {},
  "message": "Success",
  "error": null
}
```

## Security

**Backend:**
- Password hashing with bcrypt
- JWT token authentication
- Protected routes with middleware
- Input validation
- CORS enabled

**Frontend:**
- Secure token storage
- HTTPS images only
- Input validation
- Error handling

## Database Schema

**Users Collection:**
- name, email, password (hashed)
- phone, address, avatar
- createdAt

**Products Collection:**
- name, description, price
- image, category, stock
- rating, reviews

**Carts Collection:**
- user (ref), items[], total
- updatedAt

**Orders Collection:**
- user (ref), items[]
- total, status
- shippingAddress, paymentMethod
- createdAt
