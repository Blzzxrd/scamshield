import 'package:flutter/material.dart';

const pixelInk = Color(0xFF2D2354);
const pixelPurple = Color(0xFF51418A);
const pixelSky = Color(0xFFE8F7FB);
const pixelMint = Color(0xFFD8F1EC);
const pixelGrass = Color(0xFF48C82F);
const pixelGold = Color(0xFFFFCA42);
const pixelCream = Color(0xFFFFFDF4);
const pixelMuted = Color(0xFF625B77);

BoxDecoration pixelPanel(Color color, {bool shadow = true}) => BoxDecoration(
      color: color,
      border: Border.all(color: pixelInk, width: 2),
      boxShadow: shadow
          ? const [BoxShadow(color: pixelInk, offset: Offset(5, 5))]
          : null,
    );

TextStyle pixelHeading(double size, {Color color = pixelInk}) => TextStyle(
      fontFamily: 'Silkscreen',
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.15,
      color: color,
    );
