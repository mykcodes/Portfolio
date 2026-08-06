import 'package:flutter/material.dart';



class MotionSystem {
  MotionSystem._();

  
  static const Curve cinematic = Curves.easeInOutCubic;
  static const Curve deceleration = Curves.easeOutCubic;
  static const Curve acceleration = Curves.easeInCubic;

  
  static const Duration micro = Duration(
    milliseconds: 200,
  ); 
  static const Duration swift = Duration(
    milliseconds: 350,
  ); 
  static const Duration standard = Duration(
    milliseconds: 600,
  ); 
  static const Duration cinematicDuration = Duration(
    milliseconds: 1200,
  ); 
}
