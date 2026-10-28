import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../main.dart';

class CourseFormPage extends StatefulWidget {
  // TAHAP 7: Parameter course opsional. Jika diisi, berarti mode EDIT
  final Course? courseToEdit;

  const CourseFormPage({super.key, this.courseToEdit});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _titleController;
  late TextEditingController _creditsController;
  late String _status;

  bool get isEditMode => widget.courseToEdit != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill data lama jika mode EDIT
    _codeController = TextEditingController(text: widget.courseToEdit?.code ?? '');
    _titleController = TextEditingController(text: widget.courseToEdit?.title ?? '');
    _creditsController = TextEditingController(
      text: widget.courseToEdit != null ? widget.courseToEdit!.credits.toString() : '',
    );
    _status = widget.courseToEdit?.status ?? 'planned';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CourseProvider>();
      
      final updatedCourse = Course(
        id: widget.courseToEdit?.id,
        code: _codeController.text,
        title: _titleController.text,
        credits: int.parse(_creditsController.text),
        status: _status,
      );

      bool success;
      if (isEditMode) {
        // Mode Update (PUT)
        success = await provider.updateCourse(widget.courseToEdit!.id!, updatedCourse);
      } else {
        // Mode Create (POST)
        success = await provider.addCourse(updatedCourse);
      }

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode ? 'Berhasil mengupdate course!' : 'Berhasil menambahkan course!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${provider.error}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Course' : 'Tambah Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                readOnly: isEditMode, // TAHAP 7: Read-only jika mode Edit
                decoration: InputDecoration(
                  labelText: 'Kode Course',
                  helperText: isEditMode ? 'Kode course tidak dapat diubah' : null,
                ),
                validator: (value) => value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Course'),
                validator: (value) => value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(labelText: 'SKS / Credits'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'done', child: Text('Done')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _status = val);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSaving ? null : _submitForm,
                child: isSaving 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(isEditMode ? 'Update Course' : 'Simpan Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}