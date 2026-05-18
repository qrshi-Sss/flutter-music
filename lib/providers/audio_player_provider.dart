import 'package:audioplayers/audioplayers.dart';
import 'package:meta/meta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_provider.g.dart';

// 1. 提供 AudioPlayer 单例
@riverpod
AudioPlayer rawAudioPlayer(Ref ref) {
  final player = AudioPlayer();

  // 当 Provider 被销毁时，释放播放器资源
  ref.onDispose(() {
    player.dispose();
  });

  return player;
}

// 2. 播放器状态（核心）
@riverpod
class AudioPlayerNotifier extends _$AudioPlayerNotifier {
  late AudioPlayer _player;

  @override
  AudioPlayerState build() {
    // 获取 audioPlayer 实例
    _player = ref.watch(rawAudioPlayerProvider);

    // 开始监听播放器事件
    _listenToPlayerEvents();

    // 返回初始状态
    return AudioPlayerState.initial();
  }

  void _listenToPlayerEvents() {
    // 监听播放状态变化
    _player.onPlayerStateChanged.listen((pState) {
      state = state.copyWith(isPlaying: pState == PlayerState.playing);
    });

    // 监听播放进度
    _player.onPositionChanged.listen((position) {
      state = state.copyWith(position: position);
    });

    // 监听总时长
    _player.onDurationChanged.listen((duration) {
      state = state.copyWith(duration: duration);
    });

    // 监听播放完成
    _player.onPlayerComplete.listen((_) {
      state = state.copyWith(isPlaying: false, isCompleted: true);
    });
  }

  // 播放网络音频
  Future<void> playUrl(String url, {String? title, String? artist}) async {
    try {
      // 立即更新当前歌曲信息并设为加载中，这样 UI 就能立刻在目标歌曲上显示加载状态
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentSong: SongInfo(
          title: title ?? '未知歌曲',
          artist: artist ?? '未知艺术家',
          url: url,
        ),
      );

      await _player.stop();
      await _player.play(UrlSource(url));

      state = state.copyWith(
        isPlaying: true,
        isLoading: false,
        isCompleted: false,
      );
    } catch (e) {
      state = state.copyWith(error: '播放失败: $e', isLoading: false);
    }
  }

  // 播放 Asset 资源
  Future<void> playAsset(String path, {String? title, String? artist}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentSong: SongInfo(
          title: title ?? '本地歌曲',
          artist: artist ?? '',
          url: path,
        ),
      );

      final cleanPath = path.replaceFirst('assets/', '');
      await _player.stop();
      await _player.play(AssetSource(cleanPath));

      state = state.copyWith(
        isPlaying: true,
        isLoading: false,
        isCompleted: false,
      );
    } catch (e) {
      state = state.copyWith(error: '播放失败: $e', isLoading: false);
    }
  }

  // 播放/暂停切换
  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _player.pause();
      state = state.copyWith(isPlaying: false);
    } else if (state.position.inMilliseconds > 0) {
      await _player.resume();
      state = state.copyWith(isPlaying: true);
    }
  }

  // 停止播放
  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(
      isPlaying: false,
      position: Duration.zero,
      isCompleted: false,
    );
  }

  // 跳转到指定位置
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    state = state.copyWith(position: position);
  }

  // 设置循环模式
  Future<void> setLooping(bool loop) async {
    await _player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.release);
    state = state.copyWith(isLooping: loop);
  }

  // 设置音量
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
    state = state.copyWith(volume: volume);
  }

  // 设置播放速度
  Future<void> setPlaybackRate(double rate) async {
    await _player.setPlaybackRate(rate);
    state = state.copyWith(playbackRate: rate);
  }
}

// 3. 状态模型
@immutable
class AudioPlayerState {
  final SongInfo? currentSong; // 当前播放的歌曲信息
  final bool isPlaying; // 是否正在播放
  final bool isLoading; // 是否正在加载
  final bool isLooping; // 是否循环播放
  final bool isCompleted; // 是否播放完成
  final Duration position; // 当前播放位置
  final Duration duration; // 总时长
  final double volume; // 音量
  final double playbackRate; // 播放速度
  final String? error; // 错误信息

  const AudioPlayerState({
    this.currentSong,
    this.isPlaying = false,
    this.isLoading = false,
    this.isLooping = false,
    this.isCompleted = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 1.0,
    this.playbackRate = 1.0,
    this.error,
  });

  factory AudioPlayerState.initial() {
    return const AudioPlayerState();
  }

  AudioPlayerState copyWith({
    SongInfo? currentSong,
    bool? isPlaying,
    bool? isLoading,
    bool? isLooping,
    bool? isCompleted,
    Duration? position,
    Duration? duration,
    double? volume,
    double? playbackRate,
    String? error,
  }) {
    return AudioPlayerState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      isLooping: isLooping ?? this.isLooping,
      isCompleted: isCompleted ?? this.isCompleted,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      playbackRate: playbackRate ?? this.playbackRate,
      error: error,
    );
  }
}

// 4. 歌曲信息模型
@immutable
class SongInfo {
  final String title;
  final String artist;
  final String url;
  final String? coverUrl;

  const SongInfo({
    required this.title,
    required this.artist,
    required this.url,
    this.coverUrl,
  });
}
