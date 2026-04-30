import 'package:flutter/material.dart';
import '../models/calculation.dart';
import '../services/calculator_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/calculator_button.dart';
import '../widgets/display.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';
  bool _justEvaluated = false;

  void _append(String s) {
    setState(() {
      if (_justEvaluated &&
          !RegExp(r'[+\-*/^%]').hasMatch(s) &&
          !s.endsWith('(')) {
        _expression = '';
      }
      _justEvaluated = false;
      _expression += s;
      _result = CalculatorService.evaluate(_expression);
    });
  }

  void _delete() {
    setState(() {
      if (_expression.isEmpty) return;
      // Remove function names like sin( in one step
      final fnMatch = RegExp(r'(sin\(|cos\(|tan\(|log\(|ln\(|sqrt\()$')
          .firstMatch(_expression);
      if (fnMatch != null) {
        _expression =
            _expression.substring(0, _expression.length - fnMatch[0]!.length);
      } else {
        _expression = _expression.substring(0, _expression.length - 1);
      }
      _result = CalculatorService.evaluate(_expression);
      _justEvaluated = false;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '0';
      _justEvaluated = false;
    });
  }

  Future<void> _equal() async {
    if (_expression.isEmpty) return;
    final result = CalculatorService.evaluate(_expression);
    if (result == 'خطأ') {
      setState(() => _result = result);
      return;
    }
    setState(() {
      _result = result;
      _justEvaluated = true;
    });
    // Save to local DB
    await DatabaseService.instance.insert(Calculation(
      expression: _expression,
      result: result,
      createdAt: DateTime.now(),
    ));
    setState(() {
      _expression = result;
    });
  }

  void _openHistory() async {
    final picked = await Navigator.of(context).push<Calculation>(
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
    if (picked != null) {
      setState(() {
        _expression = picked.expression;
        _result = picked.result;
        _justEvaluated = true;
      });
    }
  }

  Widget _row(List<Widget> children) => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'الآلة الحاسبة',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'السجل',
            icon: const Icon(Icons.history_rounded),
            onPressed: _openHistory,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              CalculatorDisplay(expression: _expression, result: _result),
              const SizedBox(height: 12),
              // Scientific row 1
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _row([
                      CalcButton(
                          label: 'sin',
                          style: BtnStyle.scientific,
                          onTap: () => _append('sin(')),
                      CalcButton(
                          label: 'cos',
                          style: BtnStyle.scientific,
                          onTap: () => _append('cos(')),
                      CalcButton(
                          label: 'tan',
                          style: BtnStyle.scientific,
                          onTap: () => _append('tan(')),
                      CalcButton(
                          label: 'log',
                          style: BtnStyle.scientific,
                          onTap: () => _append('log(10,')),
                    ]),
                    _row([
                      CalcButton(
                          label: 'ln',
                          style: BtnStyle.scientific,
                          onTap: () => _append('ln(')),
                      CalcButton(
                          label: '√',
                          style: BtnStyle.scientific,
                          onTap: () => _append('sqrt(')),
                      CalcButton(
                          label: 'x^y',
                          style: BtnStyle.scientific,
                          onTap: () => _append('^')),
                      CalcButton(
                          label: 'π',
                          style: BtnStyle.scientific,
                          onTap: () => _append('π')),
                    ]),
                    _row([
                      CalcButton(
                          label: '(',
                          style: BtnStyle.scientific,
                          onTap: () => _append('(')),
                      CalcButton(
                          label: ')',
                          style: BtnStyle.scientific,
                          onTap: () => _append(')')),
                      CalcButton(
                          label: 'e',
                          style: BtnStyle.scientific,
                          onTap: () => _append('e')),
                      CalcButton(
                          label: '%',
                          style: BtnStyle.scientific,
                          onTap: () => _append('%')),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Basic keypad
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    _row([
                      CalcButton(
                          label: 'AC',
                          style: BtnStyle.clear,
                          flex: 2,
                          onTap: _clear),
                      CalcButton(
                          icon: Icons.backspace_outlined,
                          style: BtnStyle.delete,
                          onTap: _delete),
                      CalcButton(
                          label: '÷',
                          style: BtnStyle.operator,
                          onTap: () => _append('/')),
                    ]),
                    _row([
                      CalcButton(label: '7', onTap: () => _append('7')),
                      CalcButton(label: '8', onTap: () => _append('8')),
                      CalcButton(label: '9', onTap: () => _append('9')),
                      CalcButton(
                          label: '×',
                          style: BtnStyle.operator,
                          onTap: () => _append('*')),
                    ]),
                    _row([
                      CalcButton(label: '4', onTap: () => _append('4')),
                      CalcButton(label: '5', onTap: () => _append('5')),
                      CalcButton(label: '6', onTap: () => _append('6')),
                      CalcButton(
                          label: '−',
                          style: BtnStyle.operator,
                          onTap: () => _append('-')),
                    ]),
                    _row([
                      CalcButton(label: '1', onTap: () => _append('1')),
                      CalcButton(label: '2', onTap: () => _append('2')),
                      CalcButton(label: '3', onTap: () => _append('3')),
                      CalcButton(
                          label: '+',
                          style: BtnStyle.operator,
                          onTap: () => _append('+')),
                    ]),
                    _row([
                      CalcButton(
                          label: '0', flex: 2, onTap: () => _append('0')),
                      CalcButton(label: '.', onTap: () => _append('.')),
                      CalcButton(
                          label: '=', style: BtnStyle.equal, onTap: _equal),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
