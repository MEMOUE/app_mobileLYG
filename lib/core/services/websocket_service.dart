import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'auth_service.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final Map<String, List<Function(Map<String, dynamic>)>> _listeners = {};

  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  Future<void> connect() async {
    try {
      final token = await AuthService.getStoredToken();
      if (token == null) return;

      _channel = WebSocketChannel.connect(
        Uri.parse('${ApiConstants.wsUrl}?token=$token'),
      );

      _channel!.stream.listen(
        (data) {
          try {
            final message = jsonDecode(data);
            _handleMessage(message);
          } catch (e) {
            debugPrint('Erreur lors du parsing du message WebSocket: $e');
          }
        },
        onError: (error) {
          debugPrint('Erreur WebSocket: $error');
          _reconnect();
        },
        onDone: () {
          debugPrint('Connexion WebSocket fermée');
          _reconnect();
        },
      );
    } catch (e) {
      debugPrint('Erreur lors de la connexion WebSocket: $e');
    }
  }

  void _handleMessage(Map<String, dynamic> message) {
    final type = message['type'];
    if (type != null && _listeners.containsKey(type)) {
      for (final listener in _listeners[type]!) {
        listener(message);
      }
    }
  }

  void addListener(String messageType, Function(Map<String, dynamic>) callback) {
    if (!_listeners.containsKey(messageType)) {
      _listeners[messageType] = [];
    }
    _listeners[messageType]!.add(callback);
  }

  void removeListener(String messageType, Function(Map<String, dynamic>) callback) {
    if (_listeners.containsKey(messageType)) {
      _listeners[messageType]!.remove(callback);
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  Future<void> _reconnect() async {
    await Future.delayed(const Duration(seconds: 5));
    connect();
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _listeners.clear();
  }
}