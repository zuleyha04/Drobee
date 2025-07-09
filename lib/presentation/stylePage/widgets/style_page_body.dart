import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:drobee/data/services/firestore_database_service.dart';
import 'package:drobee/presentation/stylePage/cubit/style_cubit.dart';
import 'package:drobee/presentation/stylePage/cubit/style_state.dart';
import 'package:drobee/presentation/outfitPickerBottomSheet/pages/outfit_picker_bottom_sheet.dart';
import 'package:drobee/presentation/stylePage/widgets/style_empty_state.dart';
import 'package:drobee/presentation/stylePage/widgets/style_error_state.dart';
import 'package:drobee/presentation/stylePage/widgets/outfit_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StylePageBody extends StatefulWidget {
  const StylePageBody({Key? key}) : super(key: key);

  @override
  State<StylePageBody> createState() => _StylePageBodyState();
}

class _StylePageBodyState extends State<StylePageBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w), // Daha dar padding
          child: BlocBuilder<StyleCubit, StyleState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  const PageTitle('Style'),
                  SizedBox(height: 16.h), // Görsellerden ayırmak için yeterli
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is StyleLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is StyleError) {
                          return StyleErrorState(message: state.message);
                        } else {
                          return StreamBuilder<List<Map<String, dynamic>>>(
                            stream: FirestoreService.getUserOutfitsStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return StyleErrorState(
                                  message:
                                      'Error loading outfits: ${snapshot.error}',
                                );
                              }

                              final outfits = snapshot.data ?? [];

                              if (outfits.isEmpty) {
                                return const StyleEmptyState();
                              }

                              return OutfitGridView(outfits: outfits);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const OutfitPickerBottomSheet(),
          ).then((_) {
            setState(() {});
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 8.r,
        child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
