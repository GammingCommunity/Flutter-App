import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

class ConservationProvider {
  var _query = GraphQLQuery();
  var _conservations = <Conservation>[];

  List<Conservation> get getConservation => _conservations;

  int get countConservation => _conservations.length;

  Future refresh() async {
    _conservations.clear();
    await initPrivateConservation();
  }

  Future initPrivateConservation() async {
    var result = await MainRepo.queryGraphQL(await getToken(), _query.getAllPrivateConservation());
    var conservations =
        PrivateConservations.fromJson(result.data['getAllConservation']).conservations;

    this._conservations.addAll(conservations);
  }
}
