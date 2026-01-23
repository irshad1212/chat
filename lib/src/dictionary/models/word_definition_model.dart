class WordDefinitionModel {
  final String word;
  final String? phonetic;
  final List<PhoneticModel> phonetics;
  final List<MeaningModel> meanings;

  const WordDefinitionModel({
    required this.word,
    this.phonetic,
    this.phonetics = const [],
    this.meanings = const [],
  });

  factory WordDefinitionModel.fromJson(Map<String, dynamic> json) {
    return WordDefinitionModel(
      word: json['word'] as String? ?? '',
      phonetic: json['phonetic'] as String?,
      phonetics:
          (json['phonetics'] as List<dynamic>?)
              ?.map((e) => PhoneticModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meanings:
          (json['meanings'] as List<dynamic>?)
              ?.map((e) => MeaningModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PhoneticModel {
  final String? text;
  final String? audio;

  const PhoneticModel({this.text, this.audio});

  factory PhoneticModel.fromJson(Map<String, dynamic> json) {
    return PhoneticModel(text: json['text'] as String?, audio: json['audio'] as String?);
  }
}

class MeaningModel {
  final String partOfSpeech;
  final List<DefinitionModel> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  const MeaningModel({
    required this.partOfSpeech,
    this.definitions = const [],
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory MeaningModel.fromJson(Map<String, dynamic> json) {
    return MeaningModel(
      partOfSpeech: json['partOfSpeech'] as String? ?? '',
      definitions:
          (json['definitions'] as List<dynamic>?)
              ?.map((e) => DefinitionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      synonyms: (json['synonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      antonyms: (json['antonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class DefinitionModel {
  final String definition;
  final String? example;
  final List<String> synonyms;
  final List<String> antonyms;

  const DefinitionModel({
    required this.definition,
    this.example,
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory DefinitionModel.fromJson(Map<String, dynamic> json) {
    return DefinitionModel(
      definition: json['definition'] as String? ?? '',
      example: json['example'] as String?,
      synonyms: (json['synonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      antonyms: (json['antonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
