export interface Project {
    id: string;
    title: string;
    description: string;
    techStack: string[];
    imageUrl: string;
    link: string;
    year: string;
}

export const projects: Project[] = [
    {
        id: "proj-001",
        title: "EcoSort (Computer Vision & IoT)",
        description: "Innovated a waste sorting system by fine-tuning a ResNet50 model (TorchVision) for real-time waste classification (organic vs. recyclable), processing a live video stream captured and preprocessed with OpenCV. Built an IoT event-driven mechanism using ESP32 connecting software and hardware.",
        techStack: ["Python", "OpenCV", "ResNet50", "ESP32", "IoT"],
        imageUrl: "https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?q=80&w=1000&auto=format&fit=crop",
        link: "#",
        year: "2025"
    },
    {
        id: "proj-002",
        title: "Narrativa",
        description: "Architected a dynamic story feed application using Clean Architecture and go_router for declarative navigation. Developed features using dio for API calls and implemented infinite scrolling pagination. Integrated location-based features using google_maps_flutter.",
        techStack: ["Flutter", "Dart", "Clean Architecture", "Google Maps API"],
        imageUrl: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?q=80&w=1000&auto=format&fit=crop",
        link: "#",
        year: "2025"
    },
    {
        id: "proj-003",
        title: "pH Value Monitoring",
        description: "Engineered a real-time F&B quality monitoring system for cow milk using Python (FastAPI) and a pH sensor (ESP32). Designed a robust data persistence layer utilizing SQLAlchemy and SQLite.",
        techStack: ["Python", "FastAPI", "ESP32", "SQLAlchemy", "SQLite"],
        imageUrl: "https://images.unsplash.com/photo-1580982512681-3c7ea5d9aa66?q=80&w=1000&auto=format&fit=crop",
        link: "#",
        year: "2025"
    },
    {
        id: "proj-004",
        title: "Forum API",
        description: "Maintained high development standards by applying Test-Driven Development (TDD) with 100% code coverage. Architected the application using Clean Architecture and DDD. Configured Nginx with rate limiting and automated CI/CD via GitHub Actions.",
        techStack: ["Node.js", "TDD", "Jest", "Clean Architecture", "Nginx", "CI/CD"],
        imageUrl: "https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=1000&auto=format&fit=crop",
        link: "#",
        year: "2023"
    },
    {
        id: "proj-005",
        title: "OpenMusic RESTful API",
        description: "Engineered a plugin-based system with 5 core plugins to enhance modularity. Applied database normalization on PostgreSQL to support playlist collaboration. Utilized RabbitMQ and Redis to optimize asynchronous tasks and reduce read load.",
        techStack: ["Node.js", "PostgreSQL", "RabbitMQ", "Redis", "RESTful API"],
        imageUrl: "https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?q=80&w=1000&auto=format&fit=crop",
        link: "#",
        year: "2023"
    }
];
