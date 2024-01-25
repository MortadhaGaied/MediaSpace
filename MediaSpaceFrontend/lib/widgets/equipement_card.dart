import 'package:flutter/material.dart';
class EquipmentCard extends StatefulWidget {
  final String equipmentName;
  final String imageUrl;
  final double price;
  final int maxQuantity;
  final String description;
  final int equipmentId;
  final Function(int equipmentId, int quantity) onQuantityChange;
  EquipmentCard({
    required this.equipmentId,
    required this.equipmentName,
    required this.imageUrl,
    required this.price,
    required this.maxQuantity,
    required this.description,
    required this.onQuantityChange,
  });

  @override
  _EquipmentCardState createState() => _EquipmentCardState();
}

class _EquipmentCardState extends State<EquipmentCard> {
  int currentQuantity = 0;

  void _incrementQuantity() {
    if (currentQuantity < widget.maxQuantity) {
      setState(() => currentQuantity++);
      widget.onQuantityChange(widget.equipmentId, currentQuantity);
    }
  }

  void _decrementQuantity() {
    if (currentQuantity > 0) {
      setState(() => currentQuantity--);
      widget.onQuantityChange(widget.equipmentId, currentQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.imageUrl),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.equipmentName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${widget.price} DT/article • Max ${widget.maxQuantity}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(widget.description),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'plus d\'info',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _incrementQuantity,
              ),
              Text('$currentQuantity'),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: _decrementQuantity,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
