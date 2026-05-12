# 🥖 Panadería Gourmet — Plan de Implementación Profesional

**Documento de Planificación de Software**
**Versión 1.0 | Flutter + Firebase | Multiplataforma**

---

> *Este documento describe la arquitectura, tecnologías, diseño y fases de desarrollo de **Panadería Gourmet**, una aplicación multiplataforma diseñada para la gestión de ventas, inventario, producción y pedidos en tiempo real.*

---

## 1. Descripción General del Sistema

### ¿Qué es Panadería Gourmet?

**Panadería Gourmet** es una solución tecnológica integral diseñada para transformar un negocio de panadería tradicional en una operación digital eficiente. El sistema permite gestionar todo el ciclo de vida del producto: desde la materia prima y las categorías de panificación, hasta la venta final al cliente, el control de stock y la facturación.

A diferencia de un simple punto de venta, Panadería Gourmet está orientada a la **trazabilidad y producción**: permite gestionar pedidos por adelantado, controlar existencias de productos perecederos y administrar la relación con proveedores de insumos clave (harina, levadura, etc.).

### Objetivo Principal

El objetivo central es **optimizar la rentabilidad y la experiencia del cliente** a través de:

* **Catálogo Digital Dinámico**: Los productos se agrupan por categorías (Panes, Repostería, Bebidas), permitiendo una exploración visual fluida.
* **Gestión de Stock Atómica**: Cada venta descuenta automáticamente del inventario, evitando ofrecer productos agotados.
* **Pedidos y Trazabilidad**: Registro detallado de cada orden, permitiendo saber qué usuario realizó la venta y en qué estado se encuentra el pedido.
* **Control de Proveedores e Insumos**: Gestión de las entidades que surten la materia prima, vinculando facturas de compra con transacciones de egreso.
* **Administración Multiplataforma**: El administrador puede ver reportes en una PC (Windows/Web), mientras los vendedores operan desde tablets o móviles (Android/iOS).

---

## 2. Arquitectura del Proyecto

### Arquitectura Recomendada: Clean Architecture + MVVM

Implementaremos **Clean Architecture** para asegurar que la lógica de la panadería (reglas de negocio) sea independiente de la tecnología (Firebase/Flutter).

#### Capa de Presentación (Presentation Layer)

Contiene la UI y la lógica de estado. Aquí es donde los "vendedores" interactúan con el carrito de compras. Utilizamos el patrón **MVVM** donde el *ViewModel* prepara los datos del catálogo para ser mostrados.

#### Capa de Dominio (Domain Layer)

Es la capa más estable. Define qué es un "Producto", un "Pedido" y una "Venta". Contiene los **Casos de Uso** (ej: `RealizarVenta`, `ActualizarStock`, `GenerarFactura`).

#### Capa de Datos (Data Layer)

Gestiona la comunicación con **Firebase**. Aquí se encuentran los modelos que convierten el formato JSON de Firestore en objetos de Dart legibles por la aplicación.

---

### Organización de Carpetas

```text
panaderia_gourmet/
├── lib/
│   ├── core/                # Configuración de temas (colores crema/tierra), errores y constantes.
│   ├── data/                # DTOs (Modelos) y Repositorios (Lógica de Firestore).
│   ├── domain/              # Entidades puras y Casos de Uso (Lógica de negocio).
│   ├── presentation/
│   │   ├── screens/         # Home, Carrito, Perfil, Gestión de Inventario.
│   │   ├── widgets/         # Tarjetas de pan, botones de cantidad, recibos.
│   │   └── logic/           # Gestores de estado (Providers).
│   └── main.dart            # Inicialización de Firebase.

```

---

## 3. Tecnologías Necesarias

| Tecnología | Propósito |
| --- | --- |
| **Flutter 3.x** | Motor multiplataforma para Android, iOS, Web y Windows. |
| **Dart** | Lenguaje de programación con Null-Safety para evitar errores de sistema. |
| **Firebase Auth** | Control de acceso para empleados (Vendedores vs Administradores). |
| **Cloud Firestore** | Base de datos NoSQL para sincronización de pedidos en tiempo real. |
| **Firebase Storage** | Almacenamiento de fotos de alta resolución del pan y pasteles. |
| **Provider** | Gestión de estado (manejo del carrito de compras y catálogo). |

