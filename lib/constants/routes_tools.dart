import 'package:flutter/material.dart';

void moveToPage({
  required BuildContext context,
  required String route,
}) {
  Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
}

void moveToPageOn({
  required BuildContext context,
  required String route,
  required RoutePredicate predicate,
}) {
  Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
}

void shiftPage({
  required BuildContext context,
  required String route,
}) {
  Navigator.of(context).pushNamed(route);
}
