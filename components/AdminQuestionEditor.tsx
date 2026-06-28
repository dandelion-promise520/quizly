"use client";

import type { Question, Option, ChoiceQuestion, FillQuestion } from "@/lib/types";
import { useState, useEffect } from "react";

interface AdminQuestionEditorProps {
  question: Question;
  index: number;
  onSave: (q: Question) => void;
  isNew: boolean;
}

// A mutable draft shape — looser than Question for editing convenience
type Draft = {
  type: "单选题" | "判断题" | "填空题";
  text: string;
  options?: Option[];
  answer: string | string[];
  blanks?: string[];
};

function emptyDraft(type: Draft["type"]): Draft {
  if (type === "填空题") return { type, text: "", answer: ["答案 1"], blanks: ["答案 1"] };
  const labels = type === "判断题" ? ["A", "B"] : ["A", "B", "C", "D"];
  const texts = type === "判断题" ? ["正确", "错误"] : ["选项 A", "选项 B", "选项 C", "选项 D"];
  return {
    type,
    text: "",
    options: labels.map((l, i) => ({ label: l, text: texts[i] })),
    answer: labels[0],
  };
}

export default function AdminQuestionEditor({
  question,
  index,
  onSave,
  isNew,
}: AdminQuestionEditorProps) {
  const [draft, setDraft] = useState<Draft>(() => {
    const d = emptyDraft(question.type);
    d.text = question.text;
    if ("options" in question) d.options = question.options;
    d.answer = question.answer;
    if ("blanks" in question) d.blanks = (question as FillQuestion).blanks;
    return d;
  });

  useEffect(() => {
    const d = emptyDraft(question.type);
    d.text = question.text;
    if ("options" in question) d.options = question.options;
    d.answer = question.answer;
    if ("blanks" in question) d.blanks = (question as FillQuestion).blanks;
    setDraft(d);
  }, [question]);

  const push = () => {
    const q: Question = {
      type: draft.type,
      text: draft.text,
      answer: draft.answer,
      ...(draft.options ? { options: draft.options } : {}),
      ...(draft.blanks ? { blanks: draft.blanks } : {}),
    } as Question;
    onSave(q);
  };

  // ── Common handlers ──────────────────────────────
  const setText = (v: string) => setDraft((d) => ({ ...d, text: v }));

  // Choice / Judgment
  const updateOption = (i: number, field: "label" | "text", v: string) => {
    setDraft((d) => {
      if (!d.options) return d;
      const opts = [...d.options];
      opts[i] = { ...opts[i], [field]: v };
      return { ...d, options: opts };
    });
  };

  const setAnswerLabel = (v: string) => setDraft((d) => ({ ...d, answer: v }));

  const addOption = () => {
    setDraft((d) => {
      const opts = [...(d.options ?? [])];
      const nextLabel = String.fromCharCode(65 + opts.length);
      opts.push({ label: nextLabel, text: `选项 ${nextLabel}` });
      return { ...d, options: opts };
    });
  };

  const removeOption = (i: number) => {
    setDraft((d) => {
      if (!d.options) return d;
      const opts = d.options.filter((_, j) => j !== i);
      const ans = d.answer as string;
      const removed = d.options[i]?.label ?? "";
      const newAnswer = ans === removed ? (opts[0]?.label ?? "") : ans;
      return { ...d, options: opts, answer: newAnswer };
    });
  };

  // Fill
  const addBlank = () => {
    setDraft((d) => {
      const arr = [...(d.blanks ?? []), `答案 ${(d.blanks?.length ?? 0) + 1}`];
      return { ...d, blanks: arr, answer: arr };
    });
  };

  const updateBlank = (i: number, v: string) => {
    setDraft((d) => {
      const blanks = [...(d.blanks ?? [])];
      const answer = [...(d.answer as string[])];
      blanks[i] = v;
      answer[i] = v;
      return { ...d, blanks, answer };
    });
  };

  const removeBlank = (i: number) => {
    setDraft((d) => {
      const blanks = (d.blanks ?? []).filter((_, j) => j !== i);
      const answer = (d.answer as string[]).filter((_, j) => j !== i);
      return { ...d, blanks, answer };
    });
  };

  // ── Render ───────────────────────────────────────
  return (
    <div className="flex-1 overflow-y-auto p-6">
      <div className="max-w-2xl mx-auto space-y-5">
        {/* Header */}
        <div className="flex items-center gap-3">
          {!isNew && (
            <span className="text-sm font-bold text-teal-600 bg-teal-50 px-3 py-1 rounded-full">
              第 {index + 1} 题
            </span>
          )}
          <span className="text-sm font-semibold text-slate-500 bg-slate-100 px-3 py-1 rounded-full">
            {draft.type}
          </span>
        </div>

        {/* Type selector */}
        <div className="flex gap-2">
          {(["单选题", "判断题", "填空题"] as const).map((t) => (
            <button
              key={t}
              onClick={() => setDraft((d) => ({ ...d, type: t }))}
              className={[
                "px-4 py-1.5 rounded-full text-sm font-semibold transition border",
                draft.type === t
                  ? "bg-teal-600 text-white border-teal-600"
                  : "bg-white text-slate-600 border-slate-200 hover:border-teal-400",
              ].join(" ")}
            >
              {t}
            </button>
          ))}
        </div>

        {/* Question text */}
        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-1.5">题干</label>
          <textarea
            className="w-full px-4 py-3 border border-slate-200 rounded-lg outline-none focus:border-teal-500 focus:ring-1 focus:ring-teal-500 resize-y min-h-[80px] text-sm"
            value={draft.text}
            onChange={(e) => setText(e.target.value)}
            placeholder="输入题干内容…"
          />
        </div>

        {/* Choice / Judgment editor */}
        {draft.type !== "填空题" && (
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <label className="text-sm font-semibold text-slate-700">选项</label>
              <button
                onClick={addOption}
                className="text-xs text-teal-600 hover:text-teal-700 font-semibold"
              >
                + 添加选项
              </button>
            </div>

            {(draft.options ?? []).map((opt: Option, i: number) => (
              <div key={i} className="flex items-center gap-2">
                <input
                  value={opt.label}
                  onChange={(e) => updateOption(i, "label", e.target.value)}
                  className="w-10 px-2 py-2 text-sm border border-slate-200 rounded text-center font-bold outline-none focus:border-teal-500"
                />
                <input
                  value={opt.text}
                  onChange={(e) => updateOption(i, "text", e.target.value)}
                  className="flex-1 px-3 py-2 text-sm border border-slate-200 rounded outline-none focus:border-teal-500"
                  placeholder="选项内容"
                />
                <button
                  onClick={() => removeOption(i)}
                  className="w-8 h-8 rounded flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 transition"
                  title="删除选项"
                >
                  ×
                </button>
              </div>
            ))}

            {typeof draft.answer === "string" && (
              <div>
              <label className="block text-sm font-semibold text-slate-700 mb-1.5">正确答案</label>
              <select
                className="w-full px-3 py-2 text-sm border border-slate-200 rounded-lg outline-none focus:border-teal-500 bg-white"
                value={draft.answer}
                onChange={(e) => setAnswerLabel(e.target.value)}
              >
                {(draft.options ?? []).map((opt: Option) => (
                  <option key={opt.label} value={opt.label}>
                    {opt.label} — {opt.text}
                  </option>
                ))}
              </select>
              </div>
            )}
          </div>
        )}

        {/* Fill editor */}
        {draft.type === "填空题" && (
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <label className="text-sm font-semibold text-slate-700">
                填空答案（{(draft.blanks ?? []).length} 空）
              </label>
              <button
                onClick={addBlank}
                className="text-xs text-teal-600 hover:text-teal-700 font-semibold"
              >
                + 添加空位
              </button>
            </div>

            {(draft.blanks ?? []).map((_: string, i: number) => (
              <div key={i} className="flex items-center gap-2">
                <span className="text-xs font-bold text-slate-500 w-6 text-center">{i + 1}.</span>
                <input
                  value={(draft.answer as string[])[i]}
                  onChange={(e) => updateBlank(i, e.target.value)}
                  className="flex-1 px-3 py-2 text-sm border border-slate-200 rounded outline-none focus:border-teal-500"
                  placeholder={`第 ${i + 1} 空答案`}
                />
                <button
                  onClick={() => removeBlank(i)}
                  className="w-8 h-8 rounded flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 transition"
                  title="删除空位"
                >
                  ×
                </button>
              </div>
            ))}
          </div>
        )}

        {/* Actions */}
        <div className="flex gap-3 pt-2">
          <button
            onClick={push}
            className="px-8 py-2.5 rounded-full text-sm font-semibold text-white bg-teal-600 hover:bg-teal-700 transition"
          >
            {isNew ? "创建题目" : "保存修改"}
          </button>
        </div>
      </div>
    </div>
  );
}