---

## 4. Diseño UI/UX

### Filosofía de Diseño: "Cálida y Artesanal"

La interfaz debe evocar la sensación de una panadería tradicional pero con la eficiencia de una app moderna. Se utilizarán bordes redondeados, sombras suaves y una iconografía clara.

* **Paleta de Colores**:
* **Primario**: Café Tostado (`#6D4C41`) - Confianza y tradición.
* **Secundario**: Trigo Dorado (`#FDD835`) - Energía y calidad.
* **Fondo**: Blanco Crema (`#FFFDF5`) - Limpieza y frescura.


* **Tipografía**: `Playfair Display` para títulos (elegancia artesanal) e `Inter` para datos numéricos y precios (legibilidad).

---

## 5. Planeación del Desarrollo (Paso a Paso)

### Fase 1 — Configuración del Entorno

Instalación del Flutter SDK y configuración de VS Code. Verificación de compilación en navegadores y móviles.

### Fase 2 — Configuración de Firebase

Creación del proyecto en Firebase Console. Vinculación mediante `flutterfire configure`. Habilitación de Authentication y Firestore en modo estándar.

### Fase 3 — Diseño de Base de Datos Firestore (Estructura de Colecciones)

Diseño de documentos basados en tus entidades:

* `/productos/`: Nombre, precio, stock, imagen.
* `/pedidos/`: ID usuario, fecha, total, estado.
* `/detalle_pedidos/`: (Como subcolección de pedidos) Producto_id, cantidad, subtotal.

### Fase 4 — Sistema de Autenticación

Implementación de Login con Email y Password. Los usuarios tendrán un `rol` (Admin o Staff) que limitará qué pueden ver (ej: el Staff no puede ver costos de proveedores).

### Fase 5 — Pantallas Principales

Desarrollo del Dashboard (resumen de ventas diarias) y la pantalla de Catálogo con filtros por categoría.

### Fase 6 — CRUD de Entidades

Formularios para agregar nuevos tipos de pan, gestionar proveedores y actualizar cuentas bancarias del negocio.

### Fase 7 — Gestión de Transacciones (El Corazón)

Implementación de la lógica de **Venta Atómica**. Al confirmar un pedido, el sistema debe usar una `Transaction` de Firebase para descontar el stock y crear el pedido al mismo tiempo.

---

## 6. Dependencias Recomendadas

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^latest      # Conector base Firebase
  cloud_firestore: ^latest    # Base de datos
  firebase_auth: ^latest     # Seguridad
  provider: ^latest          # Estado de la app
  intl: ^latest              # Formato de moneda ($) y fechas
  cached_network_image: ^latest # Carga rápida de fotos de pan

