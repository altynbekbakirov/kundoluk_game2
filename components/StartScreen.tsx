import React, { useState } from 'react';
import { GradeLevel, ScenarioTheme, Language } from '../types';
import Button from './Button';
import { BookOpen, Rocket, Compass, Skull, Globe } from 'lucide-react';

interface StartScreenProps {
  onStart: (grade: GradeLevel, theme: ScenarioTheme, language: Language) => void;
}

const StartScreen: React.FC<StartScreenProps> = ({ onStart }) => {
  const [step, setStep] = useState<'language' | 'setup'>('language');
  const [language, setLanguage] = useState<Language>(Language.KYRGYZ);
  const [grade, setGrade] = useState<GradeLevel>(GradeLevel.GRADE_8);
  const [theme, setTheme] = useState<ScenarioTheme>(ScenarioTheme.TIME_TRAVEL_FUTURE);

  const handleLanguageSelect = (lang: Language) => {
    setLanguage(lang);
    setStep('setup');
  };

  const uiText = {
    [Language.KYRGYZ]: {
      title: "Билим Саякатчысы",
      subtitle: "Илимий билим — сенин эң күчтүү куралың. Классты жана окуяны танда.",
      selectGrade: "Классты тандаңыз:",
      selectTheme: "Окуяны тандаңыз:",
      themes: {
        [ScenarioTheme.TIME_TRAVEL_FUTURE]: "Келечекке Саякат",
        [ScenarioTheme.ANCIENT_KYRGYZSTAN]: "Байыркы Кыргызстан",
        [ScenarioTheme.SURVIVAL_ISLAND]: "Ээн Аралда Аман Калуу"
      },
      startBtn: "Саякатты баштоо"
    },
    [Language.RUSSIAN]: {
      title: "Путешественник Знаний",
      subtitle: "Знание — твое самое сильное оружие. Выбери класс и сценарий.",
      selectGrade: "Выберите класс:",
      selectTheme: "Выберите сценарий:",
      themes: {
        [ScenarioTheme.TIME_TRAVEL_FUTURE]: "Путешествие в будущее",
        [ScenarioTheme.ANCIENT_KYRGYZSTAN]: "Древний Кыргызстан",
        [ScenarioTheme.SURVIVAL_ISLAND]: "Выживание на острове"
      },
      startBtn: "Начать путешествие"
    }
  };

  const t = uiText[language];

  if (step === 'language') {
    return (
      <div className="max-w-2xl mx-auto space-y-8 animate-in slide-in-from-bottom-5 duration-700 min-h-[50vh] flex flex-col justify-center">
        <div className="text-center space-y-4">
          <h1 className="text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400">
            Билим Саякатчысы
          </h1>
          <h2 className="text-2xl text-slate-400">
            Путешественник Знаний
          </h2>
          <p className="text-slate-500 mt-8">Тилди тандаңыз / Выберите язык</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-lg mx-auto w-full">
          <button
            onClick={() => handleLanguageSelect(Language.KYRGYZ)}
            className="group p-6 rounded-2xl border border-slate-700 bg-slate-800/50 hover:bg-indigo-900/30 hover:border-indigo-500 transition-all text-center space-y-4"
          >
            <div className="w-16 h-16 mx-auto rounded-full bg-indigo-900/50 flex items-center justify-center group-hover:scale-110 transition-transform">
              <span className="text-3xl">🇰🇬</span>
            </div>
            <div className="space-y-1">
              <h3 className="text-xl font-bold text-white">Кыргызча</h3>
              <p className="text-sm text-slate-400">Оюн кыргыз тилинде</p>
            </div>
          </button>

          <button
            onClick={() => handleLanguageSelect(Language.RUSSIAN)}
            className="group p-6 rounded-2xl border border-slate-700 bg-slate-800/50 hover:bg-indigo-900/30 hover:border-indigo-500 transition-all text-center space-y-4"
          >
            <div className="w-16 h-16 mx-auto rounded-full bg-indigo-900/50 flex items-center justify-center group-hover:scale-110 transition-transform">
              <span className="text-3xl">🇷🇺</span>
            </div>
            <div className="space-y-1">
              <h3 className="text-xl font-bold text-white">Русский</h3>
              <p className="text-sm text-slate-400">Игра на русском языке</p>
            </div>
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-2xl mx-auto space-y-8 animate-in slide-in-from-right-5 duration-500">
      <div className="text-center space-y-4">
        <h1 className="text-5xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400">
          {t.title}
        </h1>
        <p className="text-slate-400 text-lg">
          {t.subtitle}
        </p>
      </div>

      <div className="bg-slate-800/50 backdrop-blur-sm p-6 rounded-2xl border border-slate-700 space-y-6">
        
        {/* Grade Selection */}
        <div className="space-y-3">
          <label className="flex items-center gap-2 text-indigo-300 font-semibold text-lg">
            <BookOpen className="w-5 h-5" />
            {t.selectGrade}
          </label>
          <div className="grid grid-cols-3 gap-3">
            {Object.values(GradeLevel).map((lvl) => (
              <button
                key={lvl}
                onClick={() => setGrade(lvl)}
                className={`p-3 rounded-lg border transition-all ${
                  grade === lvl
                    ? "bg-indigo-600 border-indigo-400 text-white shadow-md"
                    : "bg-slate-900 border-slate-700 text-slate-400 hover:border-indigo-500/50"
                }`}
              >
                {lvl}
              </button>
            ))}
          </div>
        </div>

        {/* Theme Selection */}
        <div className="space-y-3">
          <label className="flex items-center gap-2 text-indigo-300 font-semibold text-lg">
            <Compass className="w-5 h-5" />
            {t.selectTheme}
          </label>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <button
              onClick={() => setTheme(ScenarioTheme.TIME_TRAVEL_FUTURE)}
              className={`p-4 rounded-xl border text-left transition-all flex flex-col gap-2 ${
                theme === ScenarioTheme.TIME_TRAVEL_FUTURE
                  ? "bg-indigo-900/60 border-indigo-400 ring-1 ring-indigo-400"
                  : "bg-slate-900 border-slate-700 hover:bg-slate-800"
              }`}
            >
              <Rocket className={`w-8 h-8 ${theme === ScenarioTheme.TIME_TRAVEL_FUTURE ? 'text-indigo-400' : 'text-slate-600'}`} />
              <span className="font-medium text-slate-200">{t.themes[ScenarioTheme.TIME_TRAVEL_FUTURE]}</span>
            </button>

            <button
              onClick={() => setTheme(ScenarioTheme.ANCIENT_KYRGYZSTAN)}
              className={`p-4 rounded-xl border text-left transition-all flex flex-col gap-2 ${
                theme === ScenarioTheme.ANCIENT_KYRGYZSTAN
                  ? "bg-amber-900/40 border-amber-500 ring-1 ring-amber-500"
                  : "bg-slate-900 border-slate-700 hover:bg-slate-800"
              }`}
            >
              <BookOpen className={`w-8 h-8 ${theme === ScenarioTheme.ANCIENT_KYRGYZSTAN ? 'text-amber-500' : 'text-slate-600'}`} />
              <span className="font-medium text-slate-200">{t.themes[ScenarioTheme.ANCIENT_KYRGYZSTAN]}</span>
            </button>

            <button
              onClick={() => setTheme(ScenarioTheme.SURVIVAL_ISLAND)}
              className={`p-4 rounded-xl border text-left transition-all flex flex-col gap-2 ${
                theme === ScenarioTheme.SURVIVAL_ISLAND
                  ? "bg-emerald-900/40 border-emerald-500 ring-1 ring-emerald-500"
                  : "bg-slate-900 border-slate-700 hover:bg-slate-800"
              }`}
            >
              <Skull className={`w-8 h-8 ${theme === ScenarioTheme.SURVIVAL_ISLAND ? 'text-emerald-500' : 'text-slate-600'}`} />
              <span className="font-medium text-slate-200">{t.themes[ScenarioTheme.SURVIVAL_ISLAND]}</span>
            </button>
          </div>
        </div>

        <div className="pt-4">
          <Button fullWidth onClick={() => onStart(grade, theme, language)} className="text-lg py-4">
            {t.startBtn}
          </Button>
          <div className="mt-4 text-center">
             <button onClick={() => setStep('language')} className="text-slate-500 text-sm hover:text-indigo-400 flex items-center justify-center gap-1 w-full">
               <Globe className="w-3 h-3" />
               {language === Language.KYRGYZ ? "Тилди өзгөртүү" : "Сменить язык"}
             </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default StartScreen;