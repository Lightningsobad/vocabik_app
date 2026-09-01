import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/discover/data/models/playlist_model.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';

void main() {
  group('PlaylistModel', () {
    final sampleJson = {
      "slug": "top-pop-hits-a2-b1",
      "title": "Pop Hits A2-B1",
      "description": "Popular Pop songs, great for A2–B1 learners.",
      "coverImageUrl": "https://i.ytimg.com/vi/iPAw5GhZplc/hqdefault.jpg",
      "videoCount": 6,
      "totalDurationSeconds": 1473,
      "canonicalVersion": "v1"
    };

    final samplePaginatedJson = {
      "items": [
        {
          "slug": "top-pop-hits-a2-b1",
          "title": "Pop Hits A2-B1",
          "description": "Popular Pop songs, great for A2–B1 learners.",
          "coverImageUrl": "https://i.ytimg.com/vi/iPAw5GhZplc/hqdefault.jpg",
          "videoCount": 6,
          "totalDurationSeconds": 1473,
          "canonicalVersion": "v1"
        }
      ],
      "page": 1,
      "pageSize": 10,
      "totalItems": 1,
      "totalPages": 1
    };

    test('should correctly parse single PlaylistModel from JSON', () {
      final model = PlaylistModel.fromJson(sampleJson);

      expect(model.slug, 'top-pop-hits-a2-b1');
      expect(model.title, 'Pop Hits A2-B1');
      expect(model.description, 'Popular Pop songs, great for A2–B1 learners.');
      expect(model.coverImageUrl, 'https://i.ytimg.com/vi/iPAw5GhZplc/hqdefault.jpg');
      expect(model.videoCount, 6);
      expect(model.totalDurationSeconds, 1473);
      expect(model.canonicalVersion, 'v1');
    });

    test('should map PlaylistModel to PlaylistEntity correctly', () {
      final model = PlaylistModel.fromJson(sampleJson);
      final entity = model.toEntity();

      expect(entity, isA<PlaylistEntity>());
      expect(entity.slug, 'top-pop-hits-a2-b1');
      expect(entity.title, 'Pop Hits A2-B1');
      expect(entity.approximateMinutes, 25);
    });

    test('should correctly parse PaginatedPlaylistResponseModel and convert to entity', () {
      final paginatedModel = PaginatedPlaylistResponseModel.fromJson(samplePaginatedJson);

      expect(paginatedModel.page, 1);
      expect(paginatedModel.pageSize, 10);
      expect(paginatedModel.totalItems, 1);
      expect(paginatedModel.totalPages, 1);
      expect(paginatedModel.items.length, 1);

      final paginatedResult = paginatedModel.toEntity();
      expect(paginatedResult.items.length, 1);
      expect(paginatedResult.items.first.title, 'Pop Hits A2-B1');
      expect(paginatedResult.hasReachedMax, isTrue);
    });
  });
}
