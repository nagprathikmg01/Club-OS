import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/neon_card.dart';

class ArchivesScreen extends StatelessWidget {
  const ArchivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ClubOsTheme.gutterLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text('REPOSITORY V4.2', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            Text('ARCHIVES', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Centralized knowledge base for organization governance, historical documentation, and legal frameworks.',
              style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 48),

            // Bylaws Section (High-Density & Responsive)
            LayoutBuilder(
              builder: (context, constraints) {
                final bool useVertical = constraints.maxWidth < 650;
                
                final bylawsCard = _buildBentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.gavel, color: ClubOsTheme.secondaryIntelligence, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'ORGANIZATION BYLAWS',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildArchiveItem('Main Charter 2024.v2', 'Core governance framework and founding principles.', 'PDF • 4.2 MB', true),
                      const SizedBox(height: 16),
                      _buildArchiveItem('Member Conduct Policy', 'Updated ethics and community standards guide.', 'DOCX • 1.8 MB', false),
                    ],
                  ),
                );

                if (useVertical) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      bylawsCard,
                      const SizedBox(height: 24),
                      _buildQuickAccessPanel(),
                    ],
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: bylawsCard,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildQuickAccessPanel(),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 48),

            // Meeting Minutes List
            Text('MEETING MINUTES', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 14)),
            const SizedBox(height: 16),
            _buildBentoCard(
              child: Column(
                children: [
                  _buildMinuteRow('Board Meeting - July 2024', 'July 14, 2024', '1.2 MB'),
                  const Divider(height: 32),
                  _buildMinuteRow('General Assembly - Q2', 'June 22, 2024', '2.5 MB'),
                  const Divider(height: 32),
                  _buildMinuteRow('Emergency Bylaw Session', 'May 10, 2024', '890 KB'),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Archive Health
            LayoutBuilder(
              builder: (context, constraints) {
                final bool useVertical = constraints.maxWidth < 600;
                final healthTitle = Text('ARCHIVE HEALTH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: ClubOsTheme.onSurfaceVariant));
                final healthValue = const Text('98%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold));
                final backupStatus = Text('AUTOMATIC BACKUPS ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClubOsTheme.primaryCommand));
                final infoText = Text(
                  'All documents are cryptographically signed and immutable via the Blockchain verification layer.',
                  style: TextStyle(fontSize: 12, color: ClubOsTheme.onSurfaceVariant.withOpacity(0.7)),
                );

                if (useVertical) {
                  return _buildBentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        healthTitle,
                        const SizedBox(height: 12),
                        healthValue,
                        const SizedBox(height: 8),
                        backupStatus,
                        const SizedBox(height: 16),
                        infoText,
                      ],
                    ),
                  );
                } else {
                  return _buildBentoCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              healthTitle,
                              const SizedBox(height: 12),
                              healthValue,
                              const SizedBox(height: 8),
                              backupStatus,
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: infoText,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({required Widget child}) {
    return NeonCard(
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }

  Widget _buildArchiveItem(String title, String desc, String meta, bool isNew) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isNew ? ClubOsTheme.primaryCommand.withOpacity(0.3) : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              if (isNew) Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: ClubOsTheme.primaryCommand, borderRadius: BorderRadius.circular(4)),
                child: const Text('LATEST', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 12, color: ClubOsTheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(meta, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant)),
              Icon(Icons.download, size: 16, color: ClubOsTheme.primaryCommand),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLink(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.white54, size: 14),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildMinuteRow(String title, String date, String size) {
    return Row(
      children: [
        Icon(Icons.article, color: ClubOsTheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(date, style: TextStyle(fontSize: 11, color: ClubOsTheme.onSurfaceVariant)),
            ],
          ),
        ),
        Text(size, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant)),
        const SizedBox(width: 16),
        const Icon(Icons.chevron_right, size: 18),
      ],
    );
  }

  Widget _buildQuickAccessPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ClubOsTheme.isDark
            ? ClubOsTheme.secondaryIntelligence.withOpacity(0.15)
            : ClubOsTheme.secondaryIntelligence,
        borderRadius: BorderRadius.circular(16),
        border: ClubOsTheme.isDark
            ? Border.all(color: ClubOsTheme.secondaryIntelligence.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('QUICK ACCESS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 11)),
          const SizedBox(height: 24),
          _buildQuickLink('Member Onboarding Kit'),
          _buildQuickLink('Annual Financial Report'),
          _buildQuickLink('Emergency Protocols'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: ClubOsTheme.isDark
                  ? ClubOsTheme.secondaryIntelligence.withOpacity(0.2)
                  : Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            ),
            child: const Text('REQUEST NEW FILE'),
          ),
        ],
      ),
    );
  }
}
