import 'package:flutter/material.dart';
import 'package:legwork/features/payment/presentation/provider/payment_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String email;
  final String dancerId;
  final String clientId;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.email,
    required this.dancerId,
    required this.clientId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController webViewController;
  bool _isLoading = true;
  bool _paymentCompleted = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initPayment();
  }

  Future<void> _initPayment() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final provider = Provider.of<PaymentProvider>(context, listen: false);
      await provider.initPayment(
        amount: widget.amount,
        email: widget.email,
        dancerId: widget.dancerId,
        clientId: widget.clientId,
      );

      if (provider.payment == null || provider.payment!.reference.isEmpty) {
        debugPrint(
            'Payment initialization failed: Invalid transaction reference');
        throw Exception('Invalid transaction reference from Paystack');
      }

      _setupWebView(provider.payment!.reference);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to initialize payment: ${e.toString()}';
      });
      debugPrint('Payment initialization error: $e');
    }
  }

  void _setupWebView(String reference) {
    final paymentUrl = 'https://checkout.paystack.com/$reference';
    debugPrint('Loading Paystack URL: $paymentUrl');

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() => _isLoading = progress < 100);
          },
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'WebView error: ${error.description}';
            });
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) _handleUrlChange(change.url);
          },
        ),
      )
      ..loadRequest(
        Uri.parse(paymentUrl),
        headers: {
          'Accept': 'text/html',
          'Content-Type': 'text/html; charset=UTF-8',
        },
      );
  }

  void _handleUrlChange(String? url) {
    if (url == null) return;

    debugPrint('URL changed: $url');

    // Check for Paystack callback URLs
    if (url.contains('callback') || url.contains('verify')) {
      final uri = Uri.parse(url);
      final reference = uri.queryParameters['reference'] ??
          uri.pathSegments.lastWhere((seg) => seg.isNotEmpty, orElse: () => '');

      if (reference.isNotEmpty && !_paymentCompleted) {
        _paymentCompleted = true;
        _verifyPayment(reference);
      }
    }
  }

  Future<void> _verifyPayment(String reference) async {
    try {
      setState(() => _isLoading = true);

      final provider = Provider.of<PaymentProvider>(context, listen: false);
      await provider.verifyPayment(reference: reference);

      if (provider.payment != null) {
        if (provider.payment!.status == 'success') {
          Navigator.of(context).pop(provider.payment);
        } else {
          setState(() {
            _errorMessage = 'Payment failed: ${provider.payment!.status}';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Payment verification failed';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complete Payment'),
          actions: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initPayment,
              child: const Text('Retry Payment Again'),
            ),
          ],
        ),
      );
    }

    if (_isLoading && !_paymentCompleted) {
      return const Center(child: CircularProgressIndicator());
    }

    return WebViewWidget(controller: webViewController);
  }
}
