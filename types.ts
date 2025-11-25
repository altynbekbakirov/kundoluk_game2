export enum GameStatus {
  IDLE = 'IDLE',
  LOADING = 'LOADING',
  PLAYING = 'PLAYING',
  GAME_OVER = 'GAME_OVER',
  VICTORY = 'VICTORY'
}

export enum Language {
  KYRGYZ = 'ky',
  RUSSIAN = 'ru'
}

export enum GradeLevel {
  GRADE_6 = '6-класс',
  GRADE_7 = '7-класс',
  GRADE_8 = '8-класс',
  GRADE_9 = '9-класс',
  GRADE_10 = '10-класс',
  GRADE_11 = '11-класс'
}

export enum ScenarioTheme {
  TIME_TRAVEL_FUTURE = 'Келечекке саякат',
  ANCIENT_KYRGYZSTAN = 'Байыркы Кыргызстан',
  SURVIVAL_ISLAND = 'Ээн аралда аман калуу'
}

export interface Choice {
  id: string;
  text: string;
}

export interface GameTurnResponse {
  narrative: string; // The story text description
  question: string; // The specific problem to solve
  choices: Choice[];
  correctChoiceId: string; // The ID of the correct answer for local validation
  explanation: string; // Explanation of why the correct answer is right
  npcName?: string; // Name of the helper character (e.g. Akylman)
  npcDialogue?: string; // Specific advice or comment from NPC
  subject: string; // e.g., "Физика", "Химия"
  isGameOver?: boolean;
  isVictory?: boolean;
}

export interface TurnResult {
  success: boolean;
  feedback: string;
  energyChange: number;
}

export interface GameState {
  status: GameStatus;
  grade: GradeLevel;
  theme: ScenarioTheme;
  language: Language;
  energy: number; // "Билим энергиясы"
  turnCount: number;
  history: string[]; // Keep track of the conversation for context
  currentTurnData: GameTurnResponse | null;
  lastResult: TurnResult | null;
  selectedChoiceId: string | null;
  error: string | null;
}