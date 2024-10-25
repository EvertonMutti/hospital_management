import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:hospital_management/app/core/global_widgets/snackbar.dart';
import 'package:hospital_management/app/core/services/sqflite.dart';
import 'package:hospital_management/app/modules/global/core/model/signup_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<Uint8List> generatePdf() async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 7);

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
      row.cells[0].value = signup.name;
      row.cells[1].value = signup.email;
      row.cells[2].value = signup.phone;
      row.cells[3].value = signup.taxNumber;
      row.cells[4].value = signup.hospitalUniqueCode;
      row.cells[5].value = signup.position;
    }

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
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        Uint8List pdfData = await generatePdf();
        
        final directory = await getExternalStorageDirectory();
        String filePath = '${directory!.path}/relatorio_cadastros.pdf';

        File file = File(filePath);
        await file.writeAsBytes(pdfData);

        SnackBarApp.body('Sucesso', 'PDF salvo em: $filePath');
      } else {
        SnackBarApp.body('Permissão Negada', 'Por favor, permita acesso ao armazenamento.');
      }
    } catch (e) {
      SnackBarApp.body('Erro', 'Falha ao salvar PDF: $e');
    }
  }

}
