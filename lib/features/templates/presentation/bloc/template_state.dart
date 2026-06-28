import 'package:equatable/equatable.dart';
import '../../domain/entities/template.dart';

abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object?> get props => [];
}

class TemplateInitial extends TemplateState {}

class TemplateLoading extends TemplateState {}

class TemplatesLoaded extends TemplateState {
  final List<Template> templates;
  final String? message;
  const TemplatesLoaded(this.templates, {this.message});

  @override
  List<Object?> get props => [templates, message];
}

class TemplateAddSuccess extends TemplatesLoaded {
  final Template template;
  const TemplateAddSuccess(super.templates, this.template);
  @override
  List<Object?> get props => [templates, template];
}

class TemplateUpdateSuccess extends TemplatesLoaded {
  final Template template;
  const TemplateUpdateSuccess(super.templates, this.template);
  @override
  List<Object?> get props => [templates, template];
}

class TemplateDeleteSuccess extends TemplatesLoaded {
  final String id;
  const TemplateDeleteSuccess(super.templates, this.id);
  @override
  List<Object?> get props => [templates, id];
}

class TemplateError extends TemplateState {
  final String message;
  const TemplateError(this.message);

  @override
  List<Object> get props => [message];
}
