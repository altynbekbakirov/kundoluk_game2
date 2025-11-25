import React from 'react';
import { Loader2, Atom, CheckCircle, XCircle } from 'lucide-react';
import { TurnResult } from '../types';

interface LoadingScreenProps {
  message?: string;
  lastResult?: TurnResult | null;
}

const LoadingScreen: React.FC<LoadingScreenProps> = ({ 
  message = "Илимий маалыматтар жүктөлүүдө...", 
  lastResult 
}) => {
  return (
    <div className="flex flex-col items-center justify-center min-h-[50vh] space-y-8 animate-in fade-in duration-500 max-w-2xl mx-auto px-4 text-center">
      
      {/* Visual Spinner */}
      <div className="relative mt-8">
        <div className="absolute inset-0 bg-indigo-500 blur-xl opacity-20 rounded-full animate-pulse"></div>
        <Atom className="w-24 h-24 text-indigo-400 animate-[spin_4s_linear_infinite]" />
        <Loader2 className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-8 h-8 text-white animate-spin" />
      </div>

      {/* Feedback Section */}
      {lastResult ? (
        <div className="space-y-4 animate-in slide-in-from-bottom-4 duration-500">
          <div className="flex flex-col items-center gap-2">
            {lastResult.success ? (
              <div className="flex items-center gap-2 text-emerald-400 text-2xl font-bold">
                <CheckCircle className="w-8 h-8" />
                <span>Туура!</span>
              </div>
            ) : (
              <div className="flex items-center gap-2 text-red-400 text-2xl font-bold">
                <XCircle className="w-8 h-8" />
                <span>Туура эмес!</span>
              </div>
            )}
          </div>
          
          <div className={`p-6 rounded-xl border ${lastResult.success ? 'bg-emerald-900/20 border-emerald-500/30' : 'bg-red-900/20 border-red-500/30'}`}>
            <p className="text-lg text-slate-200 leading-relaxed">
              {lastResult.feedback}
            </p>
            <div className={`mt-3 text-sm font-bold ${lastResult.success ? 'text-emerald-400' : 'text-red-400'}`}>
               {lastResult.energyChange > 0 ? '+' : ''}{lastResult.energyChange} Энергия
            </div>
          </div>
          
          <p className="text-indigo-300/80 text-sm animate-pulse pt-4">
             {message}
          </p>
        </div>
      ) : (
        <p className="text-xl text-indigo-200 font-medium tracking-wide">{message}</p>
      )}
    </div>
  );
};

export default LoadingScreen;