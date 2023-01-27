import 'package:flutter/material.dart';
import 'dart:convert';

const clientId = 'XGrwnd_G4VUEGDGcmjWG27E_3qwa';
const redirectUrl = 'wso2.asgardeo.sampleflutterapp://login-callback';
const discoveryUrl =
    'https://api.asgardeo.io/t/lakshia/oauth2/token/.well-known/openid-configuration';
const userInfoEndpoint = 'https://api.asgardeo.io/t/lakshia/oauth2/userinfo';
const issuerUrl = 'https://api.asgardeo.io/t/lakshia/oauth2/token';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  late int _pageIndex;
  late bool _isUserLoggedIn;
  late String? _firstName;
  late String? _lastName;
  late String? _age;
  late String? _country;
  late String? _mobile;

  @override
  void initState() {
    super.initState();
    _pageIndex = 1;
    _isUserLoggedIn = false;
    _firstName = 'John';
    _lastName = 'Mayer';
    _age = '20';
    _country = 'USA';
    _mobile = '+192765421';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asgardeo Flutter Integration',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Asgardeo Flutter Integration'),
        ),
        body: _isUserLoggedIn
            ? _pageIndex == 2
            ? HomePage(retrieveUserDetails, logOutFunction)
            : _pageIndex == 3
            ? ProfilePage(_firstName, _lastName, _age, _country,
            _mobile, setPageIndex)
            : LogInPage(loginFunction)
            : LogInPage(loginFunction),
      ),
    );
  }

  void setPageIndex(index) {
    setState(() {
      _pageIndex = index;
    });
  }

  Future<void> loginFunction() async {
    setPageIndex(2);
    setState(() {
      _isUserLoggedIn = true;
    });
  }

  Future<void> retrieveUserDetails() async {
    setPageIndex(3);
  }

  void logOutFunction() async {
    setPageIndex(1);
    setState(() {
      _isUserLoggedIn = false;
    });
  }
}

class LogInPage extends StatelessWidget {
  final loginFunction;

  const LogInPage(this.loginFunction);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          loginFunction();
          // appState.userLogin();
        },
        child: Text('Sign In'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final retriveProfileFunction;
  final logOutFunction;

  const HomePage(this.retriveProfileFunction, this.logOutFunction);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome!", style: TextStyle(fontSize: 35)),
          SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              retriveProfileFunction();
            },
            child: Text('View Profile'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              logOutFunction();
            },
            child: Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final firstName;
  final LastName;
  final age;
  final country;
  final mobile;
  final pageIndex;

  const ProfilePage(this.firstName, this.LastName, this.age, this.country,
      this.mobile, this.pageIndex);

  @override
  Widget build(BuildContext context) {
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
                    Text('First Name: $firstName',
                        style: TextStyle(fontSize: 20)),
                    Text('Last Name: $LastName',
                        style: TextStyle(fontSize: 20)),
                    Text('Age: $age', style: TextStyle(fontSize: 20)),
                    Text('Mobile: $mobile', style: TextStyle(fontSize: 20)),
                    Text('Country: $country', style: TextStyle(fontSize: 20)),
                  ],
                ),
              )),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              pageIndex(2);
            },
            child: Text('Back to home'),
          ),
        ],
      ),
    );
  }
}
