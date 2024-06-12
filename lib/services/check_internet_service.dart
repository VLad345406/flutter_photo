import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CheckInternet extends StatefulWidget {
  final Widget widget;

  const CheckInternet({super.key, required this.widget});

  @override
  State<CheckInternet> createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<List<ConnectivityResult>> snapshot) {
            if (snapshot.hasData) {
              List<ConnectivityResult>? result = snapshot.data;
              if (result?[0] == ConnectivityResult.mobile ||
                  result?[0] == ConnectivityResult.wifi ||
                  result?[0] == ConnectivityResult.ethernet) {
                return widget.widget;
              } else {
                return Center(child: Text('No internet'));
              }
            } else {
              return Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}