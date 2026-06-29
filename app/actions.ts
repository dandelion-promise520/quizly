"use server";

import { saveQuestionsToDatabase } from "@/lib/db";
import type { Question } from "@/lib/types";

export async function saveQuestionsToDisk(questions: Question[]) {
  try {
    const updated = await saveQuestionsToDatabase(questions);
    return { success: true, questions: updated };
  } catch (error) {
    return { success: false, error: error instanceof Error ? error.message : "Failed to save to database" };
  }
}

