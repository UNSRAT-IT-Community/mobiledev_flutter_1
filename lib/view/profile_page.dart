import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Data> getUserData() async {
    final response = await http.get(
      Uri.parse('https://reqres.in/api/users/3'),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      Data userData = UserModel.fromJson(body).data;
      return userData;
    } else {
      throw 'Error';
    }
  }

  late Future<Data> user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = getUserData();
  }

  // FutureBuilder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/background.png',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          FutureBuilder(
              future: user,
              builder: (ctx, snapshot) {
                var connectionState = snapshot.connectionState;
                if (connectionState == ConnectionState.none) {
                  return const Text('No Internet Access');
                } else if (connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundImage:
                                NetworkImage(snapshot.data!.avatar),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                            style: titleTextStyle.copyWith(
                                letterSpacing: 2,
                                color: Colors.deepPurple,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Senior Flutter Developer',
                            style: titleTextStyle.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(snapshot.data!.email)
                        ],
                      ),
                    );
                  }
                }
                return const Center(
                  child: Text('No Data'),
                );
              })
        ],
      ),
    );
  }
}
