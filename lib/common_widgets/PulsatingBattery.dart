import 'package:flutter/material.dart';

/**
 * Copyright (C) 2025 Fusion Wallet
 * 
 * This file is part of Fusion Wallet.
 * 
 * Fusion Wallet is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Fusion Wallet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Fusion Wallet.  If not, see <https://www.gnu.org/licenses/>.
 */

class PulsingBatteryIcon extends StatefulWidget {
  final Widget battery;

  PulsingBatteryIcon({required this.battery});

  @override
  _PulsingBatteryIconState createState() => _PulsingBatteryIconState();
}

class _PulsingBatteryIconState extends State<PulsingBatteryIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  

  @override
  void initState() {
    super.initState();
    
    // Create an animation controller with a 2-second duration
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    // Create a curved animation that goes from 0.5 to 1.0 and back
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.5)
          .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);
    
    // Make the animation repeat indefinitely
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
        
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: child,
        );
      },
      child: widget.battery
    );
  }

  @override
  void dispose() {
    // Don't forget to dispose the controller when done
    _controller.dispose();
    super.dispose();
  }
}