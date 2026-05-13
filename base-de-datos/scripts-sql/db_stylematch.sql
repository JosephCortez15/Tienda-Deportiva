CREATE DATABASE IF NOT EXISTS db_stylematch;
USE db_stylematch;

CREATE TABLE roles (
    id_rol int not null auto_increment,
    nombre_rol varchar(50),
    descripcion varchar(80),
    CONSTRAINT roles_pk PRIMARY KEY (id_rol)
);

CREATE TABLE usuarios (
    id_usuario int not null auto_increment,
    id_rol int,
    nombre varchar(50),
    apellido varchar(50),
    correo varchar(60),
    contrasena varchar(100),
    fecha_registro date,
    CONSTRAINT usuarios_pk PRIMARY KEY (id_usuario)
);

CREATE TABLE perfiles_biometricos (
    id_perfil int not null auto_increment,
    id_usuario int,
    estatura decimal(5,2), -- Ej: 175.50 (cm)
    peso decimal(5,2), -- Ej: 75.50 (kg)
    tipo_cuerpo varchar(50),
    CONSTRAINT perfiles_biometricos_pk PRIMARY KEY (id_perfil)
);

CREATE TABLE categorias (
    id_categoria int not null auto_increment,
    nombre_categoria varchar(50),
    descripcion varchar(50),
    CONSTRAINT categorias_pk PRIMARY KEY (id_categoria)
);

CREATE TABLE proveedores (
    id_proveedor int not null auto_increment,
    nombre_empresa varchar(80),
    nombre_contacto varchar(80),
    numero_telefono varchar(20), 
    correo_empresa varchar(50),
    CONSTRAINT proveedores_pk PRIMARY KEY (id_proveedor)
);

CREATE TABLE productos (
    id_producto int not null auto_increment,
    id_categoria int,
    nombre varchar(50),
    marca varchar(50),
    precio_base decimal(10,2),
    descripcion_general varchar(100),
    id_proveedor int,
    CONSTRAINT productos_pk PRIMARY KEY (id_producto)
);

CREATE TABLE variantes_producto (
    id_variante int not null auto_increment,
    id_producto int,
    talla varchar(10),
    color varchar(20),
    stock_actual int, 
    CONSTRAINT variantes_producto_pk PRIMARY KEY (id_variante)
);

CREATE TABLE atributos_visuales (
    id_atributo int not null auto_increment,
    id_producto int,
    etiqueta_estilo varchar(60),
    color_hexadecimal varchar(30),
    tipo_tela varchar(30),
    CONSTRAINT atributos_visuales_pk PRIMARY KEY (id_atributo)
);

CREATE TABLE descuentos (
    id_descuento int not null auto_increment,
    codigo_promocion varchar(30), 
    porcentaje decimal(5,2),
    fecha_inicio date,
    fecha_fin date,
    activo boolean,
    CONSTRAINT descuentos_pk PRIMARY KEY (id_descuento)
);

CREATE TABLE pedidos (
    id_pedido int not null auto_increment,
    id_usuario int,
    id_descuento int,
    fecha_pedido date,
    total_pagado decimal(10,2), 
    estado_pago varchar(20),
    CONSTRAINT pedidos_pk PRIMARY KEY (id_pedido)
);

CREATE TABLE detalles_pedido (
    id_detalle int not null auto_increment,
    id_pedido int,
    id_variante int,
    cantidad int, 
    precio_unitario decimal(10,2),
    CONSTRAINT detalles_pedido_pk PRIMARY KEY (id_detalle)
);

CREATE TABLE rastreo_pedidos (
    id_rastreo int not null auto_increment,
    id_pedido int,
    estado_actual varchar(50),
    fecha_actualizacion date,
    coordenadas_gps varchar(100), 
    CONSTRAINT rastreo_pedidos_pk PRIMARY KEY (id_rastreo)
);

CREATE TABLE historial_ventas (
    id_historial int not null auto_increment,
    id_producto int,
    mes_anio date,
    cantidad_total_vendida int,
    CONSTRAINT historial_ventas_pk PRIMARY KEY (id_historial)
);

CREATE TABLE resenas_valoraciones (
    id_resena int not null auto_increment,
    id_usuario int,
    id_producto int,
    estrellas int, 
    comentario varchar(150),
    fecha date,
    CONSTRAINT resenas_valoraciones_pk PRIMARY KEY (id_resena)
);

CREATE TABLE bitacora_sistema (
    id_bitacora int not null auto_increment,
    id_usuario int,
    accion_realizada varchar(50),
    fecha_hora datetime,
    tabla_afectada varchar(50),
    CONSTRAINT bitacora_sistema_pk PRIMARY KEY (id_bitacora)
);

CREATE TABLE preferencias_estilo (
    id_preferencia int not null auto_increment,
    id_usuario int,
    id_categoria int,
    nivel_interes int,
    CONSTRAINT preferencias_estilo_pk PRIMARY KEY (id_preferencia)
);

CREATE TABLE conjuntos_sugeridos (
    id_conjunto int not null auto_increment,
    id_usuario int,
    nombre_conjunto varchar(50),
    fecha_creacion date,
    CONSTRAINT conjuntos_sugeridos_pk PRIMARY KEY (id_conjunto)
);

CREATE TABLE detalles_conjunto (
    id_conjunto int,
    id_variante int,
    CONSTRAINT detalles_conjunto_pk PRIMARY KEY (id_conjunto, id_variante)
);

CREATE TABLE imagenes_usuarios_ia (
    id_imagen int not null auto_increment,
    id_usuario int,
    ruta_archivo varchar(255), 
    etiquetas_ia_detectadas varchar(255), 
    CONSTRAINT imagenes_usuarios_ia_pk PRIMARY KEY (id_imagen)
);

CREATE TABLE lista_deseos (
    id_deseo int not null auto_increment,
    id_usuario int,
    id_producto int,
    fecha_agregado date,
    CONSTRAINT lista_deseos_pk PRIMARY KEY (id_deseo)
);

ALTER TABLE usuarios ADD CONSTRAINT fk_usuario_rol
    FOREIGN KEY (id_rol) REFERENCES roles (id_rol);

ALTER TABLE perfiles_biometricos ADD CONSTRAINT fk_biometrico_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario);

ALTER TABLE productos ADD CONSTRAINT fk_producto_categoria
    FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria);

ALTER TABLE productos ADD CONSTRAINT fk_producto_proveedor
    FOREIGN KEY (id_proveedor) REFERENCES proveedores (id_proveedor);

ALTER TABLE variantes_producto ADD CONSTRAINT fk_variante_producto
    FOREIGN KEY (id_producto) REFERENCES productos (id_producto);

ALTER TABLE atributos_visuales ADD CONSTRAINT fk_visual_producto
    FOREIGN KEY (id_producto) REFERENCES productos (id_producto);

ALTER TABLE pedidos ADD CONSTRAINT fk_pedido_descuento
    FOREIGN KEY (id_descuento) REFERENCES descuentos (id_descuento);

ALTER TABLE pedidos ADD CONSTRAINT fk_pedido_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario);

ALTER TABLE detalles_pedido ADD CONSTRAINT fk_detalle_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedido);

ALTER TABLE detalles_pedido ADD CONSTRAINT fk_detalle_variante
    FOREIGN KEY (id_variante) REFERENCES variantes_producto (id_variante);

ALTER TABLE rastreo_pedidos ADD CONSTRAINT fk_rastreo_pedido
    FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedido);

ALTER TABLE historial_ventas ADD CONSTRAINT fk_historial_producto
    FOREIGN KEY (id_producto) REFERENCES productos (id_producto);

ALTER TABLE resenas_valoraciones ADD CONSTRAINT fk_resena_producto
    FOREIGN KEY (id_producto) REFERENCES productos (id_producto);

ALTER TABLE resenas_valoraciones ADD CONSTRAINT fk_resena_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario);

ALTER TABLE bitacora_sistema ADD CONSTRAINT fk_bitacora_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario);

ALTER TABLE preferencias_estilo ADD CONSTRAINT fk_preferencia_categoria
    FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria);

ALTER TABLE preferencias_estilo ADD CONSTRAINT fk_preferencia_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario);

ALTER TABLE conjuntos_sugeridos ADD CONSTRAINT fk_conjuntos_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario);

ALTER TABLE detalles_conjunto ADD CONSTRAINT fk_detalleconjunto_variante
    FOREIGN KEY (id_variante) REFERENCES variantes_producto (id_variante);

ALTER TABLE detalles_conjunto ADD CONSTRAINT fk_detalleconjunto_conjunto
    FOREIGN KEY (id_conjunto) REFERENCES conjuntos_sugeridos (id_conjunto);

ALTER TABLE imagenes_usuarios_ia ADD CONSTRAINT fk_imagenes_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario);

ALTER TABLE lista_deseos ADD CONSTRAINT fk_deseos_producto
    FOREIGN KEY (id_producto) REFERENCES productos (id_producto);

ALTER TABLE lista_deseos ADD CONSTRAINT fk_deseos_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario);