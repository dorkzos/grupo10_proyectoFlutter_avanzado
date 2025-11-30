String calcularTiempoTranscurrido(String fechaStr, String horaStr) {
  try {
    // 1. Parsear la fecha (asumiendo formato DD/MM/YYYY)
    final partesFecha = fechaStr.split('/');
    final dia = int.parse(partesFecha[0]);
    final mes = int.parse(partesFecha[1]);
    final anio = int.parse(partesFecha[2]);

    // 2. Parsear la hora (asumiendo formato HH:MM)
    final partesHora = horaStr.split(':');
    final hora = int.parse(partesHora[0]);
    final minuto = int.parse(partesHora[1]);

    // 3. Crear el objeto DateTime del reporte
    final fechaReporte = DateTime(anio, mes, dia, hora, minuto);
    final ahora = DateTime.now();

    // 4. Calcular la diferencia
    final diferencia = ahora.difference(fechaReporte);

    // 5. Retornar texto legible
    if (diferencia.inMinutes < 1) {
      return 'Hace un momento';
    } else if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes} min';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours} hora(s)';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays} día(s)';
    } else {
      return fechaStr; 
    }
  } catch (e) {
    return 'Fecha inválida';
  }
}