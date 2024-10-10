import 'dart:convert';
import 'package:http/http.dart';
import 'package:brain_bets/constant.dart' as constant;

class TournamentsAPI {
  Future<List?> getTournaments() async {
    var client = Client();
    var uri = Uri.parse(constant.urlService + constant.uriTournaments);
    Response response = await client.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body)["result"];
    }
    return null;
  }
}
