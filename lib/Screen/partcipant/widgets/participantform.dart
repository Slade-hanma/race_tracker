import 'package:flutter/material.dart';
import '../../../model/participant_model.dart';
import '../../../provider/participant_provider.dart';

class ParticipantForm extends StatefulWidget {
  final Function(Participant) onSubmit;
  final ParticipantProvider participantProvider;
  final Participant? participant;
  final bool isEditing;

  const ParticipantForm({
    Key? key,
    required this.onSubmit,
    required this.participantProvider,
    this.participant,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _ParticipantFormState createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String sex;
  late DateTime dateOfBirth;
  late String school;
  late String bibNumber;

  @override
  void initState() {
    super.initState();
    name = widget.participant?.name ?? '';
    sex = widget.participant?.sex ?? '';
    dateOfBirth = widget.participant?.dateOfBirth ?? DateTime.now();
    school = widget.participant?.school ?? '';
    bibNumber = widget.participant?.bibNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? "Update Participant" : "Add Participant"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: sex,
                decoration: InputDecoration(labelText: 'Sex'),
                validator: (value) => value!.isEmpty ? 'Please enter your sex' : null,
                onSaved: (value) => sex = value!,
              ),
              TextFormField(
                controller: TextEditingController(text: dateOfBirth.toIso8601String().split('T')[0]),
                decoration: InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dateOfBirth,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => dateOfBirth = picked);
                },
              ),
              TextFormField(
                initialValue: school,
                decoration: InputDecoration(labelText: 'School'),
                validator: (value) => value!.isEmpty ? 'Please enter your school' : null,
                onSaved: (value) => school = value!,
              ),
              TextFormField(
                initialValue: bibNumber,
                decoration: InputDecoration(labelText: 'Bib Number'),
                validator: (value) => value!.isEmpty ? 'Please enter your bib number' : null,
                onSaved: (value) => bibNumber = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Participant participant = Participant(
                      id: widget.isEditing
                          ? widget.participant!.id
                          : widget.participantProvider.getNextId(),
                      name: name,
                      sex: sex,
                      dateOfBirth: dateOfBirth,
                      school: school,
                      bibNumber: bibNumber,
                    );

                    widget.onSubmit(participant);

                    Navigator.pop(context, participant);
                  }
                },
                child: Text(widget.isEditing ? "Update Participant" : "Add Participant"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
