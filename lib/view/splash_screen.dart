import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:eventopia_app/view/landing_page.dart'; // ✅ Ensure this file exists

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    
    // ✅ Correct video file path
    _controller = VideoPlayerController.asset('assets/videos/splash.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh UI when video is loaded
        _controller.play(); // Auto-play video
      })
      ..setLooping(false);

    // ✅ Navigate to Landing Page when the video ends
    _controller.addListener(() {
      if (!_controller.value.isPlaying &&
          _controller.value.position == _controller.value.duration) {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LandingPage()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose when leaving screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(), // Show loader until video loads
      ),
    );
  }
}
