import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'experience_controller.dart';




class ConsoleController extends ChangeNotifier {
  static final ConsoleController instance = ConsoleController._();
  ConsoleController._();

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  
  String _currentInput = '';
  String get currentInput => _currentInput;

  
  final List<ConsoleEntry> _outputBuffer = [];
  List<ConsoleEntry> get outputBuffer => List.unmodifiable(_outputBuffer);

  
  final List<String> _commandHistory = [];
  int _historyIndex = -1;

  
  static const List<String> _commandRegistry = [
    'help',
    'about',
    'resume',
    'projects',
    'architecture',
    'skills',
    'experience',
    'github',
    'linkedin',
    'email',
    'portfolio',
    'contact',
    'clear',
    'theme',
    'performance',
    'future',
    'status',
    'system',
  ];

  int _tabCycleIndex = -1;
  String _tabPrefix = '';

  void toggle() {
    _isOpen = !_isOpen;
    if (_isOpen) {
      
      if (_outputBuffer.isEmpty) {
        _outputBuffer.add(
          const ConsoleEntry(
            type: EntryType.system,
            content:
                'MYK-CODES Engineering Console v3.0\nType "help" to see available commands.\n',
          ),
        );
      }
    }
    notifyListeners();
  }

  void open() {
    if (!_isOpen) {
      _isOpen = true;
      if (_outputBuffer.isEmpty) {
        _outputBuffer.add(
          const ConsoleEntry(
            type: EntryType.system,
            content:
                'MYK-CODES Engineering Console v3.0\nType "help" to see available commands.\n',
          ),
        );
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
    _tabCycleIndex = -1; 
    notifyListeners();
  }

  
  void executeCommand() {
    final input = _currentInput.trim().toLowerCase();
    if (input.isEmpty) return;

    
    _outputBuffer.add(
      ConsoleEntry(type: EntryType.command, content: '> $input'),
    );

    
    _commandHistory.add(input);
    _historyIndex = _commandHistory.length;

    
    final response = _parseCommand(input);
    _outputBuffer.add(response);

    
    _handleConsoleAction(response.actionType);

    
    _currentInput = '';
    _tabCycleIndex = -1;
    notifyListeners();
  }

  Future<void> _handleConsoleAction(ConsoleAction action) async {
    switch (action) {
      case ConsoleAction.none:
        break;
      case ConsoleAction.openGithub:
        _launchUrl('https://github.com/mykcodes');
        break;
      case ConsoleAction.openResume:
        _launchUrl('https://mykcodes.com/resume.pdf');
        break;
      case ConsoleAction.openLinkedin:
        _launchUrl('https://linkedin.com/in/mykcodes');
        break;
      case ConsoleAction.openEmail:
        _launchUrl('mailto:contact@mykcodes.com');
        break;
      case ConsoleAction.scrollToHero:
        ExperienceController.instance.scrollToSection('hero');
        break;
      case ConsoleAction.scrollToProjects:
        ExperienceController.instance.scrollToSection('builds');
        break;
      case ConsoleAction.scrollToAbout:
        ExperienceController.instance.scrollToSection('about');
        break;
      case ConsoleAction.scrollToSkills:
        ExperienceController.instance.scrollToSection('toolbox');
        break;
      case ConsoleAction.scrollToExperience:
        ExperienceController.instance.scrollToSection('journey');
        break;
      case ConsoleAction.scrollToLab:
        ExperienceController.instance.scrollToSection('lab');
        break;
      case ConsoleAction.scrollToTerminal:
        ExperienceController.instance.scrollToSection('connection');
        break;
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Could not launch $url');
    }
  }

  
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
      case 'linkedin':
        return _linkedinResponse();
      case 'email':
        return _emailResponse();
      case 'portfolio':
        return _portfolioResponse();
      case 'contact':
        return _contactResponse();
      case 'clear':
        _outputBuffer.clear();
        return const ConsoleEntry(
          type: EntryType.system,
          content: 'Console cleared.',
        );
      case 'theme':
        return _themeResponse();
      case 'performance':
        return _performanceResponse();
      case 'future':
        return _futureResponse();
      case 'status':
        return _statusResponse();
      case 'system':
        return _systemResponse();
      
      case 'sudo':
        return const ConsoleEntry(
          type: EntryType.system,
          content: 'nice try. This incident will be reported.',
        );
      case 'whoami':
        return const ConsoleEntry(
          type: EntryType.system,
          content: 'You are a curious engineer. We should talk.',
        );
      case 'rm -rf /':
        return const ConsoleEntry(
          type: EntryType.system,
          content: 'Permission denied. The system architecture is immutable.',
        );
      case 'matrix':
        if (!ExperienceController.instance.isMatrixMode) {
          ExperienceController.instance.toggleMatrixMode();
        }
        return const ConsoleEntry(
          type: EntryType.system,
          content: 'Wake up, Neo... \nSystem override engaged.',
        );
      default:
        return ConsoleEntry(
          type: EntryType.error,
          content:
              'Command not recognized: "$input"\nType "help" to see available commands.',
        );
    }
  }

  

