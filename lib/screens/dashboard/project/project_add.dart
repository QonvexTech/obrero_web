import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project_service.dart';
import 'package:uitemplate/widgets/map.dart';

class ProjectAdd extends StatefulWidget {
  final ProjectModel? projectToEdit;
  const ProjectAdd({
    Key? key,
    this.projectToEdit,
  }) : super(key: key);
  @override
  _ProjectAddState createState() => _ProjectAddState();
}

abstract class Helper {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool userExist(List<EmployeesModel> list, EmployeesModel toCheck) {
    for (var employee in list) {
      if (employee.id == toCheck.id) {
        return true;
      }
    }
    return false;
  }
}

class _ProjectAddState extends State<ProjectAdd> with Helper {
  bool isEdit = false;
  CustomerModel dropdownValue = CustomerModel(
      fname: "UNSET",
      lname: "UNSET",
      email: "UNSET",
      adress: "adress",
      picture: "picture",
      contactNumber: "contactNumber");

  List<EmployeesModel> asignee = [];
  EmployeesModel selectedEmployee = EmployeesModel(
      fname: "fname",
      lname: "lname",
      email: "email",
      password: "password",
      contactNumber: "contactNumber",
      address: "address");
  var copy;
  var nCopy;

  @override
  void initState() {
    //for Edit
    copy = dropdownValue;

    nCopy = selectedEmployee;
    if (widget.projectToEdit != null) {
      isEdit = true;
      nameController.text = widget.projectToEdit!.name!;
      descriptionController.text = widget.projectToEdit!.description!;
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

  late List<EmployeesModel> _employeeCopy =
      List<EmployeesModel>.from(employees);
  late List<EmployeesModel> employees =
      Provider.of<EmployeeSevice>(context, listen: false).users;
  @override
  Widget build(BuildContext context) {
    var projectService = Provider.of<ProjectProvider>(context, listen: false);
    if (isEdit) {
      Provider.of<MapService>(context, listen: false)
          .setCoordinates(widget.projectToEdit!.coordinates!);
    }
    List<CustomerModel> customers =
        Provider.of<CustomerService>(context, listen: false).customers;

    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height,
        child: AdaptiveContainer(children: [
          AdaptiveItem(
            content: Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Nom du Chantier",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    SizedBox(
                      height: MySpacer.small,
                    ),
                    Container(
                      height: 5 * 24.0,
                      child: TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Description",
                        ),
                        controller: descriptionController,
                      ),
                    ),
                    DropdownButton<CustomerModel>(
                      value: dropdownValue,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      iconSize: 20,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (CustomerModel? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <CustomerModel>[copy!, ...customers.map((e) => e)]
                          .map<DropdownMenuItem<CustomerModel>>(
                              (CustomerModel value) {
                        return DropdownMenuItem<CustomerModel>(
                          value: value,
                          child: Text(value.fname!),
                        );
                      }).toList(),
                    ),
                    Container(
                      height: 150,
                      width: double.infinity,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: asignee.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 50,
                              child: Text(asignee[index].fname!),
                            );
                          }),
                    ),
                    DropdownButton<EmployeesModel>(
                      value: selectedEmployee,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 20,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (EmployeesModel? newValue) {
                        setState(() {
                          selectedEmployee = newValue!;
                          print(asignee.map((e) => e.id).toList());

                          if (!userExist(asignee, newValue)) {
                            asignee.add(newValue);
                          }
                        });
                      },
                      items: <EmployeesModel>[
                        nCopy!,
                        ..._employeeCopy.map((e) => e)
                      ].map<DropdownMenuItem<EmployeesModel>>(
                          (EmployeesModel value) {
                        return DropdownMenuItem<EmployeesModel>(
                          value: value,
                          child: Text(value.fname!),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        Text("Start Date"),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        Text("${startDate.toLocal()}".split(' ')[0]),
                        MaterialButton(
                          onPressed: () => _selectStartDate(context),
                          child: Text('Start date'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MySpacer.medium,
                    ),
                    Row(
                      children: [
                        Text("End Date"),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        Text("${endDate.toLocal()}".split(' ')[0]),
                        MaterialButton(
                          onPressed: () => _selectEndDate(context),
                          child: Text('End date'),
                        ),
                      ],
                    ),
                    Consumer<MapService>(
                      builder: (_, data, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Location ${data.coordinates ?? "No coordinates specified"}"),
                            MaterialButton(
                              onPressed: () {
                                if (isEdit) {
                                  widget.projectToEdit!.name =
                                      nameController.text;
                                  widget.projectToEdit!.customerId =
                                      dropdownValue.id == null
                                          ? widget.projectToEdit!.customerId
                                          : dropdownValue.id;
                                  widget.projectToEdit!.description =
                                      descriptionController.text;
                                  widget.projectToEdit!.coordinates =
                                      data.coordinates;
                                  widget.projectToEdit!.startDate =
                                      this.startDate;
                                  widget.projectToEdit!.endDate = this.endDate;
                                  projectService.updateProject(
                                      newProject: widget.projectToEdit);
                                } else {
                                  ProjectModel newProject = ProjectModel(
                                      assignee: [...asignee.map((e) => e.id!)],
                                      customerId: dropdownValue.id,
                                      description: descriptionController.text,
                                      name: nameController.text,
                                      coordinates: data.coordinates,
                                      startDate: this.startDate,
                                      endDate: this.endDate);

                                  projectService
                                      .createProjects(
                                        newProject: newProject,
                                      )
                                      .whenComplete(
                                          () => Navigator.pop(context));
                                }
                              },
                              child: Text("Create Project"),
                            )
                          ],
                        );
                      },
                    )
                  ],
                )),
              ),
            ),
          ),
          AdaptiveItem(
              content: Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.width,
                  width: double.infinity,
                  child: MapScreen())),
        ]));
  }
}
