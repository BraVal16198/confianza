class Client {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final double score;
  final double balance;
  final DateTime? nextVisit;
  final String? address;
  final String? notes;

  const Client({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.score,
    required this.balance,
    this.nextVisit,
    this.address,
    this.notes,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      score: (map['score'] ?? 0.0).toDouble(),
      balance: (map['balance'] ?? 0.0).toDouble(),
      nextVisit: map['nextVisit'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['nextVisit'])
          : null,
      address: map['address'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'score': score,
      'balance': balance,
      'nextVisit': nextVisit?.millisecondsSinceEpoch,
      'address': address,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'Client(id: $id, name: $name, score: $score, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Client && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

