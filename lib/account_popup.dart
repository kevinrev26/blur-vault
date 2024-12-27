import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class AccountPopup extends StatefulWidget {
  final String? initialName;
  final String? initialPassword;
  final Function(String name, String password) onSave;

  const AccountPopup({
    Key? key,
    this.initialName,
    this.initialPassword,
    required this.onSave,
  }) : super(key: key);

  @override
  _AccountPopupState createState() => _AccountPopupState();
}

class _AccountPopupState extends State<AccountPopup> {
  late TextEditingController _nameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _passwordController =
        TextEditingController(text: widget.initialPassword ?? '');
  }

  void _generateRandomPassword() {
    const chars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+";
    final random = Random();
    final password =
        List.generate(12, (index) => chars[random.nextInt(chars.length)])
            .join();
    setState(() {
      _passwordController.text = password;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Add Account' : 'Edit Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Account Name'),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.copy, color: Colors.grey),
                      onPressed: () =>
                          _copyToClipboard(_passwordController.text),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _generateRandomPassword,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_nameController.text, _passwordController.text);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
