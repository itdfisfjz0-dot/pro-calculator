import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import '../theme/app_theme.dart';

enum BtnStyle { number, operator, scientific, equal, clear, delete }

class CalcButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final BtnStyle style;
  final int flex;

  const CalcButton({
    super.key,
    this.label,
    this.icon,
    required this.onTap,
    this.style = BtnStyle.number,
    this.flex = 1,
  });

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  bool _pressed = false;

  Color get _bg {
    switch (widget.style) {
      case BtnStyle.number:
        return AppColors.muted;
      case BtnStyle.operator:
        return AppColors.accent;
      case BtnStyle.scientific:
        return AppColors.secondary;
      case BtnStyle.equal:
        return AppColors.primary;
      case BtnStyle.clear:
        return AppColors.destructive.withValues(alpha: 0.12);
      case BtnStyle.delete:
        return AppColors.muted;
    }
  }

  Color get _fg {
    switch (widget.style) {
      case BtnStyle.scientific:
        return AppColors.secondaryForeground;
      case BtnStyle.equal:
        return Colors.white;
      case BtnStyle.clear:
        return AppColors.destructive;
      default:
        return AppColors.foreground;
    }
  }

  double get _fontSize {
    switch (widget.style) {
      case BtnStyle.scientific:
        return 16;
      case BtnStyle.number:
        return 26;
      default:
        return 22;
    }
  }

  Future<void> _handleTap() async {
    HapticFeedback.lightImpact();
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 8, amplitude: 40);
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _handleTap,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1,
          duration: const Duration(milliseconds: 90),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(16),
              border: widget.style == BtnStyle.clear
                  ? Border.all(color: AppColors.destructive.withValues(alpha: 0.2))
                  : null,
              boxShadow: widget.style == BtnStyle.equal
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: widget.icon != null
                  ? Icon(widget.icon, color: _fg, size: 24)
                  : Text(
                      widget.label ?? '',
                      style: TextStyle(
                        color: _fg,
                        fontSize: _fontSize,
                        fontWeight: widget.style == BtnStyle.equal
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
