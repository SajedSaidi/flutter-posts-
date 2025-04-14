import 'package:flutter/material.dart';

class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({required this.child, Key? key}) : super(key: key);

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensures keep-alive state
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
