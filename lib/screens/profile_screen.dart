import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                user?['avatar'] ?? 'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?['name'] ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?['email'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            if (user?['isAdmin'] == true)
              _buildMenuItem(
                context,
                icon: Icons.admin_panel_settings,
                title: 'Admin Dashboard',
                onTap: () => Navigator.pushNamed(context, '/admin'),
                isAdmin: true,
              ),
            _buildMenuItem(
              context,
              icon: Icons.shopping_bag,
              title: 'My Orders',
              onTap: () => Navigator.pushNamed(context, '/orders'),
            ),
            _buildMenuItem(
              context,
              icon: Icons.favorite,
              title: 'Wishlist',
              onTap: () => Navigator.pushNamed(context, '/wishlist'),
            ),
            _buildMenuItem(
              context,
              icon: Icons.location_on,
              title: 'Addresses',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.payment,
              title: 'Payment Methods',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/signin',
                    (route) => false,
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isAdmin = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isAdmin ? Colors.purple.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(icon, color: isAdmin ? Colors.purple : Colors.pink),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isAdmin ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
