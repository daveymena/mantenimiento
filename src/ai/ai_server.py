"""
Servidor Flask para exponer funcionalidad de IA a Electron
"""
from flask import Flask, request, jsonify
from flask_cors import CORS
from ai_engine import AIMaintenanceEngine
from ai_assistant import AIAssistant
import json

app = Flask(__name__)
CORS(app)

# Inicializar motores
engine = AIMaintenanceEngine()
assistant = AIAssistant(provider="groq")  # Usando Groq con rotación automática de keys

@app.route('/api/analyze', methods=['GET'])
def analyze_system():
    """Analiza el sistema y retorna métricas"""
    try:
        analysis = engine.analyze_system()
        return jsonify({
            'success': True,
            'data': analysis
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/recommendations', methods=['POST'])
def get_recommendations():
    """Obtiene recomendaciones inteligentes"""
    try:
        analysis = request.json.get('analysis') or engine.analyze_system()
        recommendations = engine.get_intelligent_recommendations(analysis)
        
        return jsonify({
            'success': True,
            'data': recommendations
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/maintenance-plan', methods=['GET'])
def get_maintenance_plan():
    """Genera plan de mantenimiento completo"""
    try:
        analysis = engine.analyze_system()
        plan = engine.generate_maintenance_plan(analysis)
        
        return jsonify({
            'success': True,
            'data': plan
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/chat', methods=['POST'])
def chat():
    """Endpoint para chat con asistente IA"""
    try:
        data = request.json
        message = data.get('message', '')
        context = data.get('context')
        
        response = assistant.chat(message, context)
        
        return jsonify({
            'success': True,
            'response': response,
            'history': assistant.get_history()
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/chat/clear', methods=['POST'])
def clear_chat():
    """Limpia historial de chat"""
    assistant.clear_history()
    return jsonify({'success': True})

@app.route('/api/explain', methods=['POST'])
def explain_action():
    """Explica una acción en lenguaje natural"""
    try:
        data = request.json
        action = data.get('action', '')
        context = data.get('context', {})
        
        explanation = engine.explain_action(action, context)
        
        return jsonify({
            'success': True,
            'explanation': explanation
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/predict-impact', methods=['POST'])
def predict_impact():
    """Predice el impacto de una optimización"""
    try:
        data = request.json
        action = data.get('action', '')
        current_state = data.get('current_state', {})
        
        impact = engine.predict_optimization_impact(action, current_state)
        
        return jsonify({
            'success': True,
            'impact': impact
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/health', methods=['GET'])
def health():
    """Health check"""
    from groq_config import groq_key_manager
    stats = groq_key_manager.get_stats()
    
    return jsonify({
        'status': 'ok',
        'service': 'AI Maintenance Engine',
        'provider': assistant.provider,
        'groq_stats': {
            'total_keys': stats['total_keys'],
            'current_key_index': stats['current_key_index'],
            'failed_keys_count': stats['failed_keys_count']
        }
    })

@app.route('/api/groq-stats', methods=['GET'])
def groq_stats():
    """Estadísticas de uso de Groq"""
    from groq_config import groq_key_manager
    return jsonify({
        'success': True,
        'stats': groq_key_manager.get_stats()
    })

@app.route('/api/groq-reset', methods=['POST'])
def groq_reset():
    """Resetea keys fallidas de Groq"""
    from groq_config import groq_key_manager
    groq_key_manager.reset_failed_keys()
    return jsonify({
        'success': True,
        'message': 'Keys fallidas reseteadas'
    })

if __name__ == '__main__':
    import os
    
    # Configuración de producción
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('FLASK_ENV') != 'production'
    
    print("🤖 Servidor de IA iniciado")
    print(f"📡 Puerto: {port}")
    print(f"🔧 Modo: {'Desarrollo' if debug else 'Producción'}")
    print("📊 Endpoints disponibles:")
    print("  - GET  /health")
    print("  - GET  /api/analyze")
    print("  - POST /api/recommendations")
    print("  - GET  /api/maintenance-plan")
    print("  - POST /api/chat")
    print("  - POST /api/explain")
    print("  - POST /api/predict-impact")
    print("  - GET  /api/groq-stats")
    print("  - POST /api/groq-reset")
    
    app.run(host='0.0.0.0', port=port, debug=debug)
