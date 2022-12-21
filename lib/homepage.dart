import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:audioplayers/audioplayers.dart';

export 'homepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  bool _isNear = false;
  bool _currState = false;
  bool _isStart = false;
  String _startBtnMsg = 'ابدأ';
  Color _indicatorColor = Colors.red;
  bool _muteState = false;

  late StreamSubscription<dynamic> _streamSubscription;

  var displayMessages = {
    '0': 'الفورمة تستاهل',
    '1': 'ابدا يا وحش',
    '2': 'استمرر',
    '3': 'لسه بدري',
    '4': 'وحش كمل',
    '5': 'اقوي كمل',
    '6': 'عاااش يا وحش',
    '7': 'بطااال',
    '8': 'هتقدر تعملها ',
    '9': 'اسطورة يا وحش',
    '10': ' عاااااااااااش عصب'
  };
  String _displayMsg = 'الفورمة تستاهل';

  void updateCounter() {
    if (_counter == 0) {
      setState(() {
        _displayMsg = displayMessages['0'] as String;
      });
    } else if (_counter > 0 && _counter < 5) {
      setState(() {
        _displayMsg = displayMessages['1'] as String;
      });
    } else if (_counter == 5) {
      setState(() {
        _displayMsg = displayMessages['2'] as String;
      });
    } else if (_counter > 5 && _counter < 10) {
      setState(() {
        _displayMsg = displayMessages['3'] as String;
      });
    } else if (_counter == 10) {
      setState(() {
        _displayMsg = displayMessages['4'] as String;
      });
    } else if (_counter > 10 && _counter < 15) {
      setState(() {
        _displayMsg = displayMessages['5'] as String;
      });
    } else if (_counter == 15) {
      setState(() {
        _displayMsg = displayMessages['6'] as String;
      });
    } else if (_counter > 15 && _counter < 20) {
      setState(() {
        _displayMsg = displayMessages['7'] as String;
      });
    } else if (_counter > 20 && _counter < 25) {
      setState(() {
        _displayMsg = displayMessages['8'] as String;
      });
    } else if (_counter == 25) {
      setState(() {
        _displayMsg = displayMessages['9'] as String;
      });
    } else if (_counter > 25) {
      setState(() {
        _displayMsg = displayMessages['10'] as String;
      });
    }

    if (_isStart == true) {
      if (_isNear) {
        setState(() {
          _indicatorColor = Colors.green;
        });
      } else {
        setState(() {
          _indicatorColor = Colors.red;
        });
      }

      if (_isNear == true && _currState == false) {
        setState(() async {
          _counter++;
          _currState = true;

          if (!_muteState) {
            await _playAudioDing();
          }
        });
      } else if (_currState = true & _isNear == true) {
        setState(() {
          _currState = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
      });
      updateCounter();
    });
  }

  _displaySoundController() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            _muteState = _muteState ? false : true;
          });
        },
        child: Icon(
            _muteState ? Icons.volume_off_outlined : Icons.volume_up_outlined),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // alert section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _displaySoundController(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
                  alignment: Alignment.topRight,
                  // height: 50.0,
                  // color: Colors.red,
                  child: CircleAvatar(
                    // backgroundColor: _indicatorColors['red'],
                    backgroundColor: _indicatorColor,
                    radius: 20.0,
                  ),
                ),
              ],
            ),

            // main body (counter and action buttons)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _displayCounterWidget(_counter),
                  // display message
                  Text(
                    _displayMsg,
                    style:
                        const TextStyle(fontSize: 24.0, color: Colors.black87),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 10.0, vertical: 5.0),
                        child: Text(
                          _startBtnMsg,
                          style: const TextStyle(
                              fontSize: 36.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        // color: Colors.blueGrey,
                        onPressed: () {
                          setState(() {
                            _isStart = !_isStart;
                            _startBtnMsg = _isStart ? 'توقف' : 'أبدا';
                          });
                        },
                      ),
                      ElevatedButton(
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 10.0, vertical: 5.0),
                        child: const Text(
                          'تصفير',
                          style: TextStyle(
                              fontSize: 36.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        // color: Colors.blueGrey,
                        onPressed: () async {
                          setState(() {
                            _counter = 0;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
              alignment: Alignment.topRight,
              height: 100.0,
              // color: Colors.yellow,
              child: IconButton(
                icon: const Icon(Icons.info),
                iconSize: 32.0,
                color: Colors.blueGrey,
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'عداد الضغط',
                    applicationVersion: '0.0.1-beta-1',
                    // applicationIcon: const Icon(Icons.info),
                    applicationLegalese: '© Hossam Ezzat | 2023',
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 36.0),
                        child: const Text(
                          "لكي تستخدم الابلكيشن.عليك وضعه اسفل صدرك وبدا اللعب\n",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_displayCounterWidget(var _count) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: Text(
      '$_count',
      style: const TextStyle(
        fontSize: 108.0,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
  );
}

Future<AudioPlayer> _playAudioDing() async {
  AudioCache cache = AudioCache();

  return await cache.play('ding.mp3');
}
