# 🚀 Admin Dashboard Setup Guide

Quick guide to get your admin dashboard up and running.

## Step 1: Start the Backend

```bash
cd backend
npm install
npm run dev
```

The server should start on `http://localhost:3000`

## Step 2: Create Admin User

In a new terminal (keep the server running):

```bash
cd backend

# Option 1: Create default admin
npm run create-admin

# Option 2: Create custom admin
npm run create-admin your@email.com yourpassword "Your Name"
```

**Default Admin Credentials:**
- Email: `admin@example.com`
- Password: `admin123`

## Step 3: Seed Sample Data (Optional)

To have products and test data:

```bash
cd backend
npm run setup
```

This creates:
- Test user: `test@example.com` / `password123`
- 8 sample products across categories

## Step 4: Create Test Orders

To see revenue and orders in the admin dashboard, you need to create some orders:

### Option A: Using the Flutter App
1. Run the Flutter app
2. Login as test user (`test@example.com` / `password123`)
3. Add products to cart
4. Complete checkout
5. Repeat a few times

### Option B: Using API (Quick Method)

Use the REST Client extension in VS Code with `test_api.http`:

```http
### 1. Login as test user
POST http://localhost:3000/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123"
}

### 2. Get products
GET http://localhost:3000/api/products

### 3. Add to cart (use product IDs from step 2)
POST http://localhost:3000/api/cart/add
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: application/json

{
  "productId": "PRODUCT_ID_HERE",
  "quantity": 2
}

### 4. Create order
POST http://localhost:3000/api/orders
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: application/json

{
  "shippingAddress": "123 Test St, City, Country",
  "paymentMethod": "Credit Card"
}
```

## Step 5: Run Flutter App

```bash
flutter pub get
flutter run
```

## Step 6: Access Admin Dashboard

1. **Login as admin** using the credentials from Step 2
2. Go to **Profile** tab (bottom navigation)
3. Tap **Admin Dashboard** (purple button at top)
4. You should see:
   - Total Products
   - Total Orders
   - Total Users
   - Total Revenue
   - Recent Orders

## Troubleshooting

### Issue: "Access denied. Admin only"
**Solution:** Make sure you're logged in with an admin account. Check the database:

```javascript
// In MongoDB shell or Compass
db.users.find({ email: "admin@example.com" })
// Should show: isAdmin: true
```

### Issue: Revenue shows $0.00
**Solution:** You need to create some orders first (see Step 4)

### Issue: Admin button not showing in Profile
**Solution:** 
1. Logout and login again
2. Make sure the user has `isAdmin: true` in database
3. Check that the auth response includes `isAdmin` field

### Issue: Cannot connect to backend
**Solution:**
1. Make sure backend is running on port 3000
2. Update API URL in `lib/services/api_service.dart`:
   - Android Emulator: `http://10.0.2.2:3000/api`
   - iOS Simulator: `http://localhost:3000/api`
   - Physical Device: `http://YOUR_COMPUTER_IP:3000/api`

### Issue: MongoDB connection error
**Solution:**
1. Make sure MongoDB is running
2. Check `.env` file has correct `MONGODB_URI`
3. Default: `mongodb://localhost:27017/ecommerce`

## Quick Test Checklist

- [ ] Backend server running
- [ ] MongoDB connected
- [ ] Admin user created
- [ ] Sample products seeded
- [ ] Test orders created
- [ ] Flutter app running
- [ ] Logged in as admin
- [ ] Admin Dashboard accessible
- [ ] Can view statistics
- [ ] Can manage products
- [ ] Can manage orders
- [ ] Can manage users

## Admin Features Overview

### 📊 Dashboard
- View key metrics
- See recent orders
- Quick action buttons

### 📦 Product Management
- Create new products
- Edit existing products
- Delete products
- View stock levels

### 🛍️ Order Management
- View all orders
- Update order status
- See customer details
- View order items

### 👥 User Management
- View all users
- Grant admin access
- Revoke admin access
- See user details

## Next Steps

1. **Create more test data** to see the dashboard in action
2. **Test all admin features** (create, edit, delete)
3. **Try order status updates** (pending → processing → shipped → delivered)
4. **Grant admin access** to another user to test permissions

## Useful Commands

```bash
# Backend
npm run dev              # Start development server
npm run create-admin     # Create admin user
npm run setup           # Seed database

# Flutter
flutter run             # Run app
flutter clean           # Clean build
flutter pub get         # Install dependencies

# MongoDB (if using local)
mongod                  # Start MongoDB
mongo                   # Open MongoDB shell
```

## API Testing

Use `test_admin_api.http` to test all admin endpoints:

1. Login as admin to get token
2. Replace `{{token}}` with your actual token
3. Test each endpoint
4. Verify responses

## Security Notes

⚠️ **Important:**
- Change default admin password in production
- Use strong passwords
- Keep JWT_SECRET secure
- Enable HTTPS in production
- Regularly audit admin users

## Need Help?

- Check [ADMIN_GUIDE.md](ADMIN_GUIDE.md) for detailed feature documentation
- Review [README.md](README.md) for general setup
- See [SETUP.md](SETUP.md) for complete deployment guide

---

**Ready to go!** Follow these steps and your admin dashboard will be fully functional. 🎉
