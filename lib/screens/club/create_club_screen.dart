import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../providers/data_provider.dart';

class CreateClubScreen extends StatefulWidget {
  const CreateClubScreen({super.key});

  @override
  State<CreateClubScreen> createState() => _CreateClubScreenState();
}

class _CreateClubScreenState extends State<CreateClubScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _create() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await context.read<DataProvider>().createClub(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: _imageController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context); // Go back to Join screen, which will auto-redirect as user is now active
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text('INITIALIZE NETWORK', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: ClubOsTheme.primaryCommand, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ClubOsTheme.gutterLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ESTABLISH NEW ORGANIZATION',
              style: TextStyle(color: ClubOsTheme.onSurfaceVariant, letterSpacing: 0.5, fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildTextField('NOMINAL_IDENTIFIER', _nameController, false),
            const SizedBox(height: 24),
            _buildTextField('OPERATIONAL_SUMMARY', _descController, false, maxLines: 3),
            const SizedBox(height: 24),
            _buildTextField('ASSET_IMAGE_URL (OPTIONAL)', _imageController, false),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _create,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: ClubOsTheme.primaryCommand,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('INITIALIZE HUB', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool obscure, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ClubOsTheme.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          maxLines: maxLines,
          style: TextStyle(color: ClubOsTheme.onSurfaceMain),
          decoration: InputDecoration(
            filled: true,
            fillColor: ClubOsTheme.solarSurfaceLowest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ClubOsTheme.primaryCommand, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
