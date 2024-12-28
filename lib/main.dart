import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
// For the future, adjust the path if the file is in subfolders
import 'account_popup.dart';
import './utils/database_heper.dart';
import './models/account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blur Vault',
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
  late Future<List<Account>> _accountsFuture;

  final int passwordLength = 12;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    _accountsFuture =
        DatabaseHelper().getAccounts(); // Lazy initialization happens here
  }

  void _refreshAccounts() {
    setState(() {
      _loadAccounts(); // Reload accounts when needed
    });
  }

  //TODO: Move this to a centric ina specific folder.
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
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  // invisiable overlay
                  Positioned.fill(child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: password));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            //TODO: Implement localization
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blur Vault'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAccountPopup();
            },
          ),
          IconButton(onPressed: _generatePassword, icon: Icon(Icons.vpn_key))
        ],
      ),
      body: FutureBuilder<List<Account>>(
        future: _accountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading accounts: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No accounts found.'));
          }

          final accounts = snapshot.data!;
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                title: Text(account.name),
                subtitle: Text(account.dateAdded),
                onTap: () {
                  _showAccountPopup(account: account);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showAccountPopup({Account? account}) {
    showDialog(
      context: context,
      builder: (context) {
        return AccountPopup(
          initialName: account?.name,
          initialPassword: account?.password,
          onSave: (name, password) async {
            if (account == null) {
              // Add new account
              await DatabaseHelper().insertAccount(
                Account(
                  name: name,
                  password: password,
                  dateAdded: DateTime.now().toIso8601String(),
                ),
              );
            } else {
              // Update existing account
              await DatabaseHelper().updateAccount(
                Account(
                  id: account.id,
                  name: name,
                  password: password,
                  dateAdded: account.dateAdded, // Preserve original date
                ),
              );
            }
            _refreshAccounts();
          },
        );
      },
    );
  }
}
