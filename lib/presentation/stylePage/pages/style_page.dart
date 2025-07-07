import 'package:drobee/presentation/stylePage/cubit/style_cubit.dart';
import 'package:drobee/presentation/stylePage/cubit/style_state.dart';
import 'package:drobee/presentation/stylePage/pages/outfit_picker_bottom_sheet.dart';
import 'package:drobee/presentation/stylePage/widgets/style_app_bar.dart';
import 'package:drobee/presentation/stylePage/widgets/style_empty_state.dart';
import 'package:drobee/presentation/stylePage/widgets/style_error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StylePage extends StatefulWidget {
  const StylePage({Key? key}) : super(key: key);

  @override
  State<StylePage> createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StyleCubit()..loadOutfits(),
      child: const _StylePageContent(),
    );
  }
}

class _StylePageContent extends StatelessWidget {
  const _StylePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const StyleAppBar(),
      body: BlocBuilder<StyleCubit, StyleState>(
        builder: (context, state) {
          if (state is StyleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StyleError) {
            return StyleErrorState(message: state.message);
          } else {
            return const StyleEmptyState();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const OutfitPickerBottomSheet(),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
