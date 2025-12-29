import 'package:go_router/go_router.dart';

void CustomReplacementNavigation(context, String path) {
  GoRouter.of(context).pushReplacement(path);
}

void CustomNavigation(context, String path,{Object? extra}) {
  GoRouter.of(context).push(path,extra: extra);
  
}
