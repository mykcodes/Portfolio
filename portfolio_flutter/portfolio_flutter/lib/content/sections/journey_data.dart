import '../models/journey_content.dart';

class JourneyData {
  static const String sectionTitle = 'ENGINEERING LOGBOOK';

  static const String sectionSubtitle =
      'Every engineer has a beginning.\nThis is mine.';

  static const List<JourneyContent> milestones = [

    JourneyContent(
      commitHash: 'INIT001',
      logDate: '2021',
      title: 'THE FIRST SPARK',
      story:
          'Technology always fascinated me, but curiosity turned into action when I wrote my first programs in Python during school. What started as simple scripts soon became an obsession with understanding how software actually works.',
      technologies: [
        'Python',
        'Programming Fundamentals',
        'Problem Solving',
      ],
      architectureNotes:
          'Built the foundations of logical thinking, programming syntax, and algorithmic reasoning while discovering a genuine passion for software engineering.',
    ),

    JourneyContent(
      commitHash: 'CORE247',
      logDate: '2022 – 2024',
      title: 'CREATING & LEARNING',
      story:
          'Beyond academics, I explored content creation, video editing, and creative storytelling. Building digital content taught me the importance of design, user experience, and communicating ideas—skills that would later shape my approach to software.',
      technologies: [
        'Content Creation',
        'Video Editing',
        'UI Thinking',
      ],
      architectureNotes:
          'Developed creativity, visual design intuition, and communication skills that now influence every product I build.',
    ),

    JourneyContent(
      commitHash: 'ENG301',
      logDate: '2025',
      title: 'ENGINEERING BEGINS',
      story:
          'Starting Computer Science transformed curiosity into structured learning. I strengthened my understanding of Data Structures & Algorithms while building real applications instead of limiting myself to classroom theory.',
      technologies: [
        'C++',
        'DSA',
        'Git',
        'Software Engineering',
      ],
      architectureNotes:
          'Focused on problem solving, version control, and writing maintainable code while developing an engineering mindset.',
    ),

    JourneyContent(
      commitHash: 'BUILD404',
      logDate: '2026',
      title: 'BUILDING REAL SYSTEMS',
      story:
          'The journey evolved from learning concepts to engineering products. I built SARASWATI AI during the Microsoft Build with Bharat Hackathon and designed this portfolio as a living engineering experience that reflects both technical growth and craftsmanship.',
      technologies: [
        'Flutter',
        'AI',
        'FastAPI',
        'Firebase',
      ],
      architectureNotes:
          'Explored scalable architecture, responsive UI, AI integration, and modern development workflows while learning how software moves from an idea to a complete product.',
    ),

    JourneyContent(
      commitHash: 'HEAD',
      logDate: 'NOW',
      title: 'THE ROAD AHEAD',
      story:
          'Today my focus is mastering Cloud Computing, Cybersecurity, Linux, and modern system design while continuously building projects that challenge me. Every repository, every experiment, and every deployment is another milestone toward becoming a world-class software engineer.',
      technologies: [
        'Cloud',
        'Cybersecurity',
        'Linux',
        'System Design',
      ],
      architectureNotes:
          'Current mission: build production-ready systems, deepen engineering fundamentals, contribute to impactful projects, and never stop learning.',
    ),
  ];
}