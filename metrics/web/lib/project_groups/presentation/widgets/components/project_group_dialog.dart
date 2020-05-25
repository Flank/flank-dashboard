import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/widgets/base_text_field.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/project_search_input.dart';
import 'package:provider/provider.dart';

class ProjectGroupDialog extends StatefulWidget {
  final String title;

  const ProjectGroupDialog({
    @required this.title,
  }) : assert(title != null);

  @override
  _ProjectGroupDialogState createState() => _ProjectGroupDialogState();
}

class _ProjectGroupDialogState extends State<ProjectGroupDialog> {
  ProjectMetricsNotifier _projectMetricsNotifier;

  @override
  void initState() {
    super.initState();
    _projectMetricsNotifier =
        Provider.of<ProjectMetricsNotifier>(context, listen: false);

    _projectMetricsNotifier.subscribeToProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500.0,
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            BaseTextField(),
            const SizedBox(
              height: 24.0,
            ),
            Text(
              'Choose projects to add',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              height: 250.0,
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Column(
                children: <Widget>[
                  ProjectSearchInput(),
                  Flexible(
                    child: Consumer<ProjectMetricsNotifier>(
                      builder: (_, projectsMetricsNotifier, __) {
                        if (projectsMetricsNotifier.errorMessage != null) {
                          return Container(); //error loading
                        }

                        final projects =
                            projectsMetricsNotifier.projectsMetrics;

                        if (projects == null) return Container(); // no projects

                        if (projects.isEmpty) {
                          return Container(); // empty projects
                          // return const _DashboardTablePlaceholder(
                          //   text: DashboardStrings.noConfiguredProjects,
                          // );
                        }

                        return ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.grey,
                              ),
                              child: CheckboxListTile(
                                checkColor: Colors.yellowAccent,
                                activeColor: Colors.grey,
                                title: Text(
                                  project.projectName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: false,
                                onChanged: (value) {
                                  return null;
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '2 selected',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 24.0,
            ),
            SizedBox(
              width: 250.0,
              height: 50.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  'Save changes',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                color: Colors.grey[900],
                onPressed: () {
                  print('save');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectMetricsNotifier.unsubscribeFromProjects();
    super.dispose();
  }
}
