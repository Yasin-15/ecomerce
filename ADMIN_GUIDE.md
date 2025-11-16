# 👨‍💼 Admin Dashboard Guide

Complete guide for the admin dashboard functionality in the e-commerce app.

## 🎯 Overview

The admin dashboard provides a comprehensive interface for managing:
- **Products** - Create, update, and delete products
- **Orders** - View and manage order statuses
- **Users** - Manage user accounts and admin privileges
- **Statistics** - View key business metrics

## 🔐 Admin Access

### Creating an Admin User

#### Method 1: Using the Script (Recommended)
```bash
cd backend

# Create default admin (admin@example.com / admin123)
npm run create-admin

# Create custom admin
npm run create-admin your@email.com yourpassword "Your Name"
```

#### Method 2: Manual Database Update
```javascript
// Connect to MongoDB and run:
db.users.updateOne(
  { email: "user@example.com" },
  { $set: { isAdmin: true } }
)
```

### Accessing the Dashboard

1. **Login** with admin credentials
2. Navigate to **Profile** screen
3. Tap on **Admin Dashboard** (purple button at top)
4. Access all admin features

## 📊 Dashboard Features

### 1. Statistics Overview

The main dashboard displays:
- **Total Products** - Number of products in catalog
- **Total Orders** - All orders placed
- **Total Users** - Registered users
- **Total Revenue** - Sum of all completed orders
- **Recent Orders** - Last 5 orders with quick view

### 2. Product Management

**Access:** Admin Dashboard → Manage Products

#### Create Product
1. Tap the **+** floating action button
2. Fill in product details:
   - Name
   - Description
   - Price
   - Stock quantity
   - Category
   - Image URL
3. Tap **Save**

#### Edit Product
1. Find the product in the list
2. Tap the **edit** icon
3. Modify details
4. Tap **Save**

#### Delete Product
1. Find the product in the list
2. Tap the **delete** icon
3. Confirm deletion

**Features:**
- Real-time product list
- Pull to refresh
- Product images preview
- Stock level display
- Quick edit/delete actions

### 3. Order Management

**Access:** Admin Dashboard → Manage Orders

#### View Orders
- See all orders from all users
- Expandable cards show order details
- View customer information
- See order items and totals

#### Update Order Status
1. Tap on an order to expand
2. Select new status from chips:
   - **Pending** - Order placed, awaiting processing
   - **Processing** - Order being prepared
   - **Shipped** - Order dispatched
   - **Delivered** - Order completed
   - **Cancelled** - Order cancelled

**Features:**
- Color-coded status indicators
- Customer details
- Order items breakdown
- Total amount display
- One-tap status updates

### 4. User Management

**Access:** Admin Dashboard → Manage Users

#### View Users
- List of all registered users
- User details (name, email, phone)
- Join date
- Admin status indicator

#### Grant/Revoke Admin Access
1. Find the user in the list
2. Toggle the **admin switch**
3. Confirm the action

**Features:**
- User avatars
- Admin badge display
- Quick admin toggle
- Confirmation dialogs
- User registration date

## 🔒 Security

### Role-Based Access Control
- All admin routes require authentication
- Admin middleware verifies `isAdmin` flag
- Non-admin users receive 403 Forbidden
- JWT tokens required for all requests

### Backend Protection
```javascript
// Admin routes are protected
router.get('/admin/stats', adminAuth, async (req, res) => {
  // Only accessible by admin users
});
```

### Frontend Access Control
```dart
// Admin button only visible to admins
if (user?['isAdmin'] == true)
  _buildMenuItem(
    context,
    icon: Icons.admin_panel_settings,
    title: 'Admin Dashboard',
    onTap: () => Navigator.pushNamed(context, '/admin'),
  ),
```

## 📡 API Endpoints

### Dashboard Stats
```http
GET /api/admin/stats
Authorization: Bearer {token}
```

**Response:**
```json
{
  "totalProducts": 50,
  "totalOrders": 120,
  "totalUsers": 85,
  "totalRevenue": 15420.50,
  "recentOrders": [...]
}
```

### Product Management
```http
POST /api/admin/products
PUT /api/admin/products/:id
DELETE /api/admin/products/:id
Authorization: Bearer {token}
```

### Order Management
```http
GET /api/admin/orders
PUT /api/admin/orders/:id/status
Authorization: Bearer {token}
```

### User Management
```http
GET /api/admin/users
PUT /api/admin/users/:id/admin
Authorization: Bearer {token}
```

## 🎨 UI Features

### Color Coding
- **Admin elements** - Purple theme
- **Order statuses:**
  - Pending - Orange
  - Processing - Blue
  - Shipped - Purple
  - Delivered - Green
  - Cancelled - Red

### Navigation
- Quick action buttons on dashboard
- Back navigation to return to profile
- Refresh functionality on all screens
- Pull-to-refresh support

### Responsive Design
- Grid layout for statistics
- Scrollable lists
- Expandable order cards
- Dialog forms for editing

## 🔧 Customization

### Adding New Admin Features

1. **Backend Route** (`backend/routes/admin.js`):
```javascript
router.get('/new-feature', adminAuth, async (req, res) => {
  // Your logic here
});
```

2. **API Service** (`lib/services/api_service.dart`):
```dart
Future<dynamic> getNewFeature() async {
  final response = await http.get(
    Uri.parse('$baseUrl/admin/new-feature'),
    headers: await getHeaders(),
  );
  return _handleResponse(response);
}
```

3. **Flutter Screen** (`lib/screens/admin_new_feature_screen.dart`):
```dart
class AdminNewFeatureScreen extends StatefulWidget {
  // Your screen implementation
}
```

4. **Add Route** (`lib/main.dart`):
```dart
'/admin/new-feature': (context) => const AdminNewFeatureScreen(),
```

## 🐛 Troubleshooting

### "Access denied. Admin only."
- Ensure user has `isAdmin: true` in database
- Check JWT token is valid
- Verify admin middleware is working

### Admin button not showing
- Confirm user object has `isAdmin` field
- Check auth provider stores user data
- Verify login response includes `isAdmin`

### Cannot create/edit products
- Check MongoDB connection
- Verify product schema matches data
- Ensure all required fields are provided

## 📱 Screenshots Flow

1. **Profile Screen** - Admin Dashboard button (purple)
2. **Admin Dashboard** - Statistics grid + quick actions
3. **Manage Products** - Product list with edit/delete
4. **Manage Orders** - Expandable order cards
5. **Manage Users** - User list with admin toggle

## 🚀 Best Practices

1. **Always confirm destructive actions** (delete, revoke admin)
2. **Use pull-to-refresh** to get latest data
3. **Check order details** before updating status
4. **Verify product data** before saving
5. **Monitor statistics** regularly for insights

## 📈 Future Enhancements

- [ ] Analytics dashboard with charts
- [ ] Bulk product import/export
- [ ] Advanced order filtering
- [ ] Email notifications for status changes
- [ ] Product inventory alerts
- [ ] Sales reports and analytics
- [ ] Customer support chat
- [ ] Refund management

---

**Need Help?** Check the main [README.md](README.md) or [SETUP.md](SETUP.md) for general setup instructions.
