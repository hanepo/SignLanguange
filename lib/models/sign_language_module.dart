class SignLanguageModule {
  final int? id;
  final String word;
  final String description;
  final String assetPath;
  final String? videoPath;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SignLanguageModule({
    this.id,
    required this.word,
    required this.description,
    required this.assetPath,
    this.videoPath,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'description': description,
      'assetPath': assetPath,
      'videoPath': videoPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory SignLanguageModule.fromMap(Map<String, dynamic> map) {
    return SignLanguageModule(
      id: map['id'] as int?,
      word: map['word'] as String,
      description: map['description'] as String,
      assetPath: map['assetPath'] as String,
      videoPath: map['videoPath'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  SignLanguageModule copyWith({
    int? id,
    String? word,
    String? description,
    String? assetPath,
    String? videoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SignLanguageModule(
      id: id ?? this.id,
      word: word ?? this.word,
      description: description ?? this.description,
      assetPath: assetPath ?? this.assetPath,
      videoPath: videoPath ?? this.videoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
