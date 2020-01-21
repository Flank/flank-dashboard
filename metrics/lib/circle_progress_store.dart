import 'package:metrics/models/circle_progress_model.dart';
import 'package:metrics/repository/circle_progress_repository.dart';

class CircleProgressStore 
{
  final CircleProgressRepository _circleProgressRepository;
  CircleProgressStore(this._circleProgressRepository);

  CircleProgressModel _circleProgressModelCoverage;
  CircleProgressModel get circleProgressModelCoverage => _circleProgressModelCoverage;
  CircleProgressModel _circleProgressModelStability;
  CircleProgressModel get circleProgressModelStability => _circleProgressModelStability;

  void getCircleProgressCoverage() async 
  {
    _circleProgressModelCoverage =
        await _circleProgressRepository.fetchProgressCoverage();      
  }

void getCircleProgressStability() async 
  {
    _circleProgressModelStability =
        await _circleProgressRepository.fetchProgressStability();      
  }

}
