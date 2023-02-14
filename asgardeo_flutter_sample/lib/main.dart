import 'package:flutter/material.dart';
import 'dart:convert';

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
  late String? _dateOfBirth;
  late String? _country;
  late String? _mobile;
  late String? _photo;

  @override
  void initState() {
    super.initState();
    _pageIndex = 1;
    _isUserLoggedIn = false;
    _firstName = 'Anne';
    _lastName = 'Mayer';
    _dateOfBirth = '2000-01-01';
    _country = 'Sri Lanka';
    _mobile = '+94716060400';
    _photo =
        'https://4192879.fs1.hubspotusercontent-na1.net/hub/4192879/hubfs/5cb5f901f929104729adbb8e_shutterstock_1152936797.jpg?width=944&height=590&name=5cb5f901f929104729adbb8e_shutterstock_1152936797.jpg';
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
                    ? ProfilePage(_firstName, _lastName, _dateOfBirth, _country,
                        _mobile, _photo, setPageIndex)
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
    setState(() {
      _isUserLoggedIn = true;
      _pageIndex = 2;
    });
  }

  Future<void> retrieveUserDetails() async {
    setState(() {
      _pageIndex = 3;
    });
  }

  void logOutFunction() async {
    setState(() {
      _isUserLoggedIn = false;
      _pageIndex = 1;
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
            child: Text('View profile'),
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
  final dateOdBirth;
  final country;
  final mobile;
  final photo;
  final pageIndex;

  const ProfilePage(this.firstName, this.LastName, this.dateOdBirth,
      this.country, this.mobile, this.photo, this.pageIndex);

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
              border: Border.all(color: Colors.blue, width: 3.0),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(photo ?? ''),
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
                    SizedBox(height: 15),
                    Text('First Name: $firstName',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text('Last Name: $LastName',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text('Date of Birth: $dateOdBirth',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text('Mobile: $mobile', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text('Country: $country', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
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
