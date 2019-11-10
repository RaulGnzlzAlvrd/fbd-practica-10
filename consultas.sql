USE Northwind;

-- 1. El número de empleados que existen por cada puesto.

SELECT titulo, COUNT(idEmpleado)
FROM Empleados
GROUP BY titulo;

-- 2. El número de empleados que tiene a su cargo cada empleado.

SELECT E.idEmpleado, 
       CASE WHEN NumEmpleados.numeroDeEmpleados IS NULL THEN 0 
            ELSE NumEmpleados.numeroDeEmpleados
       END     
FROM empleados AS E
     LEFT JOIN
        (SELECT reportaAEmpleado AS idEmpleado, COUNT(reportaAEmpleado) AS numeroDeEmpleados
         FROM empleados
         GROUP BY reportaAEmpleado) AS NumEmpleados
	   ON E.idEmpleado = NumEmpleados.idEmpleado;

-- 3. Nombre de la ciudades que tienen más de un cliente.
SELECT ciudad
FROM Clientes
GROUP BY clientes
HAVING count(idCliente) > 1;

-- 4. El total de productos por categoría con los que cuenta cada proveedor.
SELECT idProvedor, idCategoria, COUNT(idProducto) AS numeroDeProductos
FROM Productos
GROUP BY idProvedor, idCategoria;

-- 5. La compañia de envíos que más pedidos ha despachado de la categoría 'Dairy Products'
SELECT CE.idCompaniaEnvio, CE.nombreCompania
FROM CompaniasEnvio CE
WHERE CE.idCompaniaEnvio = 
(SELECT TOP(1) idCompaniaEnvio
FROM 	(SELECT X.idCompaniaEnvio, COUNT(X.idCompaniaEnvio) AS numeroDeEnvios
		FROM	(SELECT DISTINCT P.idPedido, P.viaEnvio AS idCompaniaEnvio
				FROM 	Pedidos P
						JOIN
						DetallesPedido DP
						ON P.idPedido = DP.idPedido
						JOIN
						Productos Pr
						ON DP.idProducto = Pr.idProducto
				WHERE Pr.idCategoria = (SELECT idCategoria FROM  categorias WHERE nombreCategoria = 'Dairy Products'))
				AS X
		GROUP BY X.idCompaniaEnvio) AS X
ORDER BY X.numeroDeEnvios DESC);

-- 6. La región que más empleados tiene.
SELECT TOP(1) X.idRegion
FROM	
  (SELECT DISTINCT idRegion, idEmpleado
    FROM territorios T
        JOIN
				territoriosEmpleado E
				ON E.idTerritorio = T.idTerritorio) AS X
GROUP BY X.idRegion
ORDER BY COUNT(X.idEmpleado) DESC;

-- 7. Obtener el nombre de los clientes que han realizado los 10 pedidos más caros, ordenar el resultado por el pedido con más valor.

SELECT C.nombreCompania
FROM Clientes C
JOIN
    (SELECT TOP 10 idCliente, cargo
     FROM Pedidos
     ORDER BY cargo DESC) AS X 
ON X.idCliente = C.idCliente;

-- 8. Las ganancias por categorías que se han obtenido todos los proveedores.
SELECT idProvedor, P.idCategoria, SUM(X.Ganancia)
FROM Productos P
JOIN  
     (SELECT idProducto, SUM(precioUnitario*cantidad*(1-descuento)) Ganancia
      FROM DetallesPedido
      GROUP BY idProducto) AS X
ON X.idProducto= P.idProducto
GROUP BY P.idProvedor, P.idCategoria;

-- 9. El proveedor con los que cuenta con mas productos descontinuados.
SELECT P.idProvedor, P.nombreCompania
FROM Provedores P 
WHERE idProvedor =
     (SELECT TOP(1) X.idProvedor
      FROM (SELECT * 
             FROM Productos 
             WHERE descontinuado = 1) AS X 
      GROUP BY idProvedor
      ORDER BY COUNT(X.idProvedor) DESC);

-- 10. Obtener el total de ganancias que se han obtenido por año y mes de todos los pedidos realizados, con el formato:
-- |Año|Mes|NúmeroDePedidos|Total|

SELECT  YEAR(fechaPedido) AÑO,
        MONTH(fechaPedido) MES,  
        COUNT(idPedido) NumeroDePedidos, 
        SUM(cargo) Total
FROM    Pedidos
GROUP BY YEAR(fechaPedido), MONTH(fechaPedido);

