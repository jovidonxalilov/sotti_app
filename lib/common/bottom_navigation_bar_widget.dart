import 'package:flutter/material.dart';
import 'icon_buttom.dart';

class BottomNavigationBarMap extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationBarMap({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 78,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        color: Colors.amber,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavigationIconButton(
              callback: () => onTap(0),
              svg: Icons.home,
              iconColor: selectedIndex == 0 ? Colors.white : Colors.grey,
              title: "Home",
              titleColor: selectedIndex == 0 ? Colors.white : Colors.grey,
            ),
            BottomNavigationIconButton(
              callback: () => onTap(1),
              svg: Icons.map_outlined,
              iconColor: selectedIndex == 1 ? Colors.black : Colors.grey,
              title: "Saved",
              titleColor: selectedIndex == 1 ? Colors.black : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
