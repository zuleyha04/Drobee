import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: PageTitle('Closet')),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.isLoading) {}
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
