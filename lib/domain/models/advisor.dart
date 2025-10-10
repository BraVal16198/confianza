class Advisor {
  final String code;
  final String fullName;
  final String? email;
  final String? phone;

  const Advisor({
    required this.code,
    required this.fullName,
    this.email,
    this.phone,
  });

  factory Advisor.fromMap(Map<String, dynamic> map) {
    return Advisor(
      code: map['code'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'fullName': fullName,
      'email': email,
      'phone': phone,
    };
  }

  @override
  String toString() {
    return 'Advisor(code: $code, fullName: $fullName, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Advisor && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

