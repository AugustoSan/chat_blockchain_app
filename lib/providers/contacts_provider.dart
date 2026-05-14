import 'dart:convert';

import 'package:chat_blockchain_app/services/api_service.dart';
import 'package:flutter/foundation.dart';

import '../services/secure_storage.dart';

/// ContactsProvider almacena una lista de contactos (direcciones) en el dispositivo
/// y notifica cambios a los listeners.
class ContactsProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<String> _contacts = [];

  ContactsProvider();

  List<String> get contacts => List.unmodifiable(_contacts);

  /// Inicializa cargando los contactos desde almacenamiento seguro.
  Future<void> loadContacts() async {
    final raw = await SecureStorage.getContacts();
    if (raw == null || raw.isEmpty) {
      _contacts = [];
      notifyListeners();
      return;
    }

    try {
      final decoded = json.decode(raw);
      if (decoded is List) {
        _contacts = decoded.map((e) => e.toString()).toList();
      } else {
        _contacts = [];
      }
    } catch (_) {
      _contacts = [];
    }

    notifyListeners();
  }

  /// Guarda la lista actual en storage.
  Future<void> _persist() async {
    final encoded = json.encode(_contacts);
    await SecureStorage.saveContacts(encoded);
  }

  /// Agrega un contacto (si no existe). Retorna true si se agregó.
  Future<bool> addContact(String address) async {
    final normalized = address.trim();
    if (normalized.isEmpty) return false;
    if (_contacts.contains(normalized)) return false;
    _contacts.add(normalized);
    await _persist();
    notifyListeners();
    return true;
  }

  /// Actualiza una dirección existente por nueva dirección.
  /// Retorna true si la actualización tuvo efecto.
  Future<bool> updateContact({required String oldAddress, required String newAddress}) async {
    final o = oldAddress.trim();
    final n = newAddress.trim();
    if (o.isEmpty || n.isEmpty) return false;
    final idx = _contacts.indexOf(o);
    if (idx == -1) return false;
    if (_contacts.contains(n) && n != o) return false; // evita duplicados
    _contacts[idx] = n;
    await _persist();
    notifyListeners();
    return true;
  }

  /// Elimina un contacto por dirección. Retorna true si se eliminó.
  Future<bool> removeContact(String address) async {
    final normalized = address.trim();
    final removed = _contacts.remove(normalized);
    if (!removed) return false;
    await _persist();
    notifyListeners();
    return true;
  }

  /// Reemplaza la lista completa de contactos.
  Future<void> setContacts(List<String> addresses) async {
    _contacts = addresses.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    await _persist();
    notifyListeners();
  }

  /// Carga los contactos desde el servicio API.
  Future<void> loadContactsFromAPI() async {
    final jwt = await SecureStorage.getJwt();
    if (jwt == null) return;
    final contacts = await _api.getContacts(jwt);
    _contacts = contacts.map((c) => c.address).toList();
    await _persist();
    notifyListeners();
  }

  /// Busca si existe una dirección almacenada.
  bool contains(String address) => _contacts.contains(address.trim());

  /// Limpia los contactos del storage y memoria.
  Future<void> clear() async {
    _contacts = [];
    await SecureStorage.deleteContacts();
    notifyListeners();
  }
}
