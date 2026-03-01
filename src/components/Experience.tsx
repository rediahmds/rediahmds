import React from "react";

export function Experience() {
    const experiences = [
        {
            role: "Backend Engineer (Capstone Project)",
            company: "Bangkit Academy led by Google, Goto, and Traveloka",
            date: "Feb 2024 - Jul 2024",
            description: "Collaborated within a cross-functional team to architect a scalable cloud application. Engineered a secure RESTful API using Hapi.js, TypeScript, and Google Cloud Storage. Managed a PostgreSQL DB via Prisma ORM on Cloud SQL and established CI/CD pipelines via GitHub Actions."
        },
        {
            role: "Python Developer Intern",
            company: "Robopark Indonesia",
            date: "Sep 2023 - Dec 2023",
            description: "Engineered a state persistence feature reducing robot activation time from 3 seconds to near-instant. Developed the GUI for a chess robot application using PyQt5."
        }
    ];

    return (
        <section className="w-full wireframe-border-b" id="experience">
            <div className="px-6 sm:px-12 py-8 wireframe-border-b">
                <h2 className="text-2xl font-mono font-bold uppercase text-[var(--foreground)]">
                    <span className="text-[var(--accent)] mr-2">{"//"}</span>
                    Experience_Log
                </h2>
            </div>
            <div className="flex flex-col">
                {experiences.map((exp, index) => (
                    <div key={index} className="px-6 sm:px-12 py-8 wireframe-border-b last:border-b-0 hover:bg-[#050505] transition-colors duration-300">
                        <div className="flex flex-col md:flex-row justify-between mb-4 gap-2">
                            <h3 className="text-xl font-bold font-mono text-[var(--accent)] uppercase">{exp.role}</h3>
                            <span className="font-mono text-sm text-gray-500">{exp.date}</span>
                        </div>
                        <h4 className="text-sm font-mono text-[var(--foreground)] mb-4 uppercase">{exp.company}</h4>
                        <p className="font-sans text-gray-400 text-sm sm:text-base leading-relaxed max-w-3xl">
                            {exp.description}
                        </p>
                    </div>
                ))}
            </div>
        </section>
    );
}
