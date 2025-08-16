import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Center(
          // centers vertically and horizontally
          child: SingleChildScrollView(
            // prevents overflow
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // vertical center
              crossAxisAlignment:
                  CrossAxisAlignment.center, // horizontal center
              children: [
                Image.asset(
                  'assets/images/airbnb.png', // your logo path
                  height: 100, // adjust size
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20), // spacing
                Text(
                  'Welcome to Airbnb',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center, // center text
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    width: 400, // fixed width for consistency
                    child: TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      // textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: 'Enter Your Phone number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (v) {
                        if ((v ?? '').trim().isEmpty) {
                          return 'Enter phone number';
                        }
                        if ((v ?? '').trim().length < 8) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Continue button - small and centered
                const SizedBox(height: 30), // spacing
                Center(
                  child: SizedBox(
                    width: 400, // same as phone number box
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushNamed(
                            context,
                            '/otp',
                            arguments: _phoneCtrl.text.trim(),
                          );
                        }
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
