import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template custom_checkbox_animated}
/// A **fully customizable, animated, and accessible** checkbox widget for Flutter. ✨
///
/// ### Why use this?
/// - **Design control**: size, shape (circle/rounded), border, colors, icon.
/// - **Polished UX**: smooth transitions and responsive visuals.
/// - **Accessibility-first**: semantics, tooltip, and larger tap targets ♿
/// - **Web-friendly**: proper mouse cursor feedback.
///
/// ### Example
/// ```dart
/// bool isChecked = false;
///
/// CustomCheckBox(
///   value: isChecked,
///   onChanged: (v) => setState(() => isChecked = v),
///   size: 24,
///   borderRadius: 6,
///   borderColor: Colors.grey,
///   activeBorderColor: Colors.blue,
///   fillColor: Colors.white,
///   activeFillColor: Colors.blue,
///   iconColor: Colors.white,
///   tooltip: 'Accept terms',
/// )
/// ```
/// {@endtemplate}
class CustomCheckBox extends StatelessWidget {
  /// Creates a [CustomCheckBox] widget.
  ///
  /// All parameters are optional except [value]. The widget is **disabled**
  /// if [onChanged] is `null`.
  const CustomCheckBox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 24.0,
    this.borderRadius = 6.0,
    this.shape = BoxShape.rectangle,
    this.borderColor = Colors.grey,
    this.activeBorderColor = Colors.blue,
    this.fillColor = Colors.white,
    this.activeFillColor = Colors.blue,
    this.iconColor = Colors.white,
    this.icon,
    this.iconSize,
    this.borderWidth = 1.6,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.disabledOpacity = 0.5,
    this.minTapTargetSize = kMinInteractiveDimension,
    this.animationDuration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
    this.tooltip,
    this.semanticsLabel,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.enableHapticFeedback = false,
  }) : assert(disabledOpacity >= 0 && disabledOpacity <= 1.0);
  //==== Core state =============================================================

  /// Whether the checkbox is selected.
  ///
  /// This value is the **source of truth** for rendering the check mark.
  final bool value;

  /// Called when the checkbox is toggled.
  ///
  /// If `onChanged` is `null`, the widget is **disabled** (non-interactive)
  /// and its visuals are dimmed using [disabledOpacity].
  final ValueChanged<bool>? onChanged;

  //==== Visuals ================================================================

  /// The side length of the square area (also used as diameter if [shape] is circle).
  ///
  /// Defaults to `24.0`.
  final double size;

  /// Corner roundness used when [shape] is [BoxShape.rectangle].
  ///
  /// Ignored when [shape] is [BoxShape.circle].
  final double borderRadius;

  /// The overall shape of the control (rectangle or circle).
  ///
  /// Defaults to [BoxShape.rectangle].
  final BoxShape shape;

  /// Border color when unchecked (and enabled).
  final Color borderColor;

  /// Border color when checked (and enabled).
  final Color activeBorderColor;

  /// Background fill color when unchecked (and enabled).
  final Color fillColor;

  /// Background fill color when checked (and enabled).
  final Color activeFillColor;

  /// The color applied to [icon] when the checkbox is checked.
  final Color iconColor;

  /// The icon shown when checked. Defaults to [Icons.check_rounded].
  final Widget? icon;

  /// The icon size inside the box. Defaults to `size * 0.8`.
  final double? iconSize;

  /// The stroke width of the outer border.
  final double borderWidth;

  /// Padding inside the interactive region but outside the painted box.
  final EdgeInsetsGeometry padding;

  /// Outer margin around the entire widget.
  final EdgeInsetsGeometry margin;

  /// Opacity multiplier used to visually dim the control when disabled.
  ///
  /// Must be in the range `0.0..1.0`. Defaults to `0.5`.
  final double disabledOpacity;

  /// Minimum tap target dimension to improve usability.
  ///
  /// Defaults to Material's `kMinInteractiveDimension` (48.0).
  final double minTapTargetSize;

  //==== Interaction & UX =======================================================

  /// Duration of the selection animation.
  final Duration animationDuration;

  /// Animation curve for transitions.
  final Curve curve;

  /// Optional tooltip shown on long press / hover.
  final String? tooltip;

  /// Screen reader label for accessibility.
  final String? semanticsLabel;

  /// Mouse cursor when hovering (web/desktop).
  final MouseCursor? mouseCursor;

  /// Controls focus behavior.
  final FocusNode? focusNode;

  /// If true, requests focus when the widget is built.
  final bool autofocus;

  /// Whether to trigger light haptic feedback on toggle.
  final bool enableHapticFeedback;

  bool get _enabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(borderRadius);

    // Colors based on state (checked/unchecked + enabled/disabled)
    final Color baseFill = value ? activeFillColor : fillColor;
    final Color baseBorder = value ? activeBorderColor : borderColor;

    final Color effectiveFill =
        _enabled ? baseFill : baseFill.withValues(alpha: disabledOpacity);
    final Color effectiveBorder =
        _enabled ? baseBorder : baseBorder.withValues(alpha: disabledOpacity);

    final shapeBorder = shape == BoxShape.circle
        ? const CircleBorder()
        : RoundedRectangleBorder(borderRadius: BorderRadius.all(radius));

    final Widget checkboxBody = ClipPath(
      clipper: shape == BoxShape.circle
          ? const ShapeBorderClipper(shape: CircleBorder())
          : ShapeBorderClipper(shape: shapeBorder),
      child: AnimatedContainer(
        duration: animationDuration,
        curve: curve,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: effectiveFill,
          shape: shape,
          border: Border.all(color: effectiveBorder, width: borderWidth),
          borderRadius:
              shape == BoxShape.rectangle ? BorderRadius.all(radius) : null,
        ),
        child: AnimatedSwitcher(
          duration: animationDuration,
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: value
              ? Center(
                  key: const ValueKey('checked'),
                  child: IconTheme(
                    data: IconThemeData(
                      color: iconColor,
                      size: iconSize ?? (size * 0.8),
                    ),
                    child: icon ?? const Icon(Icons.check_rounded),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('unchecked')),
        ),
      ),
    );

    // Wrap with semantics and tooltip for accessibility & UX
    Widget result = Semantics(
      label: semanticsLabel,
      checked: value,
      enabled: _enabled,
      button: true,
      onTap: _enabled ? () => onChanged?.call(!value) : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minTapTargetSize,
          minHeight: minTapTargetSize,
        ),
        child: Align(
          child: Padding(
            padding: margin,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                customBorder: shapeBorder,
                mouseCursor: mouseCursor ??
                    (_enabled
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic),
                canRequestFocus: _enabled,
                focusNode: focusNode,
                autofocus: autofocus,
                splashColor: activeFillColor.withValues(alpha: 0.15),
                highlightColor: Colors.transparent,
                onTap: _enabled
                    ? () {
                        if (enableHapticFeedback) {
                          HapticFeedback.selectionClick();
                        }
                        onChanged?.call(!value);
                      }
                    : null,
                child: Padding(
                  padding: padding,
                  child: checkboxBody,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      result = Tooltip(message: tooltip!, child: result);
    }

    return result;
  }
}
