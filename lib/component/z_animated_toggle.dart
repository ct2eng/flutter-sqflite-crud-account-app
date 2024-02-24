import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ZAnimatedToggle extends StatefulWidget {
  final toggleBackgroundColor;
  bool tradeSts;
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color selectColor1;
  final Color selectColor2;
  ZAnimatedToggle({
    Key key,
    @required this.tradeSts,
    @required this.selectColor1,
    @required this.selectColor2,
    @required this.toggleBackgroundColor,
    @required this.values,
    @required this.onToggleCallback,
  }) : super(key: key);

  @override
  _ZAnimatedToggleState createState() => _ZAnimatedToggleState();
}

class _ZAnimatedToggleState extends State<ZAnimatedToggle>
    with SingleTickerProviderStateMixin {
  bool tradeSts;
  bool _canVibrate = true;

  Animation<Color> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    tradeSts = widget.tradeSts;

    controller = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);
    animation = ColorTween(begin: widget.selectColor1, end: widget.selectColor2)
        .animate(controller)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation object’s value.
            });
          });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void animateColor(bool sts) {
    // tradeSts ? widget.selectColor1 : widget.selectColor2
    if (!sts) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: width * .7,
      height: 30,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_canVibrate) Vibrate.feedback(FeedbackType.impact);
              setState(() {
                tradeSts = !tradeSts;
              });
              widget.onToggleCallback(tradeSts);
              animateColor(tradeSts);
            },
            child: Container(
              width: width * .7,
              height: 30,
              decoration: ShapeDecoration(
                  color: widget.toggleBackgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * .1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    // padding: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.symmetric(horizontal: width * .1),
                    child: Text(
                      widget.values[index],
                      style: TextStyle(
                          fontSize: width * .045, color: Colors.blueGrey[200]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            alignment: tradeSts ? Alignment.centerLeft : Alignment.centerRight,
            duration: Duration(milliseconds: 350),
            curve: Curves.ease,
            child: Container(
              alignment: Alignment.center,
              width: width * .35,
              height: 30,
              decoration: ShapeDecoration(
                  color: animation.value,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  // shadows: themeProvider.themeMode().shadow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * .1))),
              child: Text(
                tradeSts ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  color: tradeSts ? Colors.white : Colors.blueGrey[900],
                  fontSize: width * .045,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
