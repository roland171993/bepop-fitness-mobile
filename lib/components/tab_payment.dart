import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKCardApproval.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKNetworks.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:bepop_fitness/extensions/system_utils.dart';
import 'package:bepop_fitness/main.dart';

class PayTabScreen extends StatefulWidget {
  const PayTabScreen(
      {super.key,
      this.onCall,
      this.clientKey,
      this.cartId,
      this.serverKey,
      this.profileId,
      this.amount,
      this.currencyCode});
  final Function? onCall;
  final double? amount;
  final String? currencyCode;
  final String? clientKey;
  final String? serverKey;
  final String? profileId;
  final String? cartId;

  @override
  State<PayTabScreen> createState() => _PayTabScreenState();
}

class _PayTabScreenState extends State<PayTabScreen> {
  // static const String profileId = "95079";

  //static const String serverKey = "SDJNDHTTTT-JDJ92KMWNR-TL9DRWNRBR*";

  //static const String clientKey = "CKKMBR-6VPD6D-6PMKNV-QKMDRV";

  static const String cartDescription = "Flowers";

  static const String merchantName = "Flowers Store";

  static const String screenTitle = "Pay with Card";

  static const String merchantCountryCode = "EG";

  static const bool showBillingInfo = true;

  static const bool forceShippingInfo = true;

  static const tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;

  static const transactionType = PaymentSdkTransactionType.SALE;

  final List<PaymentSdkAPms> apms = [PaymentSdkAPms.AMAN];

  final List<PaymentSDKNetworks> networks = [
    PaymentSDKNetworks.visa,
    PaymentSDKNetworks.amex
  ];

  final PaymentSDKCardApproval cardApproval = PaymentSDKCardApproval(
    validationUrl: "https://www.example.com/validation",
    binLength: 6,
    blockIfNoResponse: false,
  );

  static const String billingAddress = "st. 12";

  static const String billingCountry = "eg";

  static const String billingCity = "dubai";

  static const String billingState = "dubai";

  static const String billingZipCode = "12345";

  static const String shippingAddress = billingAddress;

  static const String shippingCountry = billingCountry;

  static const String shippingCity = billingCity;

  static const String shippingState = billingState;

  static const String shippingZipCode = billingZipCode;

  @override
  void initState() {
    _handlePayment(FlutterPaytabsBridge.startCardPayment);
    print("---------105>>>${widget.currencyCode}");

    finish(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox.shrink(),
        ),
      ),
    );
  }

  BillingDetails _createBillingDetails() {
    return BillingDetails(
      '${userStore.fName} ${userStore.lName}',
      userStore.email,
      userStore.phoneNo,
      billingAddress,
      billingCountry,
      billingCity,
      billingState,
      billingZipCode,
    );
  }

  ShippingDetails _createShippingDetails() {
    return ShippingDetails(
      '${userStore.fName} ${userStore.lName}',
      userStore.email,
      userStore.phoneNo,
      shippingAddress,
      shippingCountry,
      shippingCity,
      shippingState,
      shippingZipCode,
    );
  }

  PaymentSdkConfigurationDetails _generatePaymentConfig() {
    final configuration = PaymentSdkConfigurationDetails(
      profileId: widget.profileId,
      serverKey: widget.serverKey,
      clientKey: widget.clientKey,
      transactionType: transactionType,
      cartId: widget.cartId,
      cartDescription: cartDescription,
      merchantName: merchantName,
      screentTitle: screenTitle,
      amount: widget.amount,
      showBillingInfo: showBillingInfo,
      forceShippingInfo: forceShippingInfo,
      currencyCode: widget.currencyCode,
      merchantCountryCode: merchantCountryCode,
      billingDetails: _createBillingDetails(),
      shippingDetails: _createShippingDetails(),
      alternativePaymentMethods: apms,
      linkBillingNameWithCardHolderName: true,
      cardApproval: cardApproval,
    );

    configuration.iOSThemeConfigurations = IOSThemeConfigurations();
    configuration.tokeniseType = tokeniseType;

    return configuration;
  }

  Future<void> _handlePayment(Function paymentMethod) async {
    paymentMethod(_generatePaymentConfig(), (event) {
      _processTransactionEvent(event);
      if (mounted) setState(() {});
    });
  }

  void _processTransactionEvent(dynamic event) {
    if (event["status"] == "success") {
      final transactionDetails = event["data"];
      _logTransaction(transactionDetails);
    } else if (event["status"] == "error") {
      debugPrint("Error occurred in transaction: ${event["message"]}");
    } else if (event["status"] == "event") {
      debugPrint("Event occurred: ${event["message"]}");
    }
  }

  void _logTransaction(dynamic transactionDetails) {
    if (transactionDetails["isSuccess"]) {
      debugPrint("successful transaction");
      widget.onCall!();
      finish(context);
      if (transactionDetails["isPending"]) {
        debugPrint("transaction pending");
      }
    } else {
      debugPrint(
          "failed transaction. Reason: ${transactionDetails["payResponseReturn"]}");
    }
  }
}
