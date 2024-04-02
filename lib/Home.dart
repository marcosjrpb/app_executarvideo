import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // URL do vídeo
    String videoUrl = 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4';

    // Criando o controlador do vídeo a partir da URL da rede
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),

      httpHeaders: {'Authorization': 'Bearer YOUR_ACCESS_TOKEN'}, // Exemplo de cabeçalho HTTP
    );

    // Inicializando o controlador do vídeo
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // Liberando recursos do controlador do vídeo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reprodutor de Vídeo'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Se o vídeo estiver pausado, inicie a reprodução. Se estiver reproduzindo, pause.
            _controller.value.isPlaying ?  _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
