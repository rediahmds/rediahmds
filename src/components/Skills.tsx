import React from "react";

export function Skills() {
    const customSkills = [
        { category: "Languages", items: ["Node.js", "Python", "SQL", "Dart", "JavaScript", "TypeScript"] },
        { category: "Backend & Cloud", items: ["GCP", "AWS", "PostgreSQL", "Redis", "RabbitMQ", "RESTful APIs", "Docker"] },
        { category: "Mobile Dev", items: ["Flutter", "Provider", "Clean Architecture"] },
        { category: "DevOps & Tools", items: ["Git", "GitHub Actions", "TDD (Jest)", "Postman"] }
    ];

    const certs = [
        "AWS Certified Cloud Practitioner",
        "Become an Intermediate Flutter App Developer (Dicoding)",
        "Become an Expert Node.js Back-End Developer (Dicoding)"
    ];

    return (
        <section className="w-full wireframe-border-b flex flex-col md:flex-row" id="skills">
            <div className="w-full md:w-1/2 wireframe-border-b md:wireframe-border-b-0 md:wireframe-border-r">
                <div className="px-6 sm:px-12 py-8 wireframe-border-b bg-[#050505]">
                    <h2 className="text-xl font-mono font-bold uppercase text-[var(--foreground)]">
                        <span className="text-[var(--accent)] mr-2">{">"}</span>
                        Tech_Stack
                    </h2>
                </div>
                <div className="px-6 sm:px-12 py-8 space-y-8">
                    {customSkills.map((skillGroup, idx) => (
                        <div key={idx}>
                            <h3 className="font-mono text-xs text-gray-500 mb-3 uppercase">{skillGroup.category}</h3>
                            <div className="flex flex-wrap gap-2">
                                {skillGroup.items.map(item => (
                                    <span key={item} className="font-mono text-sm px-3 py-1.5 wireframe-border text-[var(--foreground)] hover:text-[var(--accent)] hover:border-[var(--accent)] transition-colors cursor-default bg-black">
                                        {item}
                                    </span>
                                ))}
                            </div>
                        </div>
                    ))}
                </div>
            </div>
            <div className="w-full md:w-1/2">
                <div className="px-6 sm:px-12 py-8 wireframe-border-b bg-[#050505]">
                    <h2 className="text-xl font-mono font-bold uppercase text-[var(--foreground)]">
                        <span className="text-[var(--accent)] mr-2">{">"}</span>
                        Certifications_&_Education
                    </h2>
                </div>
                <div className="px-6 sm:px-12 py-8">
                    <div className="mb-8">
                        <h3 className="font-mono text-sm text-[var(--accent)] uppercase mb-2">Gunadarma University</h3>
                        <p className="font-sans text-sm text-gray-400 mb-1">Bachelor Degree, Computer Systems (GPA: 3.91)</p>
                        <p className="font-mono text-xs text-gray-500">Sep 2021 - Sep 2025</p>
                    </div>
                    <div>
                        <h3 className="font-mono text-xs text-gray-500 mb-4 uppercase">Verified Credentials</h3>
                        <ul className="space-y-3">
                            {certs.map((cert, idx) => (
                                <li key={idx} className="font-sans text-sm text-[var(--foreground)] flex items-start">
                                    <span className="text-[var(--accent)] mr-3 font-mono">[*]</span>
                                    {cert}
                                </li>
                            ))}
                        </ul>
                    </div>
                </div>
            </div>
        </section>
    );
}
