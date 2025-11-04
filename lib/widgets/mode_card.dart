import 'package:flutter/material.dart';

class ModeCard extends StatelessWidget {
  final String mode;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ModeCard({
    Key? key,
    required this.mode,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(30),
          child: Row(
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(width: 20),
              Text(
                mode,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}