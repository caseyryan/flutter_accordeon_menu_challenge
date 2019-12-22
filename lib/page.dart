import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_accordion_menu/data/menu_item_data.dart';

import 'data/data.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> with SingleTickerProviderStateMixin {

  static const _MAX_ROTATION = 90.0;
  static const _ITEM_HEIGHT = 80.0;





  Animation<double> _progressAnimation;
  AnimationController _animationController;
  bool _isOpen = false;

  @override
  void initState() {

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

//    _progressAnimation = Tween<double>(
//      begin: 0.0,
//      end: 1.0
//    ).animate(_animationController);
    _progressAnimation = CurvedAnimation(
      curve: Curves.easeInCubic,
      parent: _animationController
    );

    super.initState();
  }
  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) _animationController.forward();
      else _animationController.reverse();
    });
  }

  Widget _createMenuItemContent({MenuItemData menuItemData}) {
    var separatorHeight = 2.0;
    var maxHeight = _ITEM_HEIGHT - separatorHeight;

    return Column( // наполнение айтема
      children: <Widget>[
        Padding( // полоска в верхней части
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            height: separatorHeight,
            width: double.infinity,
            color: Colors.white.withOpacity(.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Container( // leading icon
                height: maxHeight,
                width: maxHeight,
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(menuItemData.iconPath)
                      )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(menuItemData.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(menuItemData.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w300
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),


      ],
    );
  }

  Widget _getMenuItemPlank({double width, double rotationDeg,
      int index = 0, MenuItemData menuItemData}) {

    var sign = index.toDouble() % 2 == 0 ? 1.0 : -1.0;
    var radians = (rotationDeg * sign) * pi / 180.0;
    var height = _ITEM_HEIGHT;
    var openRatio = cos(radians);
    var overlayColor = sign > 0 ? Colors.black : Colors.white;
    var overlayOpacity = .2 * (1 - openRatio);

    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        heightFactor: (openRatio - 0.02).clamp(0.0, 1.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Transform(
            origin: Offset(width * .50, height * .50),
            transform: (Matrix4.identity()
              ..setEntry(3, 2, 0.001))
                * Matrix4.rotationX(radians),
            child: Stack(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: height,
                    color: Color.fromRGBO(219, 87, 60, 1.0),
                    child: _createMenuItemContent(menuItemData: menuItemData),
                ),
                Container(
                  color: overlayColor.withOpacity(overlayOpacity),
                  width: double.infinity,
                  height: height,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  List<Widget> _getMenuItems({double width, double rotationDeg}) {
    var result = <Widget>[];
    for (var i = 0; i < Data().menuItems.length; i++) {
      result.add(_getMenuItemPlank(
        width: width,
        rotationDeg: rotationDeg,
        index: i,
        menuItemData: Data().menuItems[i]
        )
      );
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () {
            _toggleMenu();
          },
          icon: LayoutBuilder( // иконка меню
            builder: (c, BoxConstraints constraints) {
              var centerOffset = constraints.biggest.height / 2;
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, widget) {
                  return Transform(
                    transform: Matrix4.rotationZ(90 * _progressAnimation.value * pi / 180),
                    origin: Offset(centerOffset, centerOffset),
                    child: AnimatedIcon(
                      progress: _progressAnimation,
                      icon: AnimatedIcons.menu_arrow,
                      size: 34,
                      color: Colors.blueGrey,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      body: SafeArea(
          child: LayoutBuilder(
            builder: (c, BoxConstraints constraints) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (c, w) {
                  var rotationDeg = _MAX_ROTATION * (1 -_progressAnimation.value);
//                  var rotationDeg = 30.0;
                  return Container(
                      color: Color.fromRGBO(231, 198, 189, 1.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _getMenuItems(
                          rotationDeg: rotationDeg,
                          width: constraints.biggest.width
                        ),
                      )
                  );
                },
              );
            },
          )
      ),
    );
  }
}

