class UserModel {
  final String id;
  final String name;
  final String email;
  final double goldBalance; // in grams
  final double eurBalance;
  final String avatarInitials;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.goldBalance,
    required this.eurBalance,
    required this.avatarInitials,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    double? goldBalance,
    double? eurBalance,
    String? avatarInitials,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      goldBalance: goldBalance ?? this.goldBalance,
      eurBalance: eurBalance ?? this.eurBalance,
      avatarInitials: avatarInitials ?? this.avatarInitials,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'goldBalance': goldBalance,
        'eurBalance': eurBalance,
        'avatarInitials': avatarInitials,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        goldBalance: (json['goldBalance'] as num).toDouble(),
        eurBalance: (json['eurBalance'] as num).toDouble(),
        avatarInitials: json['avatarInitials'] as String,
      );

  factory UserModel.empty() => const UserModel(
        id: '',
        name: '',
        email: '',
        goldBalance: 0,
        eurBalance: 0,
        avatarInitials: '',
      );
}
