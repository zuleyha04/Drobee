// home_page.dart - Güncellenmiş sürüm
import 'package:drobee/common/navigator/app_navigator.dart';
import 'package:drobee/common/widget/navigationBar/main_navigation_wrapper.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:drobee/presentation/home/widgets/float_act_button.dart';
import 'package:drobee/presentation/onboarding/pages/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Closet"),
              actions: [
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //TODO:log out butonu son
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () async {
                            await context.read<HomeCubit>().logout();
                            if (context.read<HomeCubit>().state.email == null) {
                              AppNavigator.pushReplacement(
                                context,
                                const OnBoardingPage(initialPage: 3),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state.email == null) {
                  return const Center(
                    child: Text('Kullanıcı bilgisi bulunamadı'),
                  );
                }

                if (state.error != null) {
                  return Center(child: Text('Hata: ${state.error}'));
                }
                return Column(
                  children: [
                    // Resim grid'i
                    Expanded(
                      child:
                          state.userImages.isEmpty
                              ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_library_outlined,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Henüz resim eklemediniz',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Yeni resim eklemek için + butonuna basın',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.8,
                                    ),
                                itemCount: state.userImages.length,
                                itemBuilder: (context, index) {
                                  final image = state.userImages[index];
                                  return _buildImageCard(image);
                                },
                              ),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: const AddFloatingActionButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(dynamic image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Resim
            Positioned.fill(
              child: Image.network(
                image.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
