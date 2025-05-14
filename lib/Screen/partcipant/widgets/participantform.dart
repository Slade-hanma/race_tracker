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

  late TextEditingController dobController;

  @override
  void initState() {
    super.initState();
    name = widget.participant?.name ?? '';
    sex = widget.participant?.sex ?? '';
    dateOfBirth = widget.participant?.dateOfBirth ?? DateTime.now();
    school = widget.participant?.school ?? '';
    bibNumber = widget.participant?.bibNumber ?? '';
    dobController = TextEditingController(
      text: "${dateOfBirth.year}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    );
  }

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C6BC0),
        title: Text(
          widget.isEditing ? "Update Participant" : "Add Participant",
          style: const TextStyle(color: Colors.white), // White title text
        ),
        iconTheme: const IconThemeData(color: Colors.white), // White back arrow
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: 400, // Taller form
            width: 320,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: _inputDecoration('Name*'),
                      validator: (value) => value!.isEmpty ? 'Please enter name' : null,
                      onSaved: (value) => name = value!,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: dobController,
                            readOnly: true,
                            decoration: _inputDecoration('Date of Birth'),
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: dateOfBirth,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  dateOfBirth = picked;
                                  dobController.text =
                                      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: sex,
                            decoration: _inputDecoration('Gender*'),
                            validator: (value) => value!.isEmpty ? 'Please enter gender' : null,
                            onSaved: (value) => sex = value!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: school,
                            decoration: _inputDecoration('School'),
                            validator: (value) => value!.isEmpty ? 'Please enter school' : null,
                            onSaved: (value) => school = value!,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: bibNumber,
                            decoration: _inputDecoration('Bib Number'),
                            validator: (value) => value!.isEmpty ? 'Please enter bib number' : null,
                            onSaved: (value) => bibNumber = value!,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C6BC0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final newParticipant = Participant(
                              id: widget.isEditing
                                  ? widget.participant!.id
                                  : widget.participantProvider.getNextId(),
                              name: name,
                              sex: sex,
                              dateOfBirth: dateOfBirth,
                              school: school,
                              bibNumber: bibNumber,
                            );
                            widget.onSubmit(newParticipant);
                            Navigator.pop(context, newParticipant);
                          }
                        },
                        child: Text(
                          widget.isEditing ? 'Update Participant' : 'Add Participant',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
