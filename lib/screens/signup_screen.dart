import 'package:flutter/material.dart';

import '../haunted_theme.dart';
import 'success_screen.dart';

/// The Laboratory: Activity 10 form + creature dropdown, password toggle,
/// birth-date picker and loading state.
///
/// NOTE: swap the validators below for your exact Activity 10 validators if
/// they differ (messages, rules). Keep them intact.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();

  bool _obscurePassword = true; // Potion A
  DateTime? _birthDate; // Potion B
  String? _selectedCreatureType; // Creature Registry field
  bool _submitting = false; // Potion C (drives the spinner / disabled button)

  // Task C, defense #2: a plain flag flipped synchronously, so a second
  // call is rejected even if the button were somehow still enabled.
  bool _inFlight = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(), // no future birthdays
    );
    if (picked != null && mounted) {
      setState(() {
        _birthDate = picked;
        _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  Future<void> _submit() async {
    if (_inFlight) return; // defense #2: synchronous re-entry guard
    if (!_formKey.currentState!.validate()) return;

    _inFlight = true;
    setState(() => _submitting = true);

    await Future.delayed(const Duration(seconds: 2));

    // Defense #3: the guest may have backed out during the wait.
    if (!mounted) return;

    final name = _nameController.text.trim();
    final creature = _selectedCreatureType;

    // Defense #1 (first layer): never navigate with incomplete data.
    if (name.isEmpty || creature == null) {
      setState(() => _submitting = false);
      _inFlight = false;
      return;
    }

    // pushReplacement(): the lab leaves the stack, so Back cannot resubmit.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(userName: name, creatureType: creature),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 18);

    return Scaffold(
      backgroundColor: Palette.bone,
      appBar: AppBar(
        backgroundColor: Palette.ink,
        foregroundColor: Palette.bone,
        title: const Text(
          'THE LAB // INTAKE',
          style: TextStyle(
            fontFamily: kMono,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: ColoredBox(
            color: Palette.pumpkin,
            child: SizedBox(height: 4, width: double.infinity),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BrutalBox(
                  color: Palette.grape,
                  child: Text(
                    'FORM 11-C\nCREATURE INTAKE. FILL EVERY BOX. NO PENCILS.',
                    style: TextStyle(
                      fontFamily: kMono,
                      fontWeight: FontWeight.w900,
                      color: Palette.bone,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: hauntedInput('Full name', Icons.badge),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                ),
                gap,
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: hauntedInput('Email', Icons.alternate_email),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Email must contain @';
                    return null;
                  },
                ),
                gap,
                // Potion A: visibility toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: hauntedInput(
                    'Password',
                    Icons.lock,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Palette.ink,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter a password';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                ),
                gap,
                // Potion B: birth-date picker
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: hauntedInput('Birth date', Icons.cake),
                  validator: (_) =>
                      _birthDate == null ? 'Pick your birth date' : null,
                  onTap: _pickDate,
                ),
                gap,
                // Creature Registry field (required)
                DropdownButtonFormField<String>(
                  value: _selectedCreatureType,
                  isExpanded: true,
                  dropdownColor: Palette.bone,
                  decoration: hauntedInput('Creature type', Icons.pets),
                  items: kCreatureEmoji.entries
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e.key,
                          child: Text(
                            '${e.value}  ${e.key}',
                            style: const TextStyle(
                              fontFamily: kMono,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  validator: (v) => v == null ? 'Choose a creature type' : null,
                  onChanged: _submitting
                      ? null
                      : (v) => setState(() => _selectedCreatureType = v),
                ),
                const SizedBox(height: 32),
                // Potion C: loading state (button disabled while brewing)
                BrutalButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Palette.ink,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('BREWING...'),
                          ],
                        )
                      : const Text('REGISTER CREATURE'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
