import Image from "next/image";
import React from "react";

interface CrtImageProps {
    src: string;
    alt: string;
    className?: string;
    priority?: boolean;
}

export function CrtImage({ src, alt, className = "", priority = false }: CrtImageProps) {
    return (
        <div className={`relative overflow-hidden ${className}`}>
            <Image
                src={src}
                alt={alt}
                fill
                sizes="(max-width: 768px) 100vw, 50vw"
                className="object-cover transition-transform duration-700 hover:scale-105"
                priority={priority}
            />
            {/* Scanline overlay */}
            <div className="absolute inset-0 pointer-events-none mix-blend-overlay opacity-20 bg-[linear-gradient(transparent_50%,rgba(0,0,0,0.8)_50%)] bg-[length:100%_4px]"></div>
        </div>
    );
}
