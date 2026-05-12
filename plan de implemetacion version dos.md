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

**¿Deseas que profundicemos en el código de alguna de las entidades (como el Modelo de Producto o la Lógica del Carrito) basándonos en este plan?**
