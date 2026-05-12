**Contexto de Aplicación Enterprise:**
"Actúa como un **Lead Flutter Developer**. Necesito definir la infraestructura técnica de una aplicación de e-commerce (Panadería) utilizando una **Arquitectura de Capas (Clean Architecture)**. El objetivo es desacoplar la lógica de Firebase de la interfaz de usuario para permitir escalabilidad.

**Stack Tecnológico:**

* **State Management:** Provider (con un enfoque de `ChangeNotifier` y `ProxyProvider` para inyección de dependencias).
* **Backend:** Firebase (Firestore + Auth).
* **Data Mapping:** Implementación estricta de modelos DTO con soporte para nulidad (Null Safety).

**Esquema de Datos (Referencia Obligatoria):**
Mis colecciones en Firestore siguen este esquema: `usuarios`, `categorias`, `productos`, `pedidos` y `detalle_pedidos`. Debes respetar las relaciones (FK) entre ellas.

**Requerimientos del Plan de Implementación:**

1. **Definición de Capas:** Detalla la responsabilidad de cada nivel:
* **Data Layer:** Repositorios que manejen la comunicación con `Cloud Firestore` y el mapeo de excepciones.
* **Domain Layer:** Entidades puras de Dart y casos de uso (opcional, evaluar simplicidad).
* **Presentation Layer:** Implementación de `ViewModels` (Providers) que expongan estados (`Loading`, `Error`, `Success`).


2. **Estructura de Carpetas:** Proporciona un árbol de directorios profesional que separe los modelos de los servicios de Firebase.
3. **Patrones de Modelado:** Diseña la lógica para la tabla `detalle_pedidos` como una subcolección o un mapeo estructurado para optimizar lecturas/escrituras (costos de Firebase).
4. **Seguridad y Performance:** Define la estrategia de reglas de seguridad de Firestore y el uso de `StreamProvider` para el catálogo de productos.

**Resultado Esperado:**
No generes código de widgets todavía. Proporciona el **Plan Maestro de Arquitectura** y la **Estructura de Modelos Base** en Dart que garantice que el sistema de 'pedidos' y 'stock' sea atómico y consistente."

---

### 💡 Por qué este prompt es "Pro":

* **Enfoque en Costos y Rendimiento:** Al mencionar "optimizar lecturas/escrituras" y "operaciones atómicas", le pides a la IA que piense en el dinero (facturación de Firebase) y en la integridad de los datos (que no se descuente stock si el pago falla).
* **Estados de UI:** Solicitar estados como `Loading`, `Error` y `Success` asegura que la app no se quede "congelada" y siempre dé feedback al usuario.
* **Desacoplamiento:** Obligas a la IA a no mezclar código de Firebase dentro de los botones de la interfaz, algo vital en proyectos grandes.

### 🛠️ ¿Cómo usar los resultados de este prompt?

Una vez que la IA te entregue este plan profesional:

1. **Valida los Modelos:** Revisa que los campos coincidan exactamente con tu archivo `.md`.
2. **Solicita los Repositorios:** Pide la lógica de conexión a la base de datos basándote en ese plan.
3. **Implementa los Providers:** Conecta la lógica con la UI.
