import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/controllers/mercadoria_controller.dart';
import 'package:receitacerta/models/mercadoria.dart';

class QRScannerPage extends StatefulWidget {
  final Function(Mercadoria, double) onItemConfirmed;

  const QRScannerPage({super.key, required this.onItemConfirmed});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          _isProcessing = true;
        });

        // Vibrate on detection
        HapticFeedback.mediumImpact();

        await _processScannedId(barcode.rawValue!);
        break;
      }
    }
  }

  Future<void> _processScannedId(String rawValue) async {
    try {
      final int id = int.parse(rawValue);
      final mercadoria = Provider.of<MercadoriaController>(
        context,
        listen: false,
      ).getById(id);

      // Show confirmation modal
      await _showConfirmationModal(mercadoria);
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto não encontrado ou código inválido.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _showConfirmationModal(Mercadoria mercadoria) async {
    double quantity = 1.0;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: UserColor.background,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Confirmar Produto",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: UserColor.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      mercadoria.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "R\$ ${mercadoria.venda.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        color: UserColor.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.red,
                          iconSize: 32,
                          onPressed: () {
                            if (quantity > 1) {
                              setModalState(() {
                                quantity -= 1;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "${quantity.toInt()}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.green,
                          iconSize: 32,
                          onPressed: () {
                            setModalState(() {
                              quantity += 1;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(modalContext).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Voltar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.onItemConfirmed(mercadoria, quantity);
                            Navigator.of(modalContext).pop();
                          },
                          child: const Text("Adicionar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
