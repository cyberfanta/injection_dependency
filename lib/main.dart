import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_cubit.dart';
import 'data_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  await dotenv.load(fileName: ".env");

  runApp(
    MyApp(
      dataRepository: DataRepository(sharedPreferences),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.dataRepository,
  });

  final DataRepository dataRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => DataCubit(dataRepository),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inyección de Dependencias'),
        elevation: 3,
      ),
      body: Center(
        child: BlocBuilder<DataCubit, DataState>(
          builder: (context, state) {
            if (state is DataInitial) {
              return const Text('Pulsa el botón para cargar datos');
            }

            if (state is DataLoading) {
              return const CircularProgressIndicator();
            }

            if (state is DataLoaded) {
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    state.data,
                  ),
                ],
              );
            }

            if (state is DataError) {
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    'Error: ${state.message}',
                  ),
                ],
              );
            }

            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<DataCubit>().fetchData(),
        child: const Icon(Icons.download),
      ),
    );
  }
}
