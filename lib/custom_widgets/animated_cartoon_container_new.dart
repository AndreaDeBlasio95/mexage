import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/custom_themes.dart';

class AnimatedCartoonContainerNew extends StatefulWidget {
  final Widget child;
  final Future<void> Function() callbackFunction;
  final Color? colorCard;
  final Color? colorCardOutline;

  const AnimatedCartoonContainerNew({super.key, required this.child, required this.callbackFunction, this.colorCard, this.colorCardOutline});

  @override
  _AnimatedCartoonContainerNewState createState() => _AnimatedCartoonContainerNewState();
}

class _AnimatedCartoonContainerNewState extends State<AnimatedCartoonContainerNew> {
  bool _isPressed = false;
  final double _shadowSize = 6.0;
  bool _isButtonActive = true; // State variable to track button activity


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () async {
          if (_isButtonActive) {
            setState(() {
              _isButtonActive = false; // Deactivate the button when pressed
            });
            await widget.callbackFunction();
          }
        },
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          curve: Curves.ease,
          margin: EdgeInsets.only(bottom: _isPressed ? 0 : _shadowSize, top: _isPressed ? _shadowSize : 0,),
          decoration: BoxDecoration(
            color: widget.colorCardOutline ?? themeProvider.cCardColorToOpenOutline,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            curve: Curves.ease,
            padding: EdgeInsets.only(bottom: _isPressed ? _shadowSize : 0),
            margin: EdgeInsets.only(bottom: _isPressed ? 0 : _shadowSize),
            decoration: BoxDecoration(
              color: widget.colorCard ?? themeProvider.cCardColorToOpen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}