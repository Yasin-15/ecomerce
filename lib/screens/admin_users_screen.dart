import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _apiService.getAdminUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleAdminStatus(String userId, bool isAdmin) async {
    try {
      await _apiService.updateUserAdminStatus(userId, isAdmin);
      _loadUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAdmin ? 'User granted admin access' : 'Admin access revoked',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: _users.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        final isAdmin = user['isAdmin'] ?? false;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user['avatar'] != null
                                  ? NetworkImage(user['avatar'])
                                  : null,
                              child: user['avatar'] == null
                                  ? Text(user['name']?[0] ?? 'U')
                                  : null,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(user['name'] ?? 'Unknown'),
                                ),
                                if (isAdmin)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'ADMIN',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['email'] ?? ''),
                                if (user['phone'] != null)
                                  Text('Phone: ${user['phone']}'),
                                Text(
                                  'Joined: ${_formatDate(user['createdAt'])}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Switch(
                              value: isAdmin,
                              onChanged: (value) {
                                _showConfirmDialog(
                                  user['_id'],
                                  value,
                                  user['name'],
                                );
                              },
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  void _showConfirmDialog(String userId, bool makeAdmin, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(makeAdmin ? 'Grant Admin Access' : 'Revoke Admin Access'),
        content: Text(
          makeAdmin
              ? 'Are you sure you want to grant admin access to $userName?'
              : 'Are you sure you want to revoke admin access from $userName?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _toggleAdminStatus(userId, makeAdmin);
            },
            child: Text(
              'Confirm',
              style: TextStyle(color: makeAdmin ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}
