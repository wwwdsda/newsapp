import 'package:flutter/material.dart';

const List<String> allBiases = ['중도', '진보', '보수'];

class NewsBiasSection extends StatefulWidget {
  final Set<String> selectedBiases;
  final ValueChanged<Set<String>> onBiasesChanged;

  const NewsBiasSection({
    Key? key,
    required this.selectedBiases,
    required this.onBiasesChanged,
  }) : super(key: key);

  @override
  State<NewsBiasSection> createState() => _NewsBiasSectionState();
}

class _NewsBiasSectionState extends State<NewsBiasSection> {
  late Set<String> _selectedBiases;

  @override
  void initState() {
    super.initState();
    _selectedBiases = Set.from(widget.selectedBiases);
  }

  @override
  void didUpdateWidget(covariant NewsBiasSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBiases != widget.selectedBiases) {
      setState(() {
        _selectedBiases = Set.from(widget.selectedBiases);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '뉴스 성향',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: allBiases.map((bias) {
                final isSelected = _selectedBiases.contains(bias);
                return ChoiceChip(
                  backgroundColor: const Color(0xFFF8F9FA),
                  label: Text(
                    bias,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF868E96),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF228BE6),
                  avatar: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                  onSelected: (_) {
                    setState(() {
                      if (isSelected) {
                        _selectedBiases.remove(bias);
                      } else {
                        _selectedBiases.add(bias);
                      }
                    });
                    widget.onBiasesChanged(_selectedBiases.toSet());
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
