import 'package:flutter/material.dart';

typedef ActionCallback = void Function(String bib);

class LoggedTimeTable extends StatelessWidget {
  final List<Map<String, String>> data;
  final ActionCallback? onUndo;
  final ActionCallback? onMark;

  const LoggedTimeTable({
    Key? key,
    required this.data,
    this.onUndo,
    this.onMark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Text(
            'Logged time',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        // Table header (not scrollable)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(3),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 1),
              top: BorderSide.none,
              bottom: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
            ),
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xFF6C7AE0),
                ),
                children: [
                  _headerCell('BIB'),
                  _headerCell('Time'),
                  _headerCell('Action'),
                ],
              ),
            ],
          ),
        ),
        // Scrollable table body
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, idx) {
                  final row = data[idx];
                  return Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(3),
                    },
                    border: TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
                      top: BorderSide.none,
                      bottom: BorderSide.none,
                      left: BorderSide.none,
                      right: BorderSide.none,
                    ),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        children: [
                          _dataCell(row['bib']!),
                          _dataCell(row['time']!),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: onUndo != null ? () => onUndo!(row['bib']!) : null,
                                  child: _actionButton('Undo', const Color(0xFF6C7AE0), Colors.white),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: onMark != null ? () => onMark!(row['bib']!) : null,
                                  child: _actionButton('Mark', const Color(0xFF4CAF50), Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget _dataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  static Widget _actionButton(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}