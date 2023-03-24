import 'package:flutter/material.dart';

class AppDrawerButton extends StatelessWidget {
  const AppDrawerButton(
      {super.key,
      required this.text,
      required this.icon,
      this.endArrowIcon = true, required this.onPressed});

  final String text;
  final IconData icon;
  final bool endArrowIcon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
            backgroundColor: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey[300]),
                width: 40,
                height: 40,
                child: Icon(icon, color: const Color(0xff303030),)),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color:  Color(0xff303030),
                  fontSize: 18,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            endArrowIcon
                ? const Icon(Icons.arrow_forward_ios_outlined,color: Color(0xff303030),)
                : const Text("")
          ],
        ));
  }
}
