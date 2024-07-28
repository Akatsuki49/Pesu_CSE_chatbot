import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SahaiCredits extends StatefulWidget {
  @override
  _SahaiCreditsState createState() => _SahaiCreditsState();
}

class _SahaiCreditsState extends State<SahaiCredits>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;

  bool _isFirstAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeIn,
    );

    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFirstAnimationComplete = true;
        });
        _controller2.repeat();
        _fadeInController.forward();
      }
    });

    _controller1.forward();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'assets/images/credits_animation.json',
            controller: _controller1,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          if (_isFirstAnimationComplete)
            Center(
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top:
                                30.0), // Adjust top padding to move the animation higher
                        child: SizedBox(
                          width: screenWidth * 0.5,
                          height: screenHeight * 0.3,
                          child: Lottie.asset(
                            'assets/images/credits2_animation.json',
                            controller: _controller2,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            screenHeight * 0.02), // Adjust space for the text
                    const Text(
                      'Developed with love <3',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10), // Spacing between the lines
                    const Text(
                      'by\nSiddhant\nShubham\nSowmesh\nShubh',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
