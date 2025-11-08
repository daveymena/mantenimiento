"""
Motor de IA para análisis y decisiones inteligentes de mantenimiento
"""
import psutil
import json
import os
from datetime import datetime
from typing import Dict, List, Tuple

class AIMaintenanceEngine:
    def __init__(self):
        self.history = []
        self.baseline = self.get_system_baseline()
        
    def get_system_baseline(self) -> Dict:
        """Obtiene métricas base del sistema"""
        return {
            'cpu_percent': psutil.cpu_percent(interval=1),
            'memory_percent': psutil.virtual_memory().percent,
            'disk_usage': psutil.disk_usage('/').percent,
            'processes_count': len(psutil.pids()),
            'timestamp': datetime.now().isoformat()
        }
    
    def analyze_system(self) -> Dict:
        """Análisis inteligente del sistema"""
        cpu = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        # Análisis de procesos pesados
        heavy_processes = []
        for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent']):
            try:
                if proc.info['cpu_percent'] > 10 or proc.info['memory_percent'] > 5:
                    heavy_processes.append({
                        'name': proc.info['name'],
                        'cpu': round(proc.info['cpu_percent'], 2),
                        'memory': round(proc.info['memory_percent'], 2)
                    })
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                pass
        
        # Análisis de temperatura (si está disponible)
        temps = {}
        try:
            temps = psutil.sensors_temperatures()
        except:
            temps = {}
        
        return {
            'cpu': {
                'percent': cpu,
                'count': psutil.cpu_count(),
                'freq': psutil.cpu_freq().current if psutil.cpu_freq() else 0
            },
            'memory': {
                'percent': memory.percent,
                'available_gb': round(memory.available / (1024**3), 2),
                'total_gb': round(memory.total / (1024**3), 2)
            },
            'disk': {
                'percent': disk.percent,
                'free_gb': round(disk.free / (1024**3), 2),
                'total_gb': round(disk.total / (1024**3), 2)
            },
            'heavy_processes': heavy_processes[:10],
            'temperatures': temps,
            'timestamp': datetime.now().isoformat()
        }
    
    def get_intelligent_recommendations(self, analysis: Dict) -> List[Dict]:
        """Genera recomendaciones inteligentes basadas en análisis"""
        recommendations = []
        
        # Análisis de CPU
        if analysis['cpu']['percent'] > 80:
            recommendations.append({
                'priority': 'high',
                'category': 'cpu',
                'action': 'optimize_processes',
                'message': f"CPU al {analysis['cpu']['percent']}%. Recomiendo cerrar procesos pesados.",
                'impact': 'high'
            })
        
        # Análisis de Memoria
        if analysis['memory']['percent'] > 85:
            recommendations.append({
                'priority': 'high',
                'category': 'memory',
                'action': 'free_memory',
                'message': f"Memoria al {analysis['memory']['percent']}%. Solo {analysis['memory']['available_gb']} GB disponibles.",
                'impact': 'high'
            })
        elif analysis['memory']['percent'] > 70:
            recommendations.append({
                'priority': 'medium',
                'category': 'memory',
                'action': 'free_memory',
                'message': f"Memoria al {analysis['memory']['percent']}%. Considera liberar RAM.",
                'impact': 'medium'
            })
        
        # Análisis de Disco
        if analysis['disk']['percent'] > 90:
            recommendations.append({
                'priority': 'critical',
                'category': 'disk',
                'action': 'clean_disk',
                'message': f"Disco al {analysis['disk']['percent']}%. ¡Espacio crítico! Solo {analysis['disk']['free_gb']} GB libres.",
                'impact': 'critical'
            })
        elif analysis['disk']['percent'] > 80:
            recommendations.append({
                'priority': 'high',
                'category': 'disk',
                'action': 'clean_disk',
                'message': f"Disco al {analysis['disk']['percent']}%. Recomiendo limpieza profunda.",
                'impact': 'high'
            })
        
        # Análisis de procesos pesados
        if len(analysis['heavy_processes']) > 5:
            top_process = analysis['heavy_processes'][0]
            recommendations.append({
                'priority': 'medium',
                'category': 'processes',
                'action': 'manage_processes',
                'message': f"Detecté {len(analysis['heavy_processes'])} procesos pesados. '{top_process['name']}' usa {top_process['cpu']}% CPU.",
                'impact': 'medium'
            })
        
        # Si todo está bien
        if not recommendations:
            recommendations.append({
                'priority': 'info',
                'category': 'status',
                'action': 'none',
                'message': "Sistema funcionando óptimamente. No se requieren acciones.",
                'impact': 'none'
            })
        
        return recommendations
    
    def predict_optimization_impact(self, action: str, current_state: Dict) -> Dict:
        """Predice el impacto de una optimización"""
        impacts = {
            'clean_disk': {
                'disk_freed_gb': 2.5,
                'performance_gain': 5,
                'time_minutes': 3
            },
            'free_memory': {
                'memory_freed_percent': 15,
                'performance_gain': 20,
                'time_minutes': 1
            },
            'optimize_processes': {
                'cpu_reduction_percent': 25,
                'performance_gain': 30,
                'time_minutes': 2
            },
            'optimize_services': {
                'memory_freed_percent': 10,
                'performance_gain': 15,
                'time_minutes': 2
            }
        }
        
        return impacts.get(action, {
            'performance_gain': 10,
            'time_minutes': 2
        })
    
    def generate_maintenance_plan(self, analysis: Dict) -> Dict:
        """Genera un plan de mantenimiento inteligente"""
        recommendations = self.get_intelligent_recommendations(analysis)
        
        # Ordenar por prioridad
        priority_order = {'critical': 0, 'high': 1, 'medium': 2, 'low': 3, 'info': 4}
        recommendations.sort(key=lambda x: priority_order.get(x['priority'], 5))
        
        # Calcular impacto total
        total_impact = sum(
            self.predict_optimization_impact(r['action'], analysis)['performance_gain']
            for r in recommendations if r['action'] != 'none'
        )
        
        return {
            'recommendations': recommendations,
            'total_impact': min(total_impact, 100),
            'estimated_time': sum(
                self.predict_optimization_impact(r['action'], analysis)['time_minutes']
                for r in recommendations if r['action'] != 'none'
            ),
            'priority_level': recommendations[0]['priority'] if recommendations else 'info'
        }
    
    def explain_action(self, action: str, context: Dict) -> str:
        """Explica en lenguaje natural qué hace una acción"""
        explanations = {
            'clean_disk': f"Voy a limpiar archivos temporales y cache. Esto liberará aproximadamente {context.get('disk_freed_gb', 2)} GB de espacio y mejorará la velocidad de lectura/escritura.",
            'free_memory': f"Liberaré memoria RAM cerrando procesos en segundo plano y limpiando cache. Esto recuperará aproximadamente {context.get('memory_freed_percent', 15)}% de RAM.",
            'optimize_processes': "Identificaré y suspenderé procesos no críticos que consumen muchos recursos. Esto reducirá el uso de CPU significativamente.",
            'optimize_services': "Deshabilitaré servicios de Windows no esenciales que se ejecutan en segundo plano. Esto liberará recursos del sistema.",
            'optimize_startup': "Deshabilitaré aplicaciones que se inician automáticamente con Windows. Esto acelerará el arranque del sistema."
        }
        
        return explanations.get(action, "Optimizaré el sistema para mejorar el rendimiento.")
    
    def save_history(self, action: str, result: Dict):
        """Guarda historial para aprendizaje"""
        self.history.append({
            'action': action,
            'result': result,
            'timestamp': datetime.now().isoformat()
        })
        
        # Guardar en archivo
        history_file = 'logs/ai_history.json'
        os.makedirs('logs', exist_ok=True)
        
        try:
            with open(history_file, 'w') as f:
                json.dump(self.history[-100:], f, indent=2)  # Últimas 100 acciones
        except Exception as e:
            print(f"Error guardando historial: {e}")

if __name__ == "__main__":
    # Test del motor
    engine = AIMaintenanceEngine()
    analysis = engine.analyze_system()
    print(json.dumps(analysis, indent=2))
    
    plan = engine.generate_maintenance_plan(analysis)
    print("\n=== PLAN DE MANTENIMIENTO ===")
    print(json.dumps(plan, indent=2))
