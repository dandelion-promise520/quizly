"use client";

import type { Question } from "@/lib/types";
import { useState, useRef, useCallback } from "react";
import Link from "next/link";
import AdminSidebar from "@/components/AdminSidebar";
import AdminQuestionEditor from "@/components/AdminQuestionEditor";
import { Button } from "@/components/motion/button";
import { saveQuestionsToDisk } from "@/app/actions";

interface AdminDashboardProps {
  initialQuestions: Question[];
}

export default function AdminDashboard({ initialQuestions }: AdminDashboardProps) {
  const [questions, setQuestions] = useState<Question[]>(initialQuestions);
  const [search, setSearch] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [selectedIndex, setSelectedIndex] = useState<number | null>(0);
  const [isNew, setIsNew] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const saveToDisk = async (newQuestions: Question[]) => {
    try {
      const data = await saveQuestionsToDisk(newQuestions);
      if (data.success && data.questions) {
        setQuestions(data.questions);
      } else if (!data.success) {
        console.error("Failed to save to database:", data.error);
      }
    } catch (err) {
      console.error("Network error when saving to database:", err);
    }
  };

  const handleSave = useCallback((q: Question) => {
    console.log("handleSave called with question:", q);
    setQuestions((prev) => {
      const next = [...prev];
      if (selectedIndex !== null && !isNew) {
        console.log(`updating existing question at index ${selectedIndex}`);
        next[selectedIndex] = q;
      } else {
        console.log("adding new question");
        next.push(q);
        setSelectedIndex(next.length - 1);
      }
      saveToDisk(next);
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
      saveToDisk(next);
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
          saveToDisk(data);
          setSelectedIndex(0);
          setIsNew(false);
        }
      } catch {
        alert("JSON 文件格式有误，请检查后重试。");
      }
    };
    reader.readAsText(file);
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
          <Button
            variant="primary"
            size="sm"
            onClick={handleNew}
            className="px-5 py-2"
          >
            + 新增题目
          </Button>

          <Button
            variant="secondary"
            size="sm"
            onClick={handleExport}
            className="px-5 py-2"
          >
            导出 JSON
          </Button>

          <Button
            variant="secondary"
            size="sm"
            onClick={() => fileInputRef.current?.click()}
            className="px-5 py-2"
          >
            导入 JSON
          </Button>
          <input
            ref={fileInputRef}
            type="file"
            accept=".json"
            className="hidden"
            onChange={handleImport}
          />

          <div className="flex-1" />

          <Link
            href="/"
            className="text-sm text-teal-600 hover:text-teal-700 font-semibold"
          >
            ← 返回答题页面
          </Link>
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
