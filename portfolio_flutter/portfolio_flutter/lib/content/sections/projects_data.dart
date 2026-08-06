import '../models/project_content.dart';

class ProjectsData {
  static const String sectionTitle = 'SELECTED BUILDS';

  static const String sectionSubtitle =
      'Engineering systems built to solve real-world problems through thoughtful architecture and purposeful design.';

  static const List<ProjectContent> featuredBuilds = [

    ProjectContent(
      title: 'SARASWATI AI',
      shortDescription:
          'An AI-powered academic workspace designed to transform scattered study material into an intelligent learning ecosystem.',

      role: 'Lead Developer & System Architect',

      timeline: '2026',

      engineeringChallenge:
          'Designing an AI-first academic platform capable of organizing notes, understanding documents, and delivering contextual assistance while maintaining a clean, distraction-free workflow.',

      architectureNotes:
          '> MODULAR React frontend with responsive workspace.\n'
          '> AI-powered document understanding pipeline.\n'
          '> Context-aware chat interface with organized subject management.\n'
          '> Built during Microsoft Build with Bharat Hackathon.',

      techStack: [
        'React',
        'FastAPI',
        'Python',
        'AI APIs',
        'Firebase',
      ],

      metrics: [
        'Hackathon Project',
        'AI Workspace',
        'Cross Platform',
      ],

      problem:
          'Students constantly switch between PDFs, handwritten notes, videos, browsers, and AI tools. This fragmented workflow reduces productivity and makes studying inefficient.',

      solution:
          'Built SARASWATI AI as a unified academic workspace where documents, notes, AI assistance, and organized subjects exist in a single ecosystem. Instead of searching for information, students interact naturally with their learning material.',

      impact:
          'Created a scalable foundation for an AI-powered education platform capable of simplifying learning workflows while encouraging organized knowledge management.',

      technicalDecisions: {
        'Why React':
            'It is a declarative UI library that allows for the creation of complex UIs with minimal code.',

        'Why FastAPI':
            'Provided lightweight, asynchronous APIs for integrating AI services with minimal latency.',

        'Why AI-first Design':
            'The assistant was designed as the core interaction layer instead of being treated as an optional chatbot.',

        'Why Modular Architecture':
            'Every major feature was isolated into reusable components, allowing rapid experimentation during hackathon development.',
      },

      timelineStages: [
        'Research',
        'System Design',
        'AI Integration',
        'Hackathon Demo',
      ],

      githubUrl: 'https://github.com/mykcodes/SARAS.git',

      demoUrl: '',
    ),

    ProjectContent(
      title: 'MYK-CODES Portfolio',

      shortDescription:
          'A cinematic engineering portfolio built to transform a personal website into an interactive software experience.',

      role: 'Designer, Developer & Experience Engineer',

      timeline: '2026',

      engineeringChallenge:
          'Creating a portfolio that communicates engineering craftsmanship through interaction, storytelling, and performance rather than static content.',

      architectureNotes:
          '> Fully responsive Flutter Web architecture.\n'
          '> Content-driven system replacing hardcoded data.\n'
          '> Custom motion system with cinematic interactions.\n'
          '> GPU-conscious rendering optimized for high refresh-rate displays.',

      techStack: [
        'Flutter',
        'Dart',
        'GitHub',
        'Animation',
        'Responsive Design',
      ],

      metrics: [
        '120+ FPS',
        'Content Driven',
        'Responsive',
      ],

      problem:
          'Traditional portfolios often present projects as static cards, failing to communicate engineering thinking, decision making, and technical depth.',

      solution:
          'Engineered a living portfolio where every section tells a story through motion, interaction, engineering documentation, custom animations, and responsive visual systems.',

      impact:
          'Built a reusable content-driven architecture where future projects, achievements, and technical growth can be updated without modifying the UI, making the portfolio scalable for years to come.',

      technicalDecisions: {
        'Why Flutter Web':
            'Allowed complete control over rendering, animations, responsiveness, and a unified engineering experience.',

        'Why Content-driven Architecture':
            'Separated presentation from data so future updates require changing only structured content files instead of rebuilding widgets.',

        'Why Custom Motion System':
            'Designed cinematic interactions that reinforce storytelling while remaining performant on high-refresh-rate displays.',

        'Why Engineering Storytelling':
            'The goal was not simply to showcase projects, but to demonstrate problem-solving, architecture, and technical decision making.',
      },

      timelineStages: [
        'Concept',
        'Architecture',
        'Motion Design',
        'Optimization',
        'Deployment',
      ],

      githubUrl: 'https://github.com/mykcodes/Portfolio',

      demoUrl: '',
    ),
  ];
}