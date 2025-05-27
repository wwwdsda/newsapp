import 'package:flutter/material.dart';

class NewsBiasSection extends StatefulWidget {
  final Set<NewsBias> selectedBiases;
  final ValueChanged<Set<NewsBias>> onBiasesChanged;

  const NewsBiasSection({
    required this.selectedBiases,
    required this.onBiasesChanged,
  });

  @override
  State<NewsBiasSection> createState() => NewsBiasSectionState();
}

class NewsBiasSectionState extends State<NewsBiasSection> {
  late Set<NewsBias> _selectedBiases;

  @override
  void initState() {
    super.initState();
    _selectedBiases = Set.from(widget.selectedBiases);
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  NewsBias.values.map((bias) {
                    final isSelected = _selectedBiases.contains(bias);
                    return ChoiceChip(
                      backgroundColor: const Color(0xFFF8F9FA),
                      label: Text(bias.label),
                      selected: isSelected,
                      selectedColor: const Color(0xFF228BE6),
                      labelStyle: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFF868E96),
                      ),
                      avatar:
                          isSelected
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                      onSelected: (_) {
                        setState(() {
                          if (isSelected) {
                            _selectedBiases.remove(bias);
                          } else {
                            _selectedBiases.add(bias);
                          }
                          widget.onBiasesChanged(_selectedBiases);
                        });
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

enum NewsBias {
  neutral('중도'),
  progressive('진보'),
  conservative('보수');

  const NewsBias(this.label);
  final String label;
}

