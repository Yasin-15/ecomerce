# E-Commerce Backend

## Setup

1. Install dependencies:
```bash
cd backend
npm install
```

2. Create `.env` file:
```bash
copy .env.example .env
```

3. Update `.env` with your MongoDB URI and JWT secret

4. Start MongoDB (if local)

5. Run the server:
```bash
npm run dev
```

6. Seed products (optional):
```bash
POST http://localhost:3000/api/products/seed
```

## API Endpoints

### Auth
- POST `/api/auth/register` - Register user
- POST `/api/auth/login` - Login user
- POST `/api/auth/forgot-password` - Forgot password

### Products
- GET `/api/products` - Get all products
- GET `/api/products/:id` - Get product by ID

### Cart
- GET `/api/cart` - Get user cart
- POST `/api/cart/add` - Add to cart
- DELETE `/api/cart/remove/:productId` - Remove from cart

### Orders
- GET `/api/orders` - Get user orders
- POST `/api/orders` - Create order
- GET `/api/orders/:id` - Get order by ID
