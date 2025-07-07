// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:drobee/presentation/stylePage/cubit/style_cubit.dart';
// //TODO: ŞİMDİLİK GEREK YOK
// class OutfitListView extends StatelessWidget {
//   final List<dynamic> outfits;

//   const OutfitListView({Key? key, required this.outfits}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: outfits.length,
//       itemBuilder: (context, index) {
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             leading: Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(Icons.shopping_bag_outlined, color: Colors.grey[400]),
//             ),
//             title: Text('Outfit ${index + 1}'),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete_outline),
//               onPressed: () {
//                 context.read<StyleCubit>().removeOutfit(index);
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
