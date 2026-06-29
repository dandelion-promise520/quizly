"use client";

import type { Question } from "@/lib/types";
import Header from "./Header";
import Scoreboard from "./Scoreboard";
import ProgressBar from "./ProgressBar";
import QuestionCard from "./QuestionCard";
import ResultBanner from "./ResultBanner";
import QuizFooter from "./QuizFooter";
import { useQuizState } from "@/hooks/useQuizState";

interface QuizPageProps {
  initialQuestions: Question[];
}

export default function QuizPage({ initialQuestions }: QuizPageProps) {
  const {
    questions,
    score,
    answered,
    total,
    answers,
    doneFlags,
    pickAnswer,
    submitMulti,
    submitFill,
    submitAll,
    resetAll,
    hydrated,
  } = useQuizState(initialQuestions);

  const allDone = answered >= total;

  if (!hydrated) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center">
        <div className="text-center">
          <div className="text-xl font-semibold text-slate-400">加载中...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50 font-sans antialiased text-slate-900">
      <Header total={total} />
      <Scoreboard score={score} answered={answered} total={total} />
      <ProgressBar answered={answered} total={total} />

      <main className="max-w-[720px] mx-auto px-5 py-8 pb-20">
        {allDone && <ResultBanner score={score} total={total * 5} />}

        <div className="text-sm font-semibold text-slate-900 mt-11 mb-5 pb-2.5 border-b-2 border-teal-600 inline-block">
          选择题
        </div>

        {questions.map((q: Question, i: number) => {
          const done = !!doneFlags[i];
          const saved = answers[String(i)];
          let selectedIdx: number | undefined;
          let selectedIndices: number[] | undefined;
          let userAnswers: string[] | undefined;

          if (saved !== undefined) {
            if (typeof saved === "number") {
              selectedIdx = saved;
            } else if (Array.isArray(saved)) {
              if (q.type === "多选题") {
                selectedIndices = saved as number[];
              } else {
                userAnswers = saved as string[];
              }
            }
          }

          return (
            <QuestionCard
              key={i}
              question={q}
              index={i}
              done={done}
              selectedIdx={selectedIdx}
              selectedIndices={selectedIndices}
              userAnswers={userAnswers}
              onPick={pickAnswer}
              onSubmitMulti={submitMulti}
              onSubmitFill={submitFill}
            />
          );
        })}

        <QuizFooter
          allDone={allDone}
          onSubmitAll={submitAll}
          onReset={resetAll}
        />
      </main>
    </div>
  );
}
