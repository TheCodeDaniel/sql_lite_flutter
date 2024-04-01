// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:untitled/db/states_db.dart';
import 'package:untitled/model/lga_model.dart';
import 'package:untitled/widgets/create_state.dart';

class LgaManager extends StatefulWidget {
  final int stateId;
  const LgaManager({super.key, required this.stateId});

  @override
  State<LgaManager> createState() => _LgaManagerState();
}

class _LgaManagerState extends State<LgaManager> {
  Future<List<LocalGovernment>>? futureLG;
  final statesDB = StatesDB();

  @override
  void initState() {
    super.initState();
    fetchLG();
  }

  void fetchLG() {
    setState(() {
      futureLG = statesDB.fetchLocalGovernmentsByStateId(widget.stateId);
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
                await statesDB.createLocalGovernment(
                  stateId: widget.stateId,
                  localGovernmentName: value,
                );
                if (!mounted) return;
                fetchLG();
                Navigator.of(context).pop();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("LGA edit"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<LocalGovernment>>(
            future: futureLG,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              } else {
                final lg = snapshot.data!;

                return lg.isEmpty
                    ? const Center(
                        child: Text(
                          "Click '+' to add local government",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final lga = lg[index];

                          return ListTile(
                            leading: const Icon(Icons.location_on),

                            // contentPadding: EdgeInsets.zero,
                            tileColor: Colors.deepPurpleAccent.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              lg[index].lgName,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CreateStateWidget(
                                        onSubmit: (value) async {
                                          await statesDB.updateLocalGovernment(
                                            id: lga.id,
                                            localGovernmentName: value,
                                          );
                                          fetchLG();
                                          if (!mounted) return;
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 20),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () async {
                                    await statesDB
                                        .deleteLocalGovernment(lga.id);
                                    fetchLG();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 12,
                        ),
                        itemCount: lg.length,
                      );
              }
            },
          ),
        ),
      ),
    );
  }
}
