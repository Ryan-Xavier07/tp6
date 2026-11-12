import 'package:flutter/material.dart';
// Integrante: Ryan Xavier P C Amaral

const String nome = 'Ryan Xavier P C Amaral';

void main() {
  runApp(const AppReceitas());
}

class AppReceitas extends StatelessWidget {
  const AppReceitas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consulta de Receitas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D61)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAF8),
      ),
      home: const TelaReceitas(),
    );
  }
}

class TelaReceitas extends StatefulWidget {
  const TelaReceitas({super.key});

  @override
  State<TelaReceitas> createState() => _TelaReceitasState();
}

class _TelaReceitasState extends State<TelaReceitas> {
  final TextEditingController _pesquisaController = TextEditingController();

  void _buscarReceitas() {
    final termo = _pesquisaController.text.trim();
    if (termo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome de uma receita.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A pesquisa será implementada na próxima etapa.')),
    );
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Consulta de Receitas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 4),
            Text('Feito Por: $nome',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _pesquisaController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _buscarReceitas(),
                decoration: const InputDecoration(
                  labelText: 'Nome da receita',
                  hintText: 'Ex.: chicken, pasta, beef...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _buscarReceitas,
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Pesquisar'),
              ),
              const SizedBox(height: 20),
              const Expanded(
                child: Center(child: Text('Digite o nome de uma receita para começar.')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

