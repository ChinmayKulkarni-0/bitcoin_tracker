import 'package:bitcointracker/Utils/config.dart';
import 'package:bitcointracker/Utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BitcoinPriceScreen extends StatefulWidget {
  @override
  _BitcoinPriceScreenState createState() => _BitcoinPriceScreenState();
}

class _BitcoinPriceScreenState extends State<BitcoinPriceScreen> {
  Future<Map<String, dynamic>> _fetchBitcoinPrice() async {
    final response = await http
        .get(Uri.parse(ApiConstants.baseUrl + ApiConstants.currentPrice));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['bpi'];
    } else {
      throw Exception('Failed to load bitcoin price');
    }
  }

  final List<String> _currencies = ['USD', 'GBP', 'EUR'];
  int _selectedCurrencyIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: CommonColor.BACKGROUND_PRIMARY,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchBitcoinPrice(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final bpi = snapshot.data;
            // Get the selected currency and its price
            final selectedCurrency = _currencies[_selectedCurrencyIndex];
            final selectedPrice = bpi![selectedCurrency]['rate'];
            return Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeHorizontal * 10),
                bitcoinImage,
                // Show the selected currency's price on top
                price(selectedPrice),
                // Show the currency selector
                currency,
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error}',
                style: const TextStyle(color: CommonColor.ERROR),
              ),
            );
          }
          // By default, show a loading spinner
          return loader;
        },
      ),
    );
  }

  //Loader
  Widget get loader => const Center(
        child: CircularProgressIndicator(),
      );

  //Image of Bitcoin
  Widget get bitcoinImage => SvgPicture.asset(
        'assets/image/BTC.svg',
        height: SizeConfig.screenHeight * 0.2,
        allowDrawingOutsideViewBox: true,
      );

  //Selected Price Text
  Widget price(selectedPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      alignment: Alignment.center,
      child: Text(
        '$selectedPrice',
        style: const TextStyle(fontSize: 48.0, color: CommonColor.PRICE_TEXT),
      ),
    );
  }

// Currency scrollable ui
  Widget get currency => Expanded(
        child: CupertinoPicker(
          itemExtent: 60.0,
          useMagnifier: true,
          magnification: 1.5,
          diameterRatio: 1,
          children: _currencies.map((currency) {
            // Only show the rate for the selected currency
            // final rateText = isSelected ? '\$${rate}' : '';
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currency,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            );
          }).toList(),
          onSelectedItemChanged: (index) {
            setState(() {
              _selectedCurrencyIndex = index;
            });
          },
        ),
      );
}
