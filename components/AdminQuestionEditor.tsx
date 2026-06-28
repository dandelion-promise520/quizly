"use client";

import type { Question, Option, ChoiceQuestion, FillQuestion } from "@/lib/types";
import { useState, useEffect } from "react";
import { Button, StatefulButton } from "./motion/button";
import { Tabs, TabsList, TabsTrigger } from "./motion/tabs";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "./motion/select";

interface AdminQuestionEditorProps {
  question: Question;
  index: number;
  onSave: (q: Question) => void;
  isNew: boolean;
}

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
  const [saveState, setSaveState] = useState<"idle" | "loading" | "success" | "error">("idle");

  useEffect(() => {
    const d = emptyDraft(question.type);
    d.text = question.text;
    if ("options" in question) d.options = question.options;
    d.answer = question.answer;
    if ("blanks" in question) d.blanks = (question as FillQuestion).blanks;
    setDraft(d);
  }, [question]);

  const push = () => {
    console.log("push function called inside AdminQuestionEditor!");
    setSaveState("loading");
    setTimeout(() => {
      try {
        const q: Question = {
          type: draft.type,
          text: draft.text,
          answer: draft.answer,
          ...(draft.options ? { options: draft.options } : {}),
          ...(draft.blanks ? { blanks: draft.blanks } : {}),
        } as Question;
        console.log("pushing question data to onSave:", q);
        onSave(q);
        setSaveState("success");
        setTimeout(() => setSaveState("idle"), 1500);
      } catch (err) {
        console.error("error inside push function:", err);
        setSaveState("error");
        setTimeout(() => setSaveState("idle"), 1500);
      }
    }, 600);
  };

  const setText = (v: string) => setDraft((d) => ({ ...d, text: v }));

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
        <Tabs
          value={draft.type}
          onValueChange={(val: any) => setDraft((d) => ({ ...d, type: val }))}
          variant="segment"
          className="w-[280px]"
        >
          <TabsList className="w-full">
            <TabsTrigger value="单选题" className="flex-1">单选</TabsTrigger>
            <TabsTrigger value="判断题" className="flex-1">判断</TabsTrigger>
            <TabsTrigger value="填空题" className="flex-1">填空</TabsTrigger>
          </TabsList>
        </Tabs>

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
              <Button
                variant="ghost"
                size="sm"
                onClick={addOption}
                className="text-xs text-teal-600 hover:text-teal-700 font-semibold px-2 h-7"
              >
                + 添加选项
              </Button>
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
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => removeOption(i)}
                  className="w-8 h-8 rounded text-slate-400 hover:text-red-500 hover:bg-red-50 transition"
                  title="删除选项"
                >
                  ×
                </Button>
              </div>
            ))}

            {typeof draft.answer === "string" && (
              <div className="space-y-2">
                <label className="block text-sm font-semibold text-slate-700">正确答案</label>
                <Select
                  value={draft.answer}
                  onValueChange={setAnswerLabel}
                >
                  <SelectTrigger className="w-full">
                    <SelectValue placeholder="选择正确答案" />
                  </SelectTrigger>
                  <SelectContent>
                    {(draft.options ?? []).map((opt: Option) => (
                      <SelectItem
                        key={opt.label}
                        value={opt.label}
                      >
                        {opt.label} — {opt.text}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
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
              <Button
                variant="ghost"
                size="sm"
                onClick={addBlank}
                className="text-xs text-teal-600 hover:text-teal-700 font-semibold px-2 h-7"
              >
                + 添加空位
              </Button>
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
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => removeBlank(i)}
                  className="w-8 h-8 rounded text-slate-400 hover:text-red-500 hover:bg-red-50 transition"
                  title="删除空位"
                >
                  ×
                </Button>
              </div>
            ))}
          </div>
        )}

        {/* Actions */}
        <div className="flex gap-3 pt-2">
          <StatefulButton
            variant="primary"
            size="md"
            state={saveState}
            onClick={push}
            loadingText={isNew ? "创建中" : "保存中"}
            successText={isNew ? "创建成功" : "保存成功"}
            errorText="保存失败"
            className="px-8 py-2.5"
          >
            {isNew ? "创建题目" : "保存修改"}
          </StatefulButton>
        </div>
      </div>
    </div>
  );
}
