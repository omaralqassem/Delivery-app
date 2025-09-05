import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class MyTimeline extends StatelessWidget {
  bool isFirst;
  bool isLast;
  bool isDone;
  String st;
  MyTimeline(
      {required this.isDone,
      required this.isFirst,
      required this.isLast,
      required this.st,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      child: SizedBox(
        height: 100,
        child: TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          endChild: Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isDone
                    ? const Color.fromARGB(207, 227, 255, 151)
                    : Color.fromARGB(207, 227, 255, 151).withAlpha(3)),
            child: SizedBox(
                height: 40,
                width: 30,
                child: Container(
                    alignment: Alignment.center,
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: st,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isDone
                              ? Color(0xff07120f)
                              : const Color.fromARGB(255, 238, 238, 238),
                        ),
                      )
                    ])))),
          ),
          beforeLineStyle: LineStyle(
            color: isDone
                ? Color.fromARGB(207, 227, 255, 151)
                : Color.fromARGB(207, 227, 255, 151).withAlpha(3),
          ),
          indicatorStyle: IndicatorStyle(
              iconStyle: IconStyle(
                  iconData: Icons.check,
                  color: isDone
                      ? Color.fromARGB(255, 68, 72, 68)
                      : Color.fromARGB(207, 227, 255, 151).withAlpha(10)),
              color: isDone
                  ? Color.fromARGB(255, 227, 255, 151)
                  : Color.fromARGB(207, 227, 255, 151).withAlpha(3),
              width: 40),
        ),
      ),
    );
  }
}
