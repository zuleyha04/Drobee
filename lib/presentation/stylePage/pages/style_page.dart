import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:drobee/data/services/firestore_database_service.dart';
import 'package:drobee/presentation/stylePage/cubit/style_cubit.dart';
import 'package:drobee/presentation/stylePage/cubit/style_state.dart';
import 'package:drobee/presentation/stylePage/pages/outfit_picker_bottom_sheet.dart';
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

class _StylePageContent extends StatefulWidget {
  const _StylePageContent({Key? key}) : super(key: key);

  @override
  State<_StylePageContent> createState() => _StylePageContentState();
}

class _StylePageContentState extends State<_StylePageContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ), // Daha dar padding
          child: BlocBuilder<StyleCubit, StyleState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const PageTitle('Style'),
                  const SizedBox(
                    height: 16,
                  ), // Görsellerden ayırmak için yeterli
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

                              return _buildOutfitsList(outfits);
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
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildOutfitsList(List<Map<String, dynamic>> outfits) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];
          return _buildOutfitCard(outfit);
        },
      ),
    );
  }

  Widget _buildOutfitCard(Map<String, dynamic> outfit) {
    final outfitItems = outfit['outfit_items'] as List<dynamic>? ?? [];

    return GestureDetector(
      onTap: () {
        _showOutfitPreview(outfit);
      },
      onLongPress: () {
        _deleteOutfit(outfit['id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Outfit öğelerini göster
              ...outfitItems.map((item) {
                final itemMap = item as Map<String, dynamic>;
                final imageUrl = itemMap['image_url'] as String? ?? '';
                final positionX =
                    (itemMap['position_x'] as num?)?.toDouble() ?? 0.0;
                final positionY =
                    (itemMap['position_y'] as num?)?.toDouble() ?? 0.0;
                final scale = (itemMap['scale'] as num?)?.toDouble() ?? 1.0;
                final rotation =
                    (itemMap['rotation'] as num?)?.toDouble() ?? 0.0;

                return Positioned(
                  left: positionX * 0.4,
                  top: positionY * 0.4,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Container(
                      width: 60 * scale,
                      height: 60 * scale,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.error,
                                color: Colors.grey,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showOutfitPreview(Map<String, dynamic> outfit) {
    final outfitItems = outfit['outfit_items'] as List<dynamic>? ?? [];
    final outfitName = outfit['outfit_name'] as String? ?? 'Unnamed Outfit';
    final outfitId = outfit['id'] as String? ?? '';

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 300,
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    outfitName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          ...outfitItems.map((item) {
                            final itemMap = item as Map<String, dynamic>;
                            final imageUrl =
                                itemMap['image_url'] as String? ?? '';
                            final positionX =
                                (itemMap['position_x'] as num?)?.toDouble() ??
                                0.0;
                            final positionY =
                                (itemMap['position_y'] as num?)?.toDouble() ??
                                0.0;
                            final scale =
                                (itemMap['scale'] as num?)?.toDouble() ?? 1.0;
                            final rotation =
                                (itemMap['rotation'] as num?)?.toDouble() ??
                                0.0;

                            return Positioned(
                              left: positionX * 0.7,
                              top: positionY * 0.7,
                              child: Transform.rotate(
                                angle: rotation,
                                child: Container(
                                  width: 60 * scale,
                                  height: 60 * scale,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Close'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Önce dialog'u kapat
                          _deleteOutfit(
                            outfitId,
                          ); // Sonra silme işlemini başlat
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _deleteOutfit(String outfitId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Outfit'),
            content: const Text('Are you sure you want to delete this outfit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await FirestoreService.deleteOutfit(outfitId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Outfit deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting outfit: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
