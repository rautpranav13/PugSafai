// lib/utils/media_location_helper.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MediaLocationHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick multiple images from gallery
  static Future<List<File>> pickImagesFromGallery({int maxImages = 5}) async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      return pickedFiles.take(maxImages).map((x) => File(x.path)).toList();
    } catch (e) {
      print("Error picking images: $e");
      return [];
    }
  }

  /// Capture a photo from camera
  static Future<File?> captureImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null) return File(pickedFile.path);
      return null;
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }

  /// Get current GPS coordinates
  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services disabled");
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied");
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  /// Reverse-geocode coordinates to address
  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return "${p.name}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
      }
      return "";
    } catch (e) {
      print("Error getting address: $e");
      return "";
    }
  }
}
