import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SegurancaService {
  final DateTime appStart = DateTime.now();
  static const MethodChannel _channel = MethodChannel("uptime_channel");
  // -----------------------------------------
  // 1) GEOLOCALIZAÇÃO
  // -----------------------------------------
  Future<bool> verificarLocalizacao() async {
    print("🔍 [GPS] Iniciando verificação de localização...");

    const double raioPermitido = 999999999; 
    const double faculLat = -26.230702; //-26.304444;  
    const double faculLng = -48.612934; //-48.850277;

    bool servicoAtivado = await Geolocator.isLocationServiceEnabled();
    print("📡 [GPS] Serviço de localização ativo: $servicoAtivado");
    if (!servicoAtivado) {
      print("❌ [GPS] Serviço de localização desativado.");
      return false;
    }

    LocationPermission perm = await Geolocator.checkPermission();
    print("📡 [GPS] Permissão atual: $perm");

    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      print("📡 [GPS] Permissão requisitada: $perm");

      if (perm == LocationPermission.denied) {
        print("❌ [GPS] Permissão negada.");
        return false;
      }
    }

    final pos = await Geolocator.getCurrentPosition();
    print("📍 [GPS] Posição atual: lat=${pos.latitude}, lng=${pos.longitude}");

    double dist = Geolocator.distanceBetween(
      faculLat, faculLng,
      pos.latitude, pos.longitude,
    );

    print("📏 [GPS] Distância até campus: ${dist.toStringAsFixed(2)} metros");

    bool dentro = dist <= raioPermitido;
    print("🏁 [GPS] Dentro do limite? $dentro");

    return dentro;
  }

  // -----------------------------------------
  // 2) SENSORES - ACELERÔMETRO
  // -----------------------------------------
  
  Future<bool> verificarSensores() async {
  print("🛑 [SENSORES] Verificação de sensores desativada temporariamente.");
  return true;
}

  /*Future<bool> verificarSensores() async {
    print("🔍 [SENSORES] Iniciando verificação...");

    final List<double> amostras = [];

    final sub = accelerometerEvents.listen((event) {
      double modulo =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      amostras.add(modulo);
    });

    await Future.delayed(const Duration(seconds: 1));
    await sub.cancel();

    print("📊 [SENSORES] Amostras capturadas: ${amostras.length}");

    if (amostras.length < 5) {
      print("❌ [SENSORES] Poucas amostras — suspeito.");
      return false;
    }

    double media = amostras.reduce((a, b) => a + b) / amostras.length;
    print("📊 [SENSORES] Média: ${media.toStringAsFixed(4)}");

    double soma = 0;
    for (final v in amostras) {
      soma += pow(v - media, 2);
    }

    double desvio = sqrt(soma / amostras.length);

    print("📉 [SENSORES] Desvio padrão: ${desvio.toStringAsFixed(4)}");

    bool valido = desvio > 0.03;
    print("🏁 [SENSORES] Movimento real detectado? $valido");

    return valido;
  } */

  // -----------------------------------------
  // 3) HORÁRIO / UPTIME SIMULADO
  // -----------------------------------------
  Future<bool> verificarHorario() async {
    print("🔍 [HORÁRIO] Verificando manipulação de horário...");

    int uptimeMs = 0;

    try {
      uptimeMs = await _channel.invokeMethod<int>("getUptime") ?? 0;
    } catch (e) {
      print("⚠️ Erro ao obter uptime: $e");
      return true;
    }

    print("⏱ uptime real desde o boot: $uptimeMs ms");

    // Regras
    bool valido = uptimeMs > 5 * 60 * 1000;

    print("🏁 Uptime > 5 min? $valido");

    return valido;
  }

}
