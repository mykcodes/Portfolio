import '../models/toolbox_content.dart';

class ToolboxData {
  static const String sectionTitle = 'ENGINEERING TOOLBOX';

  static const String sectionSubtitle =
      "The technologies I'm building with,\nlearning, and exploring every day.";

  static const String genericClassificationLabel = 'Current Stage';
  static const String genericClassificationValue = 'Learning & Building';

  static const String genericExperienceLabel = 'Focus';
  static const String genericExperienceValue = 'Hands-on Practice';

  static const String genericIntegrationsLabel = 'Used In';
  static const String genericIntegrationsValue = 'Active Projects';

  static const String genericPhilosophyLabel = 'Engineering Mindset';

  static const String genericPhilosophyText =
      'I believe mastery comes from building. Every technology here represents something I have explored through projects, experimentation, or continuous learning—not just theory.';

  static const List<ToolboxContent> engineeringModules = [

    ToolboxContent(
      name: 'Flutter',
      description:
          'Building polished cross-platform applications with smooth user experiences.',
      fullEngineeringDescription:
          'Flutter is currently my primary development framework. I enjoy creating responsive interfaces, custom animations, reusable widgets, and performance-focused applications that feel native across platforms.',
      linkedProjects: [
        'MYK-CODES Portfolio',
        'SARASWATI AI'
      ],
      yearsOfExperience: 'Learning & Building',
      currentFocus:
          'Advanced animations and Architecture',
      tags: [
        'Flutter',
        'Dart',
        'UI Engineering',
        'Responsive Design'
      ],
    ),

    ToolboxContent(
      name: 'Artificial Intelligence',
      description:
          'Building practical AI-powered applications that solve real problems.',
      fullEngineeringDescription:
          'Exploring modern AI workflows including prompt engineering, document understanding, OCR, RAG concepts, and intelligent educational assistants using LLMs.',
      linkedProjects: [
        'SARASWATI AI'
      ],
      yearsOfExperience: 'Learning',
      currentFocus:
          'LLMs, AI integrations',
      tags: [
        'Gemini',
        'LLMs',
        'Prompt Engineering',
        'AI Systems'
      ],
    ),

    ToolboxContent(
      name: 'Cloud',
      description:
          'Learning how modern applications are deployed and scaled.',
      fullEngineeringDescription:
          'Currently exploring cloud fundamentals including deployment pipelines, backend hosting, authentication, databases, and scalable application architecture.',
      linkedProjects: [
        'Portfolio Deployment'
      ],
      yearsOfExperience: 'Learning',
      currentFocus:
          'AWS, Azure, Firebase',
      tags: [
        'Cloud',
        'Deployment',
        'Backend',
        'Scalability'
      ],
    ),

    ToolboxContent(
      name: 'Cybersecurity',
      description:
          'Beginning the journey into security and defensive engineering.',
      fullEngineeringDescription:
          'Learning networking fundamentals, Linux environments, ethical hacking concepts, and secure software development with the long-term goal of becoming a cloud security engineer.',
      linkedProjects: [
        'Security Labs'
      ],
      yearsOfExperience: 'Learning',
      currentFocus:
          'Linux, networking',
      tags: [
        'Linux',
        'Networking',
        'Security',
        'Cloud Security'
      ],
    ),

    ToolboxContent(
      name: 'Data Structures & Algorithms',
      description:
          'Strengthening problem-solving through consistent practice.',
      fullEngineeringDescription:
          'Building a strong foundation in algorithms, complexity analysis, and data structures to improve engineering thinking and prepare for technical interviews.',
      linkedProjects: [
        'DSA Practice'
      ],
      yearsOfExperience: 'Active Practice',
      currentFocus:
          'Arrays, Trees, Graphs',
      tags: [
        'C++',
        'Algorithms',
        'Problem Solving',
        'LeetCode'
      ],
    ),

    ToolboxContent(
      name: 'Python',
      description:
          'General-purpose programming for automation and AI workflows.',
      fullEngineeringDescription:
          'Using Python for scripting, backend experimentation, AI integrations, and automation while continuously expanding my understanding of the language.',
      linkedProjects: [
        'Automation Scripts'
      ],
      yearsOfExperience: 'Learning',
      currentFocus:
          'Automation, AI libraries',
      tags: [
        'Python',
        'Automation',
        'Backend',
        'AI'
      ],
    ),

    ToolboxContent(
      name: 'JavaScript & React',
      description:
          'Creating modern web interfaces and interactive user experiences.',
      fullEngineeringDescription:
          'Comfortable building component-based interfaces and understanding modern frontend development while expanding knowledge of the React ecosystem.',
      linkedProjects: [
        'Portfolio Experiments'
      ],
      yearsOfExperience: 'Learning & Building',
      currentFocus:
          'React ecosystem, frontend',
      tags: [
        'JavaScript',
        'React',
        'Frontend',
        'UI'
      ],
    ),

    ToolboxContent(
      name: 'Git & GitHub',
      description:
          'Managing projects through version control and collaboration.',
      fullEngineeringDescription:
          'Using Git daily to manage development, maintain clean commit history, collaborate on projects, and continuously improve engineering workflow.',
      linkedProjects: [
        'Every Project'
      ],
      yearsOfExperience: 'Daily Use',
      currentFocus:
          'Clean workflows, branching strategies',
      tags: [
        'Git',
        'GitHub',
        'Version Control',
        'Collaboration'
      ],
    ),
  ];
}