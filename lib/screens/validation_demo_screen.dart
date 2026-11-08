import 'package:flutter/material.dart';

import '../utils/validators.dart';

/// Halaman demo validasi input (Latihan 3).
///
/// Menguji [Validators] pada form: nama, email, telepon, URL, password.
class ValidationDemoScreen extends StatefulWidget {
  const ValidationDemoScreen({super.key});

  @override
  State<ValidationDemoScreen> createState() => _ValidationDemoScreenState();
}

class _ValidationDemoScreenState extends State<ValidationDemoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _urlController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _sanitizedName;
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _urlController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _sanitizedName = null);
      return;
    }
    setState(() => _sanitizedName = Validators.sanitize(_nameController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua input valid'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: suffix,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Validasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(
                controller: _nameController,
                label: 'Nama',
                icon: Icons.person,
                validator: (v) => Validators.validateText(v, fieldName: 'Nama'),
              ),
              _field(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              _field(
                controller: _phoneController,
                label: 'Nomor Telepon',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
              _field(
                controller: _urlController,
                label: 'URL Website',
                icon: Icons.link,
                keyboardType: TextInputType.url,
                validator: Validators.validateUrl,
              ),
              _field(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.key,
                obscure: _obscure,
                validator: Validators.validatePassword,
                suffix: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.verified),
                label: const Text('Validasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_sanitizedName != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Nama setelah sanitasi: $_sanitizedName'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
