import 'package:flutter/material.dart';
import '../helper/app_theme.dart';
import './main_navigator.dart';
import '../helper/user_session_helper.dart';
import './onboarding_screen.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

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
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabSwitcher(),
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _tabIndex == 0
                        ? _LoginForm(key: const ValueKey('login'), onSuccess: _onAuthSuccess)
                        : _RegisterForm(key: const ValueKey('register'), onSuccess: _onRegisterSuccess),
                    ),
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
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 40),
      child: Column(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: Image.asset(
              'assets/images/auth-logo.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
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

  void _onAuthSuccess() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav()));
  }
 
  Future<void> _onRegisterSuccess(int userId) async {
    final onboardingDone = await SessionHelper.isOnboardingDone();
    if (!mounted) return;
    if (onboardingDone) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav()));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen(userId: userId)),
      );
    }
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
              color: selected ? Colors.black : AppTheme.muted,
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
  bool _loading = false;
  //database validation and session persistence
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final user = await DatabaseHelper.instance.getUserByEmail(_emailCtrl.text.trim());
      if (user == null || user.password != _passCtrl.text) {
        _showError('Invalid email or password');
        return;
      }
      await SessionHelper.saveUserId(user.id!);
      widget.onSuccess();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppTheme.danger),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          const Text('Email'),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'example@gmail.com',
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: AppTheme.inputBorder,
              enabledBorder: AppTheme.inputBorder,
              focusedBorder: AppTheme.inputBorder.copyWith(
                borderSide: BorderSide(color: AppTheme.border, width: 1.5),
              ),
            ),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 20),
          const Text('Password'),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: 'Value',
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: AppTheme.inputBorder,
              enabledBorder: AppTheme.inputBorder,
              focusedBorder: AppTheme.inputBorder.copyWith(
                borderSide: BorderSide(color: AppTheme.ctaGreen, width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: AppTheme.muted,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.ctaGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot password?', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
            ),
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
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _userCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final user = User(
        name: _nameCtrl.text.trim(),
        username: _userCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        createdAt: DateTime.now().toIso8601String(),
      );
      final id = await DatabaseHelper.instance.createUser(user);
      await SessionHelper.saveUserId(id);
      await widget.onSuccess(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: AppTheme.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Name'),
          TextFormField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: 'Value',
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: AppTheme.inputBorder,
              enabledBorder: AppTheme.inputBorder,
              focusedBorder: AppTheme.inputBorder.copyWith(
                borderSide: BorderSide(color: AppTheme.ctaGreen, width: 1.5),
              ),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
          ),
          const SizedBox(height: 20),

          const Text('Username'),
          TextFormField(
            controller: _userCtrl,
            decoration: InputDecoration(
              hintText: 'Value',
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: AppTheme.inputBorder,
              enabledBorder: AppTheme.inputBorder,
              focusedBorder: AppTheme.inputBorder.copyWith(
                borderSide: BorderSide(color: AppTheme.ctaGreen, width: 1.5),
              ),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Username is required' : null,
          ),
          const SizedBox(height: 14),

          const Text('Email'),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'example@gmail.com',
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: AppTheme.inputBorder,
              enabledBorder: AppTheme.inputBorder,
              focusedBorder: AppTheme.inputBorder.copyWith(
                borderSide: BorderSide(color: AppTheme.ctaGreen, width: 1.5),
              ),
            ),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 14),

          const Text('Password'),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: 'Value',
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: AppTheme.inputBorder,
              enabledBorder: AppTheme.inputBorder,
              focusedBorder: AppTheme.inputBorder.copyWith(
                borderSide: BorderSide(color: AppTheme.ctaGreen, width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: AppTheme.muted,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.ctaGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('GET STARTED'),
            ),
          ),
        ],
      ),
    );
  }
}
