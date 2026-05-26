# ClubOS 🚀
> Next-Generation Club and Student Activity Management System with Premium Deep-Space Aesthetics.

ClubOS is a high-fidelity, feature-rich Flutter application designed to modernize student clubs and organizational activities. It features a stunning glassmorphic UI, custom neon styling, and a seamless dual-theme system (Cyberpunk Dark / Minimalist Light). Powered by Firebase, ClubOS enables interactive collaboration, financial auditing, inventory management, task tracking, and advanced role-based analytics.

---

## ✨ Features

### 🌌 Visual Design & Aesthetics
* **Neo-Cyberpunk & Glassmorphic UI**: Beautiful glow effects, dynamic animations, and neon border cards.
* **Seamless Dark & Light Themes**: Tailored HSL color palettes and custom styling across both modes.
* **Animated Page Transitions**: Built-in page wrappers for buttery-smooth routing and page switches.

### 📊 Modules & Functionality
* **Intelligence Overview (Analytics)**: Core intelligence metrics, interactive activity dashboards, and performance charts using `fl_chart`.
* **Fiscal Observatory (Management)**: Track budgets, funding, and expenses with transaction logs.
* **Vault Inventory (Management)**: Manage club assets, check-outs, and tracking status.
* **Elite ID (Profile)**: Digital identity cards for club members, complete with scannable layout.
* **Task Board**: Kanban-style task tracking with status columns (To Do, In Progress, Completed).
* **Governance & Archives**: Maintain official records, meeting minutes, and historic documents.
* **Real-time Chat**: Group chat rooms for interactive coordination between team members.
* **Club Profiling & Membership**: Register clubs, manage member permissions, and process join requests.

### 🛠 Services
* **Certificate Generator**: Dynamic PDF generation and print-ready membership certificate exports.
* **Seed Engine**: Auto-populates Firestore/mock data with realistic profiles for quick testing and local demos.

---

## 📂 Project Structure

```
lib/
├── main.dart                  # Application entry point & Auth state builder
├── theme.dart                 # Custom light/dark themed CSS/TextStyle configuration
├── models/                    # Data models mapping Firestore collections
│   ├── app_user.dart
│   ├── budget_entry.dart
│   ├── club.dart
│   ├── event.dart
│   ├── inventory_item.dart
│   ├── membership_request.dart
│   ├── message.dart
│   └── task.dart
├── providers/                 # State management layers
│   └── data_provider.dart     # Central ChangeNotifier handling state, theme, and data sync
├── services/                  # Business logic & utilities
│   ├── certificate_service.dart
│   └── seed_service.dart
├── widgets/                   # Custom reusable UI components
│   ├── animated_page_wrapper.dart
│   ├── detail_sheet.dart
│   ├── empty_state.dart
│   ├── event_card.dart
│   ├── nebula_rank_board.dart
│   ├── neon_bottom_sheet.dart
│   ├── neon_card.dart
│   ├── neon_line_chart.dart
│   ├── stat_tile.dart
│   └── task_card.dart
└── screens/                   # Views categorized by domain
    ├── analytics/             # Intelligence overview and metrics
    ├── auth/                  # Login and registration flows
    ├── chat/                  # Discussion board / chat UI
    ├── club/                  # Profiles, creation, and member details
    ├── dashboard/             # Role-based workspace dashboards
    ├── governance/            # Archives and record keeping
    ├── home/                  # Central launchpad activity stream
    ├── management/            # Fiscal tracker & inventory vaults
    ├── profile/               # Elite membership cards
    ├── shell/                 # Navigation framework (AppShell)
    └── tasks/                 # Kanban task boards
```

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (Version `>=3.11.4`)
* Dart SDK
* An active Firebase Project (with Firestore and Authentication enabled)

### Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/nagprathikmg01/Club-OS.git
   cd Club-OS
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Configure Firebase**:
   * Generate `lib/firebase_options.dart` using the FlutterFire CLI:
     ```bash
     flutterfire configure
     ```
   * Place your `google-services.json` inside `android/app/` if running on Android.

4. **Launch the application**:
   ```bash
   flutter run
   ```

---

## 🎨 Design Tokens & Style System

ClubOS implements a neon aesthetic using carefully designed tokens defined in [theme.dart](file:///d:/ALL%20PROJECTS/club_os/lib/theme.dart):

* **Cyberpunk Cyan**: `#00F0FF`
* **Neon Purple**: `#D900FF`
* **Deep Matte Black**: `#0A0E17`
* **Glass Card Backdrop**: `RGBA(255, 255, 255, 0.05)` with `BackdropFilter` blur.
