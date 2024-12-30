import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';

class PhotoPreviewScreen extends StatelessWidget {
  final String imagePath;

  const PhotoPreviewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Black background
        Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
        ),

        // Gradient border container
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 1.0],
              colors: [
                Color(0xFF2A85B5), // Lighter blue
                Color(0xFF1B6A9C), // Mid blue
                appTheme.cyan900,   // Current cyan
              ],
            ),
          ),
        ),

        // Main scaffold
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Image preview with gradient border
              Positioned(
                top: MediaQuery.of(context).size.height * 0.12,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2A85B5),
                        appTheme.cyan900,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.h),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // Top bar with close button
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: GestureDetector(
                      onTap: () {
                        // Pop twice to go back to AI chat main page
                        Navigator.pop(context); // Close preview screen
                        Navigator.pop(context); // Close camera screen
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.h,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom section
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 48.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SNAPEAT',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 20.h,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.h,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24.h),
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context, imagePath),
                          child: Text(
                            'Keep',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.h,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'or',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.h,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => Navigator.pop(context, null),
                        child: Text(
                          'Take a different photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 