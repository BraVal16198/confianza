class Visit {
  final String id;
  final String clientId;
  final String advisorId;
  final String? notes;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPendingSync;

  const Visit({
    required this.id,
    required this.clientId,
    required this.advisorId,
    this.notes,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.updatedAt,
    this.isPendingSync = false,
  });

  factory Visit.fromMap(Map<String, dynamic> map) {
    return Visit(
      id: map['id'] ?? '',
      clientId: map['clientId'] ?? '',
      advisorId: map['advisorId'] ?? '',
      notes: map['notes'],
      photoUrl: map['photoUrl'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      isPendingSync: map['isPendingSync'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'advisorId': advisorId,
      'notes': notes,
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'isPendingSync': isPendingSync,
    };
  }

  Visit copyWith({
    String? id,
    String? clientId,
    String? advisorId,
    String? notes,
    String? photoUrl,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPendingSync,
  }) {
    return Visit(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      advisorId: advisorId ?? this.advisorId,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'Visit(id: $id, clientId: $clientId, advisorId: $advisorId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Visit && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

