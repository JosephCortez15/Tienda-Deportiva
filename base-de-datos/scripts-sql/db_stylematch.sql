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

/*
 * ============================================
 * VISTAS
 * ============================================
 */

create view v_usuarios_roles
as
select u.id_usuario,
concat(u.nombre," ",u.apellido) as Usuario,
r.nombre_rol as Rol,
u.correo,
u.fecha_registro
from usuarios u
inner join roles r
on u.id_rol = r.id_rol;


create view v_productos
as
select p.id_producto,
p.nombre as Producto,
p.marca,
c.nombre_categoria as Categoria,
pr.nombre_empresa as Proveedor,
p.precio_base
from productos p
inner join categorias c
on p.id_categoria = c.id_categoria
inner join proveedores pr
on p.id_proveedor = pr.id_proveedor;


create view v_variantes
as
select vp.id_variante,
p.nombre as Producto,
vp.talla,
vp.color,
vp.stock_actual
from variantes_producto vp
inner join productos p
on vp.id_producto = p.id_producto;


create view v_pedidos
as
select pe.id_pedido,
concat(u.nombre," ",u.apellido) as Cliente,
pe.fecha_pedido,
pe.total_pagado,
pe.estado_pago
from pedidos pe
inner join usuarios u
on pe.id_usuario = u.id_usuario;


create view v_detalle_pedidos
as
select dp.id_detalle,
pe.id_pedido,
p.nombre as Producto,
vp.color,
vp.talla,
dp.cantidad,
dp.precio_unitario
from detalles_pedido dp
inner join pedidos pe
on dp.id_pedido = pe.id_pedido
inner join variantes_producto vp
on dp.id_variante = vp.id_variante
inner join productos p
on vp.id_producto = p.id_producto;


create view v_resenas
as
select r.id_resena,
concat(u.nombre," ",u.apellido) as Usuario,
p.nombre as Producto,
r.estrellas,
r.comentario,
r.fecha
from resenas_valoraciones r
inner join usuarios u
on r.id_usuario = u.id_usuario
inner join productos p
on r.id_producto = p.id_producto;


create view v_productos_estilo
as
select p.nombre as Producto,
p.marca,
a.etiqueta_estilo,
a.tipo_tela,
a.color_hexadecimal
from productos p
inner join atributos_visuales a
on p.id_producto = a.id_producto;


create view v_lista_deseos
as
select concat(u.nombre," ",u.apellido) as Usuario,
p.nombre as Producto,
l.fecha_agregado
from lista_deseos l
inner join usuarios u
on l.id_usuario = u.id_usuario
inner join productos p
on l.id_producto = p.id_producto;


create view v_historial_ventas
as
select p.nombre as Producto,
h.mes_anio,
h.cantidad_total_vendida
from historial_ventas h
inner join productos p
on h.id_producto = p.id_producto;


create view v_rastreo_pedidos
as
select pe.id_pedido,
concat(u.nombre," ",u.apellido) as Cliente,
r.estado_actual,
r.fecha_actualizacion,
r.coordenadas_gps
from rastreo_pedidos r
inner join pedidos pe
on r.id_pedido = pe.id_pedido
inner join usuarios u
on pe.id_usuario = u.id_usuario;


create view v_preferencias
as
select concat(u.nombre," ",u.apellido) as Usuario,
c.nombre_categoria,
p.nivel_interes
from preferencias_estilo p
inner join usuarios u
on p.id_usuario = u.id_usuario
inner join categorias c
on p.id_categoria = c.id_categoria;


create view v_conjuntos
as
select c.nombre_conjunto,
concat(u.nombre," ",u.apellido) as Usuario,
c.fecha_creacion
from conjuntos_sugeridos c
inner join usuarios u
on c.id_usuario = u.id_usuario;


create view v_cantidad_productos
as
select pe.id_pedido,
count(dp.id_variante) as Cantidad_Productos,
pe.total_pagado
from pedidos pe
inner join detalles_pedido dp
on pe.id_pedido = dp.id_pedido
group by pe.id_pedido;
/*
 * ============================================
 * PROCEDIMIENTOS
 * ============================================
 */

create procedure p_buscar_usuario(
	in nom varchar(50)
)
begin
	select u.id_usuario,
	concat(u.nombre," ",u.apellido) as Usuario,
	r.nombre_rol as Rol,
	u.correo
	from usuarios u
	inner join roles r
	on u.id_rol = r.id_rol
	where u.nombre = nom;
end;


create procedure p_productos_categoria(
	in categoria varchar(50)
)
begin
	select p.id_producto,
	p.nombre as Producto,
	p.marca,
	c.nombre_categoria,
	p.precio_base
	from productos p
	inner join categorias c
	on p.id_categoria = c.id_categoria
	where c.nombre_categoria = categoria;
end;


create procedure p_buscar_pedido(
	in idP int
)
begin
	select pe.id_pedido,
	concat(u.nombre," ",u.apellido) as Cliente,
	pe.total_pagado,
	pe.estado_pago
	from pedidos pe
	inner join usuarios u
	on pe.id_usuario = u.id_usuario
	where pe.id_pedido = idP;
end;


create procedure p_insertar_usuario(
	in idRol int,
	in nom varchar(50),
	in ape varchar(50),
	in correoU varchar(60),
	in contra varchar(100),
	in fechaR date
)
begin
	insert into usuarios(
	id_rol,
	nombre,
	apellido,
	correo,
	contrasena,
	fecha_registro
	)
	values(
	idRol,
	nom,
	ape,
	correoU,
	contra,
	fechaR
	);
end;


create procedure p_editar_usuario(
	in nombre_original varchar(50),
	in nombre_nuevo varchar(50)
)
begin
	update usuarios
	set nombre = nombre_nuevo
	where nombre = nombre_original;
end;


create procedure p_borrar_usuario(
	in idU int
)
begin
	delete
	from usuarios
	where id_usuario = idU;
end;


create procedure p_insertar_producto(
	in idCat int,
	in nom varchar(50),
	in marcaP varchar(50),
	in precio decimal(10,2),
	in descripcionP varchar(100),
	in idProv int
)
begin
	insert into productos(
	id_categoria,
	nombre,
	marca,
	precio_base,
	descripcion_general,
	id_proveedor
	)
	values(
	idCat,
	nom,
	marcaP,
	precio,
	descripcionP,
	idProv
	);
end;


create procedure p_editar_precio_producto(
	in idProd int,
	in nuevo_precio decimal(10,2)
)
begin
	update productos
	set precio_base = nuevo_precio
	where id_producto = idProd;
end;


create procedure p_borrar_producto(
	in idProd int
)
begin
	delete
	from productos
	where id_producto = idProd;
end;


create procedure p_cantidad_productos(
	in idPedido int
)
begin
	select pe.id_pedido,
	count(dp.id_variante) as Cantidad_Productos,
	pe.total_pagado
	from pedidos pe
	inner join detalles_pedido dp
	on pe.id_pedido = dp.id_pedido
	where pe.id_pedido = idPedido
	group by pe.id_pedido;
end;


create procedure p_lista_deseos_usuario(
	in nom varchar(50)
)
begin
	select concat(u.nombre," ",u.apellido) as Usuario,
	p.nombre as Producto,
	l.fecha_agregado
	from lista_deseos l
	inner join usuarios u
	on l.id_usuario = u.id_usuario
	inner join productos p
	on l.id_producto = p.id_producto
	where u.nombre = nom;
end;


create procedure p_rastreo_pedido(
	in idPed int
)
begin
	select pe.id_pedido,
	r.estado_actual,
	r.fecha_actualizacion,
	r.coordenadas_gps
	from rastreo_pedidos r
	inner join pedidos pe
	on r.id_pedido = pe.id_pedido
	where pe.id_pedido = idPed;
end;


create procedure p_resenas_producto(
	in producto varchar(50)
)
begin
	select p.nombre as Producto,
	r.estrellas,
	r.comentario,
	r.fecha
	from resenas_valoraciones r
	inner join productos p
	on r.id_producto = p.id_producto
	where p.nombre = producto;
end;


 * ÁLGEBRA RELACIONAL — STYLEMATCH



/*
 * Usuarios y Roles
 */

π id_usuario,nombre,apellido,nombre_rol,correo (
usuarios ⨝ roles
)


/*
 * Usuarios registrados
 */

π nombre,apellido,correo,fecha_registro (
usuarios
)


/*
 * Perfiles biométricos
 */

π id_usuario,estatura,peso,tipo_cuerpo (
perfiles_biometricos
)


/*
 * Productos con categoría y proveedor
 */

π id_producto,nombre,marca,nombre_categoria,nombre_empresa,precio_base (
productos ⨝ categorias ⨝ proveedores
)


/*
 * Variantes de productos
 */

π id_variante,nombre,talla,color,stock_actual (
variantes_producto ⨝ productos
)


/*
 * Productos y atributos visuales
 */

π nombre,marca,etiqueta_estilo,tipo_tela,color_hexadecimal (
productos ⨝ atributos_visuales
)


/*
 * Productos con stock bajo
 */

σ stock_actual < 10 (
variantes_producto
)


/*
 * Pedidos realizados
 */

π id_pedido,nombre,apellido,fecha_pedido,total_pagado,estado_pago (
pedidos ⨝ usuarios
)


/*
 * Pedidos con descuentos
 */

π id_pedido,codigo_promocion,porcentaje,total_pagado (
pedidos ⨝ descuentos
)


/*
 * Detalle de pedidos
 */

π id_detalle,id_pedido,nombre,color,talla,cantidad,precio_unitario (
detalles_pedido ⨝ variantes_producto ⨝ productos
)


/*
 * Rastreo de pedidos
 */

π id_pedido,estado_actual,fecha_actualizacion,coordenadas_gps (
rastreo_pedidos ⨝ pedidos
)


/*
 * Historial de ventas
 */

π nombre,mes_anio,cantidad_total_vendida (
historial_ventas ⨝ productos
)


/*
 * Reseñas y valoraciones
 */

π id_resena,nombre,apellido,estrellas,comentario,fecha (
resenas_valoraciones ⨝ usuarios ⨝ productos
)


/*
 * Preferencias de estilo
 */

π nombre,apellido,nombre_categoria,nivel_interes (
preferencias_estilo ⨝ usuarios ⨝ categorias
)


/*
 * Conjuntos sugeridos
 */

π nombre_conjunto,nombre,apellido,fecha_creacion (
conjuntos_sugeridos ⨝ usuarios
)


/*
 * Detalle de conjuntos
 */

π id_conjunto,nombre,talla,color (
detalles_conjunto ⨝ variantes_producto ⨝ productos
)


/*
 * Imágenes procesadas por IA
 */

π id_imagen,nombre,apellido,ruta_archivo,etiquetas_ia_detectadas (
imagenes_usuarios_ia ⨝ usuarios
)


/*
 * Lista de deseos
 */

π nombre,apellido,nombre,fecha_agregado (
lista_deseos ⨝ usuarios ⨝ productos
)


/*
 * Cantidad de productos por pedido
 */

γ id_pedido, COUNT(id_variante), total_pagado (
pedidos ⨝ detalles_pedido
)


/*
 * Productos más vendidos
 */

γ id_producto, SUM(cantidad_total_vendida) (
historial_ventas
)


/*
 * Productos mejor valorados
 */

γ id_producto, AVG(estrellas) (
resenas_valoraciones
)

 * SELECCIONES
 


/*
 * Buscar usuario
 */

σ nombre = 'Juan' (
usuarios
)


/*
 * Buscar productos por categoría
 */

σ nombre_categoria = 'Poleras' (
productos ⨝ categorias
)


/*
 * Buscar pedidos pagados
 */

σ estado_pago = 'Pagado' (
pedidos
)


/*
 * Buscar productos Nike
 */

σ marca = 'Nike' (
productos
)


/*
 * Buscar productos negros
 */

σ color = 'Negro' (
variantes_producto
)


/*
 * Buscar reseñas de 5 estrellas
 */

σ estrellas = 5 (
resenas_valoraciones
)


/*
 * Buscar pedidos de un usuario
 */

σ id_usuario = 1 (
pedidos
)


/*
 * Buscar lista de deseos de usuario
 */

σ id_usuario = 1 (
lista_deseos
)


/*
 * Buscar productos baratos
 */

σ precio_base < 100 (
productos
)


/*
 * Buscar productos caros
 */

σ precio_base > 500 (
productos
)
