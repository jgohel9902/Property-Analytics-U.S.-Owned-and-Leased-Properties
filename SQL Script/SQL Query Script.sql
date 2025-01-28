USE [Property Analytics];

SELECT *
FROM Leases
WHERE Lease_Effective_Date IS NULL;

UPDATE Leases
SET Building_Rentable_Square_Feet = 0
WHERE Building_Rentable_Square_Feet IS NULL;

WITH CTE AS (
    SELECT Lease_Number, ROW_NUMBER() OVER (PARTITION BY Lease_Number ORDER BY Lease_Effective_Date) AS row_num
    FROM Leases
)
DELETE FROM Leases
WHERE Lease_Number IN (SELECT Lease_Number FROM CTE WHERE row_num > 1);



/* total leases*/
SELECT COUNT(*) AS TotalLeases
FROM Leases;

/* total leases by the GSA region*/
SELECT GSA_Region, COUNT(*) AS NumberOfLeases
FROM Leases
GROUP BY GSA_Region

/* average rentable square feet*/
SELECT AVG(Building_Rentable_Square_Feet) AS AverageRentableSquareFeet
FROM Leases;

/* total available s	quare feet*/
SELECT SUM(Available_Square_Feet) AS TotalAvailableSquareFeet
FROM Leases;

/* list of leases started before 2024*/
SELECT Lease_Number,Location_Code, Real_Property_Asset_Name, Lease_Effective_Date, Installation_Name, Building_Rentable_Square_Feet
FROM Leases
WHERE Lease_Effective_Date > '2024-01-01';

/* list of leases that expire within the next 6 months*/
SELECT Lease_Number, Lease_Expiration_Date, Installation_Name
FROM Leases
WHERE Lease_Expiration_Date < DATEADD(MONTH, 6, GETDATE());

/* number of leases by state*/
SELECT State, COUNT(*) AS NumberOfLeases
FROM Leases
GROUP BY State;

/* number of leases by congressional district*/
SELECT Congressional_District, COUNT(*) AS NumberOfLeases
FROM Leases
GROUP BY Congressional_District;

/* vacancy rate per property*/
SELECT Lease_Number, Installation_Name, (Available_Square_Feet / Building_Rentable_Square_Feet) * 100 AS VacancyRate
FROM Leases
WHERE Building_Rentable_Square_Feet > 0;

/* properties with high vacanc rates*/
SELECT Lease_Number, Installation_Name, VacancyRate
FROM (
    SELECT 
        Lease_Number,
        Installation_Name,
        (Available_Square_Feet / Building_Rentable_Square_Feet) * 100 AS VacancyRate
    FROM Leases
) AS VacancyAnalysis
WHERE VacancyRate > 50;

/* list of lease expiration dates in the coming year*/
SELECT Lease_Number, Lease_Expiration_Date, Installation_Name
FROM Leases
WHERE Lease_Expiration_Date BETWEEN '2025-01-01' AND '2025-12-31';

/* list of leases by latitude and longitude*/
SELECT Lease_Number, Latitude, Longitude
FROM Leases;

/* list of lease by Property Type*/
SELECT Real_Property_Asset_type, COUNT(*) AS NumberOfLeases
FROM Leases 
GROUP BY Real_Property_Asset_type;

/* list of leases by Federal Lease Code*/
SELECT Federal_Leased_Code, COUNT(*) AS NumberOfLeases
FROM Leases
GROUP BY Federal_Leased_Code;

SELECT Installation_Name, Lease_Effective_Date, Lease_Expiration_Date
FROM Leases
WHERE Lease_Effective_Date >= '2020-01-01'
ORDER BY Lease_Effective_Date;