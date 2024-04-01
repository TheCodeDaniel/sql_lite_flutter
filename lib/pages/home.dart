// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:untitled/db/states_db.dart';
import 'package:untitled/model/lga_model.dart';
import 'package:untitled/model/states_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<States>>? futureStates;
  String? selectedValue;
  String? selectedLocalGovernment;
  int? selectedValueID;
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
      appBar: AppBar(
        title: const Text("States"),
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
              }

              final states = snapshot.data!;

              List<String> items = [];
              // List<int> itemsId = [];

              // Iterate through each state and add its text to the items list
              for (var state in states) {
                items.add(state.stateName);
              }

              // for (var state in states) {
              //   itemsId.add(state.id);
              // }

              return states.isEmpty
                  ? const Center(
                      child: Text(
                        "Add new states in 'edit' ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButton<String>(
                            hint: const Text(
                              'Select a state',
                            ),
                            value: selectedValue,
                            onChanged: (String? value) {
                              // Do something with the selected value
                              setState(() {
                                selectedValue = value;
                              });

                              statesDB
                                  .fetchIdByName(selectedValue!)
                                  .then((value) {
                                setState(() {
                                  selectedValueID = value;
                                });
                              });
                            },
                            items: items.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        if (selectedValueID != null)
                          FutureBuilder<List<LocalGovernment>>(
                            future: statesDB.fetchLocalGovernmentsByStateId(
                                selectedValueID!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              final localGovernments = snapshot.data!;

                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton<String>(
                                  hint: const Text('Select a local government'),
                                  value: selectedLocalGovernment,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedLocalGovernment = value;
                                    });
                                  },
                                  items: localGovernments
                                      .map<DropdownMenuItem<String>>(
                                    (LocalGovernment lg) {
                                      return DropdownMenuItem<String>(
                                        value: lg.lgName,
                                        child: Text(lg.lgName),
                                      );
                                    },
                                  ).toList(),
                                ),
                              );
                            },
                          ),
                      ],
                    );

            },
          ),
        ),
      ),
    );
  }
}
