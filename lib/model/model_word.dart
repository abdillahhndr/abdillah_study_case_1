// To parse this JSON data, do
//
//     final modelWord = modelWordFromJson(jsonString);

import 'dart:convert';

List<ModelWord> modelWordFromJson(String str) =>
    List<ModelWord>.from(json.decode(str).map((x) => ModelWord.fromJson(x)));

String modelWordToJson(List<ModelWord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelWord {
  int id;
  String word;
  String arti;

  ModelWord({
    required this.id,
    required this.word,
    required this.arti,
  });

  factory ModelWord.fromJson(Map<String, dynamic> json) => ModelWord(
        id: json["id"],
        word: json["word"],
        arti: json["arti"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "word": word,
        "arti": arti,
      };
}
