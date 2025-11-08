"""
Configuración y gestión de API keys de Groq con rotación automática
"""
import os
import json
from datetime import datetime

class GroqKeyManager:
    def __init__(self):
        # Cargar API keys desde variables de entorno
        self.api_keys = []
        
        # Intentar cargar hasta 7 keys desde variables de entorno
        for i in range(1, 8):
            key = os.getenv(f'GROQ_KEY_{i}')
            if key:
                self.api_keys.append(key)
        
        # Si no hay keys en variables de entorno, usar keys de ejemplo (NO FUNCIONALES)
        if not self.api_keys:
            print("⚠️ ADVERTENCIA: No se encontraron API keys en variables de entorno")
            print("   Configura tus keys con: setx GROQ_KEY_1 'tu-api-key'")
            print("   Obtén keys gratuitas en: https://console.groq.com/")
            # Keys de ejemplo (no funcionales)
            self.api_keys = [
                "gsk_EXAMPLE_KEY_1_REPLACE_WITH_YOUR_OWN",
                "gsk_EXAMPLE_KEY_2_REPLACE_WITH_YOUR_OWN"
            ]
        
        self.current_key_index = 0
        self.key_usage = {}  # Tracking de uso por key
        self.failed_keys = set()  # Keys que fallaron
        
        # Cargar estado previo si existe
        self.load_state()
    
    def get_current_key(self):
        """Obtiene la API key actual"""
        if self.current_key_index >= len(self.api_keys):
            self.current_key_index = 0
        
        # Saltar keys que fallaron
        attempts = 0
        while self.api_keys[self.current_key_index] in self.failed_keys:
            self.current_key_index = (self.current_key_index + 1) % len(self.api_keys)
            attempts += 1
            
            # Si todas las keys fallaron, resetear
            if attempts >= len(self.api_keys):
                self.failed_keys.clear()
                break
        
        return self.api_keys[self.current_key_index]
    
    def rotate_key(self, reason="manual"):
        """Rota a la siguiente API key"""
        old_key = self.api_keys[self.current_key_index]
        
        # Marcar como fallida si es por error
        if reason == "rate_limit" or reason == "error":
            self.failed_keys.add(old_key)
        
        # Rotar
        self.current_key_index = (self.current_key_index + 1) % len(self.api_keys)
        new_key = self.get_current_key()
        
        # Log
        print(f"🔄 Rotando API key: {old_key[-10:]}... → {new_key[-10:]}... (Razón: {reason})")
        
        # Guardar estado
        self.save_state()
        
        return new_key
    
    def mark_success(self):
        """Marca la key actual como exitosa"""
        current_key = self.get_current_key()
        
        if current_key not in self.key_usage:
            self.key_usage[current_key] = {
                'success_count': 0,
                'error_count': 0,
                'last_used': None
            }
        
        self.key_usage[current_key]['success_count'] += 1
        self.key_usage[current_key]['last_used'] = datetime.now().isoformat()
        
        # Si tuvo éxito, remover de fallidas
        if current_key in self.failed_keys:
            self.failed_keys.remove(current_key)
        
        self.save_state()
    
    def mark_error(self, error_type="unknown"):
        """Marca la key actual como con error"""
        current_key = self.get_current_key()
        
        if current_key not in self.key_usage:
            self.key_usage[current_key] = {
                'success_count': 0,
                'error_count': 0,
                'last_used': None
            }
        
        self.key_usage[current_key]['error_count'] += 1
        self.key_usage[current_key]['last_used'] = datetime.now().isoformat()
        
        self.save_state()
    
    def get_stats(self):
        """Obtiene estadísticas de uso"""
        return {
            'total_keys': len(self.api_keys),
            'current_key_index': self.current_key_index,
            'failed_keys_count': len(self.failed_keys),
            'key_usage': self.key_usage
        }
    
    def save_state(self):
        """Guarda el estado actual"""
        state = {
            'current_key_index': self.current_key_index,
            'failed_keys': list(self.failed_keys),
            'key_usage': self.key_usage
        }
        
        try:
            os.makedirs('logs', exist_ok=True)
            with open('logs/groq_keys_state.json', 'w') as f:
                json.dump(state, f, indent=2)
        except Exception as e:
            print(f"Error guardando estado de keys: {e}")
    
    def load_state(self):
        """Carga el estado previo"""
        try:
            if os.path.exists('logs/groq_keys_state.json'):
                with open('logs/groq_keys_state.json', 'r') as f:
                    state = json.load(f)
                    self.current_key_index = state.get('current_key_index', 0)
                    self.failed_keys = set(state.get('failed_keys', []))
                    self.key_usage = state.get('key_usage', {})
        except Exception as e:
            print(f"Error cargando estado de keys: {e}")
    
    def reset_failed_keys(self):
        """Resetea las keys marcadas como fallidas"""
        self.failed_keys.clear()
        self.save_state()
        print("✓ Keys fallidas reseteadas")

# Instancia global
groq_key_manager = GroqKeyManager()

if __name__ == "__main__":
    # Test del manager
    manager = GroqKeyManager()
    
    print("=== Test de Groq Key Manager ===\n")
    print(f"Total de keys: {len(manager.api_keys)}")
    print(f"Key actual: ...{manager.get_current_key()[-10:]}")
    print(f"\nEstadísticas:")
    print(json.dumps(manager.get_stats(), indent=2))
    
    # Simular rotación
    print("\n=== Simulando rotación ===")
    for i in range(3):
        print(f"\nRotación {i+1}:")
        manager.rotate_key("test")
        print(f"Nueva key: ...{manager.get_current_key()[-10:]}")
