import 'package:go_router/go_router.dart';
import 'package:sotti/navigation/routes.dart';
import 'package:sotti/page/sotti_detail.dart';
import 'package:sotti/page/sotti_maps.dart';

final router = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => SottiHomePage(),
    ),
    GoRoute(
      path: Routes.map,
      builder: (context, state) => SottiMaps(),
    ),
  ],
);
