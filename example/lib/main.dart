import 'package:custom_checkbox/custom_checkbox.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Custom CheckBox Demo',
      debugShowCheckedModeBanner: false,
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool a = false;
  bool b = true;
  bool disabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomCheckBox Demo')),
      body: Center(
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: [
            // 🔹 Primary checkbox
            CustomCheckBox(
              value: a,
              onChanged: (v) => setState(() => a = v),
              size: 28,
              borderRadius: 6,
              tooltip: 'Primary',
            ),

            // 🔹 Blue themed checkbox (customized)
            CustomCheckBox(
              value: b,
              onChanged: (v) => setState(() => b = v),
              size: 32,
              // 👇 these three were redundant before
              // activeFillColor: Colors.blue,
              // activeBorderColor: Colors.blue,
              // iconColor: Colors.white,
              tooltip: 'Blue style',
            ),

            // 🔹 Disabled checkbox (custom colors)
            CustomCheckBox(
              value: disabled,
              onChanged: null,
              size: 28,
              fillColor: Colors.grey.shade100,
              borderColor: Colors.grey.shade400,
              tooltip: 'Disabled',
            ),
          ],
        ),
      ),
    );
  }
}
