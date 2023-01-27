import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

final FlutterAppAuth flutterAppAuth = FlutterAppAuth();

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
  late String? _idToken;
  late String? _accessToken;
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
    _idToken = '';
    _accessToken = '';
    _firstName = '';
    _lastName = '';
    _dateOfBirth = '';
    _country = '';
    _mobile = '';
    _photo = '';
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
    try {
      final AuthorizationTokenResponse? result =
          await flutterAppAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          discoveryUrl: discoveryUrl,
          scopes: ['openid', 'profile'],
        ),
      );

      final idTokenParsed = parseIdToken(result?.idToken);
      setState(() {
        _isUserLoggedIn = true;
        _idToken = result?.idToken;
        _accessToken = result?.accessToken;
        _pageIndex = 2;
      });
    } catch (e, s) {
      print('Error while login to the system: $e - stack: $s');
      setState(() {
        _isUserLoggedIn = false;
      });
    }
  }

  Map<String, dynamic> parseIdToken(String? idToken) {
    final parts = idToken?.split(r'.');
    assert(parts?.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts![1]))));
  }

  Future<void> retrieveUserDetails() async {
    final userInfoResponse = await http.get(
      userInfoEndpoint,
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (userInfoResponse.statusCode == 200) {
      var profile = jsonDecode(userInfoResponse.body);
      setState(() {
        _firstName = profile['given_name'];
        _lastName = profile['family_name'];
        _dateOfBirth = profile['birthdate'];
        _country = profile['address']['country'];
        _mobile = profile['phone_number'];
        _photo = profile['picture'];
        _pageIndex = 3;
      });
    } else {
      throw Exception('Failed to get user profile information');
    }
  }

  void logOutFunction() async {
    try {
      final EndSessionResponse? result = await flutterAppAuth.endSession(
        EndSessionRequest(
          idTokenHint: _idToken,
          postLogoutRedirectUrl: redirectUrl,
          discoveryUrl: discoveryUrl,
        ),
      );

      setState(() {
        _isUserLoggedIn = false;
        _pageIndex = 1;
      });
    } catch (e, s) {
      print('Error while logout from the system: $e - stack: $s');
    }
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

  const ProfilePage(this.firstName, this.LastName, this.dateOdBirth, this.country,
      this.mobile, this.photo, this.pageIndex);

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
                image: NetworkImage(
                    photo ??
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
                    SizedBox(height: 15),
                    Text('First Name: $firstName',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text('Last Name: $LastName',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text('Date of Birth: $dateOdBirth', style: TextStyle(fontSize: 20)),
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
