export interface Option {
  label: string;
  text: string;
}

export interface ChoiceQuestion {
  type: "单选题" | "判断题";
  text: string;
  options: Option[];
  answer: string; // original label, e.g. "B"
  shuffledOptions?: Option[];
  correctShuffledIdx?: number;
}

export interface FillQuestion {
  type: "填空题";
  text: string;
  blanks: string[]; // correct answers per blank
  answer: string[];
}

export type Question = ChoiceQuestion | FillQuestion;

export interface SavedAnswer {
  // For choice/fill: index of selected option in shuffled array, or -1 if unanswered
  // For fill: array of user answers per blank
  [key: string]: number | string[];
}

export interface QuizState {
  score: number;
  answered: number;
  questions: Omit<Question, "shuffledOptions" | "correctShuffledIdx"> & {
    shuffledOptions?: Option[];
    correctShuffledIdx?: number;
  }[];
  answers: SavedAnswer;
}
