"""
Asistente conversacional con IA para mantenimiento de PC
Soporta OpenAI, Groq (con rotación automática), y modelos locales
"""
import os
import json
from typing import Dict, List, Optional
from groq_config import groq_key_manager

class AIAssistant:
    def __init__(self, provider: str = "groq", api_key: Optional[str] = None):
        self.provider = provider
        
        # Para Groq, usar el key manager
        if provider == "groq":
            self.api_key = groq_key_manager.get_current_key()
            print(f"🤖 Usando Groq con key: ...{self.api_key[-10:]}")
        else:
            self.api_key = api_key or os.getenv(f"{provider.upper()}_API_KEY")
        
        self.conversation_history = []
        self.retry_count = 0
        self.max_retries = 3
        
        # System prompt
        self.system_prompt = """Eres un asistente experto en mantenimiento y optimización de PC con Windows.
Tu trabajo es:
1. Analizar problemas de rendimiento
2. Recomendar optimizaciones específicas
3. Explicar en lenguaje claro y amigable
4. Priorizar la seguridad del sistema
5. Ser conciso pero informativo

Siempre considera:
- No eliminar archivos críticos del sistema
- Crear restore points antes de cambios importantes
- Explicar el impacto de cada acción
- Dar alternativas cuando sea posible

Responde en español de forma clara y profesional."""
    
    def chat(self, user_message: str, system_context: Optional[Dict] = None) -> str:
        """Procesa mensaje del usuario y retorna respuesta"""
        
        # Agregar contexto del sistema si está disponible
        if system_context:
            context_str = f"\n\nContexto del sistema:\n{json.dumps(system_context, indent=2)}"
            user_message += context_str
        
        # Agregar a historial
        self.conversation_history.append({
            "role": "user",
            "content": user_message
        })
        
        # Generar respuesta según proveedor
        if self.provider == "openai":
            response = self._chat_openai()
        elif self.provider == "groq":
            response = self._chat_groq()
        elif self.provider == "local":
            response = self._chat_local()
        else:
            response = self._chat_fallback(user_message, system_context)
        
        # Agregar respuesta al historial
        self.conversation_history.append({
            "role": "assistant",
            "content": response
        })
        
        return response
    
    def _chat_openai(self) -> str:
        """Chat con OpenAI API"""
        try:
            import openai
            openai.api_key = self.api_key
            
            messages = [{"role": "system", "content": self.system_prompt}]
            messages.extend(self.conversation_history[-10:])  # Últimos 10 mensajes
            
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=messages,
                temperature=0.7,
                max_tokens=500
            )
            
            return response.choices[0].message.content
        except Exception as e:
            return f"Error con OpenAI: {e}. Usando modo fallback."
    
    def _chat_groq(self) -> str:
        """Chat con Groq API con rotación automática de keys y modelos"""
        try:
            import requests
            
            # Lista de modelos disponibles en orden de preferencia
            available_models = [
                "llama-3.1-70b-versatile",      # Recomendado
                "llama-3.2-90b-text-preview",   # Más potente
                "llama-3.1-8b-instant",         # Más rápido
                "mixtral-8x7b-32768"            # Legacy (por si vuelve)
            ]
            
            # Intentar con el modelo configurado o el primero disponible
            if not hasattr(self, 'current_model_index'):
                self.current_model_index = 0
            
            model = available_models[self.current_model_index]
            
            headers = {
                "Authorization": f"Bearer {self.api_key}",
                "Content-Type": "application/json"
            }
            
            messages = [{"role": "system", "content": self.system_prompt}]
            messages.extend(self.conversation_history[-10:])
            
            data = {
                "model": model,
                "messages": messages,
                "temperature": 0.7,
                "max_tokens": 500
            }
            
            response = requests.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers=headers,
                json=data,
                timeout=30
            )
            
            # Verificar respuesta
            if response.status_code == 200:
                groq_key_manager.mark_success()
                self.retry_count = 0
                return response.json()["choices"][0]["message"]["content"]
            
            # Modelo descontinuado o no disponible
            elif response.status_code == 400:
                error_data = response.json()
                error_msg = error_data.get("error", {}).get("message", "")
                
                if "decommissioned" in error_msg or "not supported" in error_msg:
                    print(f"⚠️ Modelo '{model}' no disponible, probando siguiente...")
                    
                    # Probar con el siguiente modelo
                    self.current_model_index = (self.current_model_index + 1) % len(available_models)
                    
                    if self.retry_count < len(available_models):
                        self.retry_count += 1
                        return self._chat_groq()  # Reintentar con otro modelo
                    else:
                        print("❌ Ningún modelo de Groq disponible, usando fallback")
                        return self._chat_fallback(self.conversation_history[-1]["content"], None)
                else:
                    print(f"⚠️ Error 400 de Groq: {error_msg}")
                    return self._chat_fallback(self.conversation_history[-1]["content"], None)
            
            # Rate limit o error de API
            elif response.status_code == 429 or response.status_code >= 500:
                groq_key_manager.mark_error("rate_limit")
                
                # Intentar con otra key
                if self.retry_count < self.max_retries:
                    self.retry_count += 1
                    print(f"⚠️ Error {response.status_code}, rotando key... (intento {self.retry_count}/{self.max_retries})")
                    self.api_key = groq_key_manager.rotate_key("rate_limit")
                    return self._chat_groq()  # Reintentar
                else:
                    print("❌ Todas las keys de Groq agotadas, usando fallback")
                    return self._chat_fallback(self.conversation_history[-1]["content"], None)
            
            # Otro error
            else:
                error_msg = response.json().get("error", {}).get("message", "Unknown error")
                print(f"⚠️ Error de Groq: {error_msg}")
                groq_key_manager.mark_error("api_error")
                return self._chat_fallback(self.conversation_history[-1]["content"], None)
                
        except requests.exceptions.Timeout:
            print("⏱️ Timeout con Groq, rotando key...")
            groq_key_manager.mark_error("timeout")
            
            if self.retry_count < self.max_retries:
                self.retry_count += 1
                self.api_key = groq_key_manager.rotate_key("timeout")
                return self._chat_groq()
            else:
                return self._chat_fallback(self.conversation_history[-1]["content"], None)
                
        except Exception as e:
            print(f"❌ Error inesperado con Groq: {e}")
            groq_key_manager.mark_error("exception")
            return self._chat_fallback(self.conversation_history[-1]["content"], None)
    
    def _chat_local(self) -> str:
        """Chat con modelo local (LLaMA, Mistral, etc.)"""
        # Placeholder para integración con Ollama u otro runtime local
        return "Modo local no implementado aún. Usa 'openai' o 'groq' como provider."
    
    def _chat_fallback(self, user_message: str, context: Optional[Dict]) -> str:
        """Respuestas basadas en reglas cuando no hay API disponible"""
        message_lower = user_message.lower()
        
        # Detección de intención
        if any(word in message_lower for word in ['lento', 'lenta', 'lag', 'tarda']):
            if context and context.get('memory', {}).get('percent', 0) > 80:
                return """Detecté que tu memoria RAM está al {}%. Esto puede causar lentitud.

Recomendaciones:
1. 🧹 Liberar memoria RAM (cierra programas en segundo plano)
2. 🗑️ Limpiar archivos temporales
3. ⚙️ Optimizar servicios de Windows

¿Quieres que ejecute estas optimizaciones?""".format(context['memory']['percent'])
            else:
                return """Para mejorar la velocidad de tu PC, te recomiendo:

1. 🧹 Limpiar archivos temporales y cache
2. 🚀 Optimizar aplicaciones de inicio
3. ⚙️ Desactivar servicios innecesarios
4. 💾 Liberar memoria RAM

¿Qué acción prefieres ejecutar primero?"""
        
        elif any(word in message_lower for word in ['espacio', 'disco', 'lleno']):
            return """Para liberar espacio en disco:

1. 🗑️ Limpiar archivos temporales (puede liberar 2-5 GB)
2. 🌐 Limpiar cache de navegadores (500 MB - 2 GB)
3. 📁 Analizar carpetas grandes
4. 🧹 Ejecutar Disk Cleanup de Windows

¿Quieres que analice tu disco y limpie archivos innecesarios?"""
        
        elif any(word in message_lower for word in ['juego', 'gaming', 'fps']):
            return """Para optimizar tu PC para juegos:

1. ⚡ Cambiar plan de energía a Alto Rendimiento
2. 🎮 Cerrar procesos en segundo plano
3. 💾 Liberar máxima RAM posible
4. ⚙️ Desactivar servicios no críticos
5. 🚀 Priorizar procesos de juegos

¿Quieres activar el modo Gaming?"""
        
        elif any(word in message_lower for word in ['diseño', 'photoshop', 'render']):
            return """Para optimizar para diseño gráfico:

1. 💾 Asignar más RAM a aplicaciones de diseño
2. ⚡ Plan de energía Alto Rendimiento
3. 🗑️ Limpiar cache de aplicaciones Adobe
4. ⚙️ Priorizar procesos creativos

¿Quieres que configure el modo Diseño?"""
        
        elif any(word in message_lower for word in ['seguro', 'backup', 'restore']):
            return """Para mantener tu sistema seguro:

1. 💾 Crear Restore Point antes de optimizar
2. 📋 Revisar logs de cambios
3. 🔒 No tocar servicios críticos (Firewall, Antivirus)
4. ✅ Usar modo Dry Run primero

¿Quieres crear un Restore Point ahora?"""
        
        else:
            return """¡Hola! Soy tu asistente de mantenimiento de PC. Puedo ayudarte con:

🔍 Analizar el rendimiento de tu sistema
🧹 Limpiar archivos temporales y cache
🚀 Optimizar inicio y servicios
💾 Liberar memoria RAM
⚙️ Configurar modos específicos (Gaming, Diseño, etc.)

¿Qué necesitas optimizar hoy?"""
    
    def clear_history(self):
        """Limpia el historial de conversación"""
        self.conversation_history = []
    
    def get_history(self) -> List[Dict]:
        """Obtiene el historial de conversación"""
        return self.conversation_history

if __name__ == "__main__":
    # Test del asistente
    assistant = AIAssistant(provider="fallback")
    
    print("=== Test del Asistente ===\n")
    
    test_messages = [
        "Mi PC va muy lenta",
        "Necesito espacio en disco",
        "Quiero optimizar para juegos"
    ]
    
    for msg in test_messages:
        print(f"Usuario: {msg}")
        response = assistant.chat(msg)
        print(f"Asistente: {response}\n")
