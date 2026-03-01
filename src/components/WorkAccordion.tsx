"use client";

import React, { useState } from "react";
import { projects } from "@/data/projects";

export function WorkAccordion() {
    const [expandedId, setExpandedId] = useState<string | null>(null);

    const toggleAccordion = (id: string) => {
        setExpandedId(expandedId === id ? null : id);
    };

    return (
        <section className="w-full wireframe-border-b" id="work">
            <div className="px-6 sm:px-12 py-8 wireframe-border-b">
                <h2 className="text-2xl font-mono font-bold uppercase text-[var(--foreground)]">
                    <span className="text-[var(--accent)] mr-2">{"//"}</span>
                    Project_Manifest
                </h2>
            </div>
            <div className="flex flex-col">
                {projects.map((project, index) => {
                    const isExpanded = expandedId === project.id;
                    return (
                        <div
                            key={project.id}
                            className={`group wireframe-border-b last:border-b-0 transition-colors duration-300 ${isExpanded ? 'bg-[#050505]' : 'hover:bg-[#0a0a0a]'}`}
                        >
                            <button
                                onClick={() => toggleAccordion(project.id)}
                                className="w-full text-left px-6 sm:px-12 py-6 flex justify-between items-center focus:outline-none"
                            >
                                <div className="flex items-center gap-4 sm:gap-8">
                                    <span className="font-mono text-sm text-gray-500">
                                        {String(index + 1).padStart(2, '0')}
                                    </span>
                                    <h3 className={`text-xl sm:text-3xl font-bold uppercase transition-colors duration-300 ${isExpanded ? 'text-[var(--accent)]' : 'text-[var(--foreground)] group-hover:text-[var(--accent)]'}`}>
                                        {project.title}
                                    </h3>
                                </div>
                                <div className="font-mono text-sm text-gray-500 flex items-center gap-4">
                                    <span className="hidden sm:inline-block">{project.year}</span>
                                    <span className={`transition-transform duration-300 font-bold ${isExpanded ? 'text-[var(--accent)] rotate-45' : 'group-hover:text-[var(--accent)]'}`}>
                                        [+]
                                    </span>
                                </div>
                            </button>

                            <div
                                className={`overflow-hidden transition-all duration-500 ease-in-out ${isExpanded ? 'max-h-[1200px] opacity-100' : 'max-h-0 opacity-0'}`}
                            >
                                <div className="px-6 sm:px-12 pb-8 pt-2 flex flex-col md:flex-row gap-8">
                                    <div className="flex-1 font-sans text-gray-400 space-y-6">
                                        <p className="max-w-xl text-sm sm:text-base leading-relaxed">
                                            {project.description}
                                        </p>
                                        <div>
                                            <h4 className="font-mono text-xs text-[var(--accent)] mb-3">TECH_STACK</h4>
                                            <div className="flex flex-wrap gap-2">
                                                {project.techStack.map(tech => (
                                                    <span key={tech} className="font-mono text-sm px-3 py-1.5 wireframe-border text-gray-300 bg-black">
                                                        {tech}
                                                    </span>
                                                ))}
                                            </div>
                                        </div>
                                        <div>
                                            <a
                                                href={project.link}
                                                target="_blank"
                                                rel="noreferrer"
                                                className="inline-flex items-center gap-2 font-mono text-sm text-[var(--foreground)] hover:text-[var(--accent)] transition-colors wireframe-border-b border-transparent hover:border-[var(--accent)] pb-1"
                                            >
                                                [ VIEW_SOURCE ]
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    );
                })}
            </div>
        </section>
    );
}