```

---

## 7. Flujo de Navegación

1. **Login**: Acceso seguro.
2. **Dashboard**: Resumen de lo que se ha vendido hoy y productos por agotarse.
3. **Catálogo/Venta**: Selección de panes, ajuste de cantidades y envío al carrito.
4. **Carrito/Factura**: Resumen de la compra y confirmación de pago.
5. **Inventario**: Vista para el administrador donde se gestionan proveedores e insumos.
6. **Perfil**: Configuración y cierre de sesión.

---

## 8. Recomendaciones Profesionales (Senior Tips)

1. **Atomicidad en Ventas**: Nunca descuentes stock mediante una consulta y luego otra. Usa **Transactions** de Firestore para asegurar que si falla el internet a mitad de camino, no se descuente pan que no se vendió.
2. **Caché de Imágenes**: Las fotos de comida venden mucho. Usa `cached_network_image` para que la app no descargue la foto del "Croissant" cada vez que el usuario abre la pantalla.
3. **Modo Offline**: Configura Firestore para que guarde los cambios localmente si el internet de la panadería falla, y se sincronice automáticamente al volver la conexión.
4. **Optimización de Costos**: No traigas todos los pedidos de la historia cada vez. Usa paginación (`limit(20)`) para mostrar solo los pedidos más recientes.

---



# Prompt

# 📋 Documento de Planificación Técnica: Panadería Gourmet

**Versión:** 2.0

**Arquitecto Responsable:** Lead Software Architect (Gemini AI)

**Stack:** Flutter + Firebase

**Estado:** Fase de Diseño de Ingeniería

---

## 1. Descripción General del Sistema

**Panadería Gourmet** es una solución integral de e-commerce y gestión de inventario diseñada para cerrar la brecha entre la producción artesanal y la eficiencia digital. El sistema no es solo una "tienda en línea"; es un ecosistema que permite el control total del ciclo de venta, desde la catalogación por categorías hasta la trazabilidad de pedidos y la gestión de stock en tiempo real.

El objetivo principal es ofrecer una experiencia de usuario (UX) fluida y apetecible, mientras se garantiza que los datos de facturación y existencias sean consistentes y seguros, permitiendo que el negocio escale de una operación local a una distribución multiplataforma (Android, Web, iOS, Desktop).

---

## 2. Arquitectura del Proyecto

Para este sistema, se ha seleccionado una **Arquitectura de Capas (Clean Architecture)** simplificada para Flutter, permitiendo que la lógica de negocio sea independiente de los cambios en la interfaz o en el backend.

### Organización de Carpetas (Estructura de Directorios)

```text
lib/
├── core/                  # Código compartido: constantes, temas, utilidades de red.
├── data/                  # Implementación: Repositorios, Modelos (DTOs) y DataSources.
│   ├── models/            # Serialización de Firestore (fromMap/toMap).
│   └── repositories/      # Lógica de persistencia de datos.
├── domain/                # Corazón del negocio: Entidades puras e Interfaces.
├── presentation/          # UI y Lógica de Estado.
│   ├── logic/             # Manejadores de estado (Controller/Logic).
│   ├── screens/           # Vistas de pantalla completa.
│   └── widgets/           # Componentes visuales reutilizables.
└── main.dart              # Punto de entrada y configuración de servicios.

