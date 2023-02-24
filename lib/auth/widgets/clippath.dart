import 'package:chatapp/commun/colors/colors.dart';
import 'clip.dart';
import 'package:flutter/cupertino.dart';

class CPath extends StatefulWidget {
  const CPath({super.key});

  @override
  State<CPath> createState() => _CPathState();
}

class _CPathState extends State<CPath> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: Clipper(),
      child: Container(
        width: size.width,
        height: size.height / 1.6,
        color: all,
        child: Column(
          children: const [
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
