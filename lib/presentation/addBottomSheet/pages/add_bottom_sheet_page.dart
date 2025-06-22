import 'dart:io';
import 'package:drobee/data/google_drive_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerBox extends StatefulWidget {
  const PhotoPickerBox({super.key});

  @override
  State<PhotoPickerBox> createState() => _PhotoPickerBoxState();
}

class _PhotoPickerBoxState extends State<PhotoPickerBox> {
  final GoogleDriveService _driveService = GoogleDriveService();
  bool _isLoading = false;
  File? _selectedImage;
  bool _permissionChecked = false;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _driveService.checkDrivePermission();
      _permissionChecked = true;
      print('İzin durumu: ${_driveService.hasPermission}');
    } catch (e) {
      print('İzin kontrolü hatası: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    print('Resim seçimi başlatılıyor - Source: ${source.name}');

    // İzin kontrolü yapılmamışsa önce kontrol et
    if (!_permissionChecked) {
      await _initializePermissions();
    }

    // Eğer izin yoksa, kullanıcıdan iste
    if (!_driveService.hasPermission) {
      print('Drive izni yok, kullanıcıdan izin isteniyor...');
      final hasPermission = await _requestDrivePermission();
      if (!hasPermission) {
        print('Kullanıcı izin vermedi');
        _showPermissionDeniedDialog();
        return;
      }
    }

    // İzin varsa resim seç ve yükle
    await _pickAndUploadImage(source);
  }

  Future<bool> _requestDrivePermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _driveService.requestDrivePermission();
      print('İzin isteme sonucu: $result');
      return result;
    } catch (e) {
      print('İzin isteme hatası: $e');
      _showErrorMessage('İzin alma sırasında hata oluştu: $e');
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ImagePicker picker = ImagePicker();

      print('Image picker başlatılıyor...');
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        print('Resim seçildi: ${pickedFile.path}');
        final imageFile = File(pickedFile.path);

        // Dosya kontrolü
        if (!await imageFile.exists()) {
          throw Exception('Seçilen dosya bulunamadı');
        }

        print('Dosya boyutu: ${await imageFile.length()} bytes');

        // Drive'a yükle
        final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        print('Drive\'a yükleniyor: $fileName');

        final uploaded = await _driveService.uploadImageToDrive(
          imageFile,
          fileName,
        );

        if (uploaded) {
          print('Yükleme başarılı');
          setState(() {
            _selectedImage = imageFile;
          });
          _showSuccessMessage();
        } else {
          print('Yükleme başarısız');
          _showErrorMessage('Fotoğraf Google Drive\'a yüklenirken hata oluştu');
        }
      } else {
        print('Kullanıcı resim seçmeyi iptal etti');
      }
    } catch (e) {
      print('Resim işleme hatası: $e');
      _showErrorMessage('Resim işlenirken hata oluştu: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Google Drive İzni Gerekli'),
            content: const Text(
              'Fotoğraf yükleyebilmek için Google Drive erişim izni vermeniz gerekiyor. '
              'Bu izin olmadan fotoğraf yükleyemezsiniz.\n\n'
              'İzin vermek için "İzin Ver" butonuna basın.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  print('Dialog\'dan tekrar izin isteniyor...');
                  final hasPermission = await _requestDrivePermission();
                  if (hasPermission) {
                    print('İzin verildi, galeri açılıyor...');
                    await _pickAndUploadImage(ImageSource.gallery);
                  } else {
                    print('İzin tekrar reddedildi');
                    _showErrorMessage(
                      'Google Drive izni olmadan fotoğraf yükleyemezsiniz',
                    );
                  }
                },
                child: const Text('İzin Ver'),
              ),
            ],
          ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Fotoğraf Google Drive\'a başarıyla yüklendi!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ $message'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child:
                  _isLoading
                      ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('İşlem yapılıyor...'),
                        ],
                      )
                      : _selectedImage != null
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "✅ Google Drive'a Yüklendi",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _permissionChecked
                                ? (_driveService.hasPermission
                                    ? Icons.cloud_upload_outlined
                                    : Icons.cloud_off_outlined)
                                : Icons.cloud_queue_outlined,
                            size: 64,
                            color:
                                !_permissionChecked
                                    ? Colors.grey
                                    : (_driveService.hasPermission
                                        ? Colors.blue
                                        : Colors.orange),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            !_permissionChecked
                                ? "Yükleniyor..."
                                : (_driveService.hasPermission
                                    ? "Fotoğraf Ekle"
                                    : "Drive İzni Gerekli"),
                            style: TextStyle(
                              color:
                                  !_permissionChecked
                                      ? Colors.grey
                                      : (_driveService.hasPermission
                                          ? Colors.blue
                                          : Colors.orange),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!_permissionChecked ||
                              !_driveService.hasPermission)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "Google Drive'a yüklemek için izin gerekli",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _isLoading
                          ? null
                          : () => _handleImageSelection(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library, size: 20),
                  label: const Text(
                    "Galeri",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _isLoading
                          ? null
                          : () => _handleImageSelection(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt, size: 20),
                  label: const Text(
                    "Kamera",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),

          // Debug ve Reset butonları
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final isSignedIn = await _driveService.isSignedIn;
                    final hasPermission = _driveService.hasPermission;
                    final userEmail = await _driveService.currentUserEmail;

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Giriş: $isSignedIn\nİzin: $hasPermission\nEmail: $userEmail',
                          ),
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  child: const Text('Durum', style: TextStyle(fontSize: 12)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                      _selectedImage = null;
                      _permissionChecked = false;
                    });

                    await _driveService.revokeDrivePermission();
                    await _initializePermissions();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🔄 İzinler sıfırlandı'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Sıfırla', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
