import { GoogleGenAI, Schema, Type } from "@google/genai";
import { GameTurnResponse, GradeLevel, ScenarioTheme, Language } from "../types";

// Initialize Gemini Client
const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });

const MODEL_NAME = "gemini-2.5-flash";

// Schema for generating the game scenario and choices
const scenarioSchema: Schema = {
  type: Type.OBJECT,
  properties: {
    narrative: { type: Type.STRING, description: "The current story situation description." },
    question: { type: Type.STRING, description: "The scientific or logical question the player must answer." },
    choices: {
      type: Type.ARRAY,
      items: {
        type: Type.OBJECT,
        properties: {
          id: { type: Type.STRING },
          text: { type: Type.STRING, description: "The choice text." }
        },
        required: ["id", "text"]
      }
    },
    correctChoiceId: { type: Type.STRING, description: "The ID of the choice that is scientifically correct." },
    explanation: { type: Type.STRING, description: "A short scientific explanation why the correct answer is right." },
    npcName: { type: Type.STRING, description: "Name of the companion character." },
    npcDialogue: { type: Type.STRING, description: "Short dialogue from the companion." },
    subject: { type: Type.STRING, description: "The school subject related to this challenge." },
    isGameOver: { type: Type.BOOLEAN },
    isVictory: { type: Type.BOOLEAN }
  },
  required: ["narrative", "question", "choices", "correctChoiceId", "explanation", "subject"]
};

const themeTranslations = {
  [ScenarioTheme.TIME_TRAVEL_FUTURE]: "Путешествие в будущее",
  [ScenarioTheme.ANCIENT_KYRGYZSTAN]: "Древний Кыргызстан",
  [ScenarioTheme.SURVIVAL_ISLAND]: "Выживание на необитаемом острове"
};

const getSystemPrompt = (grade: string, theme: string, language: Language) => {
  if (language === Language.RUSSIAN) {
    const translatedTheme = themeTranslations[theme as ScenarioTheme] || theme;
    return `
      Ты сценарист текстовой интерактивной игры (RPG) для школьников (${grade}). Язык ответа: РУССКИЙ.
      Контекст: Школьная программа Кыргызстана (Математика, Физика, Химия, Биология, География).
      Тема: ${translatedTheme}.
      Цель: Создать захватывающую историю.
      Главный герой - ученик. Его оружие - научные знания.
      Вместо "Жизни" используется "Энергия Знаний".
      Персонаж-помощник: "Акылман" или "Робот-гид".
      Уровень сложности: Соответствует ${grade} школы.
      
      Важно: Вопросы должны быть основаны на школьной программе, но вписаны в сюжет.
      Ответ ВСЕГДА возвращай в заданном JSON формате.
    `;
  }

  // Default to Kyrgyz
  return `
    Сен мектеп окуучулары (${grade}) үчүн кыргыз тилинде текстке негизделген интерактивдүү оюндун (Text-Based RPG) сценаристисиң.
    Тема: ${theme}.
    Максат: Математика, Физика, Химия, Биология, География сабактарын камтыган кызыктуу окуя түзүү.
    Окуучу башкы каарман. Анын куралы - илимий билим.
    "Жашоо күчү" ордуна "Билим энергиясы" колдонулат.
    Персонаж: Окуучуга жардам берген "Акылман" же "Робот-гид" (темага жараша) болушу керек.
    Деңгээл: ${grade} окуучусуна ылайыктуу суроолор (жеңил логикадан татаал анализге чейин).
    
    Жоопту АР ДАЙЫМ берилген JSON схемасында кайтар.
  `;
};

export const generateInitialTurn = async (grade: GradeLevel, theme: ScenarioTheme, language: Language): Promise<GameTurnResponse> => {
  try {
    const startPrompt = language === Language.RUSSIAN 
      ? "Начни игру. Опиши первую ситуацию и дай 3-4 варианта действий. Укажи правильный ответ в 'correctChoiceId'."
      : "Оюнду башта. Биринчи кырдаалды сүрөттөп, 3-4 тандоо бер. Туура жоопту 'correctChoiceId' талаасына белгиле.";

    const response = await ai.models.generateContent({
      model: MODEL_NAME,
      contents: startPrompt,
      config: {
        systemInstruction: getSystemPrompt(grade, theme, language),
        responseMimeType: "application/json",
        responseSchema: scenarioSchema,
      },
    });

    const text = response.text;
    if (!text) throw new Error("Empty response from AI");
    return JSON.parse(text) as GameTurnResponse;
  } catch (error) {
    console.error("Error generating initial turn:", error);
    throw error;
  }
};

export const generateNextTurn = async (
  previousNarrative: string,
  previousQuestion: string,
  userChoiceText: string,
  isCorrect: boolean,
  grade: GradeLevel,
  theme: ScenarioTheme,
  language: Language
): Promise<GameTurnResponse> => {
  
  const nextTurnPrompt = `
    Context:
    Previous Scenario: ${previousNarrative}
    Previous Question: ${previousQuestion}
    User Choice: ${userChoiceText}
    Result: ${isCorrect ? "CORRECT" : "INCORRECT"}
    
    Task: Continue the story in ${language === Language.RUSSIAN ? "Russian" : "Kyrgyz"}.
    If the user was INCORRECT: The situation gets slightly more complicated or dangerous. Explain the consequence.
    If the user was CORRECT: Move the story forward positively.
    
    Select a NEW subject (Physics, Chemistry, Biology, etc.) different from the previous one if possible.
    Provide a new question, choices, and identify the correct answer.
  `;

  try {
    const response = await ai.models.generateContent({
      model: MODEL_NAME,
      contents: nextTurnPrompt,
      config: {
        systemInstruction: getSystemPrompt(grade, theme, language),
        responseMimeType: "application/json",
        responseSchema: scenarioSchema,
      }
    });

    const text = response.text;
    if (!text) throw new Error("Empty response from AI");
    return JSON.parse(text) as GameTurnResponse;

  } catch (error) {
    console.error("Error generating next turn:", error);
    throw error;
  }
};