import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_bottom_sheet_state.dart';

class AddBottomSheetCubit extends Cubit<AddBottomSheetState> {
  static const String _firstVisitKey = 'add_item_first_visit';
  static const String _userLoginTypeKey = 'user_login_type';

  AddBottomSheetCubit() : super(const AddBottomSheetState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstVisit = prefs.getBool(_firstVisitKey) ?? true;
      final loginTypeString = prefs.getString(_userLoginTypeKey);

      LoginType? userLoginType;
      if (loginTypeString != null) {
        userLoginType = LoginType.values.firstWhere(
          (type) => type.toString() == loginTypeString,
          orElse: () => LoginType.email,
        );
      }

      emit(
        state.copyWith(
          isLoading: false,
          isFirstVisit: isFirstVisit,
          userLoginType: userLoginType,
          showPermissionDialog: isFirstVisit,
        ),
      );

      if (isFirstVisit) {
        await Future.delayed(const Duration(milliseconds: 500));
        _showGoogleDrivePermissionDialog();
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Başlatma hatası: ${e.toString()}',
        ),
      );
    }
  }

  void _showGoogleDrivePermissionDialog() {
    emit(state.copyWith(showPermissionDialog: true));
  }

  void hidePermissionDialog() {
    emit(state.copyWith(showPermissionDialog: false));
  }

  Future<void> requestGoogleDrivePermission() async {
    emit(
      state.copyWith(
        googleDrivePermissionStatus: PermissionStatus.requesting,
        showPermissionDialog: false,
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));
      final bool granted = true;

      if (granted) {
        emit(
          state.copyWith(googleDrivePermissionStatus: PermissionStatus.granted),
        );
        await _markFirstVisitComplete();
      }
    } catch (e) {
      emit(
        state.copyWith(
          googleDrivePermissionStatus: PermissionStatus.denied,
          errorMessage: 'Google Drive izni alınamadı: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> denyGoogleDrivePermission() async {
    emit(
      state.copyWith(
        googleDrivePermissionStatus: PermissionStatus.denied,
        showPermissionDialog: false,
      ),
    );
    await _markFirstVisitComplete();
  }

  Future<void> _markFirstVisitComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstVisitKey, false);
    emit(state.copyWith(isFirstVisit: false));
  }

  void updateItemName(String name) {
    emit(state.copyWith(itemName: name));
  }

  void updateSelectedImage(String? imagePath) {
    emit(state.copyWith(selectedImagePath: imagePath));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> saveItem() async {
    if (state.itemName.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Ürün adı boş olamaz'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (state.userLoginType == LoginType.google &&
          state.googleDrivePermissionStatus == PermissionStatus.granted) {
        await _saveToGoogleDrive();
      } else {
        await _saveLocally();
      }

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Kayıt hatası: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _saveToGoogleDrive() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _saveLocally() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> setUserLoginType(LoginType loginType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userLoginTypeKey, loginType.toString());
  }

  // Yeni: Çoklu kategori güncelleme
  void toggleCategory(String category) {
    final current = List<String>.from(state.selectedCategories);
    if (current.contains(category)) {
      current.remove(category);
    } else {
      current.add(category);
    }
    emit(state.copyWith(selectedCategories: current));
  }
}
