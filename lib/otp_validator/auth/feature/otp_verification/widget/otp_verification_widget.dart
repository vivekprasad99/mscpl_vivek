import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mscpl_vivek/otp_validator/core/utils/custom_colors.dart';
import 'package:provider/provider.dart';

import '../../../../core/widget/global_widget/pin_code_field/pin_code_fields.dart';
import '../providers/otp_verification_provider.dart';

class OtpVerificationWidget extends StatefulWidget {
  final String mobileNumber;
  const OtpVerificationWidget({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {

  final _otpPasswordTEC = TextEditingController();

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(child: SingleChildScrollView(child: _buildOtpVerification(context))),
        _buildResendButton("Resend Code"),
        const SizedBox(height: 16,),
        _buildResendButton("change Number"),
      ],
    );
  }

  Widget _buildOtpVerification(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBackIcon(context),
          const SizedBox(
            height: 24,
          ),
          const Text(
            "Verify your phone",
            style: TextStyle(
                color: titleTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 32),
          ),
          const SizedBox(
            height: 24,
          ),
          _buildVerificationCode(),
          const SizedBox(
            height: 36,
          ),
          _buildOTPField(context),
          const SizedBox(
            height: 8,
          ),
          _buildTimerText(),
        ],
      ),
    );
  }

  Widget buildBackIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(null);
        },
        child: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  Widget _buildVerificationCode() {
    return RichText(
      textAlign: TextAlign.start,
      text:  TextSpan(
        style: const TextStyle(color: textColor, fontWeight: FontWeight.w500),
        children: <TextSpan>[
          const TextSpan(
              text: "Enter the verification code sent to ",
              style: TextStyle(
                  color: subTitleTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 20)),
          TextSpan(
            text: ' ${getPhoneNumber()}.',
            style: const TextStyle(color: titleTextColor, fontWeight: FontWeight.bold,fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPField(BuildContext context) {
    return PinCodeField(
      appContext: context,
      controller: _otpPasswordTEC,
      length: 6,
      cursorWidth: 1,
      autoFocus: true,
      cursorColor: titleTextColor,
      textStyle: const TextStyle(
          color: titleTextColor, fontSize: 24, fontWeight: FontWeight.w600),
      animationType: AnimationType.fade,
      autoDisposeControllers: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(6),
        fieldHeight: 60,
        fieldWidth: 48,
        borderWidth: 1,
        activeColor: borderLineColor,
        inactiveColor: borderLineColor,
        selectedColor: borderLineColor,
        inactiveFillColor: borderLineColor,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      onValidate: (String value){},
    );
  }

  String getPhoneNumber() {
    String phone = widget.mobileNumber;
    return "(${phone.substring(0, 1)}**)***_**${phone.substring(8)}";
  }

  Widget _buildTimerText() {
    return Consumer<OtpVerificationProvider>(
      builder: (BuildContext context, OtpVerificationProvider values, Widget? child) {
        return Center(child: Text("Verification code expires in ${values.getRemainingTime()}",style: const TextStyle(
            color: subTitleTextColor,
            fontWeight: FontWeight.w400,
            fontSize: 14),));
      }
    );
  }

  Widget _buildResendButton(String value) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          width: double.infinity,
          decoration: BoxDecoration(
              color: primaryBackgroundColor,
              border: Border.all(color: buttonBorderColor),
              borderRadius: BorderRadius.circular(8.0)),
          child:  Center(
            child:  Text(
              value,
              style: const TextStyle(
                  color: titleTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  void startTimeout()
  {
    int timerMaxSeconds = 170;
    int currentSeconds = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentSeconds = timer.tick;
      var timerInfo = Provider.of<OtpVerificationProvider>(context, listen: false);
      timerInfo.updateRemainingTime(timerMaxSeconds,currentSeconds);
      if (timer.tick >= timerMaxSeconds) timer.cancel();
    });
  }

  @override
  void dispose() {
    _otpPasswordTEC.dispose();
    super.dispose();
  }
}
