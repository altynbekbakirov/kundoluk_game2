import React from 'react';
import { Zap } from 'lucide-react';

interface EnergyBarProps {
  current: number;
  max?: number;
  label?: string;
}

const EnergyBar: React.FC<EnergyBarProps> = ({ current, max = 100, label = "Билим Энергиясы" }) => {
  const percentage = Math.min(100, Math.max(0, (current / max) * 100));
  
  // Color change based on low energy
  let colorClass = "bg-emerald-500";
  if (percentage < 50) colorClass = "bg-amber-500";
  if (percentage < 20) colorClass = "bg-red-500";

  return (
    <div className="w-full bg-slate-800 rounded-xl p-4 border border-slate-700 shadow-inner">
      <div className="flex justify-between items-center mb-2">
        <div className="flex items-center gap-2 text-indigo-300 font-bold">
          <Zap className="w-5 h-5 text-yellow-400 fill-yellow-400" />
          <span>{label}</span>
        </div>
        <span className="text-slate-200 font-mono">{current}/{max}</span>
      </div>
      <div className="w-full bg-slate-900 rounded-full h-4 overflow-hidden border border-slate-700">
        <div 
          className={`h-full ${colorClass} transition-all duration-1000 ease-out relative`}
          style={{ width: `${percentage}%` }}
        >
            <div className="absolute inset-0 bg-white/20 animate-pulse"></div>
        </div>
      </div>
    </div>
  );
};

export default EnergyBar;