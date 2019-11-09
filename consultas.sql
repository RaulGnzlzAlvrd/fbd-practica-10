USE Northwind;

-- 1. El número de empleados que existen por cada puesto.

-- 2. El número de empleados que tiene a su cargo cada empleado.
-- TODO: Falta poner 0 cuando es null.
SELECT E.idEmpleado, NumEmpleados.numeroDeEmpleados FROM 
	empleados AS E
	LEFT JOIN 
	(SELECT reportaAEmpleado AS idEmpleado, COUNT(reportaAEmpleado) AS numeroDeEmpleados 
		FROM empleados 
		GROUP BY reportaAEmpleado) AS NumEmpleados
	ON E.idEmpleado = NumEmpleados.idEmpleado;

-- 3. Nombre de la ciudad que tiene más clientes.
SELECT X.ciudad
FROM 	
		(SELECT ciudad, COUNT(ciudad) AS numeroDeClientes
		FROM clientes
		GROUP BY ciudad) AS X
		JOIN
		(SELECT MAX(X.numeroDeClientes) AS ndc
		FROM 	(SELECT COUNT(ciudad) AS numeroDeClientes
				FROM clientes
				GROUP BY ciudad) AS X) AS Y	
ON Y.ndc = X.numeroDeClientes;

-- 4. El total de productos por categoría con los que cuenta cada proveedor.
SELECT X.idProvedor, X.idCategoria, X.numeroDeProductos 
FROM 	(SELECT idProvedor, idCategoria, COUNT(idCategoria) AS numeroDeProductos
		FROM productos
		GROUP BY idProvedor, idCategoria) AS X;

-- 5. La compañia de envíos que más pedidos ha despachado de la categoría 'Dairy Products'

-- 6. La región que más empleados tiene.
SELECT X.idRegion, COUNT(X.idEmpleado) AS numeroDeEmpleados
FROM	(SELECT DISTINCT idRegion, idEmpleado
		FROM 	territorios T
				INNER JOIN
				territoriosEmpleado E
				ON E.idTerritorio = T.idTerritorio) AS X
GROUP BY X.idRegion;
