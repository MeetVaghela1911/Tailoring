import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tailoring_flutter/l10n/app_localizations.dart';

import 'features/customers/presentation/bloc/customer_bloc.dart';
import 'features/templates/presentation/bloc/template_bloc.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';
import 'features/onboarding/presentation/bloc/walkthrough_cubit.dart';

import 'core/locale/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utility/dependency_injection.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'routes/app_router.dart';

import 'core/widgets/app_showcase_wrapper.dart';

/// Global locale provider — accessible from any screen.
final LocaleProvider appLocaleProvider = LocaleProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection (Firebase, Supabase, services, blocs)
  await setupDependencies();

  // Load persisted locale before running the app
  await appLocaleProvider.load();

  runApp(const ProviderScope(child: StitchApp()));
}

class StitchApp extends StatelessWidget {
  const StitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<CustomerBloc>(create: (_) => getIt<CustomerBloc>()),
        BlocProvider<TemplateBloc>(create: (_) => getIt<TemplateBloc>()),
        BlocProvider<OrderBloc>(create: (_) => getIt<OrderBloc>()),
        BlocProvider<WalkthroughCubit>(
          create: (_) => getIt<WalkthroughCubit>(),
        ),
      ],
      child: AnimatedBuilder(
        animation: appLocaleProvider,
        builder: (context, _) {
          return MaterialApp.router(
            key: ValueKey(appLocaleProvider.locale.languageCode),
            title: 'Tailoring',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
            locale: appLocaleProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) {
              if (child == null) return const SizedBox.shrink();
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: AppShowcaseWrapper(child: child),
              );
            },
          );
        },
      ),
    );
  }
}
