import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> showAuthSheet(BuildContext context) async {
  final auth = FirebaseAuth.instance;

  final isSignUp = ValueNotifier<bool>(false);
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final loading = ValueNotifier<bool>(false);
  final errorText = ValueNotifier<String?>(null);
  final showPass = ValueNotifier<bool>(false);

  void resetErrors() => errorText.value = null;

  Future<void> handleSubmit() async {
    resetErrors();
    if (loading.value) return;
    loading.value = true;
    try {
      if (isSignUp.value) {
        // SIGN UP
        final cred = await auth.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passCtrl.text.trim(),
        );
        await cred.user?.updateDisplayName(nameCtrl.text.trim());
      } else {
        // SIGN IN
        await auth.signInWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passCtrl.text.trim(),
        );
      }
      if (context.mounted) Navigator.pop(context); // close on success
    } on FirebaseAuthException catch (e) {
      errorText.value = e.message ?? 'Authentication error';
    } catch (e) {
      errorText.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      final mq = MediaQuery.of(ctx);
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: mq.viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Toggle row
            ValueListenableBuilder<bool>(
              valueListenable: isSignUp,
              builder: (_, on, __) => Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        isSignUp.value = false;
                        resetErrors();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: on
                            ? Colors.grey[300]
                            : Theme.of(ctx).colorScheme.primary,
                      ),
                      child: const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        isSignUp.value = true;
                        resetErrors();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: on
                            ? Theme.of(ctx).colorScheme.primary
                            : Colors.grey[300],
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Fields
            ValueListenableBuilder<bool>(
              valueListenable: isSignUp,
              builder: (_, on, __) => Column(
                children: [
                  if (on) ...[
                    TextField(
                      controller: nameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<bool>(
                    valueListenable: showPass,
                    builder: (_, reveal, __) => TextField(
                      controller: passCtrl,
                      obscureText: !reveal,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            reveal ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => showPass.value = !reveal,
                        ),
                      ),
                      onSubmitted: (_) => handleSubmit(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Error
            ValueListenableBuilder<String?>(
              valueListenable: errorText,
              builder: (_, err, __) => err == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        err,
                        style: TextStyle(
                          color: Theme.of(ctx).colorScheme.error,
                        ),
                      ),
                    ),
            ),

            // Submit
            ValueListenableBuilder<bool>(
              valueListenable: loading,
              builder: (_, busy, __) => SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: busy ? null : handleSubmit,
                  child: busy
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : ValueListenableBuilder<bool>(
                          valueListenable: isSignUp,
                          builder: (_, on, __) =>
                              Text(on ? 'Create Account' : 'Sign In'),
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
