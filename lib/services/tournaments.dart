import 'dart:convert';
import 'package:http/http.dart';
import 'package:brain_bets/constant.dart' as constant;

Future<Map?> getTournaments() async {
  var client = Client();
  var uri = Uri.parse(constant.urlService + constant.uriTournaments);
  Response response = await client.get(uri);
  if(response.statusCode == 200) {
    return json.decode(response.body);
  }

  return null;
}
