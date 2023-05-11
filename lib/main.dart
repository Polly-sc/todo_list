import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'features/authorization/bloc/auth_bloc.dart';
import 'features/authorization/data/repositories/auth_repository.dart';
import 'features/authorization/presentation/pages/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/todo_list/factories/di_container.dart';
import 'features/todo_list/presentation/my_app.dart';

abstract class AppFactory {
  Widget makeApp();
}

final appFactory = makeAppFactory();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  final app = appFactory.makeApp();
  runApp(app);
}