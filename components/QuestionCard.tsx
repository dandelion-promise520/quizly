"use client";

import type { Question, FillQuestion, ChoiceQuestion } from "@/lib/types";
import ChoiceCard from "./ChoiceCard";
import FillCard from "./FillCard";
import FeedbackBanner from "./FeedbackBanner";
import { TiltCard } from "./motion/tilt-card";

interface QuestionCardProps {
  question: Question;
  index: number;
  done: boolean;
  selectedIdx?: number;
  userAnswers?: string[];
  onPick: (qi: number, oi: number) => void;
  onSubmitFill: (qi: number, answers: string[]) => void;
}

export default function QuestionCard({
  question,
  index,
  done,
  selectedIdx,
  userAnswers,
  onPick,
  onSubmitFill,
}: QuestionCardProps) {
  const isCorrect = question.type === "填空题"
    ? userAnswers?.every((a, i) => a === (question as any).answer[i])
    : selectedIdx === (question as any).correctShuffledIdx;

  const isWrong = question.type === "填空题"
    ? userAnswers?.some((a, i) => a !== (question as any).answer[i])
    : selectedIdx !== (question as any).correctShuffledIdx;

  let feedbackType: "correct" | "wrong" | "unanswered" = "wrong";
  let feedbackMsg = "";

  if (question.type === "填空题") {
    if (userAnswers) {
      const fillQ = question as any;
      let blankCorrect = 0;
      for (let b = 0; b < fillQ.answer.length; b++) {
        if (userAnswers[b] === fillQ.answer[b]) blankCorrect++;
      }
      if (blankCorrect === fillQ.answer.length) {
        feedbackType = "correct";
        feedbackMsg = "<strong>回答正确。</strong>";
      } else {
        feedbackType = "wrong";
        const parts: string[] = [];
        for (let b = 0; b < fillQ.answer.length; b++) {
          const status = userAnswers[b] === fillQ.answer[b] ? "✓" : "✗";
          parts.push(`${status} 第${b + 1}空：你填"${userAnswers[b] || ""}"，正确答案"${fillQ.answer[b]}"`);
        }
        feedbackMsg = "<strong>部分正确。</strong><br>" + parts.join("<br>");
      }
    }
  } else {
    if (selectedIdx !== undefined) {
      if (isCorrect) {
        feedbackType = "correct";
        feedbackMsg = `<strong>回答正确。</strong> 正确答案：${question.answer}`;
      } else {
        const opts = (question as any).shuffledOptions || question.options;
        const label = selectedIdx >= 0 ? opts[selectedIdx]?.label : "?";
        feedbackType = "wrong";
        feedbackMsg = `<strong>回答错误。</strong> 你选择了 ${label}，正确答案是 ${question.answer}`;
      }
    }
  }

  const cardBorder = done
    ? question.type === "填空题"
      ? userAnswers && isCorrect
        ? "border-green-300 ring-1 ring-green-300"
        : "border-red-300 ring-1 ring-red-300"
      : selectedIdx !== undefined && isCorrect
        ? "border-green-300 ring-1 ring-green-300"
        : "border-red-300 ring-1 ring-red-300"
    : "";

  return (
    <TiltCard
      max={4}
      glare={true}
      className={`bg-white border border-slate-200 rounded-xl p-6 mb-4 shadow-sm transition-all duration-300 ${cardBorder}`}
    >
      {/* Question header */}
      <div className="flex items-start gap-2.5 mb-4.5">
        <span className="text-sm font-semibold text-white bg-teal-600 px-3 py-0.5 rounded-full flex-shrink-0 mt-0.5">
          {index + 1}
        </span>
        <span className="text-[11px] font-semibold text-teal-600 bg-teal-50 px-2.5 py-0.75 rounded-full flex-shrink-0 mt-0.5 border border-teal-200">
          {question.type}
        </span>
        <div className="flex-1 text-[15.5px] font-medium text-slate-900 leading-relaxed">
          {question.text}
        </div>
      </div>

      {/* Body */}
      {question.type === "填空题" ? (
        <FillCard
          question={question as FillQuestion}
          index={index}
          done={done}
          userAnswers={userAnswers}
          onSubmit={onSubmitFill}
        />
      ) : (
        <ChoiceCard
          question={question as ChoiceQuestion}
          index={index}
          done={done}
          selectedIdx={selectedIdx}
          onPick={onPick}
        />
      )}

      <FeedbackBanner show={done} type={feedbackType} message={feedbackMsg} />
    </TiltCard>
  );
}
