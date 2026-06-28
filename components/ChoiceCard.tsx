"use client";

import type { Question, FillQuestion } from "@/lib/types";
import { RadioGroup, RadioGroupItem } from "./motion/radio";

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
    <RadioGroup
      value={selectedIdx !== undefined ? String(selectedIdx) : undefined}
      onValueChange={(val) => !done && onPick(index, Number(val))}
      className="pl-0 gap-1.5"
    >
      {opts.map((opt: { label: string; text: string }, oi: number) => {
        let optCls = "flex items-center gap-3 p-3 my-[2px] border border-slate-200 rounded-xl cursor-pointer select-none bg-white transition-all duration-200 hover:border-slate-300";

        if (done) {
          optCls += " cursor-default pointer-events-none";
          if (oi === correctIdx) {
            optCls += " border-green-300 bg-green-50 ring-1 ring-green-300";
          } else if (oi === selectedIdx && oi !== correctIdx) {
            optCls += " border-red-300 bg-red-50 ring-1 ring-red-300";
          }
        } else {
          if (oi === selectedIdx) {
            optCls += " border-teal-600 ring-1 ring-teal-600";
          }
        }

        return (
          <div
            key={oi}
            className={optCls}
            onClick={() => !done && onPick(index, oi)}
          >
            <RadioGroupItem
              value={String(oi)}
              disabled={done}
              className="pointer-events-none"
            />
            <span className="text-[14.5px] text-slate-900 leading-relaxed">
              <span className="opt-key font-bold mr-1">{opt.label}.</span>
              {opt.text}
            </span>
          </div>
        );
      })}
    </RadioGroup>
  );
}
