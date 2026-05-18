// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rawAudioPlayer)
final rawAudioPlayerProvider = RawAudioPlayerProvider._();

final class RawAudioPlayerProvider
    extends $FunctionalProvider<AudioPlayer, AudioPlayer, AudioPlayer>
    with $Provider<AudioPlayer> {
  RawAudioPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rawAudioPlayerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rawAudioPlayerHash();

  @$internal
  @override
  $ProviderElement<AudioPlayer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioPlayer create(Ref ref) {
    return rawAudioPlayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioPlayer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioPlayer>(value),
    );
  }
}

String _$rawAudioPlayerHash() => r'3d6445e9e0e81cdc8366a18b83071f426c78ed44';

@ProviderFor(AudioPlayerNotifier)
final audioPlayerProvider = AudioPlayerNotifierProvider._();

final class AudioPlayerNotifierProvider
    extends $NotifierProvider<AudioPlayerNotifier, AudioPlayerState> {
  AudioPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioPlayerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioPlayerNotifierHash();

  @$internal
  @override
  AudioPlayerNotifier create() => AudioPlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioPlayerState>(value),
    );
  }
}

String _$audioPlayerNotifierHash() =>
    r'2f488b7fb62bb52c0618bb24137f83483c96bb22';

abstract class _$AudioPlayerNotifier extends $Notifier<AudioPlayerState> {
  AudioPlayerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AudioPlayerState, AudioPlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AudioPlayerState, AudioPlayerState>,
              AudioPlayerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
