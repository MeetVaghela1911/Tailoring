import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/template.dart';

abstract class TemplateRepository {
  Future<Either<Failure, List<Template>>> getTemplates();
  Future<Either<Failure, Template>> addTemplate(Template template);
  Future<Either<Failure, Template>> updateTemplate(Template template);
  Future<Either<Failure, void>> deleteTemplate(String id);
}
