import 'package:brain_bets/api/tournaments.dart';

class TournamentsService {
  Future<List?> getTournaments() async {
    var api = TournamentsAPI();
    List? tournaments = await api.getTournaments();
    return tournaments;
  }
}