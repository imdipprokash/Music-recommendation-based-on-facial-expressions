import 'package:finalsem_project/youtube/screens/video_screen.dart';
import 'package:flutter/material.dart';
import '../../utilities/key.dart';
import '../models/channel_model.dart';
import '../models/video_model.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final String emotion;
  // ignore: use_key_in_widget_constructors
  const HomeScreen(this.emotion);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Channel? _channel;
  
  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService(widget.emotion)
        .fetchChannel(channelId: kYoutubeChannel);
    setState(() {
      _channel = channel;
    });
  }

  _buildProfileInfo() {
    return Container(
      height: 0,
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: const EdgeInsets.all(10.0),
        height: 140.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.emotion[0].toUpperCase()}${widget.emotion.substring(1)} playlist'),
      ),
      backgroundColor: const Color.fromARGB(15, 247, 245, 244),
      body: 
      _channel != null
          ? ListView.builder(
              itemCount: 1 + _channel!.videos.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildProfileInfo();
                }
                Video video = _channel!.videos[index - 1];
                return _buildVideo(video);
              },
            )
          //   )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }
}
