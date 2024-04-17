import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/helper_functions.dart';

class CustomContainerConclusion extends StatefulWidget {
  final Icon? icon;
  final String title;
  final String subtitle;
  final String trendsText;
  final double? widthScreen;
  final bool? trendState;


  const CustomContainerConclusion({
    Key? key,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.trendsText,
    this.trendState,
    this.widthScreen,
  }) : super(key: key);

  @override
  _CustomContainerConclusionState createState() =>
      _CustomContainerConclusionState();
}

class _CustomContainerConclusionState extends State<CustomContainerConclusion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widthScreen ?? NHelperFunctions.screenWidth(context) * 0.4,
      height: NHelperFunctions.screenHeight(context) * 0.2,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xff503F95), // Set the background color
        borderRadius: BorderRadius.circular(20), // Set the border radius
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon(Icons.abc),
              SizedBox(width: 15),
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                // fontSize: 16.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: widget.subtitle,
                  style: TextStyle(
                  ),
                ),
                // TextSpan(text: subtitle),
                TextSpan(
                  text: (widget.trendState ?? false) ? "naik" : "turun",
                  style: TextStyle(
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 15),
              Container(
                width: NHelperFunctions.screenWidth(context) * 0.5,
                height: NHelperFunctions.screenHeight(context) * 0.05,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: (widget.trendState ?? false) ? Color(0xff36CBD8) : Colors.redAccent, // Set the background color
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius
                ),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      (widget.trendState ?? false)
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      // color: Colors.white,
                      size: 15,
                    ),
                    Text(
                      " ${widget.trendsText} %",
                      style: TextStyle(
                          // color: Colors.white
                          ),
                    ),
                  ],
                )),
              ),
        ],
      ),
    );
  }
}
