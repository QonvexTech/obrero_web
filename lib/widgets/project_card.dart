import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String? name;
  final DateTime? startDate;
  final String? description;

  ProjectCard({
    @required this.name,
    @required this.startDate,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(),
        title: Text(name!),
        subtitle: Text(description!),
      ),
    );
  }
}
