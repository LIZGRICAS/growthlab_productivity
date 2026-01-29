import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/growth_bloc.dart';
import '../bloc/growth_event.dart';
import '../bloc/growth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrowthLab Productivity'),
      ),
      body: BlocConsumer<GrowthBloc, GrowthState>(
        listener: (context, state) {
          if (state.status == GrowthStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Perfil creado en CleverTap')),
            );
          }

          if (state.status == GrowthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ocurrió un error')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == GrowthStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<GrowthBloc>().add(CreateUserRequested());
              },
              child: const Text('Crear perfil CleverTap'),
            ),
          );
        },
      ),
    );
  }
}
