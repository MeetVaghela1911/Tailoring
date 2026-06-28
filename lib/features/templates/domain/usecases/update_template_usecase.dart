import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/template.dart';
import '../repositories/template_repository.dart';

class UpdateTemplateUseCase implements UseCase<Template, Template> {
  final TemplateRepository repository;

  UpdateTemplateUseCase(this.repository);

  @override
  Future<Either<Failure, Template>> call(Template template) async {
    return await repository.updateTemplate(template);
  }
}
