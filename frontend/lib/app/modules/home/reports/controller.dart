import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/snackbar.dart';
import 'package:hospital_management/app/core/services/sqflite.dart';
import 'package:hospital_management/app/core/utils/system.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';

class ReportsController extends GetxController {
  final SignupService signupService = SignupService();

  var signups = <SignupModel>[].obs;

  final RxBool _loading = false.obs;
  bool get getLoading => _loading.value;
  set setLoading(bool status) => _loading.value = status;

  @override
  void onReady() {
    super.onReady();
    fetchSignups();
  }

  Future<void> fetchSignups() async {
    try {
      setLoading = true;
      var result = await signupService.getAllSignups();
      signups.assignAll(result);
    } catch (e) {
      SnackBarApp.body('Error', 'Failed to fetch signups');
    } finally {
      setLoading = false;
    }
  }

  String wrapText(String? text, [int maxLength = 19]) {
    if (text == null) return ' ';
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i += maxLength) {
      buffer.write(text.substring(i, i + maxLength > text.length ? text.length : i + maxLength));
      if (i + maxLength < text.length) buffer.write('\n');
    }
    return buffer.toString();
  }

  Future<Uint8List> generatePdf() async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();

    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 6);

    grid.headers.add(1);
    final PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Nome';
    header.cells[1].value = 'Email';
    header.cells[2].value = 'Telefone';
    header.cells[3].value = 'CPF';
    header.cells[4].value = 'Código do Hospital';
    header.cells[5].value = 'Posição';

    for (var signup in signups) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = wrapText(signup.name);
      row.cells[1].value = wrapText(signup.email);
      row.cells[2].value = wrapText(signup.phone);
      row.cells[3].value = wrapText(signup.taxNumber);
      row.cells[4].value = wrapText(signup.hospitalUniqueCode);
      row.cells[5].value = wrapText(signup.position);
    }

    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 4, right: 4, top: 2, bottom: 2),
      font: PdfStandardFont(PdfFontFamily.helvetica, 10),
    );

    grid.draw(
      page: page,
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
    );

    List<int> bytes = await document.save();
    document.dispose();

    return Uint8List.fromList(bytes);
  }

  Future<void> savePdf() async {
    try {
      if (await SystemInfo.requestStoragePermission()) {
        Uint8List pdfData = await generatePdf();

        String? directoryPath = await FilePicker.platform.getDirectoryPath();

        if (directoryPath != null) {
          String filePath = '$directoryPath/relatorio_cadastros.pdf';

          File file = File(filePath);
          await file.writeAsBytes(pdfData);
          SnackBarApp.body('Sucesso', 'PDF salvo em: $filePath');
        } else {
          SnackBarApp.body('Erro', 'A operação de salvar foi cancelada.');
        }
      } else {
        SnackBarApp.body(
            'Permissão Negada', 'Por favor, permita acesso ao armazenamento.');
      }
    } catch (e) {
      SnackBarApp.body('Erro', 'Falha ao salvar PDF: $e');
    }
  }
}
