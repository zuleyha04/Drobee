import 'package:drobee/presentation/stylePage/cubit/style_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StyleCubit extends Cubit<StyleState> {
  StyleCubit() : super(StyleInitial());

  void loadOutfits() {
    emit(StyleLoading());
    try {
      // Burada outfit verilerinizi yükleyebilirsiniz
      // Örneğin: API çağrısı, local storage vb.
      final outfits = <dynamic>[]; // Şimdilik boş liste
      emit(StyleLoaded(outfits: outfits));
    } catch (e) {
      emit(StyleError(message: e.toString()));
    }
  }

  void addOutfit(dynamic outfit) {
    final currentState = state;
    if (currentState is StyleLoaded) {
      final updatedOutfits = List<dynamic>.from(currentState.outfits)
        ..add(outfit);
      emit(StyleLoaded(outfits: updatedOutfits));
    }
  }

  void removeOutfit(int index) {
    final currentState = state;
    if (currentState is StyleLoaded) {
      final updatedOutfits = List<dynamic>.from(currentState.outfits)
        ..removeAt(index);
      emit(StyleLoaded(outfits: updatedOutfits));
    }
  }
}
