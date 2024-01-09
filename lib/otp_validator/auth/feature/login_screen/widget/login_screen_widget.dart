import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/custom_colors.dart';
import '../../../../core/widget/global_widget/textfield.dart';
import '../../otp_verification/widget/otp_verification_widget.dart';
import '../providers/login_provider.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  final _phoneTEC = TextEditingController();
  final _phoneFN = FocusNode();
  final groupValue = true;

  @override
  void initState() {
    super.initState();
    _phoneTEC.addListener(_onTextChangeListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: _buildLogin(),
    );
  }

  Widget _buildLogin() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            children: [
              Text(
                "Enter your mobile no",
                style: TextStyle(
                    color: titleTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "We need to verity your number",
            style: TextStyle(
                color: subTitleTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 16),
          ),
          const SizedBox(
            height: 32,
          ),
          _buildLabelText(),
          const SizedBox(
            height: 8,
          ),
          _buildPhoneNumber(),
          const SizedBox(
            height: 48,
          ),
          _buildGetOtpButton(),
          const Spacer(),
          _buildBottomText(),
        ],
      ),
    );
  }

  Widget _buildLabelText() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        children: <TextSpan>[
          TextSpan(
            text: "Mobile Number",
          ),
          TextSpan(
            text: ' *',
            style: TextStyle(color: errorColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FDTextField(
        controller: _phoneTEC,
        labelText: "Enter mobile no",
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.phone,
        focusNode: _phoneFN,
      ),
    );
  }

  Widget _buildGetOtpButton() {
    return Consumer<LoginProvider>(
        builder: (BuildContext context, LoginProvider value, Widget? child) {
      return InkWell(
        onTap: () {
          value.isGetOtpVuttonDisabled || !value.isRadioButtonEnabled
              ? null
              : onGetOtpTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
                color:
                    value.isGetOtpVuttonDisabled || !value.isRadioButtonEnabled
                        ? Colors.grey[600]
                        : titleTextColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: const Center(
              child: Text(
                "Get OTP",
                style: TextStyle(
                    color: primaryBackgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomText() {
    return Consumer<LoginProvider>(
        builder: (BuildContext context, LoginProvider values, Widget? child) {
      return Align(
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            Radio(
              value: values.isRadioButtonEnabled,
              groupValue: groupValue,
              onChanged: (bool? value) {
                context
                    .read<LoginProvider>()
                    .updateRadioButton(values.isRadioButtonEnabled);
                _onTextChangeListener();
              },
              toggleable: true,
            ),
            const Expanded(
              child: Text(
                  'Allow fydaa to send financial knowledge and critical alerts on your WhatsApp.',style: TextStyle(color: subTitleTextColor,fontSize: 12),),
            ),
          ],
        ),
      );
    });
  }

  void _onTextChangeListener() {
    if (_phoneTEC.text.length == 10) {
      context.read<LoginProvider>().updateGetOtpButton(false);
    } else {
      context.read<LoginProvider>().updateGetOtpButton(true);
    }
  }

  void onGetOtpTap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   OtpVerificationWidget(mobileNumber: _phoneTEC.text, )));
  }

  @override
  void dispose() {
    _phoneTEC.dispose();
    super.dispose();
  }
}
