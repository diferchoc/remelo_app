import 'package:flutter/material.dart';

class PedidoDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> pedido;
  const PedidoDetalleScreen({super.key, required this.pedido});

  Color _estadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'en camino':
        return Colors.orange;
      case 'entregado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorEstado = _estadoColor(pedido['estado']);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Pedido #${pedido['id']}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD PRINCIPAL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.calendar_month_rounded, pedido['fecha']),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined,
                          size: 20, color: Colors.white70),
                      const SizedBox(width: 8),
                      Chip(
                        backgroundColor: colorEstado.withOpacity(.15),
                        label: Text(
                          pedido['estado'],
                          style: TextStyle(
                            color: colorEstado,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Total pagado',
                    style: TextStyle(fontSize: 14, color: Colors.white60),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${pedido['total']}',
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.purpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // RESUMEN CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen del pedido',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _line('- Camiseta básica negra (Talla M)'),
                  _line('- Envío estándar'),
                  _line('- Pago con tarjeta'),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BOTÓN DE RESEÑA
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.star_border),
                label: const Text(
                  'Dejar reseña',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  // Aquí puedes abrir un modal o una nueva pantalla para calificación
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Califica tu pedido'),
                      content: const Text('¿Cómo calificarías este pedido?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Aquí podrías guardar la calificación
                            Navigator.pop(context);
                          },
                          child: const Text('Enviar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(String txt) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          txt,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );

  Widget _infoRow(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 20, color: Colors.white70),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      );
}
