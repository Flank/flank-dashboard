import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:provider/provider.dart';

// ignore_for_file: public_member_api_docs

abstract class PageNotifier extends ChangeNotifier {
  Stream<PageParameters> get pageParametersUpdatesStream;

  void handlePageParameters(PageParameters parameters);
}

class PageParametersDispatcher extends StatefulWidget {
  final List<PageNotifier> pageNotifiers;
  final Widget child;

  const PageParametersDispatcher({
    Key key,
    this.pageNotifiers = const [],
    this.child,
  }) : super(key: key);

  @override
  _PageParametersDispatcherState createState() =>
      _PageParametersDispatcherState();
}

class _PageParametersDispatcherState extends State<PageParametersDispatcher> {
  NavigationNotifier _navigationNotifier;
  StreamSubscription<PageParameters> _pageParametersSubscription;
  List<StreamSubscription<PageParameters>> _pageParametersUpdatesSubscriptions =
      [];

  void _pageParametersListener(PageParameters pageParameters) {
    print(pageParameters?.toQueryParameters());

    for (final pageNotifier in widget.pageNotifiers) {
      pageNotifier.handlePageParameters(pageParameters);
    }
  }

  void _pageParametersUpdatesListener(PageParameters pageParameters) {}

  @override
  void initState() {
    super.initState();

    _navigationNotifier = Provider.of<NavigationNotifier>(
      context,
      listen: false,
    );

    _pageParametersSubscription =
        _navigationNotifier.pageParametersStream.listen(
      _pageParametersListener,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
