/// 사용자 모델
class User {
  final int id;
  final String? email;
  final String? nickname;
  final String? profileImage;
  final String provider;
  final bool hasPainSurvey;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    this.email,
    this.nickname,
    this.profileImage,
    required this.provider,
    this.hasPainSurvey = false,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String?,
      nickname: json['nickname'] as String?,
      profileImage: json['profileImage'] as String?,
      provider: json['provider'] as String? ?? '',
      hasPainSurvey: json['hasPainSurvey'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'nickname': nickname,
        'profileImage': profileImage,
        'provider': provider,
        'hasPainSurvey': hasPainSurvey,
      };

  /// 초기유저 여부 (초기 진단 결과가 없으면 초기유저)
  bool get isInitialUser => !hasPainSurvey;

  /// 기본유저 여부 (초기 진단 결과가 있으면 기본유저)
  bool get isRegularUser => hasPainSurvey;

  User copyWith({
    int? id,
    String? email,
    String? nickname,
    String? profileImage,
    String? provider,
    bool? hasPainSurvey,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      provider: provider ?? this.provider,
      hasPainSurvey: hasPainSurvey ?? this.hasPainSurvey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
