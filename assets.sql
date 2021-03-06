USE master;
GO

--Check if the database exists, if not then create it.
IF NOT EXISTS (
  SELECT  database_id
  FROM    [master].[sys].[databases]
  WHERE   [name] = 'ComputerAssets'
) CREATE DATABASE ComputerAssets
GO

USE ComputerAssets;
GO

-- Rebuild procedures
----------------------------------------------  ------------------------------------
IF OBJECT_ID('dbo.GetComputers') IS NOT NULL    DROP PROCEDURE dbo.GetComputers;
IF OBJECT_ID('dbo.InsertComputer') IS NOT NULL  DROP PROCEDURE dbo.InsertComputer;
IF OBJECT_ID('dbo.InsertModel') IS NOT NULL     DROP PROCEDURE dbo.InsertModel;
----------------------------------------------  ------------------------------------

--Rebuild tables
----------------------------------------------  ------------------------------------
IF OBJECT_ID('dbo.Computers') IS NOT NULL       DROP TABLE dbo.Computers;
IF OBJECT_ID('dbo.Zones') IS NOT NULL           DROP TABLE dbo.Zones;
IF OBJECT_ID('dbo.Models') IS NOT NULL          DROP TABLE dbo.Models;
----------------------------------------------  ------------------------------------
GO

--CREATE TABLES AND PROCEDURES--
------------------------------------------------------------------------------------
CREATE TABLE dbo.Zones(
  ZoneID      INT IDENTITY(1,1),
  ZoneName    NVARCHAR(20),
  CONSTRAINT  PK_Zones
  PRIMARY KEY (ZoneID)
);
GO
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
INSERT INTO dbo.Zones
VALUES      ('Ukjent'), ('Admin'), ('Skole');
GO
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
CREATE TABLE dbo.Computers (
  ComputerID    INT IDENTITY(1,1),
  AssetTag      NVARCHAR(15)  NULL,
  Serialnumber  NVARCHAR(50)  NOT NULL,
  MACAdress     NVARCHAR(50)  NOT NULL,
  BIOSGUID      NVARCHAR(50)  NULL,
  SCCMDate      DATETIME      NULL,
  ModelName     NVARCHAR(50)  NOT NULL,
  ZoneID        INT           NOT NULL,
  CONSTRAINT    PK_Computers
  PRIMARY KEY   (ComputerID),
  CONSTRAINT    FK_Zones_ZoneID
  FOREIGN KEY   (ZoneID)
  REFERENCES    dbo.Zones
);
GO
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.GetComputers
AS
SELECT  C.ComputerID,
        C.AssetTag,
        C.Serialnumber,
        C.MACAdress,
        C.SCCMDate,
        C.ModelName,
        Z.ZoneName
FROM    dbo.Computers AS C
JOIN    dbo.Zones AS Z
        ON C.ZoneID = Z.ZoneID
GO
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.InsertComputer(
  @AssetTag     NVARCHAR(15) = NULL,
  @Serialnumber NVARCHAR(50),
  @MACAdress    NVARCHAR(50),
  @SCCMDate     DATETIME = NULL,
  @ZoneID       INT = 1, -- ZoneID 1 -eq "unknown"
  @ModelName    NVARCHAR(50)
)
AS
INSERT INTO dbo.Computers(
  AssetTag,
  Serialnumber,
  MACAdress,
  SCCMDate,
  ZoneID,
  ModelName
)
VALUES (
  @AssetTag,
  @Serialnumber,
  @MACAdress,
  @SCCMDate,
  @ZoneID,
  @ModelName
);
GO
------------------------------------------------------------------------------------