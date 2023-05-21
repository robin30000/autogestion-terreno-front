import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'WJXKgrz7wKA', // the ID of the video to play
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context, listen: false);

    final mq = MediaQuery.of(context).size;
    authServices.getMenuApp();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Soporte GPON'),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Center(
            child: YoutubePlayer(
              aspectRatio: 9 / 16,
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
          ),
        ),
      ),
    );
  }
}
