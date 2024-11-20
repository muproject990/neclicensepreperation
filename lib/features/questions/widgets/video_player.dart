// const apiKey = 'AIzaSyA0U781lygbF4Gmo-CYk3O_xXC7zpix0NA';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoGuidePage extends StatefulWidget {
  final String query;

  const VideoGuidePage({Key? key, required this.query}) : super(key: key);

  @override
  _VideoGuidePageState createState() => _VideoGuidePageState();
}

class _VideoGuidePageState extends State<VideoGuidePage> {
  List<String> videoUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideos(widget.query);
  }

  Future<void> _fetchVideos(String query) async {
    const apiKey = 'AIzaSyA0U781lygbF4Gmo-CYk3O_xXC7zpix0NA';
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&q=$query&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;

      setState(() {
        videoUrls = items
            .map((item) =>
                'https://www.youtube.com/embed/${item['id']['videoId']}')
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Guide")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(videoUrls[index]), // Convert String to WebUri
                    ),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        mediaPlaybackRequiresUserGesture: false,
                        useOnLoadResource: true,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
