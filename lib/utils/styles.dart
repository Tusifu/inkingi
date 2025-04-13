import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/constants/colors.dart';

abstract class Styles {
  // H1
  static TextStyle h1HeadingWithPrimaryColor200 = GoogleFonts.outfit(
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    letterSpacing: 0,
    height: 44.0 / 36.0,
  );
  static TextStyle h1HeadingWithBlackColor200 = GoogleFonts.outfit(
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 44.0 / 36.0,
  );

  // H2
  static TextStyle h2HeadingWithPrimaryColor200 = GoogleFonts.outfit(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    letterSpacing: 0,
    height: 36.0 / 28.0,
  );
  static TextStyle h2HeadingWithBlackColor200 = GoogleFonts.outfit(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 36.0 / 28.0,
  );

  // H3

  static TextStyle h3HeadingWithBlackColor200 = GoogleFonts.outfit(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 32.0 / 28.0,
  );

  // H4

  static TextStyle h4HeadingWithBlackColor200 = GoogleFonts.outfit(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 28.0 / 20.0,
  );

  // H5

  static TextStyle h5HeadingWithBlackColor200 = GoogleFonts.outfit(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 26.0 / 18.0,
  );

  // H6
  static TextStyle h6HeadingWithPrimaryColor100 = GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    letterSpacing: 0,
    height: 24.0 / 16.0,
  );
  static TextStyle h6HeadingWithBlackColor100 = GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 24.0 / 16.0,
  );
  static TextStyle h6HeadingWithBlackColor200 = GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 24.0 / 16.0,
  );

  static TextStyle h6HeadingWithGrey500Color100 = GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor500,
    letterSpacing: 0,
    height: 24.0 / 16.0,
  );
  static TextStyle h6HeadingWithGrey500Color200 = GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.greyColor500,
    letterSpacing: 0,
    height: 24.0 / 16.0,
  );
  static TextStyle h6HeadingWithWhiteColor100 = GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor50,
    letterSpacing: 0,
    height: 24.0 / 16.0,
  );
  static TextStyle h6HeadingWithGrey300Color100 = GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor300,
    letterSpacing: 0,
    height: 24.0 / 16.0,
  );
  static TextStyle h6HeadingWithGrey700Color100 = GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor700,
    letterSpacing: 0,
    height: 24.0 / 16.0,
  );

  // H7
  static TextStyle h7HeadingWithPrimaryColor = GoogleFonts.outfit(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    letterSpacing: 0,
    height: 16.0 / 14.0,
  );
  static TextStyle h7HeadingWithBlackColor = GoogleFonts.outfit(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 16.0 / 14.0,
  );
  static TextStyle h7HeadingWithBlackColor200 = GoogleFonts.outfit(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
    letterSpacing: 0,
    height: 16.0 / 14.0,
  );

  static TextStyle h7HeadingWithGreyColor500 = GoogleFonts.outfit(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor500,
    letterSpacing: 0,
    height: 16.0 / 14.0,
  );
  static TextStyle h7HeadingWithGreyColor700 = GoogleFonts.outfit(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor700,
    letterSpacing: 0,
    height: 16.0 / 14.0,
  );

  // H8

  static TextStyle h8HeadingWithPrimary100 = GoogleFonts.outfit(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryColor,
    letterSpacing: 0,
    height: 16.0 / 12.0,
  );
  static TextStyle h8HeadingWithBlackColor100 = GoogleFonts.outfit(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    letterSpacing: 0,
    height: 16.0 / 12.0,
  );
  static TextStyle h8HeadingWithGreyColor500 = GoogleFonts.outfit(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor500,
    letterSpacing: 0,
    height: 16.0 / 12.0,
  );
  static TextStyle h8HeadingWithGreyColor700 = GoogleFonts.outfit(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor700,
    letterSpacing: 0,
    height: 16.0 / 12.0,
  );
  static TextStyle h8HeadingWithSuccess500 = GoogleFonts.outfit(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.success500,
    letterSpacing: 0,
    height: 16.0 / 12.0,
  );
}
