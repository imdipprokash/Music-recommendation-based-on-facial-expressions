import 'package:finalsem_project/youtube/models/video_model.dart';

import '../../utilities/play_list_ids.dart';

class Channel {

  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final int videoCount;
  final String uploadPlaylistId;
  List<Video> videos;

  Channel({
    required this.id,
    required this.title,
    required this.profilePictureUrl,
   required this.subscriberCount,
   required this.videoCount,
   required this.uploadPlaylistId,
   required this.videos,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      //videoCount: map['statistics']['videoCount'],
      videoCount: playlistId['anger']!.length,
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'], videos: [],
    );
  }

}