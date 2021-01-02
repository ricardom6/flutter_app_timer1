import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountDownTimer(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.red,
      ),
    );
  }
}

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
  }

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;
  int tempo = 30;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: tempo),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    //color: Colors.amber,
                    color: Colors.green[600],
                    height:
                    controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                        animation: controller,
                                        backgroundColor: Colors.white,
                                        color: themeData.indicatorColor,
                                      )),
                                ),//circulo
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,//.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "CANASTRA",
                                        style: TextStyle(
                                            fontSize: 40.0,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "TIMER",
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 112.0,
                                            color: Colors.white),

                                      ),
                                      AnimatedBuilder(
                                          animation: controller,
                                          builder: (context, child) {
                                          return RaisedButton(
                                            child: const Text('ADD'),

                                          color: Colors.white,

                                          onPressed: () {
                                              controller.reverse(
                                          from: controller.value != 0.0
                                          ? controller.value + 0.333
                                              : controller.value);
                                          },
                                            textColor: Colors.black,
                                          );},
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),//expanded
                      AnimatedBuilder(

                          animation: controller,
                          builder: (context, child) {
                            //return FloatingActionButton.extended(
                            return FloatingActionButton.extended(
                                backgroundColor: Colors.green[800],
                                onPressed: () {
                                  if (controller.isAnimating){
                                    //controller.stop();

                                    controller.reverse(
                                        from: controller.value != 0.0
                                            ? 1.0
                                            : controller.value);
                                    //controller.value = 0.6;
                                    //controller.duration = Duration(seconds: (30));
                                  }else {
                                    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
                                  }
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.refresh
                                    : Icons.play_arrow),
                                label: Text(
                                    controller.isAnimating ? "REINICIAR" : "Play"));
                          }),

                      Container(
                        height: 100,
                        width: 1000,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return RaisedButton(
                                  child: const Text('- tempo'),

                                  color: Colors.white,

                                  onPressed: () {
                                    if (tempo > 5)
                                    controller.duration = Duration (seconds: --tempo);
                                    controller.reverse(
                                        from: true
                                            ? 1.0
                                            : controller.value);
                                    controller.stop();
                                  },
                                  textColor: Colors.black,
                                );},
                            ),
                            AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return RaisedButton(
                                  child: const Text('+ tempo'),
                                  color: Colors.white,

                                  onPressed: () {
                                    controller.duration = Duration (seconds: ++tempo);
                                    controller.reverse(
                                        from: true
                                            ? 1.0
                                            : controller.value);
                                    controller.stop();
                                  },
                                  textColor: Colors.black,
                                );},
                            ),
                          ],
                        ),

                      ),

                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}