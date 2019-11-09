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
SELECT TOP(1) idCompaniaEnvio
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
ORDER BY X.numeroDeEnvios DESC;

-- 6. La región que más empleados tiene.
SELECT X.idRegion, COUNT(X.idEmpleado) AS numeroDeEmpleados
FROM	(SELECT DISTINCT idRegion, idEmpleado
		FROM 	territorios T
				INNER JOIN
				territoriosEmpleado E
				ON E.idTerritorio = T.idTerritorio) AS X
GROUP BY X.idRegion;
