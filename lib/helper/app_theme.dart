import 'package:flutter/material.dart';

// added all  thecolors, text styles, and input decorations used throughout Radar.
class AppTheme {
  // ── main/brand colors ───
  static const Color splashDark = Color.fromRGBO(1,1,13,1);// darkest navy
  static const Color splashMid  = Color.fromRGBO(15,46,68,1); //mid navy
  static const Color ctaGreen   = Color.fromRGBO(132,183,156,1); // Sign In/Get Started button
  static const Color ink        = Color.fromARGB(255, 15, 14, 11); // near-black text
  static const Color muted      = Color.fromARGB(255, 144, 141, 129); // placeholder text
  static const Color border     = Color.fromARGB(255, 208, 239, 203); //input borders when focuse
  static const Color surface    = Color(0xFFFFFFFF);// card backgrounds
  static const Color scaffold   = Color.fromARGB(255, 247, 245, 240);// off-white page bg
  static const Color danger     = Color(0xFFC0392B);//errors / delete
  static const Color chipSelected = Color(0xFF1A1A18); //selected interest chip bg
  
//Mission status badge colors
  static const Color badgeActive    = Color.fromRGBO(17, 0, 255, 0.2);
  static const Color badgePending   = Color.fromRGBO(255, 208, 0, 0.2);
  static const Color badgeDone      = Color.fromRGBO(4, 255, 0, 0.2);

  //for border
  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
  );

}