import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/template.dart';
import '../repositories/template_repository.dart';

class AddTemplateUseCase implements UseCase<Template, Template> {
  final TemplateRepository repository;

  AddTemplateUseCase(this.repository);

  @override
  Future<Either<Failure, Template>> call(Template template) async {
    return await repository.addTemplate(template);
  }
}
