import 'package:consulta_receitas_tp6/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('A tela inicial mostra campo e botão de pesquisa', (tester) async {
    await tester.pumpWidget(const AppReceitas());

    expect(find.text('Consulta de Receitas'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(
      find.text('Digite o nome de uma receita para começar.'),
      findsOneWidget,
    );
  });

  testWidgets('Pesquisa vazia mostra mensagem ao usuário', (tester) async {
    await tester.pumpWidget(const AppReceitas());
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    expect(find.text('Digite o nome de uma receita.'), findsOneWidget);
  });
}