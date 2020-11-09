import 'package:geolocator/geolocator.dart';
import 'package:riderApp/assistance/request.dart';
import 'package:riderApp/configMaps.dart';

class AssistanceMethods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = '';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var response = await RequestAssistance.getRequest(url);

    if (response != 'Failed') {
      placeAddress = response['results'][0]['formatted_address'];
    }
    return placeAddress;
  }
}
