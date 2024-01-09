import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mscpl_vivek/otp_validator/core/utils/custom_colors.dart';
import 'package:mscpl_vivek/otp_validator/core/widget/global_widget/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../core/widget/global_widget/pin_code_field/pin_code_fields.dart';
import '../providers/otp_verification_provider.dart';

class OtpVerificationWidget extends StatefulWidget {
  final String mobileNumber;
  const OtpVerificationWidget({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  Timer? _countDownTimer;
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
        Expanded(
            child:
                SingleChildScrollView(child: _buildOtpVerification(context))),
        Consumer<OtpVerificationProvider>(
          builder: (BuildContext context,
              OtpVerificationProvider values, Widget? child) {
            return _buildResendAndChangeButton("Resend Code",primaryBackgroundColor,(!_countDownTimer!.isActive),(){
              startTimeout();
            });
          }
        ),
        const SizedBox(
          height: 8,
        ),
        _buildResendAndChangeButton("change Number",primaryBackgroundColor,true,(){
          Navigator.of(context).pop();
        }),
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
          buildOtpCard(context),
          const SizedBox(
            height: 8,
          ),
          _buildTimerText(),
        ],
      ),
    );
  }

  Widget buildOtpCard(BuildContext context) {
    return Consumer<OtpVerificationProvider>(builder: (BuildContext context,
        OtpVerificationProvider values, Widget? child) {
      return values.otpText.length == 6
          ? Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: values.otpText == values.validOtpCode
                  ? validOtpColor
                  : invalidOtpColor,
              border: Border.all(color: buttonBorderColor),
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              _buildOTPField(context),
              _buildStatusText(
                  values.otpText == values.validOtpCode),
            ],
          ))
          : _buildOTPField(context);
    });
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
      text: TextSpan(
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
            style: const TextStyle(
                color: titleTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPField(BuildContext context) {
    return PinCodeField(
      controller: _otpPasswordTEC,
      appContext: context,
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
      onValidate: (String? value){
        Provider.of<OtpVerificationProvider>(context,listen: false).validateOtp(value);
      },
    );
  }

  String getPhoneNumber() {
    String phone = widget.mobileNumber;
    return "(${phone.substring(0, 1)}**)***_**${phone.substring(8)}";
  }

  Widget _buildTimerText() {
    return Consumer<OtpVerificationProvider>(builder:
        (BuildContext context, OtpVerificationProvider values, Widget? child) {
      return Visibility(
        visible: values.otpText.length < 6 && _countDownTimer!.isActive,
        child: Center(
            child: Text(
          "Verification code expires in ${values.getRemainingTime()}",
          style: const TextStyle(
              color: subTitleTextColor,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        )),
      );
    });
  }

  Widget _buildResendAndChangeButton(String value,Color backgroundColor,bool? isEnable,Function() onClickTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PrimaryButton(
        onPressed: isEnable ?? false ?  () {
          onClickTap();
        } : null,
        color: backgroundColor,
        borderRadius: 8.0,
        text: value,
        textColor: titleTextColor,
      ),
    );
  }

  Widget _buildStatusText(bool isValid) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isValid ? Icons.check : Icons.close,
          color: primaryBackgroundColor,
          size: 20,
          weight: 800,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          isValid ? "Verified" : "Invalid OTP",
          style: const TextStyle(
              color: primaryBackgroundColor,
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
      ],
    );
  }

  void startTimeout() {
    int timerMaxSeconds = 170;
    int currentSeconds = 0;
    _countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentSeconds = timer.tick;
      var timerInfo =
          Provider.of<OtpVerificationProvider>(context, listen: false);
      timerInfo.updateRemainingTime(timerMaxSeconds, currentSeconds);
      if (timer.tick >= timerMaxSeconds) timer.cancel();
    });
  }

  @override
  void dispose() {
    _otpPasswordTEC.dispose();
    _countDownTimer?.cancel();
    super.dispose();
  }
}
