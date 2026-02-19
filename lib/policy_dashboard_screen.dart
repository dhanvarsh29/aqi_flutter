import 'package:flutter/material.dart';

class PolicyDashboardScreen extends StatelessWidget {
  const PolicyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Policy Dashboard")),
      body: const Center(
        child: Text(
          "Policy Dashboard UI Coming Soon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
