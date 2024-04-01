// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/db/states_db.dart';
import 'package:untitled/model/states_model.dart';
import 'package:untitled/widgets/create_state.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Future<List<States>>? futureStates;
  final statesDB = StatesDB();

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  void fetchStates() {
    setState(() {
      futureStates = statesDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateStateWidget(
              onSubmit: (String value) async {
                await statesDB.create(stateName: value);
                if (!mounted) return;
                fetchStates();
                Navigator.of(context).pop();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Edit"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<States>>(
            future: futureStates,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              } else {
                final states = snapshot.data!;

                return states.isEmpty
                    ? const Center(
                        child: Text(
                          "No states...",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final state = states[index];

                          return ListTile(
                            onTap: () {},
                            contentPadding: EdgeInsets.zero,
                            // tileColor: Colors.deepPurple.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              states[index].stateName,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CreateStateWidget(
                                        onSubmit: (value) async {
                                          await statesDB.update(
                                            id: state.id,
                                            stateName: value,
                                          );
                                          fetchStates();
                                          if (!mounted) return;
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.edit),
                                ),
                                const SizedBox(width: 40),
                                GestureDetector(
                                  onTap: () async {
                                    await statesDB.delete(state.id);
                                    fetchStates();
                                  },
                                  child: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 12,
                        ),
                        itemCount: states.length,
                      );
              }
            },
          ),
        ),
      ),
    );
  }
}