# 📋 Plan de Implementación: Aplicación "Panadería" (Flutter + Firebase)

> 📌 **Objetivo:** Definir una hoja de ruta estructurada, sin código, para el desarrollo de una aplicación multiplataforma de panadería utilizando Flutter, Dart, Firebase (Auth + Firestore), Provider como gestor de estado, y VS Code / Antigravity como entorno de desarrollo.

---

## 🛠️ 1. Herramientas y Entorno de Desarrollo

| Categoría | Herramienta / Extensión | Propósito |
|-----------|------------------------|-----------|
| **SDK** | Flutter SDK + Dart SDK | Motor base y lenguaje |
| **IDE** | VS Code (recomendado) o Antigravity | Edición, depuración, integración con Flutter |
| **Extensiones VS Code** | `Flutter`, `Dart`, `Firebase`, `Error Lens`, `Pubspec Assist`, `GitLens` | Productividad, autocompletado, gestión de dependencias |
| **CLI** | `flutter`, `dart`, `firebase` | Creación de proyecto, configuración de Firebase, emulación |
| **Emuladores/Simuladores** | Android Studio (AVD), Xcode Simulator | Pruebas nativas multiplataforma |
| **Control de Versiones** | Git + GitHub/GitLab | Historial, ramas, colaboración |
| **Consola Backend** | Firebase Console | Configuración de Auth, Firestore, reglas, hosting (opcional) |

---

## 🏗️ 2. Arquitectura y Patrón de Diseño

- **Patrón:** MVVM simplificado + Provider (State Management)
- **Estructura de carpetas propuesta:**
  ```
  lib/
  ├── core/          (constantes, temas, utilidades, configuración Firebase)
  ├── data/          (repositorios, servicios Firebase, modelos DTO)
  ├── domain/        (entidades, casos de uso, contratos)
  ├── presentation/  (pantallas, widgets, proveedores Provider, navegación)
  └── main.dart
  ```
- **Separación de responsabilidades:** UI ↔ Lógica ↔ Datos. Evitar lógica de negocio en widgets.

---

## 🎨 3. Lineamientos UI/UX

| Aspecto | Directriz |
|---------|-----------|
| **Identidad Visual** | Paleta cálida (tonos tierra, dorado, crema), tipografía legible, iconografía minimalista de panadería |
| **Navegación** | `BottomNavigationBar` o `Drawer` con 4 secciones: Inicio, Catálogo, Carrito/Pedidos, Perfil |
| **Responsividad** | Uso de `LayoutBuilder`, `MediaQuery`, `Wrap`/`GridView` adaptativos a móvil, tablet y web |
| **Feedback** | Estados de carga (`CircularProgressIndicator`/shimmer), mensajes de error claros, toasts/snackbars para confirmaciones |
| **Accesibilidad** | Contraste WCAG AA, tamaños de fuente escalables, etiquetas semánticas, navegación por teclado/web |
| **Flujo Crítico** | Registro/Login → Exploración → Selección → Confirmación → Historial |

---

## 📦 4. Dependencias (`pubspec.yaml`)

| Categoría | Paquete | Uso |
|-----------|---------|-----|
| **Firebase Core** | `firebase_core` | Inicialización |
| **Autenticación** | `firebase_auth` | Login/Registro email-password, sesión |
| **Base de Datos** | `cloud_firestore` | Lectura/escritura en tiempo real |
| **Estado** | `provider` | Gestión de estado global, inyección de repositorios |
| **Navegación** | `go_router` (opcional pero recomendado) | Rutas declarativas, autoguard, deep links |
| **UI/Utilidades** | `cached_network_image`, `intl`, `flutter_svg`, `shimmer` | Imágenes, formato fecha/números, iconos, loaders |
| **Validación** | `formz` o `flutter_form_builder` + `email_validator` | Formularios seguros |
| **Configuración** | `flutter_dotenv` | Variables de entorno (si se requieren keys externas) |

> ✅ **Nota:** Las versiones se fijarán al momento de ejecutar `flutter pub add <paquete>`. Se recomienda usar rangos compatibles con la última versión estable de Flutter.

---

## 🔥 5. Configuración de Firebase (Procedimiento)

1. Crear proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Habilitar **Authentication** → Proveedor `Email/Password`
3. Crear base de datos **Firestore** en modo `Producción` (iniciar con reglas restrictivas)
4. Instalar Firebase CLI: `npm install -g firebase-tools`
5. Autenticar CLI: `firebase login`
6. En la raíz del proyecto Flutter ejecutar: `flutterfire configure`
   - Seleccionar proyecto, plataformas (android, ios, web)
   - Generar automáticamente `firebase_options.dart` y archivos de configuración nativos
7. Definir reglas de seguridad iniciales para Firestore (solo usuarios autenticados pueden leer/escribir sus propios datos)

---

## 🧭 6. Plan de Implementación Paso a Paso

### 🔹 Fase 1: Configuración Inicial
- [ ] Crear proyecto Flutter: `flutter create panaderia --platforms android,ios,web`
- [ ] Configurar estructura de carpetas (core, data, domain, presentation)
- [ ] Agregar dependencias listadas en `pubspec.yaml`
- [ ] Configurar `flutterfire` y verificar conexión con Firebase
- [ ] Definir `MaterialApp` base, tema personalizado y rutas vacías
- [ ] Verificar compilación en Android, iOS y Web

### 🔹 Fase 2: Autenticación (Email/Password)
- [ ] Diseñar pantallas: `LoginScreen`, `RegisterScreen`, `ForgotPasswordScreen` (UI estática primero)
- [ ] Crear `AuthProvider` con `ChangeNotifierProvider`
- [ ] Implementar métodos: `register()`, `login()`, `logout()`, `resetPassword()`
- [ ] Manejar estados: `idle`, `loading`, `success`, `error`
- [ ] Implementar navegación condicional: si `authState` es `null` → AuthFlow, si `user != null` → HomeFlow
- [ ] Validar formularios antes de llamar a Firebase
- [ ] Probar flujo completo en emuladores/dispositivos físicos

### 🔹 Fase 3: Base de Datos (Firestore)
- [ ] Definir modelo de datos: `Usuario`, `Producto`, `Pedido`, `Categoría`
- [ ] Crear repositorios: `AuthRepository`, `ProductRepository`, `OrderRepository`
- [ ] Implementar operaciones CRUD en Firestore (crear documentos, listas con paginación, actualizaciones en tiempo real)
- [ ] Configurar índices compuestos si se requieren consultas avanzadas
- [ ] Aplicar reglas de seguridad por rol/usuario (lectura pública de productos, escritura solo autenticada)
- [ ] Probar sincronización offline/online (Firestore lo soporta nativamente)

### 🔹 Fase 4: Integración con Provider
- [ ] Envolver `MaterialApp` con `MultiProvider` (AuthProvider, ProductProvider, CartProvider, etc.)
- [ ] Separar estado UI de lógica de negocio usando `ChangeNotifier` o `ProxyProvider`
- [ ] Implementar listeners para actualizaciones en tiempo real de Firestore
- [ ] Optimizar reconstrucciones: `Consumer`, `Selector`, `Provider.of(context, listen: false)`
- [ ] Validar que el estado persiste entre cambios de pantalla y rotaciones

### 🔹 Fase 5: Desarrollo UI + Lógica
- [ ] Construir pantallas definitivas conectadas a Providers
- [ ] Implementar navegación segura con redirecciones según estado de auth
- [ ] Agregar manejo de errores global (snackbars, diálogos, logs)
- [ ] Optimizar rendimiento: `const` en widgets estáticos, lazy loading de listas, caché de imágenes
- [ ] Adaptar diseño a múltiples tamaños de pantalla (responsive breakpoints)

### 🔹 Fase 6: Pruebas y Optimización
- [ ] Pruebas unitarias: lógica de validación, transformaciones de modelo, estados de Provider
- [ ] Pruebas de integración: flujo auth → carga de productos → creación de pedido
- [ ] Pruebas manuales: escenarios offline, reconexión, rotación, permisos denegados
- [ ] Perfilado: `flutter devtools` para detectar rebuilds innecesarios, fugas de memoria, latencia de red
- [ ] Revisar accesibilidad, contraste, tamaños de fuente, navegación por teclado/web

### 🔹 Fase 7: Preparación para Producción
- [ ] Configurar variables de entorno para keys sensibles (si aplica)
- [ ] Endurecer reglas de Firestore y Auth (rate limiting, validación de datos)
- [ ] Generar builds de release: `flutter build apk`, `flutter build ipa`, `flutter build web`
- [ ] Configurar signing/keystores (Android), provisioning profiles (iOS)
- [ ] Documentar arquitectura, flujos y comandos de despliegue
- [ ] Establecer pipeline CI/CD (opcional: GitHub Actions, Codemagic)

---

## 🛡️ 7. Seguridad y Buenas Prácticas

- 🔒 Nunca exponer credenciales o claves en código fuente
- 📜 Validar y sanitizar datos antes de enviarlos a Firestore
- 🧹 Implementar `try/catch` con mensajes amigables y logging en `debug`
- 📱 Manejar permisos y estados de red (sin conexión, reconexión)
- 🔄 Usar transacciones o batches para operaciones críticas (ej. descontar stock)
- 📏 Mantener dependencias actualizadas y revisar `flutter pub outdated` periódicamente
- 🧩 Evitar lógica pesada en el hilo principal; usar `Future`, `Isolate` o `compute` si es necesario

---

## ✅ 8. Próximos Pasos

1. Revisar y validar este plan con el equipo o cliente
2. Confirmar alcance exacto (¿catálogo solo? ¿carrito? ¿pedidos en tiempo real? ¿panel admin?)
3. Solicitar por separado la implementación de cada fase con código, pruebas y configuraciones específicas
4. Iterar según feedback de UI/UX o cambios en requisitos de negocio

> 📝 **Cuando estés listo, indícame qué fase deseas desarrollar primero y te entregaré el código estructurado, comentarios explicativos y configuración exacta para ese bloque.**
