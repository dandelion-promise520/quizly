import QuizPage from "@/components/QuizPage";
import fs from "fs/promises";
import path from "path";
import type { Question } from "@/lib/types";

export const dynamic = "force-dynamic";

async function getQuestions(): Promise<Question[]> {
  const filePath = path.join(process.cwd(), "lib", "questions.json");
  const data = await fs.readFile(filePath, "utf-8");
  return JSON.parse(data);
}

export default async function Home() {
  const questions = await getQuestions();
  return <QuizPage initialQuestions={questions} />;
}
