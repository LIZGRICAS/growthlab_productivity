
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'diagnostics_page.dart';
import '../bloc/growth_bloc.dart';
import '../bloc/growth_event.dart';
import '../bloc/growth_state.dart';

// TODO: pega aquí EXACTAMENTE tu GrowthPage + widgets privados
class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrowthBloc, GrowthState>(
      builder: (context, state) {
        // Determinamos si estamos en el estado de sincronización de 7 segundos
        final isSyncing = state.status == GrowthStatus.loading && 
                         state.logs.isNotEmpty && 
                         state.logs.first.contains('Sync');

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    backgroundColor: const Color(0xFFF7F9FC),
                    title: const Text(
                      'GrowthLab Pro', 
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1)
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.bug_report_outlined),
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DiagnosticsPage())),
                        tooltip: 'Diagnostics',
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _HeaderSubtitle(),
                          const SizedBox(height: 24),
                          _ActionGrid(),
                          const SizedBox(height: 24),
                          const _GenerateButton(),
                          const SizedBox(height: 32),
                          _TaskListSection(tasks: state.tasks),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isSyncing) const _SyncOverlay(),
            ],
          ),
          bottomNavigationBar: _BottomNav(currentIndex: state.activeTab),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.read<GrowthBloc>().add(TrackEventRequested());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Evento de prueba enviado: Hola_mundo')),
              );
            },
            icon: const Icon(Icons.bug_report_rounded),
            label: const Text('Test CleverTap'),
            backgroundColor: Colors.indigo,
          ),
        );
      },
    );
  }
}

class _HeaderSubtitle extends StatelessWidget {
  const _HeaderSubtitle();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SANDBOX DE PRODUCTIVIDAD',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.indigo.withAlpha(153),
            letterSpacing: 2,
          ),
        ),
        const Text(
          'Orquestación CleverTap + Firebase',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blueGrey),
        ),
      ],
    );
  }
}

class _ActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _GrowthCard(
          label: 'Onboard User',
          subtitle: 'IDENTIDAD NATIVA',
          icon: Icons.person_add_rounded,
          color: Colors.indigo,
          onTap: () => context.read<GrowthBloc>().add(CreateUserRequested()),
        ),
        _GrowthCard(
          label: 'Update DOB',
          subtitle: 'PROFILE PUSH',
          icon: Icons.cake_rounded,
          color: Colors.green,
          onTap: () => context.read<GrowthBloc>().add(CompleteProfileRequested()),
        ),
        _GrowthCard(
          label: 'Track Hola',
          subtitle: 'CUSTOM EVENT',
          icon: Icons.bolt_rounded,
          color: Colors.amber.shade800,
          onTap: () => context.read<GrowthBloc>().add(TrackEventRequested()),
        ),
        _GrowthCard(
          label: 'Sync 7s',
          subtitle: 'REST CLOUD',
          icon: Icons.cloud_sync_rounded,
          color: Colors.redAccent,
          onTap: () => context.read<GrowthBloc>().add(SyncDataRequested()),
        ),
      ],
    );
  }
}

class _GrowthCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GrowthCard({
    required this.label, 
    required this.subtitle, 
    required this.icon, 
    required this.color, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle, 
                    style: TextStyle(
                      color: Colors.white.withAlpha(153), 
                      fontSize: 8, 
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1
                    )
                  ),
                  Text(
                    label, 
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.w900,
                      fontSize: 13
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  const _GenerateButton();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => context.read<GrowthBloc>().add(GenerateTasksRequested()),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade900,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Text(
          'GENERAR LISTA PERFORMANCE (400)',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
      ),
    );
  }
}

class _TaskListSection extends StatelessWidget {
  final List<String> tasks;
  const _TaskListSection({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'COLA DE TAREAS',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey, letterSpacing: 1),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '${tasks.length}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.indigo.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text('No hay tareas activas en el motor.', style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontStyle: FontStyle.italic)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length > 5 ? 5 : tasks.length,
              separatorBuilder: (context, index) => const Divider(height: 24, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) => Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('${index + 1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 16),
                  Text(tasks[index], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.blueGrey)),
                ],
              ),
            ),
          if (tasks.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                '+ ${tasks.length - 5} tareas adicionales optimizadas',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      selectedIndex: currentIndex,
      onDestinationSelected: (i) => context.read<GrowthBloc>().add(NavigationTabChanged(i)),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Dash'),
        NavigationDestination(icon: Icon(Icons.settings_suggest_rounded), label: 'Config'),
        NavigationDestination(icon: Icon(Icons.code_rounded), label: 'Logs'),
      ],
    );
  }
}

class _SyncOverlay extends StatelessWidget {
  const _SyncOverlay();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(230),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(strokeWidth: 5, color: Colors.redAccent),
            ),
            const SizedBox(height: 24),
            const Text(
              'SINCRONIZANDO...',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Orquestación REST (7 segundos)',
              style: TextStyle(color: Colors.blueGrey.shade400, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
