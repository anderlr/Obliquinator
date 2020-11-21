import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() => runApp(
      MaterialApp(
        home: Home(),
      ), // Wrap your app
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double w, h;
  double gravity = 10; //10 m/s
  double velocity, reach;
  double angle; //0 até 90
  String _infoText = "Informe os parâmetros do canhão";
  String _infoText2 = "Descubra o alcance do lançamento abaixo:";
  TextEditingController angleController = TextEditingController();
  TextEditingController velocityController = TextEditingController();
  String imageChange = "images/cannonStage1.png";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetField() {
    angleController.text = "";
    velocityController.text = "";
    setState(() {
      imageChange = "images/cannonStage1.png";
      _infoText = "Informe os parâmetros do canhão";
      _infoText2 = "Descubra o alcance do lançamento abaixo:";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      angle = double.parse(angleController.text);
      velocity = double.parse(velocityController.text); //cm para metros
      angle = angle * pi / 180;
      reach = ((velocity * velocity) * sin(2 * angle)) / gravity;
      imageChange = "images/cannonStage2.png";
      _infoText2 = "Mude os parâmetros ou recomece!";
      _infoText = "Alcance do projétil: ${reach.toStringAsPrecision(4)} metros";
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    // 411.429
    // 683.429

    // print(w.toStringAsPrecision(6));
    // print(h.toStringAsPrecision(6));
    return Scaffold(
        backgroundColor: Colors.amber[900],
        appBar: AppBar(
          title: Text(
            "Obliquinator 3000",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh), //botao de reset
              onPressed: _resetField,
              alignment: Alignment.centerLeft,
              iconSize: 30,
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0.0243 * w, 0.05 * h, 0.0243 * w, 0 * h),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 0.02 * h, top: 0.02 * h),
                    child: Text(_infoText2,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.blue[800], fontSize: 25)),
                  ),
                  Image.asset(
                    imageChange,
                    width: 0.486 * w,
                    height: 0.292 * h,
                  ),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Angulo(Graus)",
                          labelStyle: TextStyle(color: Colors.blue[800])),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                      controller: angleController,
                      validator: (value) {
                        if (value.isEmpty ||
                            double.parse(value) <= 0 ||
                            double.parse(value) > 90) {
                          return "Insira um angulo válido! (0,90]";
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Velocidade(m/s):",
                        labelStyle: TextStyle(color: Colors.blue[800])),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                    controller: velocityController,
                    validator: (value) {
                      if (value.isEmpty || int.parse(value) < 0)
                        return "Insira uma velocidade válida! (0,inf)";
                      else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.03 * h, bottom: 0.03 * h),
                    child: Container(
                      height: 50,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _calculate();
                          }
                        },
                        child: Text("Lançar",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)),
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  Text(
                    _infoText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue[800], fontSize: 25),
                  ),
                ],
              )),
        ));
  }
}
