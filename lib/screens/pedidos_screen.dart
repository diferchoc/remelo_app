// lib/screens/pedidos_screen.dart
import 'package:flutter/material.dart';
import 'pedido_detalle_screen.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  final List<Map<String, dynamic>> pedidos = const [
    {'id': '001', 'fecha': '12/05/2025', 'estado': 'En camino', 'total': 75000},
    {'id': '002', 'fecha': '10/05/2025', 'estado': 'Entregado', 'total': 120000},
    {'id': '003', 'fecha': '09/05/2025', 'estado': 'Cancelado', 'total': 50000},
  ];

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
    return SafeArea(            // ← evita que el contenido se meta bajo la AppBar del HomeScreen
      child: Container(
        color: const Color.fromARGB(99, 197, 2, 251), // fondo oscuro coherente
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: pedidos.length,
          itemBuilder: (_, i) {
            final p = pedidos[i];
            final estadoColor = _estadoColor(p['estado']);

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PedidoDetalleScreen(pedido: p),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 22),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.45),
                      blurRadius: 8,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Borde lateral morado
                    Container(
                      width: 6,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8E24AA),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pedido #${p['id']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Fecha: ${p['fecha']}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Chip(
                                  label: Text(
                                    p['estado'],
                                    style: TextStyle(
                                      color: estadoColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: estadoColor.withOpacity(.18),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                const Spacer(),
                                Text(
                                  '\$${p['total']}',
                                  style: const TextStyle(
                                    color: Colors.purpleAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
