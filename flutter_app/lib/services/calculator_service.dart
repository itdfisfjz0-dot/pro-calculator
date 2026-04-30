import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  static final _parser = Parser();

  /// تقييم تعبير رياضي وإرجاع نتيجة منسقة.
  /// يدعم: + - * / ^ () sin cos tan log ln sqrt pi e %
  static String evaluate(String expression) {
    if (expression.trim().isEmpty) return '0';
    try {
      String normalized = _normalize(expression);
      final exp = _parser.parse(normalized);
      final cm = ContextModel();
      final result = exp.evaluate(EvaluationType.REAL, cm) as double;

      if (result.isNaN || result.isInfinite) {
        throw Exception('غير معرّف');
      }
      return _formatNumber(result);
    } catch (_) {
      return 'خطأ';
    }
  }

  static String _normalize(String input) {
    String s = input;
    s = s.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('−', '-');
    s = s.replaceAll('π', '${math.pi}');
    s = s.replaceAllMapped(RegExp(r'(?<![a-zA-Z])e(?![a-zA-Z\(])'),
        (m) => '${math.e}');
    s = s.replaceAll('√', 'sqrt');
    s = s.replaceAll('^', '^');
    // % كنسبة مئوية: تحويل n% إلى (n/100)
    s = s.replaceAllMapped(
        RegExp(r'(\d+(?:\.\d+)?)%'), (m) => '(${m[1]}/100)');
    return s;
  }

  static String _formatNumber(double value) {
    if (value == value.truncateToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }
    String s = value.toStringAsPrecision(12);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }
}
