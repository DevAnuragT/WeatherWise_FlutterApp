import 'package:flutter/material.dart';
import 'package:weather/services/database.dart';
import 'package:weather/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  final Database database;
  CityScreen({required this.database});

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  @override
  void initState() {
    super.initState();
    widget.database.getData().then((_) {
      setState(() {}); // Update the UI after data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    String city = '';
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 35.0,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.transparent,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              if (widget.database.isEmpty()) {
                                return AlertDialog(
                                  title: Text('No Data'),
                                  content: Text(
                                      'No weather data available to delete.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: Text('Delete City'),
                                  content: Text(
                                      'Are you sure you want to delete all weather reports?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.database.deleteAll();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        },
                        child: Icon(
                          Icons.delete_outline,
                          size: 35,
                          color: Color(0xFFEB1555),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: kTextFieldDecoration,
                  onChanged: (value) {
                    city = value;
                  },
                ),
              ),
              SizedBox(height: 15),
              Card(
                color: Color(0xEC16AF9D),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, city); // Send city back to previous screen
                  },
                  child: Text(
                    'Get Weather',
                    style: kHeadingStyle.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.database.getLength(),
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(15),
                      color: Colors.blueGrey,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/weather/${widget.database.getIcon(index)}.png',
                            width: 40,
                            height: 40,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/icons/clouds.png',
                                // Provide path to the default weather icon
                                width: 40,
                                height: 40,
                              );
                            },
                          ),
                          title: Text(
                            widget.database.getCity(index),
                            style: kHeadingStyle.copyWith(
                                color: Colors.white70, fontSize: 18),
                          ),
                          trailing: Text(
                              '${widget.database.getTemperature(index)}°C',
                              style: kHeadingStyle.copyWith(
                                  color: Colors.white, fontSize: 37)),
                          onTap: () {
                            Navigator.pop(
                                context, widget.database.getCity(index));
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete City'),
                                  content: Text(
                                      'Are you sure you want to delete ${widget.database.getCity(index)}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.database.deleteCity(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
