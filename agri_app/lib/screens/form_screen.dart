import 'package:agri_app/provider/userdata_provider.dart';
import 'package:agri_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  FormScreenState createState() => FormScreenState();
}

class FormScreenState extends State<FormScreen> {
  late String name;
  late Map<String, String> cropDetail = {};
  late double landArea;

  final formKey = GlobalKey<FormState>();

  List<String> predefinedCrops = ['Maize', 'Rice', 'Wheat'];
  List<String> selectedCrops = [];
  Map<String, DateTime> sowingDates = {};

  int count = 1;

  void formHandler() {
    bool? isValidate = formKey.currentState?.validate();
    if (isValidate == null || !isValidate) {
      return;
    }
    for (int i = 0; i < selectedCrops.length; i++) {
      cropDetail[selectedCrops[i]] = sowingDates[selectedCrops[i]].toString();
    }
    Provider.of<UserDataProvider>(context, listen: false)
        .setData(name, cropDetail, landArea);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Details Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/manharvest.jpg"),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a valid name!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: List.generate(count, (index) {
                        final crop = selectedCrops.length > index
                            ? selectedCrops[index]
                            : null;
                        return Column(
                          children: [
                            DropdownButtonFormField<String>(
                              key: ValueKey<String>('crop_$index'),
                              decoration:
                                  const InputDecoration(labelText: 'Crop Detail'),
                              value: crop,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedCrops.add(newValue);
                                  });
                                  _selectDate(context, newValue);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select an option!";
                                }
                                return null;
                              },
                              items: predefinedCrops.map((crop) {
                                return DropdownMenuItem<String>(
                                  value: crop,
                                  child: Text(crop),
                                );
                              }).toList(),
                            ),
                            if (sowingDates.containsKey(crop))
                              Text(
                                  'Sown Date: ${sowingDates[crop].toString().substring(0, 11)}'),
                            const SizedBox(height: 10),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (count <= 2)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () => setState(() => count++),
                            icon: const Icon(Icons.add),
                            label: const Text("Add More Crop"),
                          ),
                        if (count >= 2)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                count--;
                              });
                              setState(() {
                                final lastCrop = selectedCrops.removeLast();
                                sowingDates.remove(lastCrop);
                              });
                            },
                            icon: const Icon(Icons.remove),
                            label: const Text("Remove Crop"),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text('Land Area:\n(in acres)'),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Enter Land Area'),
                            onChanged: (value) {
                              setState(() {
                                landArea = double.parse(value);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a valid number!";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        onPressed: formHandler,
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String crop) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        sowingDates[crop] = picked;
     });
}
}
}