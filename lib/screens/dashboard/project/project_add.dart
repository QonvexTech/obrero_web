import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/project_service.dart';
import 'package:uitemplate/widgets/map.dart';

class ProjectAdd extends StatefulWidget {
  final ProjectModel? projectToEdit;

  const ProjectAdd({Key? key, this.projectToEdit}) : super(key: key);
  @override
  _ProjectAddState createState() => _ProjectAddState();
}

abstract class Helper {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
}

class _ProjectAddState extends State<ProjectAdd> with Helper {
  @override
  void initState() {
    //for Edit
    if (widget.projectToEdit != null) {
      nameController.text = widget.projectToEdit!.name!;
      descriptionController.text = widget.projectToEdit!.description!;
      latController.text = widget.projectToEdit!.coordinates![0];
      longController.text = widget.projectToEdit!.coordinates![1];
      customerIdController.text = widget.projectToEdit!.customerId!.toString();
      startDate = widget.projectToEdit!.startDate!;
      endDate = widget.projectToEdit!.endDate!;
    }
    super.initState();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate)
      setState(() {
        startDate = picked;
      });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate)
      setState(() {
        endDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    var projectService = Provider.of<ProjectProvider>(context, listen: false);
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(hintText: "Nom du Chantier"),
                      controller: nameController,
                    ),
                    Container(
                      height: 5 * 24.0,
                      child: TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Description",
                        ),
                        controller: descriptionController,
                      ),
                    ),

                    TextField(
                      decoration: InputDecoration(hintText: "lat"),
                      controller: latController,
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "long"),
                      controller: longController,
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "customerID"),
                      controller: customerIdController,
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("${startDate.toLocal()}".split(' ')[0]),
                        Text("${endDate.toLocal()}".split(' ')[0]),
                        SizedBox(
                          height: 20.0,
                        ),
                        MaterialButton(
                          onPressed: () => _selectStartDate(context),
                          child: Text('Start date'),
                        ),
                        MaterialButton(
                          onPressed: () => _selectEndDate(context),
                          child: Text('End date'),
                        ),
                      ],
                    ),

                    MaterialButton(
                      onPressed: () {
                        ProjectModel newProject = ProjectModel(
                            customerId: int.parse(customerIdController.text),
                            description: descriptionController.text,
                            name: nameController.text,
                            coordinates: [
                              latController.text,
                              longController.text
                            ],
                            startDate: startDate,
                            endDate: endDate);

                        print(newProject.name);
                        print(newProject.customerId);
                        print(newProject.coordinates);
                        print(newProject.startDate);
                        print(newProject.endDate);
                        projectService.createProjects(newProject);
                      },
                      child: Text("Create Project"),
                    )

                    //TODO: dropdown client
                    //TODO: map or coordinates
                    // TODO: warnigs
                    // TODO:Start date/end
                  ],
                )),
              ),
            ),
            Expanded(child: MapScreen())
          ],
        ));
  }
}
