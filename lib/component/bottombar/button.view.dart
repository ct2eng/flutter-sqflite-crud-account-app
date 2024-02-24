import 'package:flutter/material.dart';

// 小按鈕
class PandaBarButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;

  final Function onTap;

  final Color selectedColor;
  final Color unselectedColor;

  const PandaBarButton(
      {Key key,
      this.isSelected = false,
      this.icon = Icons.dashboard,
      this.selectedColor,
      this.unselectedColor,
      this.title = '',
      this.onTap})
      : super(key: key);

  @override
  _PandaBarButtonState createState() => _PandaBarButtonState();
}

class _PandaBarButtonState extends State<PandaBarButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    //彈跳特效
    animation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 5), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 5, end: 0), weight: 50),
    ]).chain(CurveTween(curve: Curves.bounceOut)).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: widget.onTap,
        onHighlightChanged: (touched) {
          if (!touched) {
            animationController.forward().whenCompleteOrCancel(() {
              animationController.reset();
            });
          }
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon,
                  color: widget.isSelected
                      ? (widget.selectedColor ?? Color(0xFF078DF0))
                      : (widget.unselectedColor ?? Color(0xFF9FACBE))),
              Container(
                height: animation.value,
              ),
              Text(widget.title,
                  style: TextStyle(
                      color: widget.isSelected
                          ? (widget.selectedColor ?? Color(0xFF078DF0))
                          : (widget.unselectedColor ?? Color(0xFF9FACBE)),
                      fontWeight: FontWeight.bold,
                      fontSize: 10))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
