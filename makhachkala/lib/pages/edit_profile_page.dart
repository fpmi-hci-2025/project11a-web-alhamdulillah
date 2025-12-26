import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String userName;
  final String phone;
  final String email;
  final String defaultAddress;

  const EditProfilePage({
    super.key,
    required this.userName,
    required this.phone,
    required this.email,
    required this.defaultAddress,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _phoneController = TextEditingController(text: widget.phone);
    _emailController = TextEditingController(text: widget.email);
    _addressController = TextEditingController(text: widget.defaultAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Адрес по умолчанию',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Save changes
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

