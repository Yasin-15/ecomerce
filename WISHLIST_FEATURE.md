# Wishlist Feature

## Overview
The wishlist feature allows users to save products they're interested in for later viewing and purchasing.

## Backend Implementation

### Database Schema
- Added `wishlist` field to User model (array of Product ObjectIds)

### API Endpoints
All endpoints require authentication.

- `GET /api/wishlist` - Get user's wishlist
- `POST /api/wishlist/add/:productId` - Add product to wishlist
- `DELETE /api/wishlist/remove/:productId` - Remove product from wishlist
- `GET /api/wishlist/check/:productId` - Check if product is in wishlist

### Files Modified/Created
- `backend/models/User.js` - Added wishlist field
- `backend/routes/wishlist.js` - New wishlist routes
- `backend/server.js` - Registered wishlist routes

## Flutter Implementation

### Provider
- `lib/providers/wishlist_provider.dart` - Manages wishlist state

### Screens
- `lib/screens/wishlist_screen.dart` - Displays user's wishlist with options to:
  - View product details
  - Add items to cart
  - Remove items from wishlist

### Integration Points
- **Product Detail Screen**: Heart icon to add/remove from wishlist
- **Home Screen**: Wishlist icon in app bar and drawer menu
- **Profile Screen**: Wishlist menu item

### Files Modified/Created
- `lib/providers/wishlist_provider.dart` - New provider
- `lib/screens/wishlist_screen.dart` - New screen
- `lib/services/api_service.dart` - Added wishlist API methods
- `lib/main.dart` - Added WishlistProvider and route
- `lib/screens/product_detail_screen.dart` - Added wishlist toggle
- `lib/screens/home_screen.dart` - Added wishlist navigation
- `lib/screens/profile_screen.dart` - Added wishlist navigation

## Features
- ✅ Add/remove products from wishlist
- ✅ View all wishlist items
- ✅ Add wishlist items to cart
- ✅ Visual indicator on product detail page
- ✅ Quick access from home screen and profile
- ✅ Empty state UI

## Testing
Use `test_wishlist_api.http` to test the API endpoints.

## Usage
1. Browse products and tap the heart icon on product detail pages
2. Access wishlist from:
   - Home screen app bar (heart icon)
   - Home screen drawer menu
   - Profile screen menu
3. From wishlist screen, you can:
   - Tap items to view details
   - Add items to cart
   - Remove items from wishlist
