import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_event.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_state.dart';
import 'package:tailoring_flutter/features/templates/domain/entities/template.dart';
import 'package:tailoring_flutter/core/error/failures.dart';
import '../../../../test_helpers.dart';

void main() {
  late TemplateBloc templateBloc;
  late MockGetTemplatesUseCase mockGetTemplatesUseCase;
  late MockAddTemplateUseCase mockAddTemplateUseCase;
  late MockUpdateTemplateUseCase mockUpdateTemplateUseCase;
  late MockDeleteTemplateUseCase mockDeleteTemplateUseCase;

  const tTemplate = Template(
    id: '1',
    name: 'Shirt',
    category: 'Men',
    iconCodePoint: 123,
    fields: ['Length', 'Chest'],
    basePrice: 500,
  );
  final tTemplates = [tTemplate];

  setUpAll(() {
    TestHelper.registerFallbackValues();
  });

  setUp(() {
    mockGetTemplatesUseCase = MockGetTemplatesUseCase();
    mockAddTemplateUseCase = MockAddTemplateUseCase();
    mockUpdateTemplateUseCase = MockUpdateTemplateUseCase();
    mockDeleteTemplateUseCase = MockDeleteTemplateUseCase();

    templateBloc = TemplateBloc(
      getTemplatesUseCase: mockGetTemplatesUseCase,
      addTemplateUseCase: mockAddTemplateUseCase,
      updateTemplateUseCase: mockUpdateTemplateUseCase,
      deleteTemplateUseCase: mockDeleteTemplateUseCase,
    );
  });

  tearDown(() {
    templateBloc.close();
  });

  test('initial state should be TemplateInitial', () {
    expect(templateBloc.state, isA<TemplateInitial>());
  });

  group('LoadTemplates', () {
    blocTest<TemplateBloc, TemplateState>(
      'emits [TemplateLoading, TemplatesLoaded] when successful',
      build: () {
        when(() => mockGetTemplatesUseCase(any())).thenAnswer((_) async => Right(tTemplates));
        return templateBloc;
      },
      act: (bloc) => bloc.add(LoadTemplates()),
      expect: () => [
        TemplateLoading(),
        TemplatesLoaded(tTemplates),
      ],
    );

    blocTest<TemplateBloc, TemplateState>(
      'emits [TemplateLoading, TemplateError] when failure occurs',
      build: () {
        when(() => mockGetTemplatesUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Fail')));
        return templateBloc;
      },
      act: (bloc) => bloc.add(LoadTemplates()),
      expect: () => [
        TemplateLoading(),
        const TemplateError('Fail'),
      ],
    );
  });

  group('AddTemplate (Optimistic)', () {
    const newTemplate = Template(
      id: '2',
      name: 'Pants',
      category: 'Men',
      iconCodePoint: 456,
      fields: ['Waist'],
    );

    blocTest<TemplateBloc, TemplateState>(
      'emits [TemplatesLoaded (optimistic), TemplateAddSuccess] when successful',
      build: () {
        when(() => mockAddTemplateUseCase(any())).thenAnswer((_) async => const Right(newTemplate));
        return templateBloc;
      },
      seed: () => TemplatesLoaded(tTemplates),
      act: (bloc) => bloc.add(const AddTemplate(newTemplate)),
      expect: () => [
        TemplatesLoaded([...tTemplates, newTemplate]),
        TemplateAddSuccess([...tTemplates, newTemplate], newTemplate),
      ],
    );

    blocTest<TemplateBloc, TemplateState>(
      'emits [TemplatesLoaded (optimistic), TemplateError, TemplatesLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockAddTemplateUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Add failed')));
        return templateBloc;
      },
      seed: () => TemplatesLoaded(tTemplates),
      act: (bloc) => bloc.add(const AddTemplate(newTemplate)),
      expect: () => [
        TemplatesLoaded([...tTemplates, newTemplate]),
        const TemplateError('Add failed'),
        TemplatesLoaded(tTemplates),
      ],
    );
  });

  group('UpdateTemplate (Optimistic)', () {
    const updatedTemplate = Template(
      id: '1',
      name: 'Shirt Updated',
      category: 'Men',
      iconCodePoint: 123,
      fields: ['Length', 'Chest'],
    );

    blocTest<TemplateBloc, TemplateState>(
      'emits [TemplatesLoaded (optimistic), TemplateUpdateSuccess] when successful',
      build: () {
        when(() => mockUpdateTemplateUseCase(any())).thenAnswer((_) async => const Right(updatedTemplate));
        return templateBloc;
      },
      seed: () => TemplatesLoaded(tTemplates),
      act: (bloc) => bloc.add(const UpdateTemplate(updatedTemplate)),
      expect: () => [
        TemplatesLoaded([updatedTemplate]),
        TemplateUpdateSuccess([updatedTemplate], updatedTemplate),
      ],
    );

    blocTest<TemplateBloc, TemplateState>(
      'emits [TemplatesLoaded (optimistic), TemplateError, TemplatesLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockUpdateTemplateUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return templateBloc;
      },
      seed: () => TemplatesLoaded(tTemplates),
      act: (bloc) => bloc.add(const UpdateTemplate(updatedTemplate)),
      expect: () => [
        TemplatesLoaded([updatedTemplate]),
        const TemplateError('Update failed'),
        TemplatesLoaded(tTemplates),
      ],
    );
  });

  group('DeleteTemplate (Optimistic)', () {
    blocTest<TemplateBloc, TemplateState>(
      'emits [TemplatesLoaded (optimistic), TemplateDeleteSuccess] when successful',
      build: () {
        when(() => mockDeleteTemplateUseCase(any())).thenAnswer((_) async => const Right(null));
        return templateBloc;
      },
      seed: () => TemplatesLoaded(tTemplates),
      act: (bloc) => bloc.add(const DeleteTemplate('1')),
      expect: () => [
        const TemplatesLoaded([]),
        const TemplateDeleteSuccess([], '1'),
      ],
    );

    blocTest<TemplateBloc, TemplateState>(
      'emits [TemplatesLoaded (optimistic), TemplateError, TemplatesLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockDeleteTemplateUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Delete failed')));
        return templateBloc;
      },
      seed: () => TemplatesLoaded(tTemplates),
      act: (bloc) => bloc.add(const DeleteTemplate('1')),
      expect: () => [
        const TemplatesLoaded([]),
        const TemplateError('Delete failed'),
        TemplatesLoaded(tTemplates),
      ],
    );
  });
}
