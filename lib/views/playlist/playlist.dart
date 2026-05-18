import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/audio_player_provider.dart';

// 试听列表页面
class PlaylistScreen extends ConsumerWidget {
  const PlaylistScreen({super.key});

  final List<Map<String, String>> _mockSongs = const [
    {
      'title': 'Sample 1',
      'artist': 'Artist 1',
      'url': 'https://samplelib.com/mp3/sample-12s.mp3',
    },
    {
      'title': 'Sample 2',
      'artist': 'Artist 2',
      'url': 'https://samplelib.com/mp3/sample-15s.mp3',
    },
    {
      'title': 'Sample 3',
      'artist': 'Artist 3',
      'url': 'https://samplelib.com/mp3/sample-speech-1m.mp3',
    },
  ];

  void _handleSongTap(
    AudioPlayerState audioState,
    AudioPlayerNotifier notifier,
    Map<String, String> song,
  ) {
    if (audioState.currentSong?.url == song['url']) {
      // 同一首歌，切换播放/暂停
      notifier.togglePlayPause();
    } else {
      // 不同歌曲，直接播放
      notifier.playUrl(
        song['url']!,
        title: song['title'],
        artist: song['artist'],
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);

    final currentSongUrl = audioState.currentSong?.url;
    final isPlaying = audioState.isPlaying;
    final isLoading = audioState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('试听列表'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _mockSongs.length,
        itemBuilder: (context, index) {
          final song = _mockSongs[index];
          final isSelected = currentSongUrl == song['url'];

          return ListTile(
            leading: isSelected && isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  )
                : Icon(
                    isSelected
                        ? isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill
                        : Icons.music_note,
                    color: isSelected ? Colors.green : Colors.grey,
                  ),
            title: Text(
              song['title']!,
              style: TextStyle(
                color: isSelected ? Colors.green : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(song['artist']!),
            onTap: () => _handleSongTap(audioState, notifier, song),
            trailing: isSelected
                ? isLoading
                      ? const Text(
                          '加载中...',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      : isPlaying
                      ? const Text(
                          '播放中',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        )
                      : null
                : null,
          );
        },
      ),
    );
  }
}
