import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:rxdart/rxdart.dart';

/// THe [TextField] with the ability to search across projects.
class ProjectSearchInput extends StatefulWidget {
  final Function(String) onFilter;
  final Duration duration;

  /// Creates the [ProjectSearchInput].
  /// 
  /// After a certain [duration] triggers the given [onFilter] function.
  /// The [onFilter] should not be null.
  const ProjectSearchInput({
    Key key,
    @required this.onFilter,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _ProjectSearchInputState createState() => _ProjectSearchInputState();
}

class _ProjectSearchInputState extends State<ProjectSearchInput> {
  final _subject = PublishSubject<String>();
  StreamSubscription _searchSubscription;

  @override
  void initState() {
    super.initState();
    
    _searchSubscription = _subject.debounceTime(widget.duration).listen((value) {
      widget.onFilter(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _subject.add,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: CommonStrings.searchForProject,
      ),
    );
  }

  @override
  void dispose() {
    _searchSubscription?.cancel();
    super.dispose();
  }
}
