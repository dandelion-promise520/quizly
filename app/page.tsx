import QuizPage from "@/components/QuizPage";
import { getQuestions } from "@/lib/db";

export const dynamic = "force-dynamic";

export default async function Home() {
  const questions = await getQuestions();
  return <QuizPage initialQuestions={questions} />;
}

