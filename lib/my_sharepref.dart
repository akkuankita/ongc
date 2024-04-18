import 'package:shared_preferences/shared_preferences.dart';

MySharePreference sharedPref = MySharePreference();

class MySharePreference {
  late SharedPreferences _pref;
  final String _login = 'login';
  final String _token = 'api_token';
  final String _name ='name';
  final String _email ='email';
  final String _mobile='mobile';
  final String _photo='photo';

 Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  /* ------clear------ */
   Future clear() => _pref.clear();

  /* ------login------ */
  setLogin(bool value) => _pref.setBool(_login, value);
  bool getLogin() => _pref.getBool(_login) ?? false;
  

  /* ------token------ */
  setToken(String value) => _pref.setString(_token, value);
  String getToken() => _pref.getString(_token) ?? '';


  /* ------name------ */
  setName(String value) => _pref.setString(_name, value);
  String getName() => _pref.getString(_name) ?? '';


  /* ------email------ */
  setEmail(String value) => _pref.setString(_email, value);
  String getEmail() => _pref.getString(_email) ?? '';


  /* ------mobile------ */
  setMobile(String value) => _pref.setString(_mobile, value);
  String getMobile() => _pref.getString(_mobile) ?? '';


  /* ------photo------ */
  setPhoto(String value) => _pref.setString(_photo, value);
  String getPhoto() => _pref.getString(_photo) ?? '';

//--------------save login data-----------------
  saveLoginData(Map<String, dynamic> data) {
    setLogin(true);
    setToken(data['api_token'] ?? "");
    setName(data['name'] ?? "");
    setEmail(data['email']);
    setMobile(data['mobile']);
    setPhoto(data['photo']);
  }
}
 