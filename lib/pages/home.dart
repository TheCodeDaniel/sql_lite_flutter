// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:untitled/db/states_db.dart';
import 'package:untitled/model/states_model.dart';
import 'package:untitled/widgets/dropdown_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

                // Iterate through each state and add its text to the items list
                for (var state in states) {
                  items.add(state.stateName);
                }

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
                          const SizedBox(height: 40),
                          const Center(
                            child: Text("Select a state and local government"),
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: DropDowntoSearch(
                              title: "Search a state",
                              items: items,
                            ),
                          ),
                          const Divider(),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: const DropDowntoSearch(
                              title: "Select local government",
                              items: [],
                            ),
                          ),
                        ],
                      );
              }),
        ),
      ),
    );
  }
}
