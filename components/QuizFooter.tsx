"use client";

interface QuizFooterProps {
  allDone: boolean;
  onSubmitAll: () => void;
  onReset: () => void;
}

export default function QuizFooter({ allDone, onSubmitAll, onReset }: QuizFooterProps) {
  return (
    <div className="flex justify-center gap-3 mt-10">
      {!allDone && (
        <button
          className="px-9 py-3 rounded-full text-base font-semibold font-sans text-white border-none bg-teal-600 shadow-[0_2px_8px_rgba(13,148,136,0.25)] cursor-pointer transition-all duration-200 hover:shadow-[0_4px_12px_rgba(13,148,136,0.35)] hover:-translate-y-0.5 active:translate-y-0"
          onClick={onSubmitAll}
        >
          提交全部答案
        </button>
      )}
      {allDone && (
        <button
          className="px-9 py-3 rounded-full text-base font-semibold font-sans bg-white text-slate-600 border-[1.5px] border-slate-200 cursor-pointer transition-all duration-200 hover:border-teal-600 hover:text-teal-600"
          onClick={onReset}
        >
          重新作答
        </button>
      )}
    </div>
  );
}
