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
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.yellow.shade900,
          hintStyle: const TextStyle(color: Colors.orange),
          labelStyle: const TextStyle(
            color: Colors.orange,
            fontSize: 18, // Increase font size
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      ),
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
  TextEditingController wtController = TextEditingController();
  TextEditingController feetController = TextEditingController();
  TextEditingController inchesController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String result = "";
  Color bgColor = Colors.indigo.shade200;

  HeightUnit selectedUnit = HeightUnit.Centimeters;

  Map<String, dynamic> calculateBMI(
      double weight, double height, HeightUnit unit) {
    var bmiData = <String, dynamic>{};
    if (unit == HeightUnit.Centimeters) {
      var tM = height / 100;
      var bmi = weight / (tM * tM);
      bmiData['bmi'] = bmi;
      bmiData['category'] = _getBMICategory(bmi);
    } else {
      var feet = double.tryParse(feetController.text) ?? 0.0;
      var inches = double.tryParse(inchesController.text) ?? 0.0;
      var heightInInches = (feet * 12) + inches;
      var heightInCm = heightInInches * 2.54; // Convert inches to centimeters
      var bmi = (weight / (heightInCm * heightInCm)) *
          10000; // Convert height to meters
      bmiData['bmi'] = bmi;
      bmiData['category'] = _getBMICategory(bmi);
    }
    return bmiData;
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      return "Normal weight";
    } else if (bmi >= 25 && bmi < 30) {
      return "Overweight";
    } else {
      return "Obesity";
    }
  }

  Widget _buildBMIInfo(String category, String range) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(range),
        ],
      ),
    );
  }

  Widget _buildBMIProgressBar() {
    double bmi = 0;
    if (wtController.text.isNotEmpty &&
        (heightController.text.isNotEmpty ||
            (feetController.text.isNotEmpty &&
                inchesController.text.isNotEmpty))) {
      double weight = double.parse(wtController.text);
      double height = 0;

      if (selectedUnit == HeightUnit.Centimeters) {
        height = double.tryParse(heightController.text) ?? 0;
      } else {
        double feet = double.tryParse(feetController.text) ?? 0.0;
        double inches = double.tryParse(inchesController.text) ?? 0.0;
        double heightInInches = (feet * 12) + inches;
        double heightInCm = heightInInches *
            2.54; // Convert inches to centimeters
        height = heightInCm * 0.01; // Convert height to meters
      }

      HeightUnit unit = selectedUnit;

      var bmiData = calculateBMI(weight, height, unit);
      bmi = bmiData['bmi']!;
    }

    return Column(
      children: [
        const Text(
          'BMI Range',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(
                height: 8,
                width: bmi * 200 / 50,
                decoration: BoxDecoration(
                  color: _getBMIColor(bmi),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Underweight',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Normal weight',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Overweight',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Obesity',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi >= 18.5 && bmi < 25) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red.shade800;
    }
  }

  Widget _buildHeightField() {
    if (selectedUnit == HeightUnit.Centimeters) {
      return TextField(
          controller: heightController,
          decoration: const InputDecoration(
          labelText: 'Enter your Height in cm',
                  prefixIcon:Icon(Icons.height, color: Colors.orange),
      ),
    keyboardType: TextInputType.number,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.orange, // Set text color to orange
    fontSize: 18, // Increase font size
    ),
    );
    } else {
    return Row(
    children: [
    Expanded(
    flex: 2,
    child: TextField(
    controller: feetController,
    decoration: const InputDecoration(
    labelText: 'Feet',
    ),
    keyboardType: TextInputType.number,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.orange, // Set text color to orange
    fontSize: 18, // Increase font size
    ),
    ),
    ),
    const SizedBox(width: 8),
    Expanded(
    flex: 2,
    child: TextField(
    controller: inchesController,
    decoration: const InputDecoration(
    labelText: 'Inches',
    ),
    keyboardType: TextInputType.number,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.orange, // Set text color to orange
    fontSize: 18, // Increase font size
    ),
    ),
    ),
    ],
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("BMI"),
    ),
    body: Container(
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/image/background_image.jpg'),
    fit: BoxFit.cover,
    ),
    ),
    child: Center(
    child: Container(
    width: 300,
    child: SingleChildScrollView(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text(
    'BMI',
    style: TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: Colors.white, // Set text color to white
    ),
    ),
    const SizedBox(height: 21),
    TextField(
    controller: wtController,
    decoration: const InputDecoration(
    labelText: 'Enter your Weight in kgs',
    prefixIcon: Icon(Icons.line_weight, color: Colors.orange),
    ),
    keyboardType: TextInputType.number,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.green, // Set text  color to dark green
    fontSize: 18, // Increase font size
    ),
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
    child: Text(
    'Centimeters',
    style: TextStyle(color: Colors.orange),
    ),
    ),
    DropdownMenuItem(
    value: HeightUnit.FeetInches,
    child: Text(
    'Feet & Inches',
    style: TextStyle(color: Colors.orange),
    ),
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
    _buildHeightField(),
    const SizedBox(height: 11),
    TextField(
    controller: ageController,
    decoration: const InputDecoration(
    labelText: 'Enter your Age',
    prefixIcon: Icon(Icons.calendar_today, color: Colors.orange),
    ),
    keyboardType: TextInputType.number,
    style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.green, //Set text color to dark green
    fontSize: 18, //Increase font size
    ),
    ),
    const SizedBox(height: 16),
    ElevatedButton(
    onPressed: () {
    var wt = wtController.text.toString();
    var height = heightController.text.toString();
    var age = ageController.text.toString();
    var feet = feetController.text.toString();
    var inches = inchesController.text.toString();

    if (wt.isNotEmpty && age.isNotEmpty) {
    if (selectedUnit == HeightUnit.Centimeters) {
    if (height.isNotEmpty) {
    try {
    var iWt = double.parse(wt);
    var iHeight = double.parse(height);
    var iAge = int.parse(age);

    var bmiData = calculateBMI(iWt, iHeight, selectedUnit);

    var bmi = bmiData['bmi']!;
    var category = bmiData['category']!;

    var msg = "You're $category!";
    if (category == "Obesity") {
    bgColor = Colors.red.shade200;
    msg += " 😦";
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
    } catch (e) {
    setState(() {
    result = "Invalid input values!";
    });
    }
    } else {
    setState(() {
    result = "Please fill all the required fields!";
    });
    }
    } else {
    if (feet.isNotEmpty && inches.isNotEmpty) {
    try {
    var iWt = double.parse(wt);
    var iFeet = double.parse(feet);
    var iInches = double.parse(inches);
    var iAge = int.parse(age);

    var heightInInches = (iFeet * 12) + iInches;
    var heightInCm =
    heightInInches * 2.54; // Convert inches to centimeters
    var heightInM =
    heightInCm * 0.01; // Convert height to meters

    var bmi = (iWt / (heightInM * heightInM));

    var category = _getBMICategory(bmi);

    var msg = "You're $category!";
    if (category == "Obesity") {
    bgColor = Colors.red.shade200;
    msg += " 😦";
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
    } catch (e) {
    setState(() {
    result = "Invalid input values!";
    });
    }
    } else {
    setState(() {
    result = "Please fill all the required fields!";
    });
    }
    }
    } else {
    setState(() {
    result = "Please fill all the required fields!";
    });
    }
    },
    child: const Text('Calculate'),
    ),
    const SizedBox(height: 11),
    const Text(
    'BMI Categories',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    ),
    ),
    const SizedBox(height: 8),
    _buildBMIInfo("Underweight", "<18.5"),
    _buildBMIInfo("Normal weight", "18.5–24.9"),
      _buildBMIInfo("Overweight", "25–29.9"),
      _buildBMIInfo("Obesity", "BMI of 30 or greater"),
      const SizedBox(height: 16),
      Text(
        result,
        style: const TextStyle(fontSize: 19),
      ),
      const SizedBox(height: 16),
      _buildBMIProgressBar(),
    ],
    ),
    ),
    ),
    ),
    ),
    );
  }
}


