import AdminDashboard from "@/components/AdminDashboard";
import { getQuestions } from "@/lib/db";

export const dynamic = "force-dynamic";

export default async function AdminPage() {
  const questions = await getQuestions();
  return <AdminDashboard initialQuestions={questions} />;
}

