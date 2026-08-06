import 'package:flutter/material.dart';


class MotionEngine {
  MotionEngine._();

  
  static const Curve cinematic = Curves.easeInOutCubic;
  static const Curve friction = Curves.easeOutExpo;
  static const Curve magnetic = Curves.easeOutBack;
  static const Curve emergence = Curves.easeOutQuart;

  
  static const Duration micro = Duration(
    milliseconds: 150,
  ); 
  static const Duration swift = Duration(
    milliseconds: 350,
  ); 
  static const Duration standard = Duration(
    milliseconds: 700,
  ); 
  static const Duration cinematicDuration = Duration(
    milliseconds: 1400,
  ); 
}
