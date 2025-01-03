import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ProfilePictureService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<String?> uploadProfilePicture(String userId, File imageFile) async {
    try {
      // Read and decode the image
      final image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) return null;
      
      // Calculate target dimensions while maintaining aspect ratio
      int targetSize = 800; // Maximum reasonable size for profile picture
      double ratio = image.width / image.height;
      int targetWidth, targetHeight;
      
      if (ratio > 1) {
        // Landscape
        targetWidth = targetSize;
        targetHeight = (targetSize / ratio).round();
      } else {
        // Portrait or square
        targetHeight = targetSize;
        targetWidth = (targetSize * ratio).round();
      }
      
      // Enhance colors with maximum vibrancy while keeping natural look
      var enhancedImage = img.adjustColor(
        image,
        saturation: 1.2, // Increased color saturation
        brightness: 1.1, // Increased brightness
        contrast: 1.1, // Added contrast for better definition
      );
      
      // Resize the image with highest quality interpolation
      final resized = img.copyResize(
        enhancedImage,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.linear, // Changed to linear for sharper edges
      );
      
      // Try PNG first for maximum quality
      var compressed = img.encodePng(resized);
      var base64Image = base64Encode(compressed);
      
      // If PNG is too large (>800KB), fall back to high-quality JPEG
      if (base64Image.length > 800000) {
        compressed = img.encodeJpg(resized, quality: 95); // Very high quality JPEG
        base64Image = base64Encode(compressed);
      }
      
      // Store in Firestore
      await _firestore.collection('users').doc(userId).update({
        'profilePicture': base64Image,
      });
      
      return base64Image;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }
  
  Future<void> deleteProfilePicture(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profilePicture': FieldValue.delete(),
      });
    } catch (e) {
      print('Error deleting profile picture: $e');
    }
  }
}