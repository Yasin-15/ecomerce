import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/main_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/order_success_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_products_screen.dart';
import 'screens/admin_orders_screen.dart';
import 'screens/admin_users_screen.dart';
import 'screens/payment_method_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          // Handle /product route with arguments
          if (settings.name == '/product') {
            final productId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ProductDetailScreen(productId: productId),
            );
          }

          // Handle /order-tracking route with arguments
          if (settings.name == '/order-tracking') {
            final orderId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => OrderTrackingScreen(orderId: orderId),
            );
          }

          // Handle /payment-method route with arguments
          if (settings.name == '/payment-method') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => PaymentMethodScreen(
                orderId: args['orderId'],
                totalAmount: args['totalAmount'],
              ),
            );
          }

          // Handle all other routes
          final routes = <String, WidgetBuilder>{
            '/': (context) => const SplashScreen(),
            '/signin': (context) => const SignInScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/home': (context) => const MainScreen(),
            '/cart': (context) => const CartScreen(),
            '/wishlist': (context) => const WishlistScreen(),
            '/checkout': (context) => const CheckoutScreen(),
            '/orders': (context) => const OrdersScreen(),
            '/order-success': (context) => const OrderSuccessScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/admin': (context) => const AdminDashboardScreen(),
            '/admin/products': (context) => const AdminProductsScreen(),
            '/admin/orders': (context) => const AdminOrdersScreen(),
            '/admin/users': (context) => const AdminUsersScreen(),
          };

          final builder = routes[settings.name];
          if (builder != null) {
            return MaterialPageRoute(builder: builder, settings: settings);
          }

          return null;
        },
      ),
    );
  }
}
