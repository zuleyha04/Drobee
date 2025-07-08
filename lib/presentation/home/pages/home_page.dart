import 'package:drobee/presentation/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:drobee/presentation/home/widgets/image_grid.dart';
import 'package:drobee/presentation/home/widgets/float_act_button.dart';
import 'package:drobee/common/widget/navigationBar/main_navigation_wrapper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(FirebaseAuth.instance),
      child: WillPopScope(
        onWillPop: () async => false,
        child: MainNavigationWrapper(
          homePageContent: Scaffold(
            body: SafeArea(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.email == null) {
                    return const Center(
                      child: Text('User information not found'),
                    );
                  }
                  if (state.error != null) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),
                      Expanded(child: ImageGrid(state: state)),
                    ],
                  );
                },
              ),
            ),
            floatingActionButton: const AddFloatingActionButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ),
    );
  }
}
