import 'package:equatable/equatable.dart';

enum LoginType { google, email }

enum PermissionStatus { initial, requesting, granted, denied }

class AddBottomSheetState extends Equatable {
  final String itemName;
  final String? selectedImagePath;
  final bool isLoading;
  final String? errorMessage;
  final LoginType? userLoginType;
  final PermissionStatus googleDrivePermissionStatus;
  final bool isFirstVisit;
  final bool showPermissionDialog;

  // Yeni: Çoklu kategori listesi
  final List<String> selectedCategories;

  const AddBottomSheetState({
    this.itemName = '',
    this.selectedImagePath,
    this.isLoading = false,
    this.errorMessage,
    this.userLoginType,
    this.googleDrivePermissionStatus = PermissionStatus.initial,
    this.isFirstVisit = true,
    this.showPermissionDialog = false,
    this.selectedCategories = const [],
  });

  AddBottomSheetState copyWith({
    String? itemName,
    String? selectedImagePath,
    bool? isLoading,
    String? errorMessage,
    LoginType? userLoginType,
    PermissionStatus? googleDrivePermissionStatus,
    bool? isFirstVisit,
    bool? showPermissionDialog,
    List<String>? selectedCategories,
  }) {
    return AddBottomSheetState(
      itemName: itemName ?? this.itemName,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      userLoginType: userLoginType ?? this.userLoginType,
      googleDrivePermissionStatus:
          googleDrivePermissionStatus ?? this.googleDrivePermissionStatus,
      isFirstVisit: isFirstVisit ?? this.isFirstVisit,
      showPermissionDialog: showPermissionDialog ?? this.showPermissionDialog,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  @override
  List<Object?> get props => [
    itemName,
    selectedImagePath,
    isLoading,
    errorMessage,
    userLoginType,
    googleDrivePermissionStatus,
    isFirstVisit,
    showPermissionDialog,
    selectedCategories,
  ];
}
