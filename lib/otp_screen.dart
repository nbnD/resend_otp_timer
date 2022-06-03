import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'custom_button.dart';
import 'my_theme.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    Key? key,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();

  String currentText = "";
  bool hasError = false;
  late Timer _timer;
  int _start = 5;
  bool isLoading = false;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isLoading = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();

    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    errorController!.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.themeColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyTheme.themeColor,
        elevation: 0,
        title: const Text("Verify OTP"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Code has been sent to",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 60,
                      fieldWidth: 60,
                      activeFillColor: Colors.white.withOpacity(0.5),
                      disabledColor: Colors.white.withOpacity(0.5),
                      inactiveColor: Colors.white.withOpacity(0.5),
                      inactiveFillColor: Colors.grey,
                      selectedColor: Colors.white.withOpacity(0.5),
                      activeColor: Colors.white.withOpacity(0.5),
                      selectedFillColor: MyTheme.hoverColor,
                      errorBorderColor: Colors.red),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  textStyle: const TextStyle(color: Colors.white),
                  onCompleted: (v) {},
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              const SizedBox(height: 30),
              _start != 0
                  ? Row(
                      children: [
                        Text(
                          "Resend Code in",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _start.toString(),
                          style: TextStyle(
                              color: MyTheme.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Don't receive code?",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _start = 5;
                              isLoading = true;
                              startTimer();
                            });
                          },
                          child: Text(
                            "Request again",
                            style: TextStyle(
                                color: MyTheme.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        )
                      ],
                    ),
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      minHeight: 60,
                      onPressed: () {
                        formKey.currentState!.validate();

                        if (currentText.length != 6) {
                          errorController!.add(ErrorAnimationType
                              .shake); // Triggering error shake animation
                          setState(() => hasError = true);
                        } else {
                          setState(
                            () {},
                          );
                        }
                      },
                      color: Colors.transparent,
                      title: "VERIFY")
            ],
          ),
        ),
      ),
    );
  }
}
