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
      this.username = "Anonymous",
      this.avatar});

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      id: json['id'],
      username: json['username'] ?? "Anonymous",
      token: json['token'],
      active: json['active'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "usename": this.username,
      "token": this.token,
      "active": this.active,
      "avatar": this.avatar,
    };
  }
}
