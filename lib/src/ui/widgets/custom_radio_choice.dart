import '../../core/app_export.dart';
import 'package:flutter/material.dart';

class CustomRadioChoice extends StatefulWidget {
  const CustomRadioChoice({
    super.key,
    this.width,
    required this.choices,
    required this.onSelected,
  });

  final double? width;
  final List<String> choices;
  final Function(String) onSelected;

  @override
  State<CustomRadioChoice> createState() => _CustomRadioChoice();
}

class _CustomRadioChoice extends State<CustomRadioChoice> {
  int? _value = 0;

  late final double? width;
  late final List<String> choices;
  late final double spacing; // Define o espaçamento entre os ChoiceChips
  late final double chipWidth;

  @override
  void initState() {
    super.initState();
    width = widget.width ?? 328.h;
    choices = widget.choices;
    spacing = 8.h;
    chipWidth = (width! - (spacing * (choices.length - 1))) / choices.length;
    widget.onSelected(choices[0]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width!,
      //height: 96.h,
      child: Wrap(
        spacing: spacing,
        children: List<Widget>.generate(
          choices.length,
          (int index) {
            final bool isSelected = _value == index;
            return SizedBox(
              width: chipWidth,
              child: ChoiceChip(
                showCheckmark: false,
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onPrimaryContainer,
                //backgroundColor: null,
                //checkmarkColor: Theme.of(context).colorScheme.primary,
                selectedColor: Theme.of(context).colorScheme.secondary,
                //color: Theme.of(context).colorScheme.onPrimaryContainer,
                label: Container(
                  alignment: AlignmentDirectional.center,
                  height: 32.h,
                  width: chipWidth,
                  child: Text(
                    choices[index],
                    style: isSelected
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                selected: _value == index,
                onSelected: (bool selected) {
                  if (_value != index) {
                    setState(() {
                      _value = selected ? index : null;
                    });
                    widget.onSelected(choices[index]);
                  }
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
