import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user_model.dart';
import '../models/profile_model.dart';
import '../models/shop_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthUserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<AuthUserModel?> getCurrentUser();

  Stream<AuthUserModel?> get onAuthStateChanged;

  Future<void> updateProfile(ProfileModel profile);

  Future<void> updateShop(ShopModel shop);

  Future<ProfileModel?> getProfile(String userId);

  Future<ShopModel?> getShop(String userId);
  Future<void> trackAppOpen(String userId);
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final SharedPreferences _sharedPreferences;

  static const String _profileCacheKey = 'cached_user_profile';
  static const String _shopCacheKey = 'cached_user_shop';

  SupabaseAuthRemoteDataSource(this._supabaseClient, this._sharedPreferences);

  Future<void> _cacheProfile(ProfileModel profile) async {
    await _sharedPreferences.setString(_profileCacheKey, jsonEncode(profile.toJson()));
  }

  Future<void> _cacheShop(ShopModel shop) async {
    await _sharedPreferences.setString(_shopCacheKey, jsonEncode(shop.toJson()));
  }

  ProfileModel? _getCachedProfile() {
    final str = _sharedPreferences.getString(_profileCacheKey);
    if (str != null) {
      try {
        return ProfileModel.fromJson(jsonDecode(str));
      } catch (_) {}
    }
    return null;
  }

  ShopModel? _getCachedShop() {
    final str = _sharedPreferences.getString(_shopCacheKey);
    if (str != null) {
      try {
        return ShopModel.fromJson(jsonDecode(str));
      } catch (_) {}
    }
    return null;
  }

  Future<void> _clearCache() async {
    await _sharedPreferences.remove(_profileCacheKey);
    await _sharedPreferences.remove(_shopCacheKey);
    
    // Clear onboarding / walkthrough progress keys
    await _sharedPreferences.remove('walkthrough_customer_done');
    await _sharedPreferences.remove('walkthrough_template_done');
    await _sharedPreferences.remove('walkthrough_order_done');
    await _sharedPreferences.remove('walkthrough_whatsapp_done');
    await _sharedPreferences.remove('walkthrough_auto_started');
    await _sharedPreferences.remove('walkthrough_shown_customer');
    await _sharedPreferences.remove('walkthrough_shown_template_tab');
    await _sharedPreferences.remove('walkthrough_shown_template_screen');
    await _sharedPreferences.remove('walkthrough_shown_order_tab');
    await _sharedPreferences.remove('walkthrough_shown_order_screen');
  }

  @override
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );

    if (response.user == null) {
      throw const AuthException('Sign up failed');
    }

    // Fetch profile & shop so the returned user is fully populated
    final profile = await getProfile(response.user!.id);
    final shop = await getShop(response.user!.id);
    if (profile != null) _cacheProfile(profile);
    if (shop != null) _cacheShop(shop);
    return AuthUserModel.fromSupabase(response.user!, profile: profile, shop: shop);
  }

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('Login failed');
    }

    // Fetch profile & shop so the returned user is fully populated
    final profile = await getProfile(response.user!.id);
    final shop = await getShop(response.user!.id);
    if (profile != null) _cacheProfile(profile);
    if (shop != null) _cacheShop(shop);
    return AuthUserModel.fromSupabase(response.user!, profile: profile, shop: shop);
  }

  @override
  Future<void> logout() async {
    await _clearCache();
    await _supabaseClient.auth.signOut();
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return null;

    ProfileModel? profile;
    ShopModel? shop;

    try {
      profile = await getProfile(user.id);
      if (profile != null) _cacheProfile(profile);
    } catch (e) {
      profile = _getCachedProfile();
    }

    try {
      shop = await getShop(user.id);
      if (shop != null) _cacheShop(shop);
    } catch (e) {
      shop = _getCachedShop();
    }

    return AuthUserModel.fromSupabase(user, profile: profile, shop: shop);
  }

  @override
  Stream<AuthUserModel?> get onAuthStateChanged {
    return _supabaseClient.auth.onAuthStateChange.asyncMap((data) async {
      final user = data.session?.user;
      if (user == null) {
        await _clearCache();
        return null;
      }

      ProfileModel? profile;
      ShopModel? shop;

      try {
        profile = await getProfile(user.id);
        if (profile != null) _cacheProfile(profile);
      } catch (e) {
        profile = _getCachedProfile();
      }

      try {
        shop = await getShop(user.id);
        if (shop != null) _cacheShop(shop);
      } catch (e) {
        shop = _getCachedShop();
      }

      return AuthUserModel.fromSupabase(user, profile: profile, shop: shop);
    });
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    final json = profile.toJson();
    json['updated_at'] = DateTime.now().toUtc().toIso8601String();
    await _supabaseClient.from('profiles').upsert(json);
  }

  @override
  Future<void> updateShop(ShopModel shop) async {
    final json = shop.toJson();
    json['updated_at'] = DateTime.now().toUtc().toIso8601String();
    if (shop.id.isEmpty) {
      // New shop — insert and let Supabase auto-generate the ID
      await _supabaseClient.from('shops').insert(json);
    } else {
      await _supabaseClient.from('shops').upsert(json);
    }
  }

  @override
  Future<ProfileModel?> getProfile(String userId) async {
    final response = await _supabaseClient.from('profiles').select().eq('id', userId).maybeSingle();
    return response != null ? ProfileModel.fromJson(response) : null;
  }

  @override
  Future<ShopModel?> getShop(String userId) async {
    final response = await _supabaseClient.from('shops').select().eq('owner_id', userId).maybeSingle();
    return response != null ? ShopModel.fromJson(response) : null;
  }

  @override
  Future<void> trackAppOpen(String userId) async {
    await _supabaseClient.from('app_usage_logs').insert({'user_id': userId});
  }
}
