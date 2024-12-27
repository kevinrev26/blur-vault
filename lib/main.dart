import 'package:flutter/material.dart';

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

  void _addAccount() {
    // Navigate to Add Account screen
    // TODO: Implement navigation to View 3
    print("Add Account button pressed");
  }

  void _generatePassword() {
    // Open password generator popup
    // TODO: Implement password generator popup
    print("Generate Password button pressed");
  }

  void _showAccountDetails(Map<String, String> account) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(account['name']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Date Added: ${account['dateAdded']}'),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    account['password'] =
                        'actual_password'; // Replace with actual password
                  });
                },
                child: Text(
                  account['password']!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to edit screen
                  print("Edit Account button pressed");
                },
                child: Text('Edit'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
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
