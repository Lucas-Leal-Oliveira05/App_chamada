import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SegurancaService {
  final DateTime appStart = DateTime.now();  
  // -----------------------------------------
  // 1) GEOLOCALIZAÇÃO
  // -----------------------------------------
  Future<bool> verificarLocalizacao() async {
    const double raioPermitido = 150; // metros
    const double faculLat = -26.304444; // coloque sua lat real
    const double faculLng = -48.850277; // coloque sua long real

    bool servicoAtivado = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivado) return false;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) return false;
    }

    final pos = await Geolocator.getCurrentPosition();

    double dist = Geolocator.distanceBetween(
      faculLat, faculLng,
      pos.latitude, pos.longitude,
    );

    return dist <= raioPermitido;
  }

  // -----------------------------------------
  // 2) SENSORES - ACELERÔMETRO
  // -----------------------------------------
  Future<bool> verificarSensores() async {
    final List<double> amostras = [];

    final sub = accelerometerEvents.listen((event) {
      double modulo = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      amostras.add(modulo);
    });

    // captura por 1 segundo
    await Future.delayed(const Duration(seconds: 1));
    await sub.cancel();

    if (amostras.length < 5) return false;

    // calcular desvio padrão
    double media = amostras.reduce((a, b) => a + b) / amostras.length;

    double soma = 0;
    for (final v in amostras) {
      soma += pow(v - media, 2);
    }

    double desvio = sqrt(soma / amostras.length);

    // Se desvio muito baixo → suspeito (robótico)
    return desvio > 0.03; // valor ajustável
  }

  // -----------------------------------------
  // 3) HORÁRIO / UPTIME
  // -----------------------------------------
  // -----------------------------------------
  // 3) HORÁRIO / UPTIME SIMULADO
  // -----------------------------------------
  Future<bool> verificarHorario() async {
    final agora = DateTime.now();

    // tempo desde o app iniciar
    final tempoDesdeBoot = agora.difference(appStart).inMilliseconds;

    // se o app foi reiniciado recentemente (<5 min), suspeito
    return tempoDesdeBoot > 5 * 60 * 1000; // 5 minutos
  }
}
