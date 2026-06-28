"use client";

import type { Question, FillQuestion } from "@/lib/types";
import { useState } from "react";

interface ChoiceCardProps {
  question: Exclude<Question, FillQuestion>;
  index: number;
  done: boolean;
  selectedIdx?: number;
  onPick: (qi: number, oi: number) => void;
}

export default function ChoiceCard({
  question,
  index,
  done,
  selectedIdx,
  onPick,
}: ChoiceCardProps) {
  const opts = (question as any).shuffledOptions || question.options;
  const correctIdx = (question as any).correctShuffledIdx;

  return (
    <div className="pl-0">
      {opts.map((opt: { label: string; text: string }, oi: number) => {
        let optCls = "flex items-center gap-3 p-3 my-[6px] border border-slate-200 rounded-xl cursor-pointer select-none bg-white transition-all duration-200 ease-[cubic-bezier(0.16,1,0.3,1)]";
        let circleCls =
          "w-5 h-5 border-2 border-slate-200 rounded-full flex-shrink-0 flex items-center justify-center transition-all duration-200 text-[11px] font-bold text-transparent";

        if (done) {
          optCls += " cursor-default pointer-events-none";
          if (oi === correctIdx) {
            optCls += " border-green-300 bg-green-50";
            circleCls += " border-green-600 bg-green-600 text-white";
          } else if (oi === selectedIdx && oi !== correctIdx) {
            optCls += " border-red-300 bg-red-50";
            circleCls += " border-red-600 bg-red-600 text-white";
          }
        } else {
          if (oi === selectedIdx) {
            optCls += " border-teal-600";
            circleCls += " border-teal-600 bg-teal-600 text-white";
          }
        }

        return (
          <div
            key={oi}
            className={optCls}
            onClick={() => !done && onPick(index, oi)}
          >
            <div className={circleCls}></div>
            <span className="text-[14.5px] text-slate-900 leading-relaxed">
              <span className="opt-key">{opt.label}.</span>
              {opt.text}
            </span>
          </div>
        );
      })}
    </div>
  );
}
