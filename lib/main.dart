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
  bool _carregando = false;
  bool _pesquisou = false;
  String? _erro;

  Future<void> _buscarReceitas() async {
    final termo = _pesquisaController.text.trim();

    if (termo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome de uma receita.')),
      );
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
      _receitas = [];
    });

    try {
      final url = Uri.https(
        'www.themealdb.com',
        '/api/json/v1/1/search.php',
        {'s': termo},
      );

      final resposta = await http.get(url).timeout(const Duration(seconds: 15));

      if (resposta.statusCode != 200) {
        throw Exception('Erro HTTP: ${resposta.statusCode}');
      }

      final dados = jsonDecode(resposta.body);
      if (dados is! Map<String, dynamic>) {
        throw const FormatException('Resposta JSON inválida');
      }

      final resultados = dados['meals'];
      if (resultados != null && resultados is! List) {
        throw const FormatException('Lista de receitas inválida');
      }

      final receitas = (resultados as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();

      if (!mounted) return;
      setState(() {
        _receitas = receitas;
        _pesquisou = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _receitas = [];
        _pesquisou = true;
        _erro = 'Não foi possível buscar as receitas. '
            'Confira sua internet e tente novamente.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  Widget _mostrarResultados() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Text(
          _erro!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    if (!_pesquisou) {
      return const Center(
        child: Text(
          'Digite o nome de uma receita para começar.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    if (_receitas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma receita encontrada. Tente outro nome.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
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
                  child: Image.network(
                    imagem,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 88,
                        height: 88,
                        color: Colors.black12,
                        child: const Icon(Icons.restaurant, size: 36),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
            Text(
              'Consulta de Receitas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 4),
            Text(
              'Feito Por: $nome',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11),
            ),
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
                onSubmitted: (_) {
                  if (!_carregando) _buscarReceitas();
                },
                decoration: const InputDecoration(
                  labelText: 'Nome da receita',
                  hintText: 'Ex.: chicken, pasta, beef...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _carregando ? null : _buscarReceitas,
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


