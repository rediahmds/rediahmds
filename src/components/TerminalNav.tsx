"use client";

import React, { useState, useEffect } from "react";

export function TerminalNav() {
    const [time, setTime] = useState("");

    useEffect(() => {
        const updateTime = () => {
            const date = new Date();
            const timeStr = date.toLocaleTimeString("en-US", { hour12: false, hour: '2-digit', minute: '2-digit', second: '2-digit' });
            setTime(timeStr + " UTC");
        };
        updateTime();
        const interval = setInterval(updateTime, 1000);
        return () => clearInterval(interval);
    }, []);

    return (
        <nav className="w-full wireframe-border-b bg-black/80 backdrop-blur-md text-xs font-mono py-2 px-4 flex justify-between items-center text-[var(--foreground)] fixed top-0 z-50">
            <div className="flex gap-4 items-center">
                <span className="text-[var(--accent)] font-bold">~/system/user</span>
                <span className="hidden sm:inline-block border-l border-[var(--wireframe)] pl-4 text-gray-400">STATUS: ONLINE</span>
            </div>
            <div className="flex gap-4 items-center">
                <span className="hidden sm:inline-block text-gray-400">SYS_TIME: {time || "00:00:00 UTC"}</span>
                <div className="w-2 h-2 bg-[var(--accent)] animate-pulse rounded-none"></div>
            </div>
        </nav>
    );
}
