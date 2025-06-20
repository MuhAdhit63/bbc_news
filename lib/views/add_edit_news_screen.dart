import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_article.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AddEditNewsScreen extends StatefulWidget {
  final NewsArticle? article;
  const AddEditNewsScreen({this.article, Key? key}) : super(key: key);

  @override
  _AddEditNewsScreenState createState() => _AddEditNewsScreenState();
}

class _AddEditNewsScreenState extends State<AddEditNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  static const Color appBarBackgroundColor = Color(0xFFF9A825);
  static const Color appBarTextColor = Colors.black87;

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _summaryController;
  late TextEditingController _categoryController;
  late TextEditingController _imageUrlController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title ?? '');
    _contentController = TextEditingController(
      text: widget.article?.content ?? '',
    );
    _summaryController = TextEditingController(
      text: widget.article?.summary ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.article?.category ?? '',
    );

    _imageUrlController = TextEditingController(
      text: widget.article?.featuredImageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _summaryController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final token = Provider.of<AuthService>(context, listen: false).token;
    final apiService = ApiService(token);

    try {
      final newArticle = NewsArticle(
        id: widget.article?.id,
        title: _titleController.text,
        content: _contentController.text,
        summary: _summaryController.text,
        category: _categoryController.text,
        featuredImageUrl: _imageUrlController.text,
        tags: widget.article?.tags ?? ["general"],
        isPublished: widget.article?.isPublished ?? true,
      );

      if (widget.article == null) {
        // Mode Tambah
        await apiService.createNews(newArticle);
      } else {
        // Mode Edit
        await apiService.updateNews(widget.article!.id!, newArticle);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Terjadi Kesalahan'),
                content: Text('Gagal menyimpan berita: $e'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appBarTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.article == null ? 'Add News' : 'Edit News',
          style: TextStyle(
            color: appBarTextColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Judul tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _summaryController,
                        decoration: const InputDecoration(
                          labelText: 'Ringkasan (Summary)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator:
                            (value) =>
                                (value != null && value.length < 10)
                                    ? 'Ringkasan minimal 10 karakter'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Konten Lengkap',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 8,
                        validator:
                            (value) =>
                                (value != null && value.length < 10)
                                    ? 'Konten minimal 10 karakter'
                                    : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL Gambar Utama',
                          hintText: 'https://contoh.com/gambar.jpg',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'URL Gambar tidak boleh kosong';
                          }
                          if (!value.startsWith('http')) {
                            return 'Masukkan URL yang valid (diawali http/https)';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Kategori tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(
                          widget.article == null ? 'Add News' : 'Update News',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF9A825),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
