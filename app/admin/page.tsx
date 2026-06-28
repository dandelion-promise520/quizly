"use client";

import questionsData from "@/lib/questions.json";
import type { Question } from "@/lib/types";
import { useState, useRef, useCallback } from "react";
import AdminSidebar from "@/components/AdminSidebar";
import AdminQuestionEditor from "@/components/AdminQuestionEditor";

export default function AdminPage() {
  const [questions, setQuestions] = useState<Question[]>(questionsData as Question[]);
  const [search, setSearch] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [selectedIndex, setSelectedIndex] = useState<number | null>(0);
  const [isNew, setIsNew] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleSave = useCallback((q: Question) => {
    setQuestions((prev) => {
      const next = [...prev];
      if (selectedIndex !== null && !isNew) {
        next[selectedIndex] = q;
      } else {
        next.push(q);
        setSelectedIndex(next.length - 1);
      }
      return next;
    });
    setIsNew(false);
  }, [selectedIndex, isNew]);

  const handleDelete = useCallback((idx: number) => {
    setQuestions((prev) => {
      const next = prev.filter((_, i) => i !== idx);
      if (selectedIndex === idx) {
        setSelectedIndex(next.length > 0 ? 0 : null);
      } else if (selectedIndex !== null && selectedIndex > idx) {
        setSelectedIndex(selectedIndex - 1);
      }
      return next;
    });
    setIsNew(false);
  }, [selectedIndex]);

  const handleNew = () => {
    const emptyQ: Question = {
      type: "单选题",
      text: "",
      options: [
        { label: "A", text: "选项 A" },
        { label: "B", text: "选项 B" },
        { label: "C", text: "选项 C" },
        { label: "D", text: "选项 D" },
      ],
      answer: "A",
    };
    setQuestions((prev) => [...prev, emptyQ]);
    setSelectedIndex(questions.length);
    setIsNew(true);
  };

  const handleExport = () => {
    const json = JSON.stringify(questions, null, 2);
    const blob = new Blob([json], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "questions.json";
    a.click();
    URL.revokeObjectURL(url);
  };

  const handleImport = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      try {
        const data = JSON.parse(reader.result as string);
        if (Array.isArray(data)) {
          setQuestions(data);
          setSelectedIndex(0);
          setIsNew(false);
        }
      } catch {
        alert("JSON 文件格式有误，请检查后重试。");
      }
    };
    reader.readAsText(file);
    // Reset input so same file can be re-imported
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  const displayQuestion = selectedIndex !== null ? questions[selectedIndex] : null;

  return (
    <div className="flex h-screen bg-slate-50">
      <AdminSidebar
        questions={questions}
        search={search}
        onSearchChange={setSearch}
        typeFilter={typeFilter}
        onTypeFilterChange={setTypeFilter}
        selectedId={selectedIndex}
        onSelect={(id) => { setSelectedIndex(id); setIsNew(false); }}
        onDelete={handleDelete}
      />

      <div className="flex-1 flex flex-col min-w-0">
        {/* Top bar */}
        <div className="flex items-center gap-3 px-6 py-4 bg-white border-b border-slate-200">
          <button
            onClick={handleNew}
            className="px-5 py-2 rounded-full text-sm font-semibold text-white bg-teal-600 hover:bg-teal-700 transition"
          >
            + 新增题目
          </button>

          <button
            onClick={handleExport}
            className="px-5 py-2 rounded-full text-sm font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 transition"
          >
            导出 JSON
          </button>

          <label className="px-5 py-2 rounded-full text-sm font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 transition cursor-pointer">
            导入 JSON
            <input
              ref={fileInputRef}
              type="file"
              accept=".json"
              className="hidden"
              onChange={handleImport}
            />
          </label>

          <div className="flex-1" />

          <a
            href="/"
            className="text-sm text-teal-600 hover:text-teal-700 font-semibold"
          >
            ← 返回答题页面
          </a>
        </div>

        {/* Editor */}
        {displayQuestion ? (
          <AdminQuestionEditor
            key={isNew ? "new" : String(selectedIndex)}
            question={displayQuestion}
            index={selectedIndex!}
            onSave={handleSave}
            isNew={isNew}
          />
        ) : (
          <div className="flex-1 flex items-center justify-center text-slate-400 text-sm">
            请选择或新增一道题目
          </div>
        )}
      </div>
    </div>
  );
}
