// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example/domain/use_case/increment_use_case.dart' as _i412;
import 'package:example/home/management/home_manager.dart' as _i185;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i412.IncrementUseCase>(() => _i412.IncrementUseCase());
    gh.factory<_i185.HomeManager>(
        () => _i185.HomeManager(gh<_i412.IncrementUseCase>()));
    return this;
  }
}
