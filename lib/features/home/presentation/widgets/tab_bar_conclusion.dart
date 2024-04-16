import 'package:flutter/material.dart';

class ConclusionScreen extends StatefulWidget{
  @override
  _ConclusionScreenState createState() => _ConclusionScreenState();
}

class _ConclusionScreenState extends State<ConclusionScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              "Kesimpulan",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xff503F95)),
            ),
            SizedBox(height: 15),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Berat menunjukkan trend naik\n',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13
                    ),// Set your desired color
                  ),
                  TextSpan(
                    text: 'Tinggi menunjukkan trend naik\n',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 13
                    ),
                  ),
                  TextSpan(
                    text: 'LingkarKepala menunjukkan trend naik\n',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 13
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Fuzzy",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xff503F95)),
            ),
            Text("Normal + Mikrosefali",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 13
              ),
            ),
          ],
        ),
      ),
    );
  }

}