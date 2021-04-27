import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../states/target.dart';
import '../common/util.dart';
import '../common/animation.dart';
import '../components/text.dart';

class EditTarget extends StatefulWidget {
  @override
  _EditTargetState createState() => new _EditTargetState();
}

class _EditTargetState extends State<EditTarget> {
  TextEditingController _utaskController = TextEditingController();
  TextEditingController _udaysController = TextEditingController();
  Widget child;

  Widget gloveWidget;
  bool status = false;

  void createTarget(TargetListStates contextStates) {
    if (status == true) {
      contextStates.create(
          _utaskController.text, int.parse(_udaysController.text.toString()));
      _utaskController.clear();
      _udaysController.clear();
      // TODO: 不能用pushNewScreen了; 如果不能用，就换成提示，让用户自己切换
      // Navigator.of(context).push(
      //     MaterialPageRoute(settings: RouteSettings(name: ), builder: (BuildContext context) => TargetList()));
      // pushNewScreen(context, screen: TargetList());
    }
  }

  void onTaskChange(String days) {
    checkValid();
  }

  void onDaysChange(String days) {
    if (days != null && days != '' && int.parse(days.toString()) > 365) {
      _udaysController.value = TextEditingValue(text: '365');
    }
    checkValid();
  }

  void checkValid() {
    status = _utaskController.text != '' && _udaysController.text != '';
    setGlove();
  }

  void setGlove() {
    setState(() {
      /// TODO: `rebuild`时有渐变效果
      gloveWidget = status == true
          ? FadeInImage(
              placeholder: AssetImage('imgs/glove_error.webp'),
              image: AssetImage('imgs/glove.webp'),
              fit: BoxFit.cover,
              width: 100)
          : Image(
              image: AssetImage('imgs/glove_error.webp'),
              repeat: ImageRepeat.noRepeat,
              width: 100,
            );
      // WidgetTransition.trans
    });
  }

  @override
  void initState() {
    checkValid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final targetListContext = context.watch<TargetListStates>();
    final List<Target> targetListRunning =
        targetListContext.getTargetList(status: 'running');
    if (targetListRunning.length < 3) {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFieldWidget(
              controller: _utaskController,
              labelText: "任务",
              style: TextStyle(color: Colors.white),
              onChange: onTaskChange),
          TextFieldWidget(
              controller: _udaysController,
              keyboardType: TextInputType.number,
              labelText: "期限(最大365)",
              style: TextStyle(color: Colors.white),
              onChange: onDaysChange,
              formatter: [WhitelistingTextInputFormatter(RegExp("[0-9]"))]),
          Listener(
              onPointerDown: (PointerDownEvent event) =>
                  createTarget(targetListContext),
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: WidgetTransition(
                    initialChild: Image(
                      image: AssetImage('imgs/glove_error.webp'),
                      repeat: ImageRepeat.noRepeat,
                      width: 100,
                    ),
                    duration: 500,
                  )))
        ],
      );
    } else {
      child = Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('imgs/panda_gun.webp'),
              repeat: ImageRepeat.noRepeat,
              width: 100,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText('足够了 :)'),
                  SizedBox(
                    height: 10,
                  ),
                  StyleText(
                      '已经有三个任务了.',
                      TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            )
          ],
        ),
      );
    }
    return Container(
        color: Utils.transStr('000'),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Center(
                    child: Image(
                        image: AssetImage('imgs/edit.png'),
                        repeat: ImageRepeat.noRepeat,
                        width: Utils.getScreenWidth(context)))),
            Container(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  // height: 200,
                  color: Colors.black.withOpacity(0.3),
                  // padding: const EdgeInsets.only(bottom: 100),
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
            )
          ],
        ));
  }
}
