import 'package:equatable/equatable.dart';

abstract class StyleState extends Equatable {
  const StyleState();

  @override
  List<Object> get props => [];
}

class StyleInitial extends StyleState {}

class StyleLoading extends StyleState {}

class StyleLoaded extends StyleState {
  final List<dynamic> outfits; // Outfit modelinize göre değiştirin

  const StyleLoaded({required this.outfits});

  @override
  List<Object> get props => [outfits];
}

class StyleError extends StyleState {
  final String message;

  const StyleError({required this.message});

  @override
  List<Object> get props => [message];
}
