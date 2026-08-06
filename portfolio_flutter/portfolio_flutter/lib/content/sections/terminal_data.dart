import '../models/terminal_command.dart';
import '../social_links.dart';

class TerminalData {
  static const List<TerminalCommand> connectionChannels = [
    TerminalCommand(
      label: 'GitHub',
      command: 'open github',
      url: SocialLinks.github,
    ),
    TerminalCommand(
      label: 'LinkedIn',
      command: 'open linkedin',
      url: SocialLinks.linkedin,
    ),
    TerminalCommand(
      label: 'Email',
      command: 'send email',
      url: SocialLinks.email,
    ),
    TerminalCommand(
      label: 'Resume',
      command: 'download resume',
      url: SocialLinks.resume,
    ),
  ];
}
