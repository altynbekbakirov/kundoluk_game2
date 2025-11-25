import React, { useState, useEffect } from 'react';
import { GameStatus, GameState, GradeLevel, ScenarioTheme, TurnResult, Language } from './types';
import { generateInitialTurn, generateNextTurn } from './services/geminiService';
import StartScreen from './components/StartScreen';
import LoadingScreen from './components/LoadingScreen';
import EnergyBar from './components/EnergyBar';
import Button from './components/Button';
import { Brain, Scroll, MessageCircle, Check, X, ArrowRight } from 'lucide-react';

const INITIAL_ENERGY = 100;
const CHOICE_LABELS = ['A', 'B', 'C', 'D'];

// Localization Dictionary
const UI_TEXT = {
  [Language.KYRGYZ]: {
    energy: "Билим Энергиясы",
    loadingLevel: "Кийинки деңгээл жүктөлүүдө...",
    loadingStart: "Илимий маалыматтар жүктөлүүдө...",
    gameOverTitle: "Оюн бүттү",
    gameOverDesc: "Билим энергиясы түгөндү. Илимди кайра кайталап, кайра аракет кылыңыз!",
    restart: "Кайра баштоо",
    victoryTitle: "Жеңиш!",
    victoryDesc: "Сиз бардык сыноолордон илимдин жардамы менен өттүңүз.",
    mainMenu: "Башкы меню",
    helper: "Жардамчы",
    guide: "Гид",
    defaultHelperQuote: "Илимге таян, ошондо жол табасың.",
    task: "Тапшырма:",
    level: "Деңгээл:",
    correct: "Туура!",
    incorrect: "Туура эмес!",
    nextLevel: "Кийинки деңгээл",
    errorStart: "Оюнду баштоодо ката кетти. API ачкычын текшериңиз же кайра аракет кылыңыз.",
    errorNext: "Жоопту иштеп чыгууда ката кетти. Сураныч, кайра аракет кылыңыз.",
    energyChange: "Энергия"
  },
  [Language.RUSSIAN]: {
    energy: "Энергия Знаний",
    loadingLevel: "Загрузка следующего уровня...",
    loadingStart: "Загрузка научных данных...",
    gameOverTitle: "Игра окончена",
    gameOverDesc: "Энергия знаний исчерпана. Повторите материал и попробуйте снова!",
    restart: "Начать заново",
    victoryTitle: "Победа!",
    victoryDesc: "Вы прошли все испытания с помощью науки.",
    mainMenu: "Главное меню",
    helper: "Помощник",
    guide: "Гид",
    defaultHelperQuote: "Полагайся на науку, и найдешь путь.",
    task: "Задание:",
    level: "Уровень:",
    correct: "Правильно!",
    incorrect: "Неправильно!",
    nextLevel: "Следующий уровень",
    errorStart: "Ошибка при запуске игры. Проверьте API ключ или попробуйте снова.",
    errorNext: "Ошибка обработки ответа. Пожалуйста, попробуйте снова.",
    energyChange: "Энергия"
  }
};

