import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jour/workdetails.dart';
import 'work_tile.dart';

class workList extends StatefulWidget {
  @override
  _workListState createState() => _workListState();
}

class _workListState extends State<workList> {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<List<details>>(context) ?? [];

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return WorkTile(items: notes[index]);
      },
    );
  }
}