```

### Manejo de Estados y Escalabilidad

* **Separación Frontend/Backend:** La comunicación se realiza estrictamente a través de la capa `data`, evitando que los Widgets llamen directamente a Firebase.
* **Gestión de Estado:** Se utilizará un patrón reactivo basado en la notificación de cambios, permitiendo que la UI se reconstruya solo cuando los datos específicos (como el precio total de un pedido) cambien.

---

## 3. Tecnologías Necesarias

### Core Stack

* **Flutter & Dart:** Motor multiplataforma y lenguaje con seguridad de tipos (Null Safety).
* **Firebase Authentication:** Gestión de identidad (Email/Password).
* **Cloud Firestore:** Base de datos NoSQL documental para persistencia en tiempo real.
* **Firebase Storage:** Almacenamiento de imágenes de alta resolución de los productos.

### Dependencias Críticas

* `cloud_firestore` & `firebase_auth`: Integración oficial con el backend.
* `intl`: Para el formateo de moneda local y fechas de pedidos.
* `cached_network_image`: Optimización de memoria al cargar el catálogo.
* `go_router`: Navegación declarativa avanzada para soporte de rutas en Web.

---

## 4. Diseño UI/UX

* **Estilo Visual:** "Artisanal Modern". Uso de superficies limpias con tipografías serif para títulos (calidez) y sans-serif para datos técnicos (legibilidad).
* **Paleta de Colores:** * **Primario:** Marrón Trigo (#8D6E63)
* **Secundario:** Crema Vainilla (#FFF8E1)
* **Accento:** Naranja Horneado (#F57C00) para CTAs (Call to Action).


* **Adaptabilidad:** Diseño **Responsive & Adaptive**. En Web/Desktop, la interfaz mostrará una cuadrícula expandida; en móviles, una navegación vertical optimizada para el pulgar.

---

## 5. Planeación del Desarrollo (Fase a Fase)

### Fase 1: Configuración del Entorno

* **Objetivo:** Establecer el workspace.
* **Acciones:** Instalación de SDKs, configuración de VS Code y linters de estilo de código.
* **Buena Práctica:** Configurar archivos `.env` para proteger llaves si se integran servicios externos.

### Fase 2: Configuración de Firebase

* **Objetivo:** Vincular la app con la nube.
* **Acciones:** Creación del proyecto en consola y ejecución de `flutterfire configure`.
* **Posible Problema:** Errores de SHA-1 en Android. **Solución:** Generar el keystore desde la terminal antes de la vinculación.

### Fase 3: Diseño de Base de Datos Firestore

* **Objetivo:** Arquitectura de datos basada en las tablas proporcionadas.
* **Desarrollo:** Creación de colecciones de `productos` y `categorias`. Configuración de la subcolección `detalle_pedidos` dentro de cada documento de `pedidos` para optimizar costos de lectura.

### Fase 4: Sistema de Autenticación

* **Objetivo:** Registro y control de acceso.
* **Desarrollo:** Flujos de Login/Registro. Vinculación del UID de Firebase con el documento en la colección `usuarios`.

### Fase 5: Pantallas Principales

* **Objetivo:** Esqueleto visual.
* **Desarrollo:** Dashboard de productos, vista de detalle y carrito de compras.

### Fase 6: CRUD de Entidades

* **Objetivo:** Gestión administrativa.
* **Desarrollo:** Módulos para que el administrador pueda subir fotos, editar precios y ajustar stock de panes/pasteles.

### Fase 7: Gestión de Transacciones

* **Objetivo:** El núcleo del negocio.
* **Desarrollo:** Lógica de "Agregar al carrito" y cálculo de totales. Implementación de **Batches** en Firestore para asegurar que al comprar, el stock baje automáticamente.

### Fase 8: Facturación y Pedidos

* **Objetivo:** Cierre de venta.
* **Desarrollo:** Generación de recibos digitales y actualización del historial de pedidos del usuario.

### Fase 9: Testing Multiplataforma

* **Objetivo:** Calidad de software.
* **Desarrollo:** Pruebas de renderizado en Chrome (Web) y emuladores Android/iOS.

### Fase 10: Implantación Estándar

* **Objetivo:** Entrega del MVP (Producto Mínimo Viable).
* **Desarrollo:** Generación de archivos compilados para revisión final.

---

## 6. Seguridad y Autenticación

* **Manejo de Sesiones:** Persistencia automática; el usuario no necesita loguearse cada vez que abre la app.
* **Reglas de Firestore:**
* `Allow read` para productos: Público.
* `Allow write` en pedidos: Solo usuarios autenticados.
* `Validation`: Ningún pedido puede tener un total negativo o stock menor a cero.


* **Roles:** Diferenciación entre `cliente` (compra) y `admin` (gestiona inventario).

---

## 7. Flujo de Navegación

1. **Splash Screen:** Verificación de estado de sesión.
2. **Auth Flow:** Login/Registro si no hay sesión activa.
3. **Home Dashboard:** Exploración de productos por categoría.
4. **Product Detail:** Información nutricional, descripción y selección de cantidad.
5. **Cart/Checkout:** Resumen de compra y confirmación.
6. **Order History:** Seguimiento de pedidos previos y estados (Pendiente/Entregado).

---

## 8. Recomendaciones Profesionales (Senior Tips)

1. **Atomicidad:** Nunca descuentes stock y crees un pedido por separado. Usa `FirebaseFirestore.instance.runTransaction` para que ambas cosas pasen al mismo tiempo o ninguna pase.
2. **Imágenes:** No subas fotos de 10MB. Procesa las imágenes antes de subirlas al Storage para ahorrar ancho de banda y mejorar la carga en móviles.
3. **Manejo de Errores:** No uses prints. Implementa un sistema de excepciones que devuelva mensajes humanos al usuario ("No tenemos suficiente stock" en vez de "Error 404").
4. **Escalabilidad:** Mantén tus modelos de datos limpios. Si el día de mañana decides cambiar Firebase por una base de datos SQL, solo deberías cambiar la capa `data`, nunca tus pantallas.

---

**¿Deseas que procedamos a definir los Modelos de Datos en Dart (DTOs) basándonos en este plan para iniciar la construcción?**

**¿Deseas que profundicemos en el código de alguna de las entidades (como el Modelo de Producto o la Lógica del Carrito) basándonos en este plan?**
