import 'package:flutter/material.dart';

/// Manages the interactive engineering console state.
/// Handles command parsing, history navigation, TAB autocomplete,
/// and output buffering with animated reveal.
class ConsoleController extends ChangeNotifier {
  static final ConsoleController instance = ConsoleController._();
  ConsoleController._();

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  // Input state
  String _currentInput = '';
  String get currentInput => _currentInput;

  // Output buffer — each entry is a console output block
  final List<ConsoleEntry> _outputBuffer = [];
  List<ConsoleEntry> get outputBuffer => List.unmodifiable(_outputBuffer);

  // Command history
  final List<String> _commandHistory = [];
  int _historyIndex = -1;

  // Autocomplete
  static const List<String> _commandRegistry = [
    'help',
    'about',
    'resume',
    'projects',
    'architecture',
    'skills',
    'experience',
    'github',
    'contact',
    'clear',
    'theme',
    'performance',
    'future',
  ];

  int _tabCycleIndex = -1;
  String _tabPrefix = '';

  void toggle() {
    _isOpen = !_isOpen;
    if (_isOpen) {
      // Add welcome message on first open
      if (_outputBuffer.isEmpty) {
        _outputBuffer.add(ConsoleEntry(
          type: EntryType.system,
          content: 'MYK-CODES Engineering Console v3.0\nType "help" to see available commands.\n',
        ));
      }
    }
    notifyListeners();
  }

  void open() {
    if (!_isOpen) {
      _isOpen = true;
      if (_outputBuffer.isEmpty) {
        _outputBuffer.add(ConsoleEntry(
          type: EntryType.system,
          content: 'MYK-CODES Engineering Console v3.0\nType "help" to see available commands.\n',
        ));
      }
      notifyListeners();
    }
  }

  void close() {
    if (_isOpen) {
      _isOpen = false;
      notifyListeners();
    }
  }

  void updateInput(String value) {
    _currentInput = value;
    _tabCycleIndex = -1; // Reset autocomplete on manual typing
    notifyListeners();
  }

  /// Execute the current input as a command
  void executeCommand() {
    final input = _currentInput.trim().toLowerCase();
    if (input.isEmpty) return;

    // Add command echo to output
    _outputBuffer.add(ConsoleEntry(
      type: EntryType.command,
      content: '> $input',
    ));

    // Store in history
    _commandHistory.add(input);
    _historyIndex = _commandHistory.length;

    // Parse and execute
    final response = _parseCommand(input);
    _outputBuffer.add(response);

    // Clear input
    _currentInput = '';
    _tabCycleIndex = -1;
    notifyListeners();
  }

  /// Navigate command history with ↑/↓ arrows
  void navigateHistory(bool up) {
    if (_commandHistory.isEmpty) return;

    if (up) {
      _historyIndex = (_historyIndex - 1).clamp(0, _commandHistory.length - 1);
    } else {
      _historyIndex = (_historyIndex + 1).clamp(0, _commandHistory.length);
    }

    if (_historyIndex < _commandHistory.length) {
      _currentInput = _commandHistory[_historyIndex];
    } else {
      _currentInput = '';
    }
    notifyListeners();
  }

  /// TAB autocomplete — cycles through matching commands
  void autocomplete() {
    if (_currentInput.isEmpty) return;

    if (_tabCycleIndex == -1) {
      _tabPrefix = _currentInput.toLowerCase();
    }

    final matches = _commandRegistry
        .where((cmd) => cmd.startsWith(_tabPrefix))
        .toList();

    if (matches.isEmpty) return;

    _tabCycleIndex = (_tabCycleIndex + 1) % matches.length;
    _currentInput = matches[_tabCycleIndex];
    notifyListeners();
  }

  ConsoleEntry _parseCommand(String input) {
    switch (input) {
      case 'help':
        return _helpResponse();
      case 'about':
        return _aboutResponse();
      case 'resume':
        return _resumeResponse();
      case 'projects':
        return _projectsResponse();
      case 'architecture':
        return _architectureResponse();
      case 'skills':
        return _skillsResponse();
      case 'experience':
        return _experienceResponse();
      case 'github':
        return _githubResponse();
      case 'contact':
        return _contactResponse();
      case 'clear':
        _outputBuffer.clear();
        return ConsoleEntry(type: EntryType.system, content: 'Console cleared.');
      case 'theme':
        return _themeResponse();
      case 'performance':
        return _performanceResponse();
      case 'future':
        return _futureResponse();
      default:
        return ConsoleEntry(
          type: EntryType.error,
          content: 'Command not recognized: "$input"\nType "help" to see available commands.',
        );
    }
  }

