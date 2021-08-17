import 'package:flutter/material.dart';

const int _defaultMillSeconds = 300;

///
/// desc: WriteText 是逐步显示文本的动画组件，像手写一样的效果。
///
class WriteText extends StatefulWidget {
  ///
  /// 数据
  ///
  final String data;

  final bool showCursor;

  final Widget? cursor;

  final int perMillSeconds;

  final TextStyle? textStyle;

  final bool autoStart;

  final WriteTextController? controller;

  const WriteText({
    Key? key,
    required this.data,
    this.controller,
    this.showCursor = true,
    this.cursor,
    this.perMillSeconds = _defaultMillSeconds,
    this.textStyle,
    this.autoStart = true,
  })  : assert(data != null, 'data cannot be null'),
        assert(perMillSeconds != null, 'perDuration cannot be null'),
        super(key: key);

  @override
  _WriteTextState createState() => _WriteTextState();
}

class _WriteTextState extends State<WriteText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: widget.perMillSeconds * widget.data.length));
    if (widget.autoStart) {
      _animationController.forward();
    }
    if (widget.controller != null) {
      widget.controller!._setStepTextState(this);
    }
    super.initState();
  }

  start() {
    _animationController.forward();
  }

  stop() {
    _animationController.stop();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        int endIndex =
            (widget.data.length * _animationController.value).floor();
        var text = widget.data.substring(0, endIndex);
        return RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <InlineSpan>[
                TextSpan(
                    text: '$text ', style: widget.textStyle ?? TextStyle()),
                if (widget.showCursor)
                  WidgetSpan(
                      child: StepTextCursor(
                    cursor: widget.cursor ?? const _DefaultCursor(),
                  )),
              ]),
        );
      },
    );
  }
}

class StepTextCursor extends StatefulWidget {
  final Widget cursor;

  const StepTextCursor({Key? key, required this.cursor}) : super(key: key);

  @override
  _StepTextCursorState createState() => _StepTextCursorState();
}

class _StepTextCursorState extends State<StepTextCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: _controller.value,
            child: widget.cursor,
          );
        });
  }
}

class _DefaultCursor extends StatelessWidget {
  const _DefaultCursor();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 3,
      color: Theme.of(context).primaryColor,
    );
  }
}

class WriteTextController {
  late _WriteTextState _stepTextState;

  void _setStepTextState(_WriteTextState __stepTextState) {
    this._stepTextState = __stepTextState;
  }

  start() {
    _stepTextState.start();
  }

  stop() {
    _stepTextState.stop();
  }
}
