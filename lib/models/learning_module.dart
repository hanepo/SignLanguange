class LearningModule {
  final int? id;
  final String title;
  final String content;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final int orderIndex;
  final List<int>? signLanguageModuleIds; // Related sign modules
  final DateTime createdAt;
  final DateTime? updatedAt;

  LearningModule({
    this.id,
    required this.title,
    required this.content,
    required this.difficulty,
    this.orderIndex = 0,
    this.signLanguageModuleIds,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'difficulty': difficulty,
      'orderIndex': orderIndex,
      'signLanguageModuleIds': signLanguageModuleIds?.join(','),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory LearningModule.fromMap(Map<String, dynamic> map) {
    return LearningModule(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      difficulty: map['difficulty'] as String,
      orderIndex: map['orderIndex'] as int? ?? 0,
      signLanguageModuleIds: map['signLanguageModuleIds'] != null
          ? (map['signLanguageModuleIds'] as String)
              .split(',')
              .map((e) => int.parse(e))
              .toList()
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  LearningModule copyWith({
    int? id,
    String? title,
    String? content,
    String? difficulty,
    int? orderIndex,
    List<int>? signLanguageModuleIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearningModule(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      difficulty: difficulty ?? this.difficulty,
      orderIndex: orderIndex ?? this.orderIndex,
      signLanguageModuleIds:
          signLanguageModuleIds ?? this.signLanguageModuleIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
