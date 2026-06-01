import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppStyles {
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark,
  );
  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark,
  );
  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 14, color: AppColors.textDark,
  );
  static TextStyle greyText = GoogleFonts.poppins(
    fontSize: 13, color: AppColors.textGrey,
  );
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white,
  );
  static TextStyle priceText = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary,
  );
}
