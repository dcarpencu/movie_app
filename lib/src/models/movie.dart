part of 'index.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    required int year,
    required double rating,
    required List<String> genres,
    // ignore: non_constant_identifier_names
    required String description_full,
    @JsonKey(name: 'large_cover_image') required String posterBig,
    @JsonKey(name: 'medium_cover_image') required String poster,
  }) = Movie$;

  factory Movie.fromJson(Map<dynamic, dynamic> json) => _$MovieFromJson(Map<String, dynamic>.from(json));
}
