-- ============================================================
--  BASE DE DATOS: bdpanaderia
--  Motor: MySQL 8.0
--  Descripción: Sistema de gestión integral para panadería
--  Incluye: Producción, Inventario, Ventas, RRHH, Finanzas
-- ============================================================

DROP DATABASE IF EXISTS bdpanaderia;
CREATE DATABASE bdpanaderia
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bdpanaderia;

-- ============================================================
-- SECCIÓN 1: RECURSOS HUMANOS
-- ============================================================

CREATE TABLE empleado (
    id_empleado     INT             NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(150)    NOT NULL,
    puesto          VARCHAR(80)     NOT NULL,
    telefono        VARCHAR(20)         NULL,
    email           VARCHAR(100)        NULL,
    fecha_ingreso   DATE            NOT NULL,
    salario_base    DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_empleado PRIMARY KEY (id_empleado)
) ENGINE=InnoDB;

CREATE TABLE turno (
    id_turno        INT             NOT NULL AUTO_INCREMENT,
    id_empleado     INT             NOT NULL,
    fecha           DATE            NOT NULL,
    hora_entrada    TIME            NOT NULL,
    hora_salida     TIME                NULL,
    horas_extra     DECIMAL(4,2)    NOT NULL DEFAULT 0.00,
    observaciones   TEXT                NULL,
    CONSTRAINT pk_turno     PRIMARY KEY (id_turno),
    CONSTRAINT fk_turno_emp FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE pago_nomina (
    id_pago         INT             NOT NULL AUTO_INCREMENT,
    id_empleado     INT             NOT NULL,
    periodo_inicio  DATE            NOT NULL,
    periodo_fin     DATE            NOT NULL,
    salario_base    DECIMAL(10,2)   NOT NULL,
    extras          DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    deducciones     DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    total_pago      DECIMAL(10,2)   NOT NULL,
    fecha_pago      DATE            NOT NULL,
    CONSTRAINT pk_pago_nomina     PRIMARY KEY (id_pago),
    CONSTRAINT fk_pago_nomina_emp FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- SECCIÓN 2: CATÁLOGOS BASE
-- ============================================================

CREATE TABLE ingrediente (
    id_ingrediente  INT             NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(100)    NOT NULL,
    unidad_medida   VARCHAR(20)     NOT NULL COMMENT 'kg, g, l, ml, pza',
    stock_actual    DECIMAL(10,3)   NOT NULL DEFAULT 0.000,
    stock_minimo    DECIMAL(10,3)   NOT NULL DEFAULT 0.000,
    costo_unitario  DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_ingrediente PRIMARY KEY (id_ingrediente)
) ENGINE=InnoDB;

CREATE TABLE producto (
    id_producto     INT             NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(100)    NOT NULL,
    descripcion     TEXT                NULL,
    precio_venta    DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    categoria       VARCHAR(50)     NOT NULL COMMENT 'pan, pastel, galleta, bebida, otro',
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_producto PRIMARY KEY (id_producto)
) ENGINE=InnoDB;

CREATE TABLE proveedor (
    id_proveedor    INT             NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(150)    NOT NULL,
    contacto        VARCHAR(100)        NULL,
    telefono        VARCHAR(20)         NULL,
    email           VARCHAR(100)        NULL,
    direccion       TEXT                NULL,
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor)
) ENGINE=InnoDB;

CREATE TABLE cliente (
    id_cliente      INT             NOT NULL AUTO_INCREMENT,
    nombre          VARCHAR(150)    NOT NULL,
    telefono        VARCHAR(20)         NULL,
    email           VARCHAR(100)        NULL,
    direccion       TEXT                NULL,
    tipo            ENUM('mostrador','mayorista','crédito')
                                    NOT NULL DEFAULT 'mostrador',
    saldo_credito   DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente)
) ENGINE=InnoDB;

-- ============================================================
-- SECCIÓN 3: PRODUCCIÓN
-- ============================================================

CREATE TABLE receta (
    id_receta       INT             NOT NULL AUTO_INCREMENT,
    id_producto     INT             NOT NULL,
    id_ingrediente  INT             NOT NULL,
    cantidad        DECIMAL(10,3)   NOT NULL,
    unidad_medida   VARCHAR(20)     NOT NULL,
    CONSTRAINT pk_receta        PRIMARY KEY (id_receta),
    CONSTRAINT fk_receta_prod   FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_receta_ing    FOREIGN KEY (id_ingrediente)
        REFERENCES ingrediente (id_ingrediente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_receta        UNIQUE (id_producto, id_ingrediente)
) ENGINE=InnoDB;

CREATE TABLE orden_produccion (
    id_orden            INT             NOT NULL AUTO_INCREMENT,
    id_producto         INT             NOT NULL,
    id_empleado         INT             NOT NULL,
    fecha               DATE            NOT NULL,
    cantidad_planificada INT            NOT NULL DEFAULT 0,
    cantidad_producida  INT             NOT NULL DEFAULT 0,
    estado              ENUM('pendiente','en_proceso','completada','cancelada')
                                        NOT NULL DEFAULT 'pendiente',
    CONSTRAINT pk_orden_prod        PRIMARY KEY (id_orden),
    CONSTRAINT fk_orden_prod_prod   FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_orden_prod_emp    FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- SECCIÓN 4: COMPRAS E INVENTARIO
-- ============================================================

CREATE TABLE compra_insumo (
    id_compra       INT             NOT NULL AUTO_INCREMENT,
    id_proveedor    INT             NOT NULL,
    id_empleado     INT             NOT NULL,
    fecha_compra    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total           DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    estado          ENUM('pendiente','recibida','cancelada')
                                    NOT NULL DEFAULT 'pendiente',
    num_factura     VARCHAR(50)         NULL,
    CONSTRAINT pk_compra_insumo     PRIMARY KEY (id_compra),
    CONSTRAINT fk_compra_prov       FOREIGN KEY (id_proveedor)
        REFERENCES proveedor (id_proveedor)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_compra_emp        FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE detalle_compra (
    id_detalle      INT             NOT NULL AUTO_INCREMENT,
    id_compra       INT             NOT NULL,
    id_ingrediente  INT             NOT NULL,
    cantidad        DECIMAL(10,3)   NOT NULL,
    precio_unitario DECIMAL(10,2)   NOT NULL,
    subtotal        DECIMAL(12,2)   NOT NULL,
    CONSTRAINT pk_detalle_compra    PRIMARY KEY (id_detalle),
    CONSTRAINT fk_det_compra_comp   FOREIGN KEY (id_compra)
        REFERENCES compra_insumo (id_compra)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_det_compra_ing    FOREIGN KEY (id_ingrediente)
        REFERENCES ingrediente (id_ingrediente)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- SECCIÓN 5: VENTAS
-- ============================================================

CREATE TABLE venta (
    id_venta        INT             NOT NULL AUTO_INCREMENT,
    id_cliente      INT                 NULL COMMENT 'NULL = cliente de mostrador',
    id_empleado     INT             NOT NULL,
    fecha_hora      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subtotal        DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    descuento       DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    total           DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    forma_pago      ENUM('efectivo','tarjeta','transferencia','crédito')
                                    NOT NULL DEFAULT 'efectivo',
    estado          ENUM('abierta','pagada','cancelada')
                                    NOT NULL DEFAULT 'abierta',
    CONSTRAINT pk_venta         PRIMARY KEY (id_venta),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_venta_emp     FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE detalle_venta (
    id_detalle      INT             NOT NULL AUTO_INCREMENT,
    id_venta        INT             NOT NULL,
    id_producto     INT             NOT NULL,
    cantidad        INT             NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2)   NOT NULL,
    descuento       DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    subtotal        DECIMAL(12,2)   NOT NULL,
    CONSTRAINT pk_detalle_venta     PRIMARY KEY (id_detalle),
    CONSTRAINT fk_det_venta_venta   FOREIGN KEY (id_venta)
        REFERENCES venta (id_venta)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_det_venta_prod    FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- SECCIÓN 6: FINANZAS
-- ============================================================

CREATE TABLE gasto (
    id_gasto        INT             NOT NULL AUTO_INCREMENT,
    concepto        VARCHAR(200)    NOT NULL,
    categoria       VARCHAR(60)     NOT NULL COMMENT 'renta, servicios, mantenimiento, otros',
    monto           DECIMAL(12,2)   NOT NULL,
    fecha           DATE            NOT NULL,
    id_empleado     INT                 NULL,
    comprobante     VARCHAR(100)        NULL,
    CONSTRAINT pk_gasto     PRIMARY KEY (id_gasto),
    CONSTRAINT fk_gasto_emp FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- SECCIÓN 7: ÍNDICES ADICIONALES
-- ============================================================

CREATE INDEX idx_turno_fecha        ON turno           (fecha);
CREATE INDEX idx_turno_emp          ON turno           (id_empleado);
CREATE INDEX idx_orden_fecha        ON orden_produccion (fecha);
CREATE INDEX idx_orden_estado       ON orden_produccion (estado);
CREATE INDEX idx_compra_fecha       ON compra_insumo   (fecha_compra);
CREATE INDEX idx_venta_fecha        ON venta           (fecha_hora);
CREATE INDEX idx_venta_estado       ON venta           (estado);
CREATE INDEX idx_gasto_fecha        ON gasto           (fecha);
CREATE INDEX idx_gasto_categoria    ON gasto           (categoria);
CREATE INDEX idx_ingrediente_stock  ON ingrediente     (stock_actual);

-- ============================================================
-- SECCIÓN 8: DATOS DE PRUEBA
-- ============================================================

-- Empleados
INSERT INTO empleado (nombre, puesto, telefono, email, fecha_ingreso, salario_base) VALUES
('Ana López García',     'Gerente',      '656-100-0001', 'ana.lopez@panaderia.com',   '2020-01-10', 15000.00),
('Juan Pérez Ramos',     'Panadero',     '656-100-0002', 'juan.perez@panaderia.com',  '2021-03-15',  9000.00),
('María Torres Silva',   'Vendedora',    '656-100-0003', 'maria.t@panaderia.com',     '2022-06-01',  8500.00),
('Carlos Díaz Mendez',   'Panadero',     '656-100-0004', NULL,                        '2023-01-20',  9000.00),
('Sofía Ruiz Castro',    'Repartidora',  '656-100-0005', NULL,                        '2023-09-05',  8000.00);

-- Ingredientes
INSERT INTO ingrediente (nombre, unidad_medida, stock_actual, stock_minimo, costo_unitario) VALUES
('Harina de trigo',     'kg',   150.000,  30.000,  12.50),
('Azúcar blanca',       'kg',    80.000,  15.000,  14.00),
('Mantequilla',         'kg',    25.000,   5.000,  80.00),
('Huevo',               'pza',  200.000,  50.000,   3.50),
('Leche entera',        'l',     40.000,  10.000,  18.00),
('Levadura seca',       'g',   1500.000, 300.000,   0.25),
('Sal',                 'kg',    10.000,   2.000,   8.00),
('Cacao en polvo',      'kg',     5.000,   1.000,  95.00),
('Canela molida',       'g',    500.000, 100.000,   0.18),
('Esencia de vainilla', 'ml',   250.000,  50.000,   0.50);

-- Productos
INSERT INTO producto (nombre, descripcion, precio_venta, categoria) VALUES
('Pan blanco',          'Pan de mesa estándar, barra de 500g',          22.00, 'pan'),
('Conchas',             'Pan dulce de concha con azúcar de colores',      8.00, 'pan'),
('Cuernos de mantequilla', 'Cuernos hojaldrados con mantequilla',        10.00, 'pan'),
('Pastel de chocolate', 'Pastel esponjoso cubierto con ganache',         350.00, 'pastel'),
('Pastel tres leches',  'Pastel húmedo bañado en tres tipos de leche',   320.00, 'pastel'),
('Galletas de canela',  'Galletas crujientes con canela y azúcar',         5.00, 'galleta'),
('Cupcake de vainilla', 'Cupcake esponjoso con betún de vainilla',        25.00, 'pastel');

-- Recetas (ingredientes por unidad/pieza)
INSERT INTO receta (id_producto, id_ingrediente, cantidad, unidad_medida) VALUES
(1, 1, 0.500, 'kg'), (1, 7, 0.010, 'kg'), (1, 6, 3.000, 'g'),  (1, 5, 0.300, 'l'),
(2, 1, 0.100, 'kg'), (2, 2, 0.080, 'kg'), (2, 3, 0.040, 'kg'), (2, 4, 1.000, 'pza'),
(3, 1, 0.120, 'kg'), (3, 3, 0.060, 'kg'), (3, 2, 0.050, 'kg'), (3, 4, 1.000, 'pza'),
(6, 1, 0.050, 'kg'), (6, 2, 0.040, 'kg'), (6, 9, 2.000, 'g');

-- Proveedor
INSERT INTO proveedor (nombre, contacto, telefono, email, direccion) VALUES
('Molinos del Norte S.A.',   'Roberto Soto',  '800-555-0001', 'ventas@molinosnorte.mx',  'Av. Industrial 100, Cd. Juárez'),
('Lácteos La Vaquita',       'Carmen Iglesias','800-555-0002', 'pedidos@lavaquita.mx',    'Blvd. Díaz Ordaz 45, Chihuahua'),
('Distribuidora Dulce',      'Ernesto Vega',  '800-555-0003', 'dulce@distrib.mx',        'Calle Reforma 78, Juárez');

-- Clientes
INSERT INTO cliente (nombre, telefono, email, tipo, saldo_credito) VALUES
('Restaurante El Mesón',   '656-200-0010', 'compras@elmeson.com',  'mayorista', 0.00),
('Cafetería Central',      '656-200-0011', 'cafe.central@mx.com',  'crédito',  500.00),
('Laura Martínez',         '656-200-0012', NULL,                   'mostrador', 0.00);

-- Orden de producción (ejemplo)
INSERT INTO orden_produccion (id_producto, id_empleado, fecha, cantidad_planificada, cantidad_producida, estado) VALUES
(1, 2, CURDATE(), 100, 100, 'completada'),
(2, 2, CURDATE(),  80,  75, 'completada'),
(4, 4, CURDATE(),   5,   0, 'pendiente');

-- Compra de insumos
INSERT INTO compra_insumo (id_proveedor, id_empleado, fecha_compra, total, estado, num_factura) VALUES
(1, 1, NOW(), 2875.00, 'recibida', 'FAC-2026-001');

INSERT INTO detalle_compra (id_compra, id_ingrediente, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 200.000, 12.50, 2500.00),
(1, 7,   5.000,  8.00,   40.00),
(1, 6, 1340.000, 0.25,  335.00);

-- Venta de mostrador
INSERT INTO venta (id_cliente, id_empleado, fecha_hora, subtotal, descuento, total, forma_pago, estado) VALUES
(NULL, 3, NOW(), 86.00, 0.00, 86.00, 'efectivo', 'pagada'),
(1,    3, NOW(), 660.00, 60.00, 600.00, 'transferencia', 'pagada');

INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, descuento, subtotal) VALUES
(1, 2, 5,  8.00, 0.00,  40.00),
(1, 3, 3, 10.00, 0.00,  30.00),
(1, 6, 2,  5.00, 0.00,  10.00),
(1, 7, 1, 25.00, 0.00,  25.00) -- corregido: subtotal cambiado a 25
;

INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, descuento, subtotal) VALUES
(2, 4, 1, 350.00, 30.00, 320.00),
(2, 5, 1, 320.00, 30.00, 290.00);

-- Gastos
INSERT INTO gasto (concepto, categoria, monto, fecha, id_empleado) VALUES
('Renta local mayo 2026',       'renta',        8500.00, '2026-05-01', 1),
('Electricidad abril 2026',     'servicios',    1250.00, '2026-05-05', 1),
('Gas LP para hornos',          'servicios',     870.00, '2026-05-07', 1),
('Mantenimiento horno #2',      'mantenimiento', 600.00, '2026-05-09', 2);

-- Turnos
INSERT INTO turno (id_empleado, fecha, hora_entrada, hora_salida, horas_extra) VALUES
(2, CURDATE(), '04:00:00', '12:00:00', 0.00),
(4, CURDATE(), '04:00:00', '12:00:00', 0.00),
(3, CURDATE(), '08:00:00', '16:00:00', 0.00),
(5, CURDATE(), '09:00:00', '17:00:00', 1.50);

-- ============================================================
-- FIN DEL SCRIPT  •  bdpanaderia  •  MySQL 8.0
-- ============================================================
