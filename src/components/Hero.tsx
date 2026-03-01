"use client";

import React, { useState, useEffect } from "react";

export function Hero() {
    const fullText = "Specializing in Scalable Backend Architecture and Mobile Development.";
    const [text, setText] = useState("");
    const [index, setIndex] = useState(0);

    useEffect(() => {
        if (index < fullText.length) {
            const timeout = setTimeout(() => {
                setText((prev) => prev + fullText[index]);
                setIndex(index + 1);
            }, 40); // typing speed
            return () => clearTimeout(timeout);
        }
    }, [index, fullText]);

    return (
        <section className="min-h-[70vh] flex flex-col justify-center px-6 sm:px-12 wireframe-border-b pt-20 pb-16">
            <div className="max-w-4xl">
                <h1 className="text-5xl sm:text-7xl md:text-8xl lg:text-9xl font-mono font-bold tracking-tighter mb-6 text-[var(--foreground)] uppercase leading-none">
                    REDI<br />AHMAD
                </h1>
                <div className="flex items-center text-sm sm:text-base font-mono text-gray-400">
                    <span className="text-[var(--accent)] mr-2">{">"}</span>
                    <span>{text}</span>
                    <span className="w-2 h-5 bg-[var(--accent)] ml-1 animate-pulse"></span>
                </div>
            </div>
        </section>
    );
}
