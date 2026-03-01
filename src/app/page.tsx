import { TerminalNav } from "@/components/TerminalNav";
import { Hero } from "@/components/Hero";
import { WorkAccordion } from "@/components/WorkAccordion";
import { Experience } from "@/components/Experience";
import { Skills } from "@/components/Skills";

export default function Home() {
  return (
    <main className="min-h-screen bg-transparent pt-8 sm:pt-10 pb-20 sm:pb-0">
      <TerminalNav />
      <div className="max-w-6xl mx-auto wireframe-border-l wireframe-border-r min-h-screen bg-black/60 shadow-2xl">
        <Hero />
        <Experience />
        <WorkAccordion />
        <Skills />

        <footer className="px-6 sm:px-12 py-12 flex flex-col sm:flex-row gap-6 justify-between items-center text-xs font-mono text-gray-500">
          <span>&copy; {new Date().getFullYear()} REDI AHMAD // V1.0.0</span>
          <div className="flex gap-6">
            <a href="#" className="hover:text-[var(--accent)] transition-colors uppercase tracking-widest">[ GITHUB ]</a>
            <a href="#" className="hover:text-[var(--accent)] transition-colors uppercase tracking-widest">[ LINKEDIN ]</a>
            <a href="#" className="hover:text-[var(--accent)] transition-colors uppercase tracking-widest">[ EMAIL ]</a>
          </div>
        </footer>
      </div>
    </main>
  );
}
