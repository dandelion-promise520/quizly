"use client";

import type { FillQuestion } from "@/lib/types";
import { useState } from "react";

interface FillCardProps {
  question: FillQuestion;
  index: number;
  done: boolean;
  userAnswers?: string[];
  onSubmit: (qi: number, answers: string[]) => void;
}

export default function FillCard({
  question,
  index,
  done,
  userAnswers,
  onSubmit,
}: FillCardProps) {
  const blankCount = question.answer.length;
  const [inputs, setInputs] = useState<string[]>(
    userAnswers ?? question.answer.map(() => "")
  );

  const handleSubmit = () => {
    onSubmit(index, inputs);
  };

  return (
    <div className="flex flex-col gap-2.5 mt-1">
      {Array.from({ length: blankCount }).map((_, b) => (
        <div key={b} className="flex items-center gap-2">
          <span className="text-sm font-semibold text-slate-600 whitespace-nowrap">
            {b + 1}.
          </span>
          <input
            type="text"
            className="flex-1 px-3.5 py-2 border border-slate-200 rounded-lg text-[14.5px] font-sans outline-none transition-colors duration-200 bg-white disabled:cursor-default"
            placeholder="请输入答案"
            disabled={done}
            value={inputs[b] || ""}
            onChange={(e) =>
              setInputs((prev) => {
                const next = [...prev];
                next[b] = e.target.value;
                return next;
              })
            }
            style={
              done
                ? {
                    borderColor:
                      inputs[b] === question.answer[b]
                        ? "var(--color-success-border)"
                        : "var(--color-error-border)",
                    backgroundColor:
                      inputs[b] === question.answer[b]
                        ? "var(--color-success-light)"
                        : "var(--color-error-light)",
                  }
                : undefined
            }
          />
        </div>
      ))}
      {!done && (
        <button
          className="self-end px-7 py-2 rounded-full text-sm font-semibold font-sans text-white border-none bg-teal-600 cursor-pointer transition-colors duration-200 hover:bg-teal-700"
          onClick={handleSubmit}
        >
          提交答案
        </button>
      )}
    </div>
  );
}