  // ─── Command Responses ─────────────────────────────────────────────

  ConsoleEntry _helpResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
╔══════════════════════════════════════════╗
║  MYK-CODES ENGINEERING CONSOLE          ║
╠══════════════════════════════════════════╣
║                                          ║
║  help          Show this menu            ║
║  about         Who built this            ║
║  resume        Qualifications            ║
║  projects      Selected builds           ║
║  architecture  System architecture       ║
║  skills        Technology stack           ║
║  experience    Engineering timeline       ║
║  github        Open GitHub profile        ║
║  contact       Connection channels        ║
║  clear         Clear console              ║
║  theme         Current theme state        ║
║  performance   Runtime metrics            ║
║  future        What comes next            ║
║                                          ║
║  ↑↓  History  │  TAB  Autocomplete       ║
╚══════════════════════════════════════════╝''',
    );
  }

  ConsoleEntry _aboutResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ ABOUT ──────────────────────────────────┐
│                                          │
│  Mayank — Software Engineer              │
│                                          │
│  Building products with engineering      │
│  precision. Focused on high-performance  │
│  systems, native platforms, and          │
│  production-grade architectures.         │
│                                          │
│  Philosophy:                             │
│  "Every pixel should be intentional.     │
│   Every interaction should communicate   │
│   craftsmanship."                        │
│                                          │
│  Currently exploring:                    │
│  → AI/ML Systems                         │
│  → Cloud Infrastructure                  │
│  → Cybersecurity                         │
│  → WebGL Rendering                       │
│                                          │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _resumeResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.openResume,
      content: '''
┌─ RESUME ─────────────────────────────────┐
│                                          │
│  EDUCATION                               │
│  └─ B.Tech Computer Science (Current)    │
│                                          │
│  KEY SKILLS                              │
│  ├─ Flutter / Dart          ██████████   │
│  ├─ Python / FastAPI        ████████░░   │
│  ├─ C++ / Algorithms        ████████░░   │
│  ├─ Cloud / Firebase        ███████░░░   │
│  └─ AI / ML                 ██████░░░░   │
│                                          │
│  HIGHLIGHTS                              │
│  → Cross-platform native architectures   │
│  → Real-time state synchronization       │
│  → WebGL rendering pipelines             │
│  → Production deployment experience      │
│                                          │
│  [Opening resume...]                     │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _projectsResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ SELECTED BUILDS ────────────────────────┐
│                                          │
│  ■ Neural Node Synchronizer              │
│    Real-time distributed state mgmt      │
│    Stack: Dart FFI, C++, WebSockets      │
│    Status: ████████████████ DEPLOYED      │
│                                          │
│  ■ Quantum Fluid Renderer                │
│    High-perf WebGL fluid simulation      │
│    Stack: Flutter Web, WebGL, GLSL       │
│    Status: ████████████░░░░ IN PROGRESS   │
│                                          │
│  Run "architecture" for system diagrams  │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _architectureResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ PORTFOLIO ARCHITECTURE ─────────────────┐
│                                          │
│  ┌─────────┐    ┌──────────────────┐     │
│  │  main   │───▶│ ExperienceEngine │     │
│  └────┬────┘    └──────┬───────────┘     │
│       │                │                 │
│       ▼                ▼                 │
│  ┌─────────┐    ┌──────────────┐         │
│  │ GoRouter│    │ ScrollEngine │         │
│  └────┬────┘    ├──────────────┤         │
│       │         │ SoundEngine  │         │
│       ▼         ├──────────────┤         │
│  ┌─────────┐    │ ParallaxEng  │         │
│  │HomeView │    ├──────────────┤         │
│  └────┬────┘    │ AmbientEng   │         │
│       │         └──────────────┘         │
│       ▼                                  │
│  ┌──────────────────────────────┐        │
│  │      Section Modules         │        │
│  ├──────┬──────┬──────┬────────┤        │
│  │ Hero │Builds│Jrney │Toolbox │        │
│  ├──────┴──────┴──────┴────────┤        │
│  │  Lab  │  Connection          │        │
│  └──────────────────────────────┘        │
│                                          │
│  Rendering: CustomPainter + Ticker       │
│  State: ChangeNotifier (Singleton)       │
│  Scroll: Cinematic Spring Physics        │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _skillsResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ TECHNOLOGY STACK ───────────────────────┐
│                                          │
│  LANGUAGES                               │
│  ├─ Dart ·········· ████████████  2y     │
│  ├─ Python ········ ████████░░░░  1y     │
│  ├─ C++ ·········── ████████░░░░  1y     │
│  └─ GLSL ········── ██████░░░░░░  <1y    │
│                                          │
│  FRAMEWORKS                              │
│  ├─ Flutter ······── ████████████         │
│  ├─ FastAPI ·····── ████████░░░░         │
│  └─ TensorFlow ··── ██████░░░░░░         │
│                                          │
│  INFRASTRUCTURE                          │
│  ├─ Firebase ····── ████████░░░░         │
│  ├─ Cloud ·······── ███████░░░░░         │
│  ├─ Git ·········── ████████████         │
│  └─ CI/CD ·······── ██████░░░░░░         │
│                                          │
│  DOMAINS                                 │
│  ├─ AI/ML            ├─ WebGL            │
│  ├─ Cybersecurity    └─ Real-time Sync   │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _experienceResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ ENGINEERING TIMELINE ───────────────────┐
│                                          │
│  2024 ─── THE BEGINNING                  │
│  │  ░░ Discovered programming            │
│  │  ░░ First algorithms in C++           │
│  │  ░░ Problem-solving foundations        │
│  │                                       │
│  2025 ─── BUILDING PRODUCTS              │
│  │  ▓▓ Flutter cross-platform apps       │
│  │  ▓▓ Firebase backend integration      │
│  │  ▓▓ Git workflow mastery              │
│  │                                       │
│  2026 ─── AI + CLOUD                     │
│  │  ██ Intelligent systems design        │
│  │  ██ Cloud infrastructure              │
│  │  ██ Cybersecurity exploration         │
│  │                                       │
│  NEXT ─── EVOLUTION                      │
│     ▶▶ Building software for millions    │
│                                          │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _githubResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.openGithub,
      content: '''
┌─ GITHUB ─────────────────────────────────┐
│                                          │
│  github.com/mykcodes                     │
│                                          │
│  [Opening in new tab...]                 │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _contactResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ CONNECTION CHANNELS ────────────────────┐
│                                          │
│  ▸ GitHub    github.com/mykcodes         │
│  ▸ LinkedIn  linkedin.com/in/mykcodes    │
│  ▸ Email     contact@mykcodes.com        │
│                                          │
│  Status: ● Available for Opportunities   │
│                                          │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _themeResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ THEME ENGINE STATE ─────────────────────┐
│                                          │
│  Mode:        Dark (Engineered)          │
│  Background:  #050505                    │
│  Surface:     #0A0A0A                    │
│  Accent:      #4F8CFF                    │
│  Typography:  Chakra Petch + Geist       │
│  Scroll:      Cinematic Spring Physics   │
│  Cursor:      Premium Ring + Trail       │
│  Sound:       Ambient + Interactive      │
│                                          │
│  // Everything is intentional.           │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _performanceResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ RUNTIME PERFORMANCE ────────────────────┐
│                                          │
│  Renderer:      Impeller / CanvasKit     │
│  Target FPS:    120 Hz                   │
│  Scroll:        CinematicSpringPhysics   │
│  Cursor:        Ticker @ VSync           │
│  Constellation: 250 nodes (procedural)   │
│  Painters:      RepaintBoundary isolated │
│  Animations:    Procedural sine waves    │
│  Sound:         Pre-loaded AudioCache    │
│                                          │
│  Use Ctrl+Shift+D for live metrics.      │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _futureResponse() {
    return ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ WHAT COMES NEXT ────────────────────────┐
│                                          │
│  ▸ Edge Intelligence                     │
│    On-device LLM inference at 15 tok/s   │
│                                          │
│  ▸ Zero-Trust Networking                 │
│    P2P encrypted state sync              │
│                                          │
│  ▸ Spatial Computing                     │
│    3D interfaces beyond flat screens     │
│                                          │
│  ▸ Open Source Contributions             │
│    Giving back to the ecosystem          │
│                                          │
│  // The architecture is ready.           │
│  // The environment is initialized.      │
│  // Let's build something people         │
│  // remember.                            │
│                                          │
└──────────────────────────────────────────┘''',
    );
  }

  @override
  void dispose() {
    _outputBuffer.clear();
    _commandHistory.clear();
    super.dispose();
  }
}

/// Types of console entries for styling
enum EntryType { command, output, system, error }

/// Optional action triggered by a command
enum ConsoleAction { none, openGithub, openResume, openLinkedin }

/// Represents a single entry in the console output buffer
class ConsoleEntry {
  final EntryType type;
  final String content;
  final ConsoleAction actionType;

  const ConsoleEntry({
    required this.type,
    required this.content,
    this.actionType = ConsoleAction.none,
  });
}
