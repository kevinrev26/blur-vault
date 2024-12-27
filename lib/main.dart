import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
// For the future, adjust the path if the file is in subfolders
import 'account_popup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Sample list of accounts (replace with your data source)
  List<Map<String, String>> accounts = [
    {'name': 'Google', 'password': '******', 'dateAdded': '2023-12-20'},
    {'name': 'Facebook', 'password': '******', 'dateAdded': '2023-12-22'},
  ];

  final int passwordLength = 12;

  void _addAccount() {
    showDialog(
        context: context,
        builder: (context) {
          return AccountPopup(onSave: (name, password) {
            setState(() {
              accounts.add({
                'name': name,
                'password': password,
                'dateAdded': DateTime.now().toString()
              });
            });
          });
        });
  }

  String _generateRandomPassword(int length) {
    const chars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+";
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  void _generatePassword() {
    final password = _generateRandomPassword(passwordLength);
    showDialog(
        context: context,
        builder: (contentx) {
          return AlertDialog(
              title: Text('Generated Password'),
              content: Stack(
                children: [
                  // the password displayed for selection
                  SelectableText(
                    password,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  // invisiable overlay
                  Positioned.fill(child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: password));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Passowrd copied to clipboard!')),
                      );
                    },
                  )),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'))
              ]);
        });
  }

  void _showAccountDetails(Map<String, String> account) {
    showDialog(
      context: context,
      builder: (context) {
        return AccountPopup(
          initialName: account['name'],
          initialPassword: account['password'],
          onSave: (name, password) {
            setState(() {
              account['name'] = name;
              account['password'] = password;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blur Vault'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addAccount,
          ),
          IconButton(
            icon: Icon(Icons.key),
            onPressed: _generatePassword,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return ListTile(
            title: Text(account['name']!),
            subtitle: Text('Added: ${account['dateAdded']}'),
            onTap: () => _showAccountDetails(account),
          );
        },
      ),
    );
  }
}
