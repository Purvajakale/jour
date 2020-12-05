import 'package:flutter/material.dart';
import 'work.dart';
import 'workdetails.dart';

class WorkTile extends StatelessWidget {
  final details items;
  WorkTile({this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0),
      child: Card(
          child: ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.blueGrey[items.importance],
        ),
        title: Text(items.work) ?? Text('meet'),
        subtitle: Text('${items.name} - ${items.description}'),
      )),
    );
  }
}
