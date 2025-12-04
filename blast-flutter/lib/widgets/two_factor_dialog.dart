import 'package:flutter/material.dart';

import '../api/api_service.dart';

Future<void> showTwoFactorDialog({
  required BuildContext context,
  required ApiService apiService,
  required bool rememberMe,
  required VoidCallback onSuccess,
}) async {
  if (apiService.pendingTwoFactorId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Нет ожидающей 2FA-сессии')),
    );
    return;
  }

  final codeController = TextEditingController();
  final backupController = TextEditingController();
  bool useBackup = false;
  bool isLoading = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) {
      return StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1D),
          title: Text(
            useBackup ? 'Резервный код' : 'Код из приложения',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                useBackup
                    ? 'Введите один из резервных кодов Necsoura.'
                    : 'Введите 6‑значный код из приложения Necsoura ID.',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: useBackup ? backupController : codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2F),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: useBackup ? 'XXXX-XXXX' : '123456',
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    useBackup = !useBackup;
                  });
                },
                child: Text(
                  useBackup ? 'Использовать код из приложения' : 'Использовать резервный код',
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                apiService.clearPendingTwoFactor();
                Navigator.of(dialogCtx).pop();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final value = (useBackup ? backupController : codeController).text.trim();
                      if (value.isEmpty) return;
                      setState(() => isLoading = true);
                      final ok = useBackup
                          ? await apiService.verifyBackupCode(value, rememberMe)
                          : await apiService.verifyTwoFactorCode(value, rememberMe);
                      setState(() => isLoading = false);
                      if (ok) {
                        Navigator.of(dialogCtx).pop();
                        onSuccess();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Код отклонён')),
                        );
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Подтвердить'),
            )
          ],
        ),
      );
    },
  );

  codeController.dispose();
  backupController.dispose();
}

