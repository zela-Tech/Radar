import 'package:flutter/material.dart';
import '../helper/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.splashDark,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.zero),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabSwitcher(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // headaer 
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      child: Column(
        children: [
          const Icon(Icons.radar, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Go ahead and set up\nyour account',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sign in-up and find your next experience',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  //toggle for registration and login
  int _tabIndex = 0;
  Widget _buildTabSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDE6),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _TabButton(label: 'Login', selected: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
          _TabButton(label: 'Register', selected: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
        ],
      ),
    );
  }
}


class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
 
  const _TabButton({required this.label, required this.selected, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppTheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [BoxShadow(color: const Color.fromARGB(19, 0, 0, 0), blurRadius: 4, offset: const Offset(0, 1))]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppTheme.ink : AppTheme.muted,
            ),
          ),
        ),
      ),
    );
  }
}
//login 
class _LoginForm extends StatefulWidget {
  final VoidCallback onSuccess;
  const _LoginForm({super.key, required this.onSuccess});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          const Text('Email'),
          TextFormField(controller: _emailCtrl),
          const SizedBox(height: 16),
          const Text('Password'),
          TextFormField(controller: _passCtrl, obscureText: _obscure),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {}, 
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

//registration
class _RegisterForm extends StatefulWidget {
  final Future<void> Function(int userId) onSuccess;
  const _RegisterForm({super.key, required this.onSuccess});

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text('Name'),
          TextFormField(controller: _nameCtrl),
          const Text('Username'),
          TextFormField(controller: _userCtrl),
          const Text('Email'),
          TextFormField(controller: _emailCtrl),
          const Text('Password'),
          TextFormField(controller: _passCtrl, obscureText: true),
          ElevatedButton(
            onPressed: () {}, 
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}