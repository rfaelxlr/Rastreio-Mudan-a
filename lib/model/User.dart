class User {
  String idUser;
  String _name;
  String _email;
  String _password;
  String _cod;

  User();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "email": this.email,
      "code": this.cod
    };
    return map;
  }

  String get getIdUser => idUser;

  set setIdUser(String idUser) => this.idUser = idUser;

  String get name => _name;

  set name(String value) => _name = value;

  String get email => _email;

  set email(String value) => _email = value;

  String get password => _password;

  set password(String value) => _password = value;

  String get cod => _cod;

  set cod(String value) => _cod = value;
}
