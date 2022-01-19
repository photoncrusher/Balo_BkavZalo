class LoginInfo {
  final String id;
  final String token;
  final bool active;
  String username;
  String? avatar;

  LoginInfo(
      {required this.id,
      required this.token,
      required this.active,
      required this.username,
      this.avatar});

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      id: json['id'],
      username: json['username'],
      token: json['token'],
      active: json['active'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "username": this.username,
      "token": this.token,
      "active": this.active,
      "avatar": this.avatar,
    };
  }
}
