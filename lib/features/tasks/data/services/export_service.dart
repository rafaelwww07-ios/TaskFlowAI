import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../domain/entities/task.dart';

/// Service for exporting tasks
class ExportService {
  /// Export tasks to CSV
  Future<void> exportToCSV(List<Task> tasks) async {
    final csvData = [
      ['Title', 'Description', 'Priority', 'Status', 'Category', 'Due Date', 'Created At'],
    ];

    for (final task in tasks) {
      csvData.add([
        task.title,
        task.description ?? '',
        task.priority.name,
        task.status.name,
        task.category.name,
        task.dueDate?.toIso8601String() ?? '',
        task.createdAt?.toIso8601String() ?? '',
      ]);
    }

    final csv = const ListToCsvConverter().convert(csvData);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/tasks_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'TaskFlow AI Export',
    );
  }

  /// Export tasks to JSON
  Future<void> exportToJSON(List<Task> tasks) async {
    final jsonData = tasks.map((task) => {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'priority': task.priority.name,
      'status': task.status.name,
      'category': task.category.name,
      'dueDate': task.dueDate?.toIso8601String(),
      'createdAt': task.createdAt?.toIso8601String(),
      'tags': task.tags,
    }).toList();

    final json = jsonEncode(jsonData);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/tasks_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(json);
    
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'TaskFlow AI Export',
    );
  }

  /// Export tasks to PDF
  Future<void> exportToPDF(List<Task> tasks) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'TaskFlow AI - Task Export',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Generated on: ${DateTime.now().toIso8601String()}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 20),
          ...tasks.map((task) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  task.title,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (task.description != null) ...[
                  pw.SizedBox(height: 5),
                  pw.Text(
                    task.description!,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Text('Priority: ${task.priority.name}'),
                    pw.SizedBox(width: 20),
                    pw.Text('Status: ${task.status.name}'),
                    pw.SizedBox(width: 20),
                    pw.Text('Category: ${task.category.name}'),
                  ],
                ),
                if (task.dueDate != null)
                  pw.Text('Due: ${task.dueDate!.toIso8601String()}'),
              ],
            ),
          )),
        ],
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/tasks_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'TaskFlow AI Export',
    );
  }
}

