-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-05-2026 a las 18:20:28
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tienda_ropa`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_precio_producto` (IN `p_id_producto` INT, IN `p_nuevo_precio_compra` DECIMAL(10,2), IN `p_nuevo_precio_venta` DECIMAL(10,2))   insert into historial_precios (id_producto, fecha, precio_compra, precio_venta)
values (p_id_producto, curdate(), p_nuevo_precio_compra, p_nuevo_precio_venta)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_stock` (IN `p_id_variante` INT, IN `p_cantidad` INT)   update variantes_producto
set stock_actual = stock_actual + p_cantidad
where id_variante = p_id_variante$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_wishlist` (IN `p_id_usuario` INT, IN `p_id_variante` INT)   insert into lista_deseos (id_usuario, id_variante, fecha_agregado)
values (p_id_usuario, p_id_variante, curdate())$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_wishlist` (IN `p_id_wish` INT)   delete from lista_deseos
where id_wish = p_id_wish$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_devolucion` (IN `p_id_detalle` INT, IN `p_motivo` VARCHAR(150))   insert into devoluciones (id_detalle, fecha, motivo, estado)
values (p_id_detalle, curdate(), p_motivo, 'pendiente')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_producto` (IN `p_nombre` VARCHAR(50), IN `p_marca` VARCHAR(50), IN `p_id_categoria` INT, IN `p_id_proveedor` INT, IN `p_descripcion` VARCHAR(200))   insert into productos (nombre, marca, id_categoria, id_proveedor, descripcion_general)
values (p_nombre, p_marca, p_id_categoria, p_id_proveedor, p_descripcion)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_resena` (IN `p_id_usuario` INT, IN `p_id_producto` INT, IN `p_estrellas` TINYINT, IN `p_comentario` VARCHAR(150))   insert into resenas_valoraciones (id_usuario, id_producto, estrellas, comentario, fecha)
values (p_id_usuario, p_id_producto, p_estrellas, p_comentario, curdate())$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `contar_compras_cliente` (`p_id_usuario` INT) RETURNS INT(11)  return (
    select count(*)
    from pedidos
    where id_usuario = p_id_usuario
)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `descuento_producto` (`p_id_producto` INT) RETURNS DECIMAL(5,2)  return (
    select coalesce(max(d.porcentaje), 0)
    from pedidos pe
    join descuentos d on pe.id_descuento = d.id_descuento
    join detalles_pedido dp on pe.id_pedido = dp.id_pedido
    join variantes_producto v on dp.id_variante = v.id_variante
    where v.id_producto = p_id_producto
    and d.activo = true
    and d.fecha_inicio <= curdate()
    and d.fecha_fin >= curdate()
)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `precio_actual_producto` (`p_id_producto` INT) RETURNS DECIMAL(10,2)  return (
    select precio_venta
    from historial_precios
    where id_producto = p_id_producto
    order by fecha desc
    limit 1
)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `precio_con_puntos` (`p_id_producto` INT, `p_puntos_usuario` INT) RETURNS DECIMAL(10,2)  return (
    select precio_venta * (1 - (floor(p_puntos_usuario / 100) * 0.15))
    from historial_precios
    where id_producto = p_id_producto
    order by fecha desc
    limit 1
)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `puede_canjear` (`p_id_usuario` INT, `p_puntos_necesarios` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  return (
    select case
        when coalesce(puntos_actuales, 0) >= p_puntos_necesarios then 'SI'
        else 'NO'
    end
    from puntos_usuario
    where id_usuario = p_id_usuario
)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `stock_disponible` (`p_id_variante` INT) RETURNS INT(11)  return (
    select stock_actual
    from variantes_producto
    where id_variante = p_id_variante
)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_pedido` (`p_id_pedido` INT) RETURNS DECIMAL(10,2)  return (
    select sum(subtotal)
    from detalles_pedido
    where id_pedido = p_id_pedido
)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_productos_comprados` (`p_id_usuario` INT) RETURNS INT(11)  return (
    select sum(dp.cantidad)
    from detalles_pedido dp
    join pedidos p on dp.id_pedido = p.id_pedido
    where p.id_usuario = p_id_usuario
)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `atributos_visuales`
--

CREATE TABLE `atributos_visuales` (
  `id_atributo` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `color_hexadecimal` varchar(7) NOT NULL,
  `tipo_tela` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora_sistema`
--

CREATE TABLE `bitacora_sistema` (
  `id_bitacora` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `accion_realizada` varchar(50) NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `tabla_afectada` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `nombre_categoria` varchar(50) NOT NULL,
  `descripcion` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `categorias`
--
DELIMITER $$
CREATE TRIGGER `validar_eliminar_categoria` BEFORE DELETE ON `categorias` FOR EACH ROW begin
    if (select count(*) from productos where id_categoria = old.id_categoria) > 0 then
        signal sqlstate '45000' set message_text = 'Error: No se puede eliminar la categoria porque tiene productos asociados';
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cupones_puntos`
--

CREATE TABLE `cupones_puntos` (
  `id_cupon` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `codigo_cupon` varchar(30) NOT NULL,
  `porcentaje_descuento` decimal(5,2) NOT NULL,
  `fecha_expiracion` date NOT NULL,
  `usado` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cupon_productos_wishlist`
--

CREATE TABLE `cupon_productos_wishlist` (
  `id_cupon` int(11) NOT NULL,
  `id_variante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuentos`
--

CREATE TABLE `descuentos` (
  `id_descuento` int(11) NOT NULL,
  `codigo_promo` varchar(30) NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `descuentos`
--
DELIMITER $$
CREATE TRIGGER `validar_porcentaje_descuento` BEFORE INSERT ON `descuentos` FOR EACH ROW begin
    if new.porcentaje > 50 then
        signal sqlstate '45000' set message_text = 'Error: El descuento no puede ser mayor al 50%';
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalles_pedido`
--

CREATE TABLE `detalles_pedido` (
  `id_detalle` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_variante` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `detalles_pedido`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_venta` AFTER INSERT ON `detalles_pedido` FOR EACH ROW begin
    update variantes_producto
    set stock_actual = stock_actual - new.cantidad
    where id_variante = new.id_variante;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validar_stock_venta` BEFORE INSERT ON `detalles_pedido` FOR EACH ROW begin
    if new.cantidad > (select stock_actual from variantes_producto where id_variante = new.id_variante) then
        signal sqlstate '45000' set message_text = 'Error: Stock insuficiente';
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `id_devolucion` int(11) NOT NULL,
  `id_detalle` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `motivo` varchar(150) NOT NULL,
  `estado` varchar(30) NOT NULL DEFAULT 'pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `devoluciones`
--
DELIMITER $$
CREATE TRIGGER `recuperar_stock_devolucion` AFTER INSERT ON `devoluciones` FOR EACH ROW begin
    update variantes_producto v
    join detalles_pedido dp on v.id_variante = dp.id_variante
    set v.stock_actual = v.stock_actual + dp.cantidad
    where dp.id_detalle = new.id_detalle;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `etiquetas`
--

CREATE TABLE `etiquetas` (
  `id_etiqueta` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_precios`
--

CREATE TABLE `historial_precios` (
  `id_historial_precio` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_puntos`
--

CREATE TABLE `historial_puntos` (
  `id_historial` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `puntos_cantidad` int(11) NOT NULL,
  `concepto` varchar(100) NOT NULL,
  `fecha` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_ventas`
--

CREATE TABLE `historial_ventas` (
  `id_historial` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `mes_anio` date NOT NULL,
  `cantidad_total_vendida` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lista_deseos`
--

CREATE TABLE `lista_deseos` (
  `id_wish` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_variante` int(11) NOT NULL,
  `fecha_agregado` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_descuento` int(11) DEFAULT NULL,
  `fecha_pedido` date NOT NULL,
  `total_pagado` decimal(10,2) NOT NULL,
  `estado_pago` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preferencias_estilo`
--

CREATE TABLE `preferencias_estilo` (
  `id_preferencia` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `nivel_interes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `marca` varchar(50) NOT NULL,
  `descripcion_general` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `productos`
--
DELIMITER $$
CREATE TRIGGER `bitacora_eliminar_producto` AFTER DELETE ON `productos` FOR EACH ROW begin
    insert into bitacora_sistema (id_usuario, accion_realizada, fecha_hora, tabla_afectada)
    values (1, concat('Eliminó producto: ', old.nombre), now(), 'productos');
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_etiquetas`
--

CREATE TABLE `producto_etiquetas` (
  `id_producto` int(11) NOT NULL,
  `id_etiqueta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nombre_empresa` varchar(80) NOT NULL,
  `nombre_contacto` varchar(80) NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `correo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puntos_usuario`
--

CREATE TABLE `puntos_usuario` (
  `id_puntos` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `puntos_actuales` int(11) NOT NULL DEFAULT 0,
  `puntos_totales_ganados` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resenas_valoraciones`
--

CREATE TABLE `resenas_valoraciones` (
  `id_resena` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `estrellas` tinyint(4) NOT NULL,
  `comentario` varchar(150) NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `resenas_valoraciones`
--
DELIMITER $$
CREATE TRIGGER `validar_estrellas_resena` BEFORE INSERT ON `resenas_valoraciones` FOR EACH ROW begin
    if new.estrellas < 1 or new.estrellas > 5 then
        signal sqlstate '45000' set message_text = 'Error: Las estrellas deben ser entre 1 y 5';
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL,
  `descripcion` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `correo` varchar(60) DEFAULT NULL,
  `contrasenia` varchar(255) NOT NULL,
  `fecha_registro` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `variantes_producto`
--

CREATE TABLE `variantes_producto` (
  `id_variante` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `talla` varchar(10) NOT NULL,
  `color` varchar(20) NOT NULL,
  `stock_actual` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `variantes_producto`
--
DELIMITER $$
CREATE TRIGGER `bitacora_cambio_stock` AFTER UPDATE ON `variantes_producto` FOR EACH ROW begin
    if old.stock_actual != new.stock_actual then
        insert into bitacora_sistema (id_usuario, accion_realizada, fecha_hora, tabla_afectada)
        values (1, concat('Stock cambiado de ', old.stock_actual, ' a ', new.stock_actual, ' en variante ', new.id_variante), now(), 'variantes_producto');
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_descuentos_activos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_descuentos_activos` (
`id_descuento` int(11)
,`codigo_promo` varchar(30)
,`porcentaje` decimal(5,2)
,`fecha_inicio` date
,`fecha_fin` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_historial_cliente`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_historial_cliente` (
`id_usuario` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`id_pedido` int(11)
,`fecha_pedido` date
,`total_pagado` decimal(10,2)
,`estado_pago` varchar(20)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_productos_disponibles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_productos_disponibles` (
`id_producto` int(11)
,`nombre` varchar(50)
,`marca` varchar(50)
,`talla` varchar(10)
,`color` varchar(20)
,`stock_actual` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_productos_mejor_valorados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_productos_mejor_valorados` (
`id_producto` int(11)
,`nombre` varchar(50)
,`marca` varchar(50)
,`promedio_estrellas` decimal(5,1)
,`total_resenas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_productos_por_etiqueta`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_productos_por_etiqueta` (
`etiqueta` varchar(30)
,`id_producto` int(11)
,`nombre` varchar(50)
,`marca` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_puntos_usuario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_puntos_usuario` (
`id_usuario` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`puntos_actuales` int(11)
,`puntos_totales_ganados` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_stock_bajo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_stock_bajo` (
`id_producto` int(11)
,`nombre` varchar(50)
,`marca` varchar(50)
,`talla` varchar(10)
,`color` varchar(20)
,`stock_actual` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_top_productos_vendidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_top_productos_vendidos` (
`id_producto` int(11)
,`nombre` varchar(50)
,`marca` varchar(50)
,`total_vendido` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_ventas_hoy`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_ventas_hoy` (
`id_pedido` int(11)
,`nombre` varchar(50)
,`apellido` varchar(50)
,`fecha_pedido` date
,`total_pagado` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_descuentos_activos`
--
DROP TABLE IF EXISTS `vista_descuentos_activos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_descuentos_activos`  AS SELECT `descuentos`.`id_descuento` AS `id_descuento`, `descuentos`.`codigo_promo` AS `codigo_promo`, `descuentos`.`porcentaje` AS `porcentaje`, `descuentos`.`fecha_inicio` AS `fecha_inicio`, `descuentos`.`fecha_fin` AS `fecha_fin` FROM `descuentos` WHERE `descuentos`.`activo` = 1 AND `descuentos`.`fecha_inicio` <= curdate() AND `descuentos`.`fecha_fin` >= curdate() ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_historial_cliente`
--
DROP TABLE IF EXISTS `vista_historial_cliente`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_historial_cliente`  AS SELECT `u`.`id_usuario` AS `id_usuario`, `u`.`nombre` AS `nombre`, `u`.`apellido` AS `apellido`, `p`.`id_pedido` AS `id_pedido`, `p`.`fecha_pedido` AS `fecha_pedido`, `p`.`total_pagado` AS `total_pagado`, `p`.`estado_pago` AS `estado_pago` FROM (`usuarios` `u` join `pedidos` `p` on(`u`.`id_usuario` = `p`.`id_usuario`)) ORDER BY `u`.`id_usuario` ASC, `p`.`fecha_pedido` DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_productos_disponibles`
--
DROP TABLE IF EXISTS `vista_productos_disponibles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_productos_disponibles`  AS SELECT `p`.`id_producto` AS `id_producto`, `p`.`nombre` AS `nombre`, `p`.`marca` AS `marca`, `v`.`talla` AS `talla`, `v`.`color` AS `color`, `v`.`stock_actual` AS `stock_actual` FROM (`productos` `p` join `variantes_producto` `v` on(`p`.`id_producto` = `v`.`id_producto`)) WHERE `v`.`stock_actual` > 0 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_productos_mejor_valorados`
--
DROP TABLE IF EXISTS `vista_productos_mejor_valorados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_productos_mejor_valorados`  AS SELECT `p`.`id_producto` AS `id_producto`, `p`.`nombre` AS `nombre`, `p`.`marca` AS `marca`, round(avg(`r`.`estrellas`),1) AS `promedio_estrellas`, count(`r`.`id_resena`) AS `total_resenas` FROM (`productos` `p` join `resenas_valoraciones` `r` on(`p`.`id_producto` = `r`.`id_producto`)) GROUP BY `p`.`id_producto`, `p`.`nombre`, `p`.`marca` HAVING avg(`r`.`estrellas`) >= 4 ORDER BY round(avg(`r`.`estrellas`),1) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_productos_por_etiqueta`
--
DROP TABLE IF EXISTS `vista_productos_por_etiqueta`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_productos_por_etiqueta`  AS SELECT `e`.`nombre` AS `etiqueta`, `p`.`id_producto` AS `id_producto`, `p`.`nombre` AS `nombre`, `p`.`marca` AS `marca` FROM ((`etiquetas` `e` join `producto_etiquetas` `pe` on(`e`.`id_etiqueta` = `pe`.`id_etiqueta`)) join `productos` `p` on(`pe`.`id_producto` = `p`.`id_producto`)) ORDER BY `e`.`nombre` ASC, `p`.`nombre` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_puntos_usuario`
--
DROP TABLE IF EXISTS `vista_puntos_usuario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_puntos_usuario`  AS SELECT `u`.`id_usuario` AS `id_usuario`, `u`.`nombre` AS `nombre`, `u`.`apellido` AS `apellido`, `pu`.`puntos_actuales` AS `puntos_actuales`, `pu`.`puntos_totales_ganados` AS `puntos_totales_ganados` FROM (`usuarios` `u` left join `puntos_usuario` `pu` on(`u`.`id_usuario` = `pu`.`id_usuario`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_stock_bajo`
--
DROP TABLE IF EXISTS `vista_stock_bajo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_stock_bajo`  AS SELECT `p`.`id_producto` AS `id_producto`, `p`.`nombre` AS `nombre`, `p`.`marca` AS `marca`, `v`.`talla` AS `talla`, `v`.`color` AS `color`, `v`.`stock_actual` AS `stock_actual` FROM (`productos` `p` join `variantes_producto` `v` on(`p`.`id_producto` = `v`.`id_producto`)) WHERE `v`.`stock_actual` < 5 ORDER BY `v`.`stock_actual` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_top_productos_vendidos`
--
DROP TABLE IF EXISTS `vista_top_productos_vendidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_top_productos_vendidos`  AS SELECT `p`.`id_producto` AS `id_producto`, `p`.`nombre` AS `nombre`, `p`.`marca` AS `marca`, sum(`dp`.`cantidad`) AS `total_vendido` FROM ((`detalles_pedido` `dp` join `variantes_producto` `v` on(`dp`.`id_variante` = `v`.`id_variante`)) join `productos` `p` on(`v`.`id_producto` = `p`.`id_producto`)) GROUP BY `p`.`id_producto`, `p`.`nombre`, `p`.`marca` ORDER BY sum(`dp`.`cantidad`) DESC LIMIT 0, 10 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_ventas_hoy`
--
DROP TABLE IF EXISTS `vista_ventas_hoy`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_ventas_hoy`  AS SELECT `p`.`id_pedido` AS `id_pedido`, `u`.`nombre` AS `nombre`, `u`.`apellido` AS `apellido`, `p`.`fecha_pedido` AS `fecha_pedido`, `p`.`total_pagado` AS `total_pagado` FROM (`pedidos` `p` join `usuarios` `u` on(`p`.`id_usuario` = `u`.`id_usuario`)) WHERE `p`.`fecha_pedido` = curdate() ORDER BY `p`.`id_pedido` DESC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `atributos_visuales`
--
ALTER TABLE `atributos_visuales`
  ADD PRIMARY KEY (`id_atributo`),
  ADD KEY `fk_atributos_productos` (`id_producto`);

--
-- Indices de la tabla `bitacora_sistema`
--
ALTER TABLE `bitacora_sistema`
  ADD PRIMARY KEY (`id_bitacora`),
  ADD KEY `fk_bitacora_usuarios` (`id_usuario`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `cupones_puntos`
--
ALTER TABLE `cupones_puntos`
  ADD PRIMARY KEY (`id_cupon`),
  ADD UNIQUE KEY `codigo_cupon` (`codigo_cupon`),
  ADD KEY `fk_cupones_usuarios` (`id_usuario`);

--
-- Indices de la tabla `cupon_productos_wishlist`
--
ALTER TABLE `cupon_productos_wishlist`
  ADD PRIMARY KEY (`id_cupon`,`id_variante`),
  ADD KEY `fk_cupones_productos_variante` (`id_variante`);

--
-- Indices de la tabla `descuentos`
--
ALTER TABLE `descuentos`
  ADD PRIMARY KEY (`id_descuento`),
  ADD UNIQUE KEY `codigo_promo` (`codigo_promo`);

--
-- Indices de la tabla `detalles_pedido`
--
ALTER TABLE `detalles_pedido`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `fk_detalles_pedidos` (`id_pedido`),
  ADD KEY `fk_detalles_variantes` (`id_variante`);

--
-- Indices de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD PRIMARY KEY (`id_devolucion`),
  ADD KEY `fk_devoluciones_detalles` (`id_detalle`);

--
-- Indices de la tabla `etiquetas`
--
ALTER TABLE `etiquetas`
  ADD PRIMARY KEY (`id_etiqueta`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `historial_precios`
--
ALTER TABLE `historial_precios`
  ADD PRIMARY KEY (`id_historial_precio`),
  ADD KEY `fk_historial_precios_productos` (`id_producto`);

--
-- Indices de la tabla `historial_puntos`
--
ALTER TABLE `historial_puntos`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `fk_historial_usuarios` (`id_usuario`);

--
-- Indices de la tabla `historial_ventas`
--
ALTER TABLE `historial_ventas`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `fk_historial_productos` (`id_producto`);

--
-- Indices de la tabla `lista_deseos`
--
ALTER TABLE `lista_deseos`
  ADD PRIMARY KEY (`id_wish`),
  ADD KEY `fk_deseos_usuarios` (`id_usuario`),
  ADD KEY `fk_deseos_variantes` (`id_variante`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `fk_pedidos_usuarios` (`id_usuario`),
  ADD KEY `fk_pedidos_descuentos` (`id_descuento`);

--
-- Indices de la tabla `preferencias_estilo`
--
ALTER TABLE `preferencias_estilo`
  ADD PRIMARY KEY (`id_preferencia`),
  ADD KEY `fk_preferencias_usuarios` (`id_usuario`),
  ADD KEY `fk_preferencias_categorias` (`id_categoria`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_productos_categorias` (`id_categoria`);

--
-- Indices de la tabla `producto_etiquetas`
--
ALTER TABLE `producto_etiquetas`
  ADD PRIMARY KEY (`id_producto`,`id_etiqueta`),
  ADD KEY `fk_prodet_etiquetas` (`id_etiqueta`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`);

--
-- Indices de la tabla `puntos_usuario`
--
ALTER TABLE `puntos_usuario`
  ADD PRIMARY KEY (`id_puntos`),
  ADD KEY `fk_puntos_usuarios` (`id_usuario`);

--
-- Indices de la tabla `resenas_valoraciones`
--
ALTER TABLE `resenas_valoraciones`
  ADD PRIMARY KEY (`id_resena`),
  ADD KEY `fk_resenas_usuarios` (`id_usuario`),
  ADD KEY `fk_resenas_productos` (`id_producto`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `fk_usuarios_roles` (`id_rol`);

--
-- Indices de la tabla `variantes_producto`
--
ALTER TABLE `variantes_producto`
  ADD PRIMARY KEY (`id_variante`),
  ADD KEY `fk_variantes_productos` (`id_producto`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `atributos_visuales`
--
ALTER TABLE `atributos_visuales`
  MODIFY `id_atributo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `bitacora_sistema`
--
ALTER TABLE `bitacora_sistema`
  MODIFY `id_bitacora` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cupones_puntos`
--
ALTER TABLE `cupones_puntos`
  MODIFY `id_cupon` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `descuentos`
--
ALTER TABLE `descuentos`
  MODIFY `id_descuento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalles_pedido`
--
ALTER TABLE `detalles_pedido`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `id_devolucion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `etiquetas`
--
ALTER TABLE `etiquetas`
  MODIFY `id_etiqueta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_precios`
--
ALTER TABLE `historial_precios`
  MODIFY `id_historial_precio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_puntos`
--
ALTER TABLE `historial_puntos`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_ventas`
--
ALTER TABLE `historial_ventas`
  MODIFY `id_historial` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lista_deseos`
--
ALTER TABLE `lista_deseos`
  MODIFY `id_wish` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `preferencias_estilo`
--
ALTER TABLE `preferencias_estilo`
  MODIFY `id_preferencia` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `puntos_usuario`
--
ALTER TABLE `puntos_usuario`
  MODIFY `id_puntos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `resenas_valoraciones`
--
ALTER TABLE `resenas_valoraciones`
  MODIFY `id_resena` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `variantes_producto`
--
ALTER TABLE `variantes_producto`
  MODIFY `id_variante` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `atributos_visuales`
--
ALTER TABLE `atributos_visuales`
  ADD CONSTRAINT `fk_atributos_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `bitacora_sistema`
--
ALTER TABLE `bitacora_sistema`
  ADD CONSTRAINT `fk_bitacora_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `cupones_puntos`
--
ALTER TABLE `cupones_puntos`
  ADD CONSTRAINT `fk_cupones_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `cupon_productos_wishlist`
--
ALTER TABLE `cupon_productos_wishlist`
  ADD CONSTRAINT `fk_cupones_productos_cupon` FOREIGN KEY (`id_cupon`) REFERENCES `cupones_puntos` (`id_cupon`),
  ADD CONSTRAINT `fk_cupones_productos_variante` FOREIGN KEY (`id_variante`) REFERENCES `variantes_producto` (`id_variante`);

--
-- Filtros para la tabla `detalles_pedido`
--
ALTER TABLE `detalles_pedido`
  ADD CONSTRAINT `fk_detalles_pedidos` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`),
  ADD CONSTRAINT `fk_detalles_variantes` FOREIGN KEY (`id_variante`) REFERENCES `variantes_producto` (`id_variante`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `fk_devoluciones_detalles` FOREIGN KEY (`id_detalle`) REFERENCES `detalles_pedido` (`id_detalle`);

--
-- Filtros para la tabla `historial_precios`
--
ALTER TABLE `historial_precios`
  ADD CONSTRAINT `fk_historial_precios_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `historial_puntos`
--
ALTER TABLE `historial_puntos`
  ADD CONSTRAINT `fk_historial_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `historial_ventas`
--
ALTER TABLE `historial_ventas`
  ADD CONSTRAINT `fk_historial_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `lista_deseos`
--
ALTER TABLE `lista_deseos`
  ADD CONSTRAINT `fk_deseos_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `fk_deseos_variantes` FOREIGN KEY (`id_variante`) REFERENCES `variantes_producto` (`id_variante`);

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_pedidos_descuentos` FOREIGN KEY (`id_descuento`) REFERENCES `descuentos` (`id_descuento`),
  ADD CONSTRAINT `fk_pedidos_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `preferencias_estilo`
--
ALTER TABLE `preferencias_estilo`
  ADD CONSTRAINT `fk_preferencias_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  ADD CONSTRAINT `fk_preferencias_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_productos_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`);

--
-- Filtros para la tabla `producto_etiquetas`
--
ALTER TABLE `producto_etiquetas`
  ADD CONSTRAINT `fk_prodet_etiquetas` FOREIGN KEY (`id_etiqueta`) REFERENCES `etiquetas` (`id_etiqueta`),
  ADD CONSTRAINT `fk_prodet_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `puntos_usuario`
--
ALTER TABLE `puntos_usuario`
  ADD CONSTRAINT `fk_puntos_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `resenas_valoraciones`
--
ALTER TABLE `resenas_valoraciones`
  ADD CONSTRAINT `fk_resenas_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  ADD CONSTRAINT `fk_resenas_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_roles` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);

--
-- Filtros para la tabla `variantes_producto`
--
ALTER TABLE `variantes_producto`
  ADD CONSTRAINT `fk_variantes_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
