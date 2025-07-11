import 'package:drobee/presentation/stylePage/cubit/style_cubit.dart';
import 'package:drobee/presentation/stylePage/widgets/style_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StylePage extends StatefulWidget {
  const StylePage({super.key});

  @override
  State<StylePage> createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StyleCubit()..loadOutfits(),
      child: const StylePageBody(),
    );
  }
}
