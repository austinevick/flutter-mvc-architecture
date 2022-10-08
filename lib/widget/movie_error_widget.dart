import 'package:flutter/material.dart';
import 'custom_button.dart';

class MovieErrorWidget extends StatelessWidget {
  final VoidCallback onTap;
  const MovieErrorWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Something went wrong',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          width: 150,
          radius: 16,
          height: 45,
          borderSide: const BorderSide(color: Colors.red, width: 1.8),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.refresh),
              SizedBox(width: 8),
              Text(
                'Retry',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              )
            ],
          ),
        )
      ],
    );
  }
}
