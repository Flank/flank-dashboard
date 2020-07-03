import 'package:flutter/foundation.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:mockito/mockito.dart';

class ProjectGroupsNotifierMock extends Mock
    with ChangeNotifier
    implements ProjectGroupsNotifier {}
