import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageService {
  Future<String> uploadImage({
    required File file,
    required String bucket,
    required String fileName,
  });

  Future<void> deleteImage({
    required String bucket,
    required String fileName,
  });

  String getPublicUrl({
    required String bucket,
    required String fileName,
  });
}

class SupabaseStorageService implements StorageService {
  final SupabaseClient client;

  SupabaseStorageService(this.client);

  @override
  Future<String> uploadImage({
    required File file,
    required String bucket,
    required String fileName,
  }) async {
    await client.storage.from(bucket).upload(fileName, file);
    return getPublicUrl(bucket: bucket, fileName: fileName);
  }

  @override
  Future<void> deleteImage({
    required String bucket,
    required String fileName,
  }) async {
    await client.storage.from(bucket).remove([fileName]);
  }

  @override
  String getPublicUrl({
    required String bucket,
    required String fileName,
  }) {
    return client.storage.from(bucket).getPublicUrl(fileName);
  }
}
