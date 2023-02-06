import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ChatAudio extends StatefulWidget {
  final  AudioPlayer justAudioPlayer;
  final String urlAudio;
  final String index;
  const ChatAudio(
      {super.key,
      required this.justAudioPlayer,
      required this.urlAudio,
      required this.index});

  @override
  State<ChatAudio> createState() => _ChatAudioState();
}

class _ChatAudioState extends State<ChatAudio> {
  /// Some Integer Value Initialized
  double _currAudioPlayingTime = 0.0;
  String _lastAudioPlayingIndex = ' ';

  double _audioPlayingSpeed = 1.0;

  /// Audio Playing Time Related
  String _totalDuration = '0:00';
  String _loadingTime = '0:00';

  double _chatBoxHeight = 0.0;

  String _hintText = "Type Here...";

  /// For Audio Player
  IconData _iconData = Icons.play_arrow_rounded;

  ///Pour l'unique audio
  bool _encours = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 20.0,
          ),
          GestureDetector(
            onTap: () => chatMicrophoneOnTapAction(widget.urlAudio),
            child: Icon(
              widget.index == _lastAudioPlayingIndex
                  ? _iconData
                  : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 26.0,
                    ),
                    child: LinearPercentIndicator(
                      percent:  widget.justAudioPlayer.duration == null
                          ? 0.0
                          : _lastAudioPlayingIndex == widget.index
                              ? _currAudioPlayingTime /
                                          widget.justAudioPlayer.duration!
                                              .inMicroseconds
                                              .ceilToDouble() <=
                                      1.0
                                  ? _currAudioPlayingTime /
                                      widget.justAudioPlayer.duration!
                                          .inMicroseconds
                                          .ceilToDouble()
                                  : 0.0
                              : 0,
                      backgroundColor: Colors.black26,
                      // progressColor:
                      //     this._conversationMessageHolder[index]
                      //         ? Colors.lightBlue
                      //         : Colors.amber,
                    ),
                     
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _lastAudioPlayingIndex == widget.index
                                  ? _loadingTime
                                  : '0:00',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _lastAudioPlayingIndex == widget.index
                                  ? _totalDuration
                                  : '',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              child: _lastAudioPlayingIndex != widget.index
                  ? CircleAvatar(
                      radius: 23.0,
                      backgroundColor: Colors.white,
                    )
                  : Text(
                      '${this._audioPlayingSpeed.toString().contains('.0') ? this._audioPlayingSpeed.toString().split('.')[0] : this._audioPlayingSpeed}x',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
              onTap: () {
                print('Audio Play Speed Tapped');
                if (mounted) {
                  setState(() {
                    if (this._audioPlayingSpeed != 3.0)
                      this._audioPlayingSpeed += 0.5;
                    else
                      this._audioPlayingSpeed = 1.0;

                    widget.justAudioPlayer.setSpeed(this._audioPlayingSpeed);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void chatMicrophoneOnTapAction(String url) async {
    try {
      widget.justAudioPlayer.positionStream.listen((event) {
        if (mounted) {
          setState(() {
            _encours = true;
            _currAudioPlayingTime = event.inMicroseconds.ceilToDouble();
            _loadingTime =
                '${event.inMinutes} : ${event.inSeconds > 59 ? event.inSeconds % 60 : event.inSeconds}';
          });
        }
      });

      widget.justAudioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          widget.justAudioPlayer.stop();
          _encours = false;
          if (mounted) {
            setState(() {
              this._loadingTime = '0:00';
              this._iconData = Icons.play_arrow_rounded;
            });
          }
        }
      });

      if (_lastAudioPlayingIndex != widget.index) {
        await widget.justAudioPlayer.setUrl(url);

        if (mounted) {
          setState(() {
            _lastAudioPlayingIndex = widget.index;
            _totalDuration =
                '${widget.justAudioPlayer.duration!.inMinutes} : ${widget.justAudioPlayer.duration!.inSeconds > 59 ? widget.justAudioPlayer.duration!.inSeconds % 60 : widget.justAudioPlayer.duration!.inSeconds}';
            _iconData = Icons.pause;
            this._audioPlayingSpeed = 1.0;
            widget.justAudioPlayer.setSpeed(this._audioPlayingSpeed);
          });
        }

        await widget.justAudioPlayer.play();
      } else {
        print(widget.justAudioPlayer.processingState);
        if (widget.justAudioPlayer.processingState == ProcessingState.idle) {
          await widget.justAudioPlayer.setUrl(url);

          if (mounted) {
            setState(() {
              _lastAudioPlayingIndex = widget.index;
              _totalDuration =
                  '${widget.justAudioPlayer.duration!.inMinutes} : ${widget.justAudioPlayer.duration!.inSeconds}';
              _iconData = Icons.pause;
            });
          }

          await widget.justAudioPlayer.play();
        } else if (widget.justAudioPlayer.playing) {
          if (mounted) {
            setState(() {
              _iconData = Icons.play_arrow_rounded;
            });
          }

          await widget.justAudioPlayer.pause();
        } else if (widget.justAudioPlayer.processingState ==
            ProcessingState.ready) {
          if (mounted) {
            setState(() {
              _iconData = Icons.pause;
            });
          }

          await widget.justAudioPlayer.play();
        } else if (widget.justAudioPlayer.processingState ==
            ProcessingState.completed) {}
      }
    } catch (e) {
      print('Audio Playing Error');
    }
  }
}
