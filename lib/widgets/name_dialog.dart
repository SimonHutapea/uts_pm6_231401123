import 'package:flutter/material.dart';

class NameDialog extends StatefulWidget {
  final String mode;
  final Function(String) onStart;

  const NameDialog({
    Key? key,
    required this.mode,
    required this.onStart,
  }) : super(key: key);

  @override
  State<NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameEmpty = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkNameEmpty);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkNameEmpty);
    _nameController.dispose();
    super.dispose();
  }

  void _checkNameEmpty() {
    setState(() {
      _isNameEmpty = _nameController.text.trim().isEmpty;
    });
  }

  void _handleStart() {
    if (!_isNameEmpty) {
      widget.onStart(_nameController.text.trim());
    }
  }

  Color _getModeColor() {
    switch (widget.mode) {
      case 'Classic':
        return Colors.green.shade400;
      case 'Timer':
        return Colors.orange.shade400;
      case 'Endless':
        return Colors.purple.shade400;
      default:
        return Colors.blue.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getModeIcon(),
              size: 60,
              color: _getModeColor(),
            ),
            const SizedBox(height: 15),
            Text(
              'Mode ${widget.mode}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _getModeColor(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Masukkan nama Anda:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Nama',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: _getModeColor(), width: 2),
                ),
              ),
              onSubmitted: (_) => _handleStart(),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isNameEmpty ? null : _handleStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getModeColor(),
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Mulai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getModeIcon() {
    switch (widget.mode) {
      case 'Classic':
        return Icons.library_books;
      case 'Timer':
        return Icons.timer;
      case 'Endless':
        return Icons.all_inclusive;
      default:
        return Icons.quiz;
    }
  }
}