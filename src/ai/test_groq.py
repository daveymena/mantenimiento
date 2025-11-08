"""
Script de prueba para verificar las API keys de Groq
"""
import requests
import json
from groq_config import groq_key_manager

def test_groq_key(api_key):
    """Prueba una API key de Groq"""
    try:
        headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
        
        data = {
            "model": "llama-3.1-70b-versatile",
            "messages": [
                {"role": "user", "content": "Hola, responde solo 'OK' si funciono"}
            ],
            "temperature": 0.7,
            "max_tokens": 10
        }
        
        response = requests.post(
            "https://api.groq.com/openai/v1/chat/completions",
            headers=headers,
            json=data,
            timeout=10
        )
        
        if response.status_code == 200:
            result = response.json()
            message = result["choices"][0]["message"]["content"]
            return True, message
        else:
            return False, f"Error {response.status_code}: {response.text}"
            
    except Exception as e:
        return False, str(e)

def test_all_keys():
    """Prueba todas las API keys"""
    print("=== Probando API Keys de Groq ===\n")
    
    manager = groq_key_manager
    working_keys = []
    failed_keys = []
    
    for i, key in enumerate(manager.api_keys, 1):
        print(f"Probando key {i}/{len(manager.api_keys)}: ...{key[-10:]}")
        success, message = test_groq_key(key)
        
        if success:
            print(f"  ✓ Funciona - Respuesta: {message}")
            working_keys.append(key)
        else:
            print(f"  ✗ Fallo - {message}")
            failed_keys.append(key)
        
        print()
    
    # Resumen
    print("=== RESUMEN ===")
    print(f"Keys funcionando: {len(working_keys)}/{len(manager.api_keys)}")
    print(f"Keys con error: {len(failed_keys)}/{len(manager.api_keys)}")
    
    if working_keys:
        print(f"\n✓ Tienes {len(working_keys)} keys disponibles para usar")
    else:
        print("\n⚠️ Ninguna key está funcionando. Verifica las API keys.")
    
    return working_keys, failed_keys

def test_rotation():
    """Prueba el sistema de rotación"""
    print("\n=== Probando Sistema de Rotación ===\n")
    
    manager = groq_key_manager
    
    print(f"Key inicial: ...{manager.get_current_key()[-10:]}")
    
    for i in range(3):
        print(f"\nRotación {i+1}:")
        new_key = manager.rotate_key("test")
        print(f"Nueva key: ...{new_key[-10:]}")
        
        # Probar la nueva key
        success, message = test_groq_key(new_key)
        if success:
            print(f"  ✓ Key funciona")
            manager.mark_success()
        else:
            print(f"  ✗ Key no funciona")
            manager.mark_error()
    
    print("\n=== Estadísticas ===")
    stats = manager.get_stats()
    print(json.dumps(stats, indent=2))

if __name__ == "__main__":
    # Probar todas las keys
    working, failed = test_all_keys()
    
    # Si hay keys funcionando, probar rotación
    if working:
        test_rotation()
    
    print("\n✓ Prueba completada")
