import 'package:animated_background/animated_background.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';
import '../../extensions/app_button.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../../extensions/shared_pref.dart';
import '../../extensions/system_utils.dart';
import '../../extensions/text_styles.dart';
import 'dart:async';
import 'dart:math';
import '../../logic/game_data.dart';
import '../../main.dart';
import '../../network/rest_api.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_images.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  GameData gameData = GameData();

  late Timer timer;
  int timeLeft = 5;

  int gridSize = 2;
  Color? targetColor;
  Color? dummyColor;

  Random random = Random();

  var isReverse = false;

  final CountDownController _controllerTime = CountDownController();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAnimating = false;
  Offset _startPosition = Offset.zero;
  Offset _endPosition = Offset.zero;
  final List<GlobalKey> _boxKeys = List.generate(100, (_) => GlobalKey());
  final GlobalKey _actionBarKey = GlobalKey();

  List<bool> _starVisibilities = [false, false, false, false, false];

  @override
  void dispose() {
    timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    gridSize = gameData.getGridSize();
    gameData.targetIndex = random.nextInt(pow(gridSize, 2).toInt() - 1);
    nextColor();
    startTimer();
  }

  _startStarAnimation() async {
    for (int i = 0; i < _starVisibilities.length; i++) {
      //await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        _starVisibilities[i] = true;
      });
    }
  }

  Future<void> saveScoreApi() async {
    print("-------->>>${getStringAsync(COUNTRY_CODE)}");
    if (gameData.score > 10) {
      Map req = {
        'score': gameData.score,
        'country_code': getStringAsync(COUNTRY_CODE),
      };
      await saveScore(req).then((value) {}).catchError((error) {
        log(error);
      });
    }
  }

  void _startAnimation(int index) {
    RenderBox? box =
        _boxKeys[index].currentContext?.findRenderObject() as RenderBox?;
    RenderBox? actionBar =
        _actionBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      setState(() {
        _isAnimating = true;
        _startPosition = box.localToGlobal(Offset.zero);
        _endPosition =
            actionBar!.localToGlobal(Offset(actionBar.size.width - 40, -8));
      });

      // Reset animation after completion
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (timer) {
        if (gameData.isPlaying) {
          if (timeLeft == 0) {
            setState(() {
              timer.cancel();
            });
            endGame();
          } else {
            setState(() {
              timeLeft--;
            });
          }
        }
      },
    );
  }

  void nextLevel(index) {
    setState(() {
      _startAnimation(index);
      gameData.nextLevel(timeLeft);
      gridSize = gameData.getGridSize();
      //_controller.isStarted;
      _playSound('sounds/coins.mp3');
      timeLeft = gameData.level >= 15 ? 10 : 5;
      _controllerTime.restart(duration: timeLeft);
    });
    nextColor();
  }

  void endGame() async {
    await _startStarAnimation();

    setState(() {
      gameData.endGame();
      _playSound('sounds/wrong.mp3');
    });

    _showFreeDiscountDialog(context);
    saveScoreApi();
  }

  /* void continuePlaying() {
    setState(() {
      gameData.isPlaying = true;
      // timeLeft = 10;
    });
    startTimer();
    nextLevel();
  }*/
  Future<void> _playSound(String filePath) async {
    await _audioPlayer.play(AssetSource(filePath));
  }

  void nextColor() {
    // Random random = Random();
    int r = random.nextInt(255);
    int g = random.nextInt(255);
    int b = random.nextInt(255);

    int minOffset = 6;
    int offset = 50;

    if (gridSize == 3) {
      offset = 25;
    } else if (gridSize == 4) {
      offset = 12;
    } else if (gridSize == 5) {
      offset = 6;
    }

    // Offset is always guaranteed to be exactly the same.
    int rOffset = minOffset + random.nextInt(offset);
    int gOffset = minOffset + random.nextInt(offset);
    int bOffset = minOffset + random.nextInt(offset);

    if (r + rOffset > 255) rOffset = -rOffset;
    if (g + gOffset > 255) gOffset = -gOffset;
    if (b + bOffset > 255) bOffset = -bOffset;

    setState(() {
      targetColor = Color.fromRGBO(r + rOffset, g + gOffset, b + bOffset, 1.0);
      dummyColor = Color.fromRGBO(r, g, b, 1);
    });
  }

  int normalize(int value, {int min = 0, int max = 255}) {
    if (value < min) {
      return min;
    } else if (value > max) {
      return max;
    } else {
      return (min + (value * (max - min) / max)).floor();
    }
  }

  ParticleOptions particleOptions = ParticleOptions(
    baseColor: primaryColor,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    // maxOpacity: 0.3,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 40,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: appStore.isDarkMode ? socialBackground : Colors.white,
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
            options: particleOptions, paint: particlePaint),
        vsync: this,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: 5,
                  right: 0,
                  child: Row(
                    key: _actionBarKey,
                    children: [
                      Image.asset(ic_coin, height: 27, width: 27),
                      10.width,
                      Text("${gameData.score}",
                          style: primaryTextStyle(size: 22)),
                      10.width,
                    ],
                  )),
              Positioned(
                  top: 5,
                  left: 5,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          finish(context);
                        },
                        child: Icon(
                          Octicons.chevron_left,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                      10.width,
                      Text(
                        "${languages.lblLevel}: ${gameData.level}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appStore.isDarkMode
                                ? Colors.white
                                : scaffoldColorDark,
                            fontSize: 18),
                      ),
                    ],
                  )),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularCountDownTimer(
                        duration: timeLeft,
                        initialDuration: 0,
                        controller: _controllerTime,
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 3,
                        ringColor: Colors.grey[300]!,
                        ringGradient: null,
                        fillColor: primaryLightColor,
                        fillGradient: null,
                        backgroundColor: primaryColor,
                        backgroundGradient: null,
                        strokeWidth: 13.0,
                        strokeCap: StrokeCap.round,
                        textStyle: const TextStyle(
                          fontSize: 33.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textFormat: CountdownTextFormat.S,
                        isReverse: true,
                        isReverseAnimation: true,
                        isTimerTextShown: true,
                        autoStart: true,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: gridSize,
                            children:
                                List.generate(pow(gridSize, 2) as int, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () async {
                                      if (gameData.targetIndex == index) {
                                        nextLevel(index);
                                      } else {
                                        endGame();
                                      }
                                    },
                                    child: Ink(
                                      key: _boxKeys[index],
                                      decoration: ShapeDecoration(
                                        color: gameData.targetIndex == index
                                            ? targetColor
                                            : dummyColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        shadows: [
                                          BoxShadow(
                                            color:
                                                (gameData.targetIndex == index
                                                        ? targetColor
                                                        : dummyColor)!
                                                    .withValues(alpha: 0.3),
                                            blurRadius: 10.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0, 0),
                                          ),
                                          BoxShadow(
                                            color:
                                                (gameData.targetIndex == index
                                                        ? targetColor
                                                        : dummyColor)!
                                                    .withValues(alpha: 0.3),
                                            blurRadius: 20.0,
                                            spreadRadius: 5.0,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      height: 50,
                                      width: 50,
                                    )),
                              );
                            }),
                          ),
                        ),
                      ),
                    ]),
              ),
              if (_isAnimating)
                TweenAnimationBuilder(
                  tween:
                      Tween<Offset>(begin: _startPosition, end: _endPosition),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  builder: (context, Offset value, child) {
                    return Positioned(
                      left: value.dx,
                      top: value.dy,
                      child: Hero(
                        tag: 'coin',
                        child: Image.asset(ic_coin, height: 27, width: 27),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> gameOver() async {
    await showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          // ignore: deprecated_member_use
          return WillPopScope(
            onWillPop: () async {
              // Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushReplacementNamed(context, '/home');
              return false;
            },
            child: SimpleDialog(
              title: Center(
                child: Text(
                  languages.lblGameOver,
                  style: primaryTextStyle(size: 28),
                ),
              ),
              children: [
                /* SimpleDialogOption(
                  onPressed: () {
                    // Navigator.popUntil(context, ModalRoute.withName('/home'));
                    // return true;
                    // this.deactivate();}
                    // Navigator.
                    Navigator.pop(context, true);
                    continuePlaying();
                    // return true;
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Continue ', style: primaryTextStyle(size: 22)),
                        Icon(
                          Icons.movie,
                          size: 25,
                        )
                      ]),
                ),*/
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, true);
                    Navigator.pop(context, true);
                    Navigator.pop(context, true);
                  },
                  child: Center(
                      child: Text(languages.lblMainMenu,
                          style: primaryTextStyle(size: 22))),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildStar(int index) {
    return AnimatedOpacity(
      opacity: _starVisibilities[index] ? 1.0 : 0.0,
      duration: Duration(milliseconds: 100),
      child: Lottie.asset(
        'assets/star.json',
        width: 90,
        height: 90,
        repeat: false,
      ),
    );
  }

  _showFreeDiscountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            return false;
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.transparent,
            elevation: 10,
            child: Container(
                padding: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (gameData.level > 5)
                          SizedBox(width: 50, height: 50, child: _buildStar(0)),
                        if (gameData.level > 15)
                          SizedBox(width: 50, height: 50, child: _buildStar(1)),
                        if (gameData.level > 30)
                          SizedBox(width: 50, height: 50, child: _buildStar(2)),
                        if (gameData.level > 40)
                          SizedBox(width: 50, height: 50, child: _buildStar(3)),
                        if (gameData.level > 50)
                          SizedBox(width: 50, height: 50, child: _buildStar(4)),
                      ],
                    ),
                    Lottie.asset('assets/gameover.json',
                        width: 180, height: 180),
                    Text(
                      languages.lblBetterLuckNextTime,
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(
                          size: 16,
                          weight: FontWeight.bold,
                          color: appStore.isDarkMode
                              ? Colors.white
                              : scaffoldColorDark),
                    ),
                    10.height,
                    AppButton(
                      text: languages.lblExit,
                      width: context.width(),
                      color: Colors.red,
                      onTap: () async {
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      },
                    ).paddingSymmetric(horizontal: 20, vertical: 13),
                    10.height,
                  ],
                )),
          ),
        );
      },
    );
  }
}
