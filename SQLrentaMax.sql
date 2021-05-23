-- =============================================
-- Creación de la Base de Datos
-- =============================================

USE master;
GO

IF( EXISTS ( SELECT name FROM master.sys.databases WHERE name = 'VENTAS' ) )
BEGIN
	DROP DATABASE VENTAS;
END;
GO

CREATE DATABASE VENTAS;
GO

-- =============================================
-- Seleccionar la Base de Datos
-- =============================================

USE VENTAS;

-- =============================================
-- CREACION DE TABLAS DE EMPLEADOS
-- =============================================

CREATE TABLE EMPLEADO
( 
	idemp                int IDENTITY ,
	nombre               varchar(50)  NOT NULL ,
	apellido             varchar(50)  NOT NULL ,
	email                varchar(50)  NOT NULL ,
	telefono             varchar(20)  NULL ,
	CONSTRAINT XPKEMPLEADO PRIMARY KEY  NONCLUSTERED (idemp ASC)
);
go

SET IDENTITY_INSERT dbo.EMPLEADO ON;  
GO  
  
INSERT INTO EMPLEADO(IDEMP,NOMBRE,APELLIDO,EMAIL,TELEFONO) 
VALUES(1001,'RANGI','BECERRA','rbecerra@gmail.com',NULL);

INSERT INTO EMPLEADO(IDEMP,NOMBRE,APELLIDO,EMAIL,TELEFONO)  
VALUES(1002,'fabian','valenzuela','fvalenzuela@gmail.com','91234567');

INSERT INTO EMPLEADO(IDEMP,NOMBRE,APELLIDO,EMAIL,TELEFONO)  
VALUES(1003,'ariel','cantero','acantero@gmail.com','91234568');

INSERT INTO EMPLEADO(IDEMP,NOMBRE,APELLIDO,EMAIL,TELEFONO)  
VALUES(1004,'cristobal','acuna','cacuna@gmail.com','912345679');

GO

SET IDENTITY_INSERT dbo.EMPLEADO OFF;  
GO

-- =============================================
-- CREACION DE TABLAS DEL USUARIOS
-- =============================================

CREATE TABLE USUARIO
( 
	idemp                int  NOT NULL ,
	usuario              varchar(20)  NOT NULL ,
	clave                varbinary(100)  NOT NULL ,
	estado               smallint  NOT NULL 
	CONSTRAINT CHK_USUARIO_ESTADO CHECK  ( estado=1 OR estado=0 ),
	CONSTRAINT XPKUSUARIO PRIMARY KEY  NONCLUSTERED (idemp ASC),
	CONSTRAINT FK_USUARIO_EMPLEADO FOREIGN KEY (idemp) REFERENCES EMPLEADO(idemp)
)
GO

INSERT INTO USUARIO(IDEMP, USUARIO, CLAVE, ESTADO)
VALUES(1002,'rbecerra',HashBytes('SHA1','suerte'),1);

INSERT INTO USUARIO(IDEMP, USUARIO, CLAVE, ESTADO)
VALUES(1003,'acantero',HashBytes('SHA1','pequeño'),1);

INSERT INTO USUARIO(IDEMP, USUARIO, CLAVE, ESTADO)
VALUES(1004,'fvalenzuela',HashBytes('SHA1','felicidad'),0);

INSERT INTO USUARIO(IDEMP, USUARIO, CLAVE, ESTADO)
VALUES(1004,'cacuna',HashBytes('SHA1','sueño'),1);

GO

-- =============================================
-- CREACION DE TABLAS DEL CATALOGO
-- =============================================

CREATE TABLE CATEGORIA
( 
	idcat                int  NOT NULL ,
	nombre               VARCHAR(50)  NOT NULL ,
	CONSTRAINT XPKCATEGORIA PRIMARY KEY  NONCLUSTERED (idcat ASC)
);
GO

INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(1,'CAMIONES DE ARRASTRE');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(2,'CAMIONES DE RIEGO');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(3,'CAMIONES DE TALADRO');
INSERT INTO CATEGORIA(IDCAT,NOMBRE) VALUES(4,'PERCUTORES');

GO

CREATE TABLE PRODUCTO
( 
	idprod               int IDENTITY ,
	idcat                int  NOT NULL ,
	nombre               VARCHAR(100)  NOT NULL ,
	precio               NUMERIC(10,2)  NOT NULL ,
	stock                int  NOT NULL ,
	CONSTRAINT XPKPRODUCTO PRIMARY KEY  NONCLUSTERED (idprod ASC),
	CONSTRAINT FK_PRODUCTO_CATEGORIA FOREIGN KEY (idcat) REFERENCES CATEGORIA(idcat)
);
GO

SET IDENTITY_INSERT dbo.PRODUCTO ON;  
GO

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(1,1,'CAMION1',900.0,456);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(2,7,'RETROESCABADORA',150.0,4567);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(3,1,'CAMION2',1300.0,690);

INSERT INTO PRODUCTO(IDPROD,IDCAT,NOMBRE,PRECIO,STOCK)
VALUES(4,7,'CAMION3',95.00,150);

GO

SET IDENTITY_INSERT dbo.PRODUCTO OFF;  
GO

-- =============================================
-- CREACION DE TABLAS DE VENTAS
-- =============================================

CREATE TABLE VENTA
( 
	idventa              int IDENTITY ,
	idemp                int  NOT NULL ,
	cliente              VARCHAR(100)  NOT NULL ,
	fecha                datetime  NOT NULL ,
	importe              NUMERIC(10,2)  NOT NULL ,
	CONSTRAINT XPKVENTA PRIMARY KEY  CLUSTERED (idventa ASC),
	CONSTRAINT R_VENTA_EMPLEADO FOREIGN KEY (idemp) REFERENCES USUARIO(idemp)
);
GO

CREATE TABLE DETALLE
( 
	iddetalle            int IDENTITY ,
	idventa              int  NOT NULL ,
	idprod               int  NOT NULL ,
	cant                 NUMERIC  NOT NULL ,
	precio               NUMERIC(10,2)  NOT NULL ,
	subtotal             NUMERIC(10,2)  NULL ,
	CONSTRAINT XPKDETALLE PRIMARY KEY  CLUSTERED (iddetalle ASC),
	CONSTRAINT FK_DETALLE_PRODUCTO FOREIGN KEY (idprod) REFERENCES PRODUCTO(idprod),
	CONSTRAINT FK_DETALLE_VENTA FOREIGN KEY (idventa) REFERENCES VENTA(idventa)
);
GO

CREATE UNIQUE INDEX U_DETALLE ON DETALLE
( 
	idventa               ASC,
	idprod                ASC
);
GO

-- =============================================
-- CREACION DE TABLAS DE PAGOS
-- =============================================

CREATE TABLE TIPO_PAGO
( 
	idtipo               int  NOT NULL ,
	nombre               VARCHAR(50)  NOT NULL ,
	CONSTRAINT XPKTIPO_PAGO PRIMARY KEY (idtipo ASC)
);
GO

INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(1,'EFECTIVO');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(2,'TARJETA CREDITO');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(3,'TARJETA DE DEBITO');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(4,'CHEQUE');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(5,'NOTA DE CREDITO');
INSERT INTO TIPO_PAGO(IDTIPO,NOMBRE) VALUES(6,'BONO EFECTIVO');
GO

CREATE TABLE PAGO
( 
	idpago               int IDENTITY ,
	idventa              int  NOT NULL ,
	idtipo               int  NOT NULL ,
	detalle              VARCHAR(100)  NOT NULL ,
	importe              NUMERIC(10,2)  NOT NULL ,
	obs                  VARCHAR(1000)  NOT NULL ,
	CONSTRAINT XPKPAGO PRIMARY KEY (idpago ASC),
	CONSTRAINT FK_PAGO_VENTA FOREIGN KEY (idventa) REFERENCES VENTA(idventa),
	CONSTRAINT FK_PAGO_TIPO_PAGO FOREIGN KEY (idtipo) REFERENCES TIPO_PAGO(idtipo)
);
GO

CREATE UNIQUE INDEX U_PAGO_UNIQUE ON PAGO
( 
	idventa               ASC,
	idtipo                ASC
);
GO

--Consulta READ
--SELECT * FROM [Ayudantia].[dbo].Usuario
SELECT * FROM [VENTAS].[dbo].CATEGORIA
SELECT * FROM [VENTAS].[dbo].DETALLE
SELECT * FROM [VENTAS].[dbo].EMPLEADO
SELECT * FROM [VENTAS].[dbo].PAGO
SELECT * FROM [VENTAS].[dbo].PRODUCTO
SELECT * FROM [VENTAS].[dbo].TIPO_PAGO
SELECT * FROM [VENTAS].[dbo].USUARIO
SELECT * FROM [VENTAS].[dbo].VENTA
