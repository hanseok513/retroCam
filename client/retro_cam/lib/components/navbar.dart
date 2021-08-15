import 'package:flutter/material.dart';

class NavbarBase extends StatelessWidget {
  final Widget left;
  final Widget right;

  NavbarBase({Key key, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: EdgeInsets.all(38),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [left, right],
      ),
    );
  }
}

class SimpleNavBar extends StatelessWidget {
  final String title;
  final IconButton button;

  SimpleNavBar({Key key, this.title, this.button});

  @override
  Widget build(BuildContext context) {
    return NavbarBase(
      left: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
      right: button,
    );
  }
}

class StripEditNavBar extends StatelessWidget {
  final bool isDateShown;
  final void Function() onDateViewToggle;
  final void Function() onDownloadStrip;
  final void Function() onClose;

  StripEditNavBar(
      {Key key, this.isDateShown, this.onDateViewToggle, this.onDownloadStrip, this.onClose});

  @override
  Widget build(BuildContext context) {
    return NavbarBase(
      left: Row(
        children: [
          IconButton(
            icon: Icon(isDateShown ? Icons.visibility : Icons.visibility_off),
            onPressed: onDateViewToggle,
          ),
          IconButton(icon: Icon(Icons.file_download), onPressed: onDownloadStrip),
        ],
      ),
      right: IconButton(icon: Icon(Icons.close), onPressed: onClose),
    );
  }
}
