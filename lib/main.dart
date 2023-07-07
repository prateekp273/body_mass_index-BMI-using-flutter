import 'package:flutter/material.dart';

enum HeightUnit { Centimeters, FeetInches }

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
  var heightController = TextEditingController();
  var ageController = TextEditingController();

  var result = "";
  var bgColor = Colors.indigo.shade200;

  var selectedUnit = HeightUnit.Centimeters;

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
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BMI',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 21),
                TextField(
                  controller: wtController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your Weight in kgs',
                    prefixIcon: Icon(Icons.line_weight),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    const Text(
                      'Height: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<HeightUnit>(
                      value: selectedUnit,
                      items: const [
                        DropdownMenuItem(
                          value: HeightUnit.Centimeters,
                          child: Text('Centimeters'),
                        ),
                        DropdownMenuItem(
                          value: HeightUnit.FeetInches,
                          child: Text('Feet & Inches'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                buildHeightField(),
                const SizedBox(height: 11),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your Age',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    var wt = wtController.text.toString();
                    var height = heightController.text.toString();
                    var age = ageController.text.toString();

                    if (wt != "" && height != "" && age != "") {
                      var iWt = double.parse(wt);
                      var iHeight = double.parse(height);
                      var iAge = int.parse(age);

                      var bmiData = calculateBMI(iWt, iHeight, selectedUnit);

                      var bmi = bmiData['bmi'];
                      var category = bmiData['category'];

                      var msg = "You're $category!";
                      if (category == "Obese") {
                        bgColor = Colors.red.shade200;
                      } else if (category == "Overweight") {
                        bgColor = Colors.orange.shade200;
                      } else if (category == "Underweight") {
                        bgColor = Colors.yellow.shade200;
                      } else {
                        bgColor = Colors.green.shade200;
                      }
                      setState(() {
                        result = "$msg\nYour BMI is: ${bmi.toStringAsFixed(2)}";
                      });
                    } else {
                      setState(() {
                        result = "Please fill all the required fields!";
                      });
                    }
                  },
                  child: const Text('Calculate'),
                ),
                const SizedBox(height: 11),
                Text(
                  result,
                  style: const TextStyle(fontSize: 19),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeightField() {
    if (selectedUnit == HeightUnit.Centimeters) {
      return TextField(
        controller: heightController,
        decoration: const InputDecoration(
          labelText: 'Enter your Height in cm',
          prefixIcon: Icon(Icons.height),
        ),
        keyboardType: TextInputType.number,
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: heightController,
              decoration: const InputDecoration(
                labelText: 'Feet',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Inches',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  // Do nothing, inches value is not stored separately
                });
              },
            ),
          ),
        ],
      );
    }
  }

  Map<String, dynamic> calculateBMI(
      double weight, double height, HeightUnit unit) {
    var bmiData = <String, dynamic>{};
    if (unit == HeightUnit.Centimeters) {
      var tM = height / 100;
      var bmi = weight / (tM * tM);
      bmiData['bmi'] = bmi;
      bmiData['category'] = getBMICategory(bmi);
    } else {
      var feet = height;
      var inches = 0.0;
      if (heightController.text.contains('.')) {
        var parts = heightController.text.split('.');
        feet = double.parse(parts[0]);
        inches = double.parse(parts[1]);
      }
      var tInch = (feet * 12) + inches;
      var tCm = tInch * 2.54;
      var tM = tCm / 100;
      var bmi = weight / (tM * tM);
      bmiData['bmi'] = bmi;
      bmiData['category'] = getBMICategory(bmi);
    }
    return bmiData;
  }

  String getBMICategory(double bmi) {
    if (bmi > 30) {
      return "Obese";
    } else if (bmi > 25) {
      return "Overweight";
    } else if (bmi < 18.5) {
      return "Underweight";
    } else {
      return "Healthy";
    }
  }
}
