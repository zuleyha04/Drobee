import 'package:drobee/presentation/addBottomSheet/cubit/add_bottom_sheet_cubit.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/add_bottom_sheet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemNameInput extends StatelessWidget {
  const ItemNameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddBottomSheetCubit, AddBottomSheetState>(
      builder: (context, state) {
        return TextField(
          decoration: const InputDecoration(
            labelText: 'Ürün adı',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<AddBottomSheetCubit>().updateItemName(value);
          },
        );
      },
    );
  }
}
