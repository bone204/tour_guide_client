import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/user.dart';

class Feedback {
  final int id;
  final User? user;
  final int star;
  final String? comment;
  final List<String> photos;
  final List<String> videos;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FeedbackReply>? replies;
  final int likeCount;
  final int loveCount;
  final bool isLiked;
  final bool isLoved;

  const Feedback({
    required this.id,
    this.user,
    required this.star,
    this.comment,
    this.photos = const [],
    this.videos = const [],
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.replies,
    this.likeCount = 0,
    this.loveCount = 0,
    this.isLiked = false,
    this.isLoved = false,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      star: json['star'] ?? 0,
      comment: json['comment'],
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videos:
          (json['videos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: json['status'] ?? 'pending',
      createdAt: DateFormatter.parse(json['createdAt']),
      updatedAt: DateFormatter.parse(json['updatedAt']),
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => FeedbackReply.fromJson(e))
              .toList(),
      likeCount:
          json['reactions'] != null
              ? (json['reactions'] as List)
                  .where((r) => r['type'] == 'like')
                  .length
              : 0,
      loveCount:
          json['reactions'] != null
              ? (json['reactions'] as List)
                  .where((r) => r['type'] == 'love')
                  .length
              : 0,
      isLiked: false,
      isLoved: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'star': star,
      'comment': comment,
      'photos': photos,
      'videos': videos,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'replies': replies?.map((e) => e.toJson()).toList(),
      'reactions': [], // Placeholder if needed
    };
  }
}

class FeedbackResponse {
  final List<Feedback> items;

  FeedbackResponse({required this.items});

  factory FeedbackResponse.fromJson(dynamic json) {
    if (json is List) {
      return FeedbackResponse(
        items: json.map((e) => Feedback.fromJson(e)).toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return FeedbackResponse(
        items:
            (json['items'] as List<dynamic>? ?? [])
                .map((e) => Feedback.fromJson(e))
                .toList(),
      );
    } else {
      return FeedbackResponse(items: []);
    }
  }
}

class FeedbackReply {
  final int id;
  final User? user;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FeedbackReply({
    required this.id,
    this.user,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedbackReply.fromJson(Map<String, dynamic> json) {
    return FeedbackReply(
      id: json['id'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      content: json['content'] ?? '',
      createdAt: DateFormatter.parse(json['createdAt']),
      updatedAt: DateFormatter.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class FeedbackReplyResponse {
  final List<FeedbackReply> items;

  FeedbackReplyResponse({required this.items});

  factory FeedbackReplyResponse.fromJson(dynamic json) {
    if (json is List) {
      return FeedbackReplyResponse(
        items: json.map((e) => FeedbackReply.fromJson(e)).toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return FeedbackReplyResponse(
        items:
            (json['items'] as List<dynamic>? ?? [])
                .map((e) => FeedbackReply.fromJson(e))
                .toList(),
      );
    } else {
      return FeedbackReplyResponse(items: []);
    }
  }
}
