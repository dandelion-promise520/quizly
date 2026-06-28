"use server";

import fs from "fs/promises";
import path from "path";
import type { Question } from "@/lib/types";

export async function saveQuestionsToDisk(questions: Question[]) {
  try {
    const filePath = path.join(process.cwd(), "lib", "questions.json");
    await fs.writeFile(filePath, JSON.stringify(questions, null, 2), "utf-8");
    return { success: true };
  } catch (error) {
    return { success: false, error: error instanceof Error ? error.message : "Failed to save to disk" };
  }
}
