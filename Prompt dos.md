
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
