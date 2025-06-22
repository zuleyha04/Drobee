import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/add_bottom_sheet_cubit.dart';
import '../cubit/add_bottom_sheet_state.dart';

class ItemCategoryChips extends StatelessWidget {
  const ItemCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Sunny', 'Cloudy', 'Rainy', 'Snowy'];

    return BlocBuilder<AddBottomSheetCubit, AddBottomSheetState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8.0,
          children:
              categories.map((category) {
                final isSelected = state.selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Colors.blue,
                  onSelected: (selected) {
                    context.read<AddBottomSheetCubit>().toggleCategory(
                      category,
                    );
                  },
                );
              }).toList(),
        );
      },
    );
  }
}
