import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/audio_player_provider.dart';

class BottomPlayer extends ConsumerWidget {
  const BottomPlayer({super.key});

  // 格式化时间
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);

    final isPlaying = audioState.isPlaying;
    final isLooping = audioState.isLooping;
    final position = audioState.position;
    final duration = audioState.duration;
    final isLoading = audioState.isLoading;
    final currentSong = audioState.currentSong;

    final songTitle = currentSong?.title ?? '未在播放';
    final artist = currentSong?.artist ?? '请从列表选择歌曲';

    // 计算进度条值
    double currentPosMs = position.inMilliseconds.toDouble();
    double totalDurationMs = duration.inMilliseconds.toDouble();
    // 确保 value 在 min 和 max 之间，且 max > min
    if (totalDurationMs <= 0) totalDurationMs = 1.0;
    if (currentPosMs > totalDurationMs) currentPosMs = totalDurationMs;

    return Container(
      height: 90, // 稍微增加高度以容纳进度条
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // 控制栏区域
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 歌曲信息区域
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              songTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              artist,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (currentSong != null)
                              if (!isLoading)
                                Text(
                                  '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                )
                              else
                                const Text(
                                  '加载中...',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                          ],
                        ),
                      ),
                      // 进度条区域
                      SizedBox(
                        height: 20,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.green.withAlpha(50),
                            thumbColor: Colors.green,
                            overlayColor: Colors.green.withAlpha(32),
                          ),
                          child: Slider(
                            value: currentPosMs,
                            min: 0.0,
                            max: totalDurationMs,
                            onChanged: (value) {
                              notifier.seek(
                                Duration(milliseconds: value.toInt()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 播放控制区域
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isLooping ? Icons.repeat_one : Icons.repeat),
                        onPressed: () => notifier.setLooping(!isLooping),
                        iconSize: 20,
                        color: isLooping ? Colors.green : Colors.black,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: null,
                        iconSize: 24,
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                        ),
                        onPressed: () => notifier.togglePlayPause(),
                        iconSize: 36,
                        color: Colors.green,
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () => notifier.stop(),
                        iconSize: 24,
                      ),
                    ],
                  ),
                  // 右侧功能区域
                  const Row(
                    children: [
                      Icon(Icons.volume_up, size: 18),
                      SizedBox(width: 12),
                      Text(
                        'SQ',
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.queue_music, size: 18),
                      SizedBox(width: 12),
                      Icon(Icons.comment, size: 18),
                      SizedBox(width: 12),
                      Icon(Icons.fullscreen, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
