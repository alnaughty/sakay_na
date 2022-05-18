import 'package:flutter/material.dart';
import 'package:sakayna/global/app.dart';

class BookingInfo extends StatefulWidget {
  const BookingInfo({
    Key? key,
    required this.distance,
    required this.fareCallback,
    required this.passengerCallback,
  }) : super(key: key);
  final double distance;
  final ValueChanged<double> fareCallback;
  final ValueChanged<int> passengerCallback;
  @override
  State<BookingInfo> createState() => _BookingInfoState();
}

class _BookingInfoState extends State<BookingInfo> {
  final TextEditingController _passenger = TextEditingController()..text = "1";
  int passengerAmount = 1;
  int minimumFare = 10;
  double _totalFare = 10;
  void totalFare(int amount) {
    final double _tempFare = (widget.distance * minimumFare) <= 10
        ? 10
        : (widget.distance * minimumFare);
    setState(() {
      _totalFare = passengerAmount * _tempFare;
    });
    widget.fareCallback(_totalFare);
  }

  @override
  void initState() {
    totalFare(passengerAmount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Number of\npassengers: ",
              style: TextStyle(
                color: Colors.grey.shade800,
                height: 1,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (passengerAmount > 1) {
                        setState(() {
                          passengerAmount -= 1;
                          _passenger.text = passengerAmount.toString();
                          totalFare(passengerAmount);
                        });
                        widget.passengerCallback(passengerAmount);
                      }
                    },
                    icon: Icon(Icons.remove_circle_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _passenger,
                      onChanged: (text) {
                        if (text.isNotEmpty) {
                          final int parsed = int.parse(text);
                          print("ASDS");
                          if (parsed > 0) {
                            setState(() {
                              passengerAmount = parsed;
                              // _passenger.text = parsed.toString();
                              totalFare(passengerAmount);
                            });
                            widget.passengerCallback(passengerAmount);
                          } else {
                            setState(() {
                              passengerAmount = 1;
                              totalFare(passengerAmount);
                            });
                            widget.passengerCallback(passengerAmount);
                          }
                        } else {
                          setState(() {
                            passengerAmount = 1;
                            // _passenger.text = passengerAmount.toString();
                            totalFare(passengerAmount);
                          });
                          widget.passengerCallback(passengerAmount);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        passengerAmount += 1;
                        _passenger.text = passengerAmount.toString();
                        totalFare(passengerAmount);
                        widget.passengerCallback(passengerAmount);
                      });
                    },
                    icon: Icon(Icons.add_circle_outlined),
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text("Total Fare: "),
            const SizedBox(
              width: 10,
            ),
            Text((_totalFare).toStringAsFixed(2))
          ],
        ),
      ],
    );
  }
}
