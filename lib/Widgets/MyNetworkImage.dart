import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media/Utils/Api.dart';

class MyNetworkImage extends StatefulWidget {
  final String? url;
  const MyNetworkImage({super.key, required this.url});

  @override
  State<MyNetworkImage> createState() => _MyNetworkImageState();
}

class _MyNetworkImageState extends State<MyNetworkImage> {
  late final String? url = widget.url;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${Api.baseURL}/${url!}',
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