  ConsoleEntry _helpResponse() {
    return const ConsoleEntry(
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
║  linkedin      Open LinkedIn profile      ║
║  email         Launch mail client         ║
║  contact       Connection channels        ║
║  portfolio     Scroll to top              ║
║  clear         Clear console              ║
║  theme         Current theme state        ║
║  performance   Runtime metrics            ║
║  future        What comes next            ║
║  status        System vitals              ║
║  system        Environment info           ║
║                                          ║
║  ↑↓  History  │  TAB  Autocomplete       ║
╚══════════════════════════════════════════╝''',
    );
  }

  ConsoleEntry _aboutResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.scrollToAbout,
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
│  [Navigating to Dossier...]              │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _resumeResponse() {
    return const ConsoleEntry(
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
│  [Opening resume in new tab...]          │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _projectsResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.scrollToProjects,
      content: '''
┌─ SELECTED BUILDS ────────────────────────┐
│                                          │
│  ■ Neural Node Synchronizer              │
│    Real-time distributed state mgmt      │
│    Status: ████████████████ DEPLOYED      │
│                                          │
│  ■ Quantum Fluid Renderer                │
│    High-perf WebGL fluid simulation      │
│    Status: ████████████░░░░ IN PROGRESS   │
│                                          │
│  [Navigating to Builds...]               │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _architectureResponse() {
    return const ConsoleEntry(
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
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _skillsResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.scrollToSkills,
      content: '''
┌─ TECHNOLOGY STACK ───────────────────────┐
│                                          │
│  LANGUAGES                               │
│  ├─ Dart ·········· ████████████  2y     │
│  ├─ Python ········ ████████░░░░  1y     │
│  ├─ C++ ·········── ████████░░░░  1y     │
│                                          │
│  FRAMEWORKS                              │
│  ├─ Flutter ······── ████████████         │
│  ├─ FastAPI ·····── ████████░░░░         │
│                                          │
│  [Navigating to Toolbox...]              │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _experienceResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.scrollToExperience,
      content: '''
┌─ ENGINEERING TIMELINE ───────────────────┐
│                                          │
│  2024 ─── THE BEGINNING                  │
│  │  ░░ Discovered programming            │
│  │                                       │
│  2025 ─── BUILDING PRODUCTS              │
│  │  ▓▓ Flutter cross-platform apps       │
│  │                                       │
│  2026 ─── AI + CLOUD                     │
│  │  ██ Intelligent systems design        │
│  │                                       │
│  [Navigating to Journey...]              │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _githubResponse() {
    return const ConsoleEntry(
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

  ConsoleEntry _linkedinResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.openLinkedin,
      content: '''
┌─ LINKEDIN ───────────────────────────────┐
│                                          │
│  linkedin.com/in/mykcodes                │
│                                          │
│  [Opening in new tab...]                 │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _emailResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.openEmail,
      content: '''
┌─ EMAIL ──────────────────────────────────┐
│                                          │
│  contact@mykcodes.com                    │
│                                          │
│  [Launching mail client...]              │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _portfolioResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.scrollToHero,
      content: '''
┌─ PORTFOLIO ──────────────────────────────┐
│                                          │
│  Resetting viewport to hero section.     │
│                                          │
│  [Navigating...]                         │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _contactResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      actionType: ConsoleAction.scrollToTerminal,
      content: '''
┌─ CONNECTION CHANNELS ────────────────────┐
│                                          │
│  ▸ GitHub    github.com/mykcodes         │
│  ▸ LinkedIn  linkedin.com/in/mykcodes    │
│  ▸ Email     contact@mykcodes.com        │
│                                          │
│  Status: ● Available for Opportunities   │
│                                          │
│  [Navigating to Terminal...]             │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _themeResponse() {
    return const ConsoleEntry(
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
    return const ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ RUNTIME PERFORMANCE ────────────────────┐
│                                          │
│  Renderer:      Impeller / CanvasKit     │
│  Target FPS:    120 Hz                   │
│  Scroll:        CinematicSpringPhysics   │
│  Cursor:        Ticker @ VSync           │
│  Painters:      RepaintBoundary isolated │
│  Animations:    Procedural sine waves    │
│  Sound:         Pre-loaded AudioCache    │
│                                          │
│  Use Ctrl+Shift+D for live metrics.      │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _statusResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ SYSTEM STATUS ──────────────────────────┐
│                                          │
│  Core Loop:      ONLINE                  │
│  Render Engine:  STABLE                  │
│  Audio System:   SYNCHRONIZED            │
│  Network:        CONNECTED               │
│                                          │
│  All systems operating within parameters.│
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _systemResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ ENVIRONMENT INFO ───────────────────────┐
│                                          │
│  OS:             Dart VM / Browser       │
│  Architecture:   Cross-Platform UI       │
│  Build:          1.0.0+1 (Production)    │
│  Uptime:         Tracking...             │
│                                          │
└──────────────────────────────────────────┘''',
    );
  }

  ConsoleEntry _futureResponse() {
    return const ConsoleEntry(
      type: EntryType.output,
      content: '''
┌─ WHAT COMES NEXT ────────────────────────┐
│                                          │
│  ▸ Edge Intelligence                     │
│    On-device LLM inference               │
│                                          │
│  ▸ Zero-Trust Networking                 │
│    P2P encrypted state sync              │
│                                          │
│  ▸ Spatial Computing                     │
│    3D interfaces beyond flat screens     │
│                                          │
│  // The architecture is ready.           │
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


enum EntryType { command, output, system, error }


enum ConsoleAction {
  none,
  openGithub,
  openResume,
  openLinkedin,
  openEmail,
  scrollToHero,
  scrollToProjects,
  scrollToAbout,
  scrollToSkills,
  scrollToExperience,
  scrollToLab,
  scrollToTerminal,
}


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
