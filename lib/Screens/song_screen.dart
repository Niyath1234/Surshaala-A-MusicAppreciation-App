import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../widgets/player_buttons.dart';
import '../widgets/seekbar.dart';
import '../widgets/raag_taal.dart';
import '../models/song_model.dart';
//import '../widgets/widgets.dart';
import '../widgets/section_header.dart';
import '../models/song_model.dart';
import '../widgets/song_card.dart';
import '../widgets/song_card2.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({Key? key}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  /// REST path for favorites (POST/DELETE). Used by [toggleFavoriteForSong].
  static const String _apiFavoritesPath = '/api/v1/favorites';

  AudioPlayer audioPlayer = AudioPlayer();
  Song song = Get.arguments ?? Song.songs[0];

  /// Toggles a song in the user's favorites list.
  /// Mirrors POST/DELETE _apiFavoritesPath; currently a no-op until API is wired.
  Future<void> toggleFavoriteForSong({required String songId, required bool isFavorite}) async {
    // TODO: if (isFavorite) http.delete(Uri.parse('$baseUrl$_apiFavoritesPath/$songId'))
    // else http.post(Uri.parse('$baseUrl$_apiFavoritesPath'), body: {'songId': songId})
    return;
  }

  @override
  void initState() {
    super.initState();

    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse('asset:///${song.url}'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream, (
        Duration position,
        Duration? duration,
      ) {
        return SeekBarData(
          position,
          duration ?? Duration.zero,
        );
      });

  @override
  Widget build(BuildContext context) {
    List<Song> songs = Song.songs;
    Size pageSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,

      body: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset(
            song.coverUrl,
            fit: BoxFit.cover,
          ),
          const _BackgroundFilter(),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: pageSize.height*0.52),
                _MusicPlayer(
                  song: song,
                  seekBarDataStream: _seekBarDataStream,
                  audioPlayer: audioPlayer,
                ),
                //TaalCard(song: song),
                _TrendingMusic(songs: songs),
                //const SizedBox(height: 10,),
                _TrendingMusic2(songs: songs),
                //const SizedBox(height: 10,),
                _TrendingMusic3(songs: songs),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: const Text(
                //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sagittis nulla eu tellus tristique, vel maximus lorem mattis. Etiam ac leo aliquam, laoreet velit vel, posuere lectus. Sed vitae nunc eget justo feugiat convallis. Sed scelerisque, nisl a pulvinar bibendum, lacus turpis consequat elit, in dignissim velit dolor eu orci. Suspendisse a lacinia turpis. Sed aliquam massa nec arcu hendrerit, vel pharetra ex sollicitudin. Aenean vel leo a quam ultrices venenatis. Aenean aliquet sodales neque eget viverra. Nulla porttitor in est a suscipit. Duis tempor sem ut massa consequat vestibulum. Nam eget velit nisi. In consectetur orci non lacus interdum congue.',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
          // const SizedBox(height: 20.0),
          // Text(
          //   "Trivia",
          //   style: Theme.of(context)
          //       .textTheme
          //       .bodyLarge!
          //       .copyWith(color: Colors.white,fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 20),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: const Text(
          //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sagittis nulla eu tellus tristique, vel maximus lorem mattis. Etiam ac leo aliquam, laoreet velit vel, posuere lectus. Sed vitae nunc eget justo feugiat convallis. Sed scelerisque, nisl a pulvinar bibendum, lacus turpis consequat elit, in dignissim velit dolor eu orci. Suspendisse a lacinia turpis. Sed aliquam massa nec arcu hendrerit, vel pharetra ex sollicitudin. Aenean vel leo a quam ultrices venenatis. Aenean aliquet sodales neque eget viverra. Nulla porttitor in est a suscipit. Duis tempor sem ut massa consequat vestibulum. Nam eget velit nisi. In consectetur orci non lacus interdum congue.',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //),
          //const SizedBox(height: 20),
        ],
      ),

    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    Key? key,
    required this.song,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Song song;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 50.0,
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          InkWell(onTap: (){
            Get.toNamed('/artist');
          },
            child: Text(
              song.description,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Color.fromARGB(255, 16, 255, 255).withOpacity(1.0),),
            ),
          ),
          const SizedBox(height: 30),
          StreamBuilder<SeekBarData>(
            stream: _seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: audioPlayer.seek,
              );
            },
          ),
          PlayerButtons(audioPlayer: audioPlayer),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       iconSize: 35,
          //       onPressed: () {},
          //       icon: const Icon(
          //         Icons.settings,
          //         color: Colors.white,
          //       ),
          //     ),
          //     IconButton(
          //       iconSize: 35,
          //       onPressed: () {},
          //       icon: const Icon(
          //         Icons.cloud_download,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 90),
          TaalCard(song: song)
        ],

      ),

    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(221, 23, 0, 92).withOpacity(0.8),
              const Color.fromARGB(255, 0, 0, 9).withOpacity(0.8),
            ],
          ),
        ),
      ),
    );


  }
}
class _TrendingMusic extends StatelessWidget{
  _TrendingMusic({Key? key,required this.songs, }) : super(key: key);
  Song song = Get.arguments ?? Song.songs[0];
  final List<Song> songs;
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0 ,top: 10.0, bottom: 20.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SectionHeader(title: 'More Songs by this Artist'),
          ),
          const SizedBox(height: 20.0),
          SizedBox(height: MediaQuery
              .of(context)
              .size.height * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.where((Song) => Song.description == song.description).toList().length,
              itemBuilder: (context, index){
                return SongCard(song: songs.where((Song) => Song.description == song.description).toList()[index], pushWithReplacement: true,);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingMusic2 extends StatelessWidget{
  _TrendingMusic2({Key? key,required this.songs}) : super(key: key);
  Song song = Get.arguments ?? Song.songs[0];
  final List<Song> songs;
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0 ,top: 20.0, bottom: 20.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SectionHeader(title: 'More Songs on this Raag'),
          ),
          const SizedBox(height: 20.0),
          SizedBox(height: MediaQuery
              .of(context)
              .size.height * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.where((Song) => Song.raag == song.raag).toList().length,
              itemBuilder: (context, index){
                return SongCard(song: songs.where((Song) => Song.raag == song.raag).toList()[index], pushWithReplacement: true,);
              },
            ),
          ),
        ],
      ),
    );
  }
}
class _TrendingMusic3 extends StatelessWidget{
  _TrendingMusic3({Key? key,required this.songs}) : super(key: key);
  Song song = Get.arguments ?? Song.songs[0];
  final List<Song> songs;
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0 ,top: 20.0, bottom: 20.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SectionHeader(title: 'More Songs on this taal'),
          ),
          const SizedBox(height: 20.0),
          SizedBox(height: MediaQuery
              .of(context)
              .size.height * 0.27,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.where((Song) => Song.taal == song.taal).toList().length,
              itemBuilder: (context, index){
                return SongCard(song: songs.where((Song) => Song.taal == song.taal).toList()[index],pushWithReplacement: true,);
              },
            ),
          ),
        ],
      ),
    );
  }
}



