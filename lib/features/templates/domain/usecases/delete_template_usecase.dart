import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/template_repository.dart';

class DeleteTemplateUseCase implements UseCase<void, String> {
  final TemplateRepository repository;

  DeleteTemplateUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTemplate(id);
  }
}
