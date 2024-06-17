import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 80.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 80.0,
);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white54,
  icon: Icon(
    Icons.location_city,
    size: 30,
  ),
  iconColor: Colors.white,
  hintText: 'Enter City',
  hintStyle: TextStyle(color: Colors.black54),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide.none,
  ),
);

final kTextStyle = GoogleFonts.barlow(
  color: Colors.black54,
  fontSize: 15);

final kHeadingStyle = GoogleFonts.barlow(
    color: Colors.black87,
    fontSize: 18);
const colour=Color.fromRGBO(190, 186, 186, 0.3176470588235294);
