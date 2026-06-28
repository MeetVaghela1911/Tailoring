import 'customer_model.dart';

class CustomerRepository {
  CustomerRepository._();
  static final CustomerRepository instance = CustomerRepository._();

  final List<CustomerModel> _customers = [];

  List<CustomerModel> get all => List.unmodifiable(_customers);

  void add(CustomerModel customer) {
    _customers.add(customer);
  }

  void update(CustomerModel updated) {
    final idx = _customers.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _customers[idx] = updated;
    }
  }

  void delete(String id) {
    _customers.removeWhere((c) => c.id == id);
  }

  CustomerModel? getById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
