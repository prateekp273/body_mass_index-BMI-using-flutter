import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FlutterApp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const DashBoardScreen(),
    );
  }
}

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  var wtController = TextEditingController();
  var ftController = TextEditingController();
  var inController = TextEditingController();

  var result = "";
  var bgColor  = Colors.indigo.shade200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI"),
      ),
      body: Container(
        color: bgColor,
        child: Center(
          child: Container(
            width:300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  'BMI',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 21,),
                TextField(
                  controller: wtController,
                  decoration: InputDecoration(
                    label: Text('Enter your Weight in kgs)'),
                    prefixIcon: Icon(Icons.line_weight)
                  ),
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 11,),
                TextField(
                  controller: inController,
                  decoration: InputDecoration(
                    label: Text('Enter your Height(in Feet)'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 11,),


                TextField(
                  controller: ftController,
                  decoration: InputDecoration(
                    label: Text('Enter your Height (in inch)'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),

                  SizedBox(height: 16,),

                  ElevatedButton(onPressed: (){

                    var wt = wtController.text.toString();
                    var ft = ftController.text.toString();
                    var inch = inController.text.toString();

                    if(wt!="" && ft!="" && inch!="") {


                      var iWt = int.parse(wt);
                      var iFt = int.parse(ft);
                      var iInch = int.parse(inch);

                      var tInch =(iFt*12) + iInch;

                      var tCm =tInch*2.54;

                      var tM = tCm/100;

                      var bmi = iWt/(tM*tM);

                      var msg = "";
                      if(bmi>25){
                        msg = "You're OverWeight!!";
                        bgColor = Colors.orange.shade200;

                      } else if(bmi<18){
                        msg = "You're UnderWeight!!";
                        bgColor = Colors.red.shade200;
                      } else {

                      }
                      setState(() {
                        msg = "You're Healthy!!";
                        bgColor = Colors.green.shade200;
                        result = "Your BMI is:${bmi.toStringAsFixed(4)}";
                      });


                    } else{
                      setState(() {
                        result = "Please fill all the required blanks!! ";
                      });

                    }
                  }, child: Text ('Calculate')),

                  SizedBox(height: 11,),

                  Text(result, style: TextStyle(fontSize: 19),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
