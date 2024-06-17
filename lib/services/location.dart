import 'package:geolocator/geolocator.dart';

class LocateLocation{
  double latitude=0;
  double longitude=0;
  Future<void> getCurrentLocation() async{
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      longitude=position.longitude;
      latitude=position.latitude;
    }
  }