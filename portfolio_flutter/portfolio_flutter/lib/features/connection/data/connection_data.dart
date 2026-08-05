import '../models/terminal_command_model.dart';

class ConnectionData {
  static const bool isAvailable = true;
  static const String availabilityStatus = 'Available for Opportunities';
  
  static const List<TerminalCommandModel> connectionChannels = [
    TerminalCommandModel(
      label: 'GitHub',
      command: 'open github',
      url: 'https://github.com/mykcodes',
    ),
    TerminalCommandModel(
      label: 'LinkedIn',
      command: 'open linkedin',
      url: 'https://linkedin.com/in/mykcodes',
    ),
    TerminalCommandModel(
      label: 'Email',
      command: 'send email',
      url: 'mailto:contact@mykcodes.com',
    ),
    TerminalCommandModel(
      label: 'Resume',
      command: 'download resume',
      url: '/assets/resume.pdf',
    ),
  ];
}