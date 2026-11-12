import 'dart:convert';
// Integrante: Ryan Xavier P C Amaral

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  List<Map<String, dynamic>> _receitas = [];

  Future<void> _buscarReceitas() async {
    final termo = _pesquisaController.text.trim();
    if (termo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome de uma receita.')),
      );
      return;
    }

    final url = Uri.https(
      'www.themealdb.com',
      '/api/json/v1/1/search.php',
      {'s': termo},
    );
    final resposta = await http.get(url);
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    final resultados = dados['meals'] as List<dynamic>? ?? [];
    if (!mounted) return;
    setState(() {
      _receitas = resultados.cast<Map<String, dynamic>>();
    });
  }

  Widget _mostrarResultados() {
    if (_receitas.isEmpty) {
      return const Center(child: Text('Nenhuma receita na lista.'));
    }
    return ListView.separated(
      itemCount: _receitas.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final receita = _receitas[index];
        final nome = receita['strMeal']?.toString() ?? 'Sem nome';
        final imagem = receita['strMealThumb']?.toString() ?? '';
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imagem, width: 88, height: 88, fit: BoxFit.cover),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(nome, style: const TextStyle(fontSize: 17))),
              ],
            ),
          ),
        );
      },
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
                onSubmitted: (_) { _buscarReceitas(); },
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
              Expanded(child: _mostrarResultados()),
            ],
          ),
        ),
      ),
    );
  }
}


