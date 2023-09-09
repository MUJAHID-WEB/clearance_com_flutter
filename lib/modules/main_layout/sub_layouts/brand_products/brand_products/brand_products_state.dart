part of 'brand_products_cubit.dart';

@immutable
abstract class BrandProductsState {}
class InitialBrandProductsState extends BrandProductsState {}
class LoadingBrandProductsState extends BrandProductsState {}
class SuccessBrandProductsState extends BrandProductsState {}
class FailureBrandProductsState extends BrandProductsState {}