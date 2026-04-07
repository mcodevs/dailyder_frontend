import 'package:flutter/material.dart';

class PmUpdateTheme {
  const PmUpdateTheme._();

  static const Color background = Color(0xFF07111E);
  static const Color backgroundGlow = Color(0xFF0D1A2B);
  static const Color surface = Color(0xFF0E1A2C);
  static const Color surfaceRaised = Color(0xFF132238);
  static const Color surfaceSoft = Color(0xFF0A1523);
  static const Color border = Color(0xFF22324A);
  static const Color textPrimary = Color(0xFFF4F8FF);
  static const Color textSecondary = Color(0xFF93A7C4);
  static const Color accent = Color(0xFF4EA4FF);
  static const Color accentSoft = Color(0xFF14365E);
  static const Color success = Color(0xFF59C58A);
  static const Color warning = Color(0xFFF2B84B);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color neutral = Color(0xFF8A99AE);

  static const List<PmStatusOption> statusOptions = [
    PmStatusOption(
      value: null,
      label: 'Tanlanmagan',
      icon: Icons.radio_button_unchecked,
      color: neutral,
      hint: 'Hali baholanmadi',
    ),
    PmStatusOption(
      value: 'completed',
      label: 'Bajarildi',
      icon: Icons.check_circle_outline,
      color: success,
      hint: 'Holat yopilgan',
    ),
    PmStatusOption(
      value: 'warning',
      label: 'Xavf bor',
      icon: Icons.warning_amber_outlined,
      color: warning,
      hint: 'Diqqat talab qiladi',
    ),
    PmStatusOption(
      value: 'blocked',
      label: 'To‘siq bor',
      icon: Icons.block_outlined,
      color: danger,
      hint: 'Ish to‘xtagan',
    ),
    PmStatusOption(
      value: 'dropped',
      label: 'Bekor qilindi',
      icon: Icons.remove_circle_outline,
      color: neutral,
      hint: 'Scope yopildi',
    ),
  ];

  static BoxDecoration shellDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [background, Color(0xFF050A13)],
      ),
    );
  }

  static BoxDecoration panelDecoration({Color? tint, bool elevated = false}) {
    final baseColor = tint ?? surface;
    return BoxDecoration(
      color: baseColor,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseColor,
          Color.lerp(baseColor, surfaceRaised, 0.18) ?? surfaceRaised,
        ],
      ),
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: border),
      boxShadow: elevated
          ? const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 28,
                offset: Offset(0, 18),
              ),
            ]
          : const [],
    );
  }

  static BoxDecoration statusDecoration({
    required Color color,
    bool selected = false,
  }) {
    return BoxDecoration(
      color: selected
          ? Color.lerp(color, surface, 0.82) ?? surface
          : surfaceSoft,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: selected ? color : border,
        width: selected ? 1.3 : 1,
      ),
    );
  }

  static InputDecoration fieldDecoration({
    required String labelText,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      filled: true,
      fillColor: surfaceSoft,
      labelStyle: const TextStyle(
        color: textSecondary,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: const TextStyle(color: Color(0xFF73859E)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: accent, width: 1.4),
      ),
    );
  }

  static ButtonStyle primaryButtonStyle() {
    return FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      backgroundColor: accent,
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFF274669),
      disabledForegroundColor: const Color(0xFF9AB0C7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
    );
  }

  static ButtonStyle secondaryButtonStyle() {
    return OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      foregroundColor: textPrimary,
      side: const BorderSide(color: border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
    );
  }
}

class PmStatusOption {
  const PmStatusOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.hint,
  });

  final String? value;
  final String label;
  final IconData icon;
  final Color color;
  final String hint;
}

PmStatusOption pmStatusOptionForValue(String? value) {
  return PmUpdateTheme.statusOptions.firstWhere(
    (option) => option.value == value,
    orElse: () => PmUpdateTheme.statusOptions.first,
  );
}

String pmStatusLabel(String? value) => pmStatusOptionForValue(value).label;

Color pmStatusColor(String? value) => pmStatusOptionForValue(value).color;

IconData pmStatusIcon(String? value) => pmStatusOptionForValue(value).icon;
