import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/usecases/add_template_usecase.dart';
import '../../domain/usecases/delete_template_usecase.dart';
import '../../domain/usecases/get_templates_usecase.dart';
import '../../domain/usecases/update_template_usecase.dart';
import '../../../../core/usecase/usecase.dart';
import 'template_event.dart';
import 'template_state.dart';
import '../../domain/entities/template.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final GetTemplatesUseCase getTemplatesUseCase;
  final AddTemplateUseCase addTemplateUseCase;
  final UpdateTemplateUseCase updateTemplateUseCase;
  final DeleteTemplateUseCase deleteTemplateUseCase;

  TemplateBloc({
    required this.getTemplatesUseCase,
    required this.addTemplateUseCase,
    required this.updateTemplateUseCase,
    required this.deleteTemplateUseCase,
  }) : super(TemplateInitial()) {
    on<LoadTemplates>(_onLoadTemplates);
    on<AddTemplate>(_onAddTemplate);
    on<UpdateTemplate>(_onUpdateTemplate);
    on<DeleteTemplate>(_onDeleteTemplate);
  }

  Future<void> _onLoadTemplates(
    LoadTemplates event,
    Emitter<TemplateState> emit,
  ) async {
    emit(TemplateLoading());
    final result = await getTemplatesUseCase(NoParams());
    result.fold(
      (failure) => emit(TemplateError(failure.message)),
      (templates) => emit(TemplatesLoaded(templates)),
    );
  }

  Future<void> _onAddTemplate(
    AddTemplate event,
    Emitter<TemplateState> emit,
  ) async {
    final currentState = state;
    List<Template> currentTemplates = [];
    if (currentState is TemplatesLoaded) {
      currentTemplates = List<Template>.from(currentState.templates);
    }

    final templateToAdd = event.template.id.trim().isEmpty
        ? event.template.copyWith(id: const Uuid().v4())
        : event.template;

    // Optimistic Update
    final optimisticList = List<Template>.from(currentTemplates)..add(templateToAdd);
    emit(TemplatesLoaded(optimisticList));

    final result = await addTemplateUseCase(templateToAdd);
    result.fold(
      (failure) {
        // Revert on failure
        emit(TemplateError(failure.message));
        emit(TemplatesLoaded(currentTemplates));
      },
      (savedTemplate) {
        final updatedList = optimisticList.map((t) {
          if (t.id == templateToAdd.id || (t.id.isEmpty && t.name == savedTemplate.name)) {
            return savedTemplate;
          }
          return t;
        }).toList();
        emit(TemplateAddSuccess(updatedList, savedTemplate));
      },
    );
  }

  Future<void> _onUpdateTemplate(
    UpdateTemplate event,
    Emitter<TemplateState> emit,
  ) async {
    final currentState = state;
    List<Template> currentTemplates = [];
    if (currentState is TemplatesLoaded) {
      currentTemplates = List<Template>.from(currentState.templates);
    }

    // Optimistic Update
    final optimisticList = currentTemplates.map<Template>((t) {
      return t.id == event.template.id ? event.template : t;
    }).toList();
    emit(TemplatesLoaded(optimisticList));

    final result = await updateTemplateUseCase(event.template);
    result.fold(
      (failure) {
        // Revert on failure
        emit(TemplateError(failure.message));
        emit(TemplatesLoaded(currentTemplates));
      },
      (_) => emit(TemplateUpdateSuccess(optimisticList, event.template)),
    );
  }

  Future<void> _onDeleteTemplate(
    DeleteTemplate event,
    Emitter<TemplateState> emit,
  ) async {
    if (event.id.trim().isEmpty) return;

    final currentState = state;
    List<Template> currentTemplates = [];
    if (currentState is TemplatesLoaded) {
      currentTemplates = List<Template>.from(currentState.templates);
    }

    // Optimistic Update
    final optimisticList = currentTemplates.where((t) => t.id != event.id).toList();
    emit(TemplatesLoaded(optimisticList));

    final result = await deleteTemplateUseCase(event.id);
    result.fold(
      (failure) {
        // Revert on failure
        emit(TemplateError(failure.message));
        emit(TemplatesLoaded(currentTemplates));
      },
      (_) => emit(TemplateDeleteSuccess(optimisticList, event.id)),
    );
  }
}
