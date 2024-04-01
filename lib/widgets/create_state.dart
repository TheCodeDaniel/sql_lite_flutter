import 'package:flutter/material.dart';
import 'package:untitled/model/states_model.dart';

class CreateStateWidget extends StatefulWidget {
  final States? state;
  final ValueChanged<String> onSubmit;
  const CreateStateWidget({
    super.key,
    this.state,
    required this.onSubmit,
  });

  @override
  State<CreateStateWidget> createState() => _CreateStateWidgetState();
}

class _CreateStateWidgetState extends State<CreateStateWidget> {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller.text = widget.state?.stateName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.state != null;
    return AlertDialog(
      title: Text(isEditing ? "Edit state" : "Add / Edit"),
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'name',
          ),
          validator: (value) =>
              value != null && value.isEmpty ? 'name is required' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate() == true) {
              widget.onSubmit(controller.text);
            }
          },
          child: const Text("Submit"),
        )
      ],
    );
  }
}