function App() {
  const [gameState, setGameState] = useState<GameState>({
    status: GameStatus.IDLE,
    grade: GradeLevel.GRADE_8,
    theme: ScenarioTheme.TIME_TRAVEL_FUTURE,
    language: Language.KYRGYZ,
    energy: INITIAL_ENERGY,
    turnCount: 0,
    history: [],
    currentTurnData: null,
    lastResult: null,
    selectedChoiceId: null,
    error: null,
  });

  const t = UI_TEXT[gameState.language];

  // Effect to handle Game Over or Victory state checks when energy changes
  useEffect(() => {
    if (gameState.status === GameStatus.PLAYING && !gameState.selectedChoiceId) {
      if (gameState.currentTurnData?.isGameOver) {
        setGameState(prev => ({ ...prev, status: GameStatus.GAME_OVER }));
      } else if (gameState.currentTurnData?.isVictory) {
        setGameState(prev => ({ ...prev, status: GameStatus.VICTORY }));
      }
    }
  }, [gameState.currentTurnData, gameState.status, gameState.selectedChoiceId]);

  const startGame = async (grade: GradeLevel, theme: ScenarioTheme, language: Language) => {
    setGameState(prev => ({
      ...prev,
      status: GameStatus.LOADING,
      grade,
      theme,
      language,
      energy: INITIAL_ENERGY,
      turnCount: 1,
      history: [],
      currentTurnData: null,
      lastResult: null,
      selectedChoiceId: null,
      error: null,
    }));

    try {
      const data = await generateInitialTurn(grade, theme, language);
      setGameState(prev => ({
        ...prev,
        status: GameStatus.PLAYING,
        currentTurnData: data,
      }));
    } catch (err) {
      // Error handling with potentially wrong language context if failed immediately, but okay for now
      setGameState(prev => ({
        ...prev,
        status: GameStatus.IDLE,
        error: UI_TEXT[language].errorStart,
      }));
    }
  };

  const handleChoice = (choiceId: string, choiceText: string) => {
    if (!gameState.currentTurnData || gameState.selectedChoiceId) return;

    const { correctChoiceId, explanation } = gameState.currentTurnData;
    
    // Local validation
    const isCorrect = choiceId === correctChoiceId;
    
    // Logic for energy deduction
    const energyChange = isCorrect ? 5 : -20;
    const newEnergy = Math.min(100, Math.max(0, gameState.energy + energyChange));

    const result: TurnResult = {
      success: isCorrect,
      feedback: explanation,
      energyChange: energyChange
    };

    // Update state with result BUT STAY ON PLAYING SCREEN to show feedback
    setGameState(prev => ({
      ...prev,
      energy: newEnergy,
      lastResult: result,
      selectedChoiceId: choiceId
    }));
  };

  const proceedToNextTurn = async () => {
    if (!gameState.currentTurnData || !gameState.lastResult || !gameState.selectedChoiceId) return;

    const { narrative, question, choices } = gameState.currentTurnData;
    // Find the text of the selected choice
    const selectedChoice = choices.find(c => c.id === gameState.selectedChoiceId);
    const choiceText = selectedChoice ? selectedChoice.text : "";

    // Check for Game Over before loading next
    if (gameState.energy <= 0) {
      setGameState(prev => ({ ...prev, status: GameStatus.GAME_OVER }));
      return;
    }

    setGameState(prev => ({
      ...prev,
      status: GameStatus.LOADING,
    }));

    try {
      const nextTurn = await generateNextTurn(
        narrative,
        question,
        choiceText,
        gameState.lastResult.success,
        gameState.grade,
        gameState.theme,
        gameState.language
      );

      setGameState(prev => {
        const newHistory = [
          ...prev.history,
          `Turn ${prev.turnCount}: ${narrative} | User: ${choiceText} | Result: ${gameState.lastResult?.success ? "Correct" : "Incorrect"}`
        ];

        return {
          ...prev,
          status: GameStatus.PLAYING,
          turnCount: prev.turnCount + 1,
          history: newHistory,
          currentTurnData: nextTurn,
          lastResult: null,       // Clear result for new turn
          selectedChoiceId: null  // Clear selection for new turn
        };
      });
    } catch (err) {
      setGameState(prev => ({
        ...prev,
        status: GameStatus.PLAYING, // Go back to playing state so user can retry or see error
        error: t.errorNext,
      }));
    }
  };

  const resetGame = () => {
    setGameState({
      status: GameStatus.IDLE,
      grade: GradeLevel.GRADE_8,
      theme: ScenarioTheme.TIME_TRAVEL_FUTURE,
      language: Language.KYRGYZ, // Default back to Kyrgyz or keep user preference? Reset implies full reset.
      energy: INITIAL_ENERGY,
      turnCount: 0,
      history: [],
      currentTurnData: null,
      lastResult: null,
      selectedChoiceId: null,
      error: null,
    });
  };

  // --- RENDER HELPERS ---

  const renderContent = () => {
    switch (gameState.status) {
      case GameStatus.IDLE:
        return <StartScreen onStart={startGame} />;
      case GameStatus.LOADING:
        return (
            <LoadingScreen 
                message={gameState.turnCount === 1 ? t.loadingStart : t.loadingLevel} 
            />
        );
      case GameStatus.GAME_OVER:
        return (
          <div className="text-center space-y-6 animate-in zoom-in duration-500 p-8 bg-red-900/20 rounded-3xl border border-red-500/50 max-w-2xl mx-auto mt-10">
            <h2 className="text-4xl font-bold text-red-400">{t.gameOverTitle}</h2>
            <p className="text-xl text-slate-300">{t.gameOverDesc}</p>
            <Button onClick={resetGame} variant="primary">{t.restart}</Button>
          </div>
        );
      case GameStatus.VICTORY:
        return (
          <div className="text-center space-y-6 animate-in zoom-in duration-500 p-8 bg-emerald-900/20 rounded-3xl border border-emerald-500/50 max-w-2xl mx-auto mt-10">
            <h2 className="text-4xl font-bold text-emerald-400">{t.victoryTitle}</h2>
            <p className="text-xl text-slate-300">{t.victoryDesc}</p>
            <Button onClick={resetGame} variant="primary">{t.mainMenu}</Button>
          </div>
        );
      case GameStatus.PLAYING:
        if (!gameState.currentTurnData) return null;
        const { narrative, question, choices, npcName, npcDialogue, subject, correctChoiceId } = gameState.currentTurnData;
        
        const hasAnswered = !!gameState.selectedChoiceId;

        return (
          <div className="max-w-4xl w-full mx-auto animate-in fade-in slide-in-from-bottom-4 duration-500">
            
            {/* Top Section: Stats & NPC */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
              <EnergyBar current={gameState.energy} label={t.energy} />
              
              <div className="bg-slate-800/50 backdrop-blur rounded-xl p-4 border border-slate-700 flex items-center gap-4 h-full">
                <div className="w-12 h-12 rounded-full bg-indigo-900/50 flex items-center justify-center border border-indigo-500/30 shrink-0">
                  <MessageCircle className="w-6 h-6 text-indigo-400" />
                </div>
                <div>
                  <div className="flex items-center gap-2 mb-1">
                     <p className="font-bold text-indigo-300">{npcName || t.helper}</p>
                     <span className="bg-slate-700/50 text-slate-400 text-[10px] px-1.5 py-0.5 rounded uppercase tracking-wider border border-slate-600">
                       <Brain className="w-3 h-3 inline mr-1" />
                       {t.guide}
                     </span>
                  </div>
                  <p className="text-slate-300 italic text-sm leading-snug">"{npcDialogue || t.defaultHelperQuote}"</p>
                </div>
              </div>
            </div>

            {/* Main Content: Narrative & Choices */}
            <div className="space-y-6">
              
              {/* Story Card */}
              <div className="bg-slate-800 rounded-2xl p-6 md:p-8 shadow-xl border border-slate-700 relative overflow-hidden">
                <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500"></div>
                
                <div className="mb-4 flex items-center gap-2">
                  <span className="bg-indigo-900/50 text-indigo-300 px-3 py-1 rounded-full text-xs font-bold border border-indigo-500/30">
                    {subject}
                  </span>
                  <span className="bg-slate-700 text-slate-300 px-3 py-1 rounded-full text-xs font-bold">
                    {t.level} {gameState.grade}
                  </span>
                </div>

                <div className="prose prose-invert max-w-none">
                  <p className="text-lg md:text-xl leading-relaxed text-slate-200 serif-text">
                    {narrative}
                  </p>
                </div>

                <div className="mt-8 p-5 bg-slate-900/50 rounded-xl border-l-4 border-indigo-500">
                  <h4 className="flex items-center gap-2 text-indigo-400 font-bold mb-2">
                    <Scroll className="w-5 h-5" />
                    {t.task}
                  </h4>
                  <p className="text-lg font-medium text-white">{question}</p>
                </div>
              </div>

              {/* Choices */}
              <div className="grid grid-cols-1 gap-4">
                {choices.map((choice, index) => {
                  const label = CHOICE_LABELS[index] || choice.id;
                  const isSelected = gameState.selectedChoiceId === choice.id;
                  const isCorrectChoice = choice.id === correctChoiceId;
                  
                  let buttonStyle = "bg-slate-800 border-slate-700 hover:border-indigo-500 hover:shadow-indigo-900/20";
                  let labelStyle = "bg-slate-700";
                  let textStyle = "text-slate-200";

                  if (hasAnswered) {
                    if (isCorrectChoice) {
                      buttonStyle = "bg-emerald-900/20 border-emerald-500 ring-1 ring-emerald-500";
                      labelStyle = "bg-emerald-600 text-white";
                      textStyle = "text-white";
                    } else if (isSelected) {
                      buttonStyle = "bg-red-900/20 border-red-500 ring-1 ring-red-500";
                      labelStyle = "bg-red-600 text-white";
                      textStyle = "text-white";
                    } else {
                      buttonStyle = "bg-slate-800/50 border-slate-800 opacity-50";
                    }
                  } else {
                    // Hover states only when active
                    buttonStyle += " hover:bg-indigo-900/40";
                  }

                  return (
                    <button
                      key={choice.id}
                      onClick={() => handleChoice(choice.id, choice.text)}
                      disabled={hasAnswered}
                      className={`group relative p-4 rounded-xl border text-left transition-all duration-200 shadow-sm flex items-center gap-4 ${buttonStyle}`}
                    >
                      <div className={`flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center text-lg font-bold transition-colors ${labelStyle}`}>
                        {hasAnswered && isCorrectChoice ? <Check className="w-6 h-6" /> : 
                         hasAnswered && isSelected ? <X className="w-6 h-6" /> : 
                         label}
                      </div>
                      <span className={`font-medium text-lg flex-1 ${textStyle}`}>
                        {choice.text}
                      </span>
                    </button>
                  );
                })}
              </div>

              {/* Feedback Panel (Shown after answering) */}
              {hasAnswered && gameState.lastResult && (
                <div className="animate-in fade-in slide-in-from-bottom-2 duration-500 space-y-4">
                   <div className={`p-6 rounded-xl border ${gameState.lastResult.success ? 'bg-emerald-900/30 border-emerald-500/50' : 'bg-red-900/30 border-red-500/50'}`}>
                      <div className="flex items-center gap-2 mb-3">
                        {gameState.lastResult.success ? (
                          <span className="text-emerald-400 font-bold text-lg flex items-center gap-2">
                            <Check className="w-5 h-5" /> {t.correct}
                          </span>
                        ) : (
                          <span className="text-red-400 font-bold text-lg flex items-center gap-2">
                            <X className="w-5 h-5" /> {t.incorrect}
                          </span>
                        )}
                         <span className={`text-sm font-bold px-2 py-0.5 rounded ${gameState.lastResult.success ? 'bg-emerald-500/20 text-emerald-300' : 'bg-red-500/20 text-red-300'}`}>
                            {gameState.lastResult.energyChange > 0 ? '+' : ''}{gameState.lastResult.energyChange} {t.energyChange}
                        </span>
                      </div>
                      <p className="text-slate-200 leading-relaxed">
                        {gameState.lastResult.feedback}
                      </p>
                   </div>
                   
                   <Button 
                     onClick={proceedToNextTurn} 
                     fullWidth 
                     className="py-4 text-lg shadow-xl shadow-indigo-900/50"
                   >
                     <span>{t.nextLevel}</span>
                     <ArrowRight className="w-5 h-5" />
                   </Button>
                </div>
              )}

            </div>
          </div>
        );
    }
  };

  return (
    <div className="min-h-screen bg-[#0f172a] text-slate-200 p-4 md:p-8 relative overflow-x-hidden">
       {/* Background Ambience */}
       <div className="fixed inset-0 pointer-events-none">
          <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-indigo-900/20 rounded-full blur-[120px]"></div>
          <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-purple-900/20 rounded-full blur-[120px]"></div>
       </div>

      <div className="max-w-7xl mx-auto relative z-10">
        {gameState.error && (
           <div className="mb-6 bg-red-500/10 border border-red-500 text-red-200 p-4 rounded-lg flex justify-between items-center">
             <span>{gameState.error}</span>
             <button onClick={() => setGameState(prev => ({...prev, error: null}))} className="text-sm underline">X</button>
           </div>
        )}
        
        {renderContent()}
      </div>
    </div>
  );
}

export default App;