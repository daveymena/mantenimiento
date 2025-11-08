"""
Script para detectar automáticamente modelos disponibles en Groq
"""
import requests
from groq_config import groq_key_manager

def detect_available_models():
    """Detecta qué modelos están disponibles en Groq"""
    
    # Lista de modelos conocidos para probar
    known_models = [
        "llama-3.1-70b-versatile",
        "llama-3.2-90b-text-preview",
        "llama-3.1-8b-instant",
        "llama-3.3-70b-versatile",
        "mixtral-8x7b-32768",
        "gemma-7b-it",
        "gemma2-9b-it"
    ]
    
    available = []
    deprecated = []
    
    api_key = groq_key_manager.get_current_key()
    
    print("🔍 Detectando modelos disponibles en Groq...\n")
    
    for model in known_models:
        print(f"Probando: {model}...", end=" ")
        
        try:
            headers = {
                "Authorization": f"Bearer {api_key}",
                "Content-Type": "application/json"
            }
            
            data = {
                "model": model,
                "messages": [{"role": "user", "content": "test"}],
                "max_tokens": 5
            }
            
            response = requests.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers=headers,
                json=data,
                timeout=10
            )
            
            if response.status_code == 200:
                print("✅ Disponible")
                available.append(model)
            elif response.status_code == 400:
                error_msg = response.json().get("error", {}).get("message", "")
                if "decommissioned" in error_msg or "not supported" in error_msg:
                    print("❌ Descontinuado")
                    deprecated.append(model)
                else:
                    print(f"⚠️ Error: {error_msg[:50]}")
            else:
                print(f"⚠️ Status {response.status_code}")
                
        except Exception as e:
            print(f"❌ Error: {str(e)[:50]}")
    
    print("\n" + "="*50)
    print(f"✅ Modelos disponibles: {len(available)}")
    for model in available:
        print(f"  - {model}")
    
    print(f"\n❌ Modelos descontinuados: {len(deprecated)}")
    for model in deprecated:
        print(f"  - {model}")
    
    print("="*50)
    
    return available, deprecated

if __name__ == "__main__":
    available, deprecated = detect_available_models()
    
    if available:
        print(f"\n💡 Recomendación: Usa '{available[0]}' como modelo principal")
    else:
        print("\n⚠️ No se encontraron modelos disponibles")
