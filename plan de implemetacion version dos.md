## 📂 1. Estructura de Proyecto (Clean Architecture Simplificada)

Esta organización separa la **lógica de datos** (Firestore) de la **lógica de negocio** (Modelos/Entidades) y la **interfaz** (UI).

```text
lib/
├── core/
│   ├── config/            # Configuración de Firebase y variables de entorno
│   ├── constants/         # Colores del tema (tierra/crema), strings, assets
│   ├── router/            # Configuración de GoRouter (rutas protegidas/públicas)
│   └── utils/             # Validadores de formularios y formateo de moneda (intl)
├── data/
│   ├── models/            # DTOs: Mapeo de JSON (Firestore) a objetos Dart
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   └── order_model.dart
│   ├── repositories/      # Implementación de llamadas a Firebase (CRUD)
│   └── services/          # Servicios externos (Auth Service, Storage Service)
├── domain/
│   ├── entities/          # Clases base de negocio (limpias de lógica Firebase)
│   └── providers/         # Lógica de estado (Auth, Cart, Inventory) con ChangeNotifier
├── presentation/
│   ├── screens/           # Pantallas principales (Home, Login, Checkout)
│   ├── widgets/           # Componentes reutilizables (ProductCard, CustomButton)
│   └── theme/             # Definición de ThemeData (Paleta Panadería)
└── main.dart              # Punto de entrada y MultiProvider

```

---

## 🚀 2. Plan de Implementación Optimizado (Fase Técnica)

He condensado tu plan para que sea una hoja de ruta de ejecución directa, integrando la lógica de tus tablas de base de datos.

### **Fase A: Cimentación y Auth**

* **Configuración Core:** Inicialización de `FirebaseCore` y `FirebaseOptions`. Configuración del tema visual (Paleta cálida/artesanal).
* **Módulo de Identidad:** Implementación de Registro/Login basado en tu tabla `usuarios`.
* *Detalle:* Al registrar en Auth, crear automáticamente el documento en la colección `usuarios` de Firestore para persistir nombre y rol.



### **Fase B: Gestión de Catálogo (Tu tabla `productos` y `categorias`)**

* **Carga Dinámica:** Implementación de un `ProductProvider` que consuma un `Stream` de Firestore.
* **Filtrado por Categoría:** Lógica para segmentar productos (Pan, Pastelería, Bebidas) mediante consultas indexadas.
* **Optimización de Imagen:** Uso de `cached_network_image` para no consumir datos innecesarios del Storage.

### **Fase C: Carrito y Lógica de Pedidos (Tu tabla `pedidos` y `detalle_pedidos`)**

* **Gestión de Estado Local:** El `CartProvider` manejará la lista temporal de productos y el cálculo de totales en memoria.
* **Transacción de Venta:** Al confirmar, se ejecutan dos acciones:
1. Creación del documento en la colección `pedidos`.
2. Escritura de los sub-documentos o arrays en `detalle_pedidos`.


* **Control de Stock:** Implementación de lógica para descontar unidades en la colección `productos` tras la compra.

### **Fase D: Panel de Usuario y Historial**

* **Perfil:** Consulta de datos personales y edición de perfil.
* **Historial de Compras:** Consulta filtrada de la tabla `pedidos` donde `id_usuario == currentUser`.

---

## 🛠️ 3. Especificaciones Técnicas de Integración

| Componente | Estrategia de Implementación |
| --- | --- |
| **Persistencia** | Firestore (Offline persistence habilitada por defecto en móviles). |
| **Estado Global** | `ChangeNotifierProvider` para Auth y Carrito; `StreamProvider` para catálogo en tiempo real. |
| **Seguridad** | Reglas de Firestore: `allow read` público para productos; `allow write` solo para dueños del pedido. |
| **Modelado** | Uso de métodos `fromFirestore()` y `toFirestore()` en cada modelo para sanitizar datos. |
| **Navegación** | GoRouter para manejar "Deep Linking" (especialmente útil si la panadería se abre desde un link web). |

---

## 🎨 4. Lineamientos de Diseño Profesional

* **Identidad Visual:** No usar el azul estándar de Flutter. Definir un `ColorScheme` basado en:
* `Primary`: #8D6E63 (Marrón café/pan tostado).
* `Secondary`: #FFF8E1 (Crema/harina).
* `Surface`: Blanco puro para limpieza visual.


* **Micro-interacciones:** Feedback táctil al añadir al carrito y transiciones suaves entre categorías.

---

### 📝 Notas de Arquitectura (Basado en tus tablas)

Dado que tienes una tabla de `categorias`, te sugiero que en Firestore no la manejes solo como un string, sino como una **referencia** o una colección independiente para que, si cambias el nombre de una categoría (ej. de "Panes" a "Panadería Artesanal"), se actualice en toda la app automáticamente.

