import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Asgardeo Flutter Integration',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var isLoggedIn = false;
  var pageIndex = 0;

  void logIn() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logOut() {
    isLoggedIn = false;
    notifyListeners();
  }

  void changePageIndex(page) {
    pageIndex = page;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Authentication Sample'),
      ),
      body: appState.isLoggedIn
          ? (appState.pageIndex == 1 ? HomePage() : ProfilePage())
          : LogInPage(),
    );
  }
}

class LogInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: ElevatedButton(
        onPressed: () {
          appState.logIn();
          appState.changePageIndex(1);
        },
        child: Text('Sign In'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome!", style: TextStyle(fontSize: 35)),
          SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              appState.changePageIndex(2);
            },
            child: Text('View Profile'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              appState.logOut();
              appState.changePageIndex(0);
            },
            child: Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Profile Information", style: TextStyle(fontSize: 30)),
          SizedBox(height: 50),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 4.0),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://media.istockphoto.com/id/639454418/photo/close-up-of-beagle-against-gray-background.jpg?s=1024x1024&w=is&k=20&c=UYhYASTsGtLC6SSWG8FdUICt6bf9nZPh6IPOLzZh3P0=' ??
                        ''),
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text('First Name: John', style: TextStyle(fontSize: 20)),
                    Text('Last Name: Mayer', style: TextStyle(fontSize: 20)),
                    Text('Age: 20', style: TextStyle(fontSize: 20)),
                    Text('Mobile: +1717552749', style: TextStyle(fontSize: 20)),
                    Text('Country: USA', style: TextStyle(fontSize: 20)),
                  ],
                ),
              )),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              appState.changePageIndex(1);
            },
            child: Text('Back to home'),
          ),
        ],
      ),
    );
  }
}
