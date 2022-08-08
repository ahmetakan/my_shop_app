import 'dart:math';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import '../providers/orders.dart' as oi;

class OrderItem extends StatefulWidget {
  const OrderItem({required this.order, Key? key}) : super(key: key);

  final oi.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.order.amount}"),
            subtitle: Text(
                DateFormat("dd MM yyyy hh:mm").format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
                if (_expanded) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            height: _expanded
                ? min(widget.order.products.length * 20 + 10, 100)
                : 0,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: FadeTransition(
              opacity: _opacityAnimation!,
              child: ListView(
                children: widget.order.products.map(
                  (prod) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prod.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${prod.quantity}x \$${prod.price}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
