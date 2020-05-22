import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card_list.dart';

class ProjectGroupPage extends StatefulWidget {
  @override
  _ProjectGroupPageState createState() => _ProjectGroupPageState();
}

class _ProjectGroupPageState extends State<ProjectGroupPage> {
  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: ProjectGroupCardList(),
    );
  }
}
