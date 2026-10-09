-- USE Hospital;
-- GO


-- /* ============================================================
--    Q1 — Create a Clustered Index

--    Create PatientIndexDemo with:
--    PatientId, PatientName, DOB, WardId

--    Copy data from Patients, then create a clustered index
--    on PatientId.
--    ============================================================ */

-- -- Drop the demo table if it already exists
-- IF OBJECT_ID('dbo.PatientIndexDemo', 'U') IS NOT NULL
--     DROP TABLE dbo.PatientIndexDemo;
-- GO

-- -- Create the table
-- CREATE TABLE dbo.PatientIndexDemo
-- (
--     PatientId INT NOT NULL,
--     PatientName NVARCHAR(255) NOT NULL,
--     DOB DATE NOT NULL,
--     WardId INT NULL
-- );
-- GO

-- -- Copy data from Patients
-- INSERT INTO dbo.PatientIndexDemo
--     (PatientId, PatientName, DOB, WardId)
-- SELECT
--     Id,
--     Name,
--     DOB,
--     WardId
-- FROM dbo.Patients;
-- GO

-- -- Create clustered index
-- CREATE CLUSTERED INDEX IX_PatientIndexDemo_PatientId
-- ON dbo.PatientIndexDemo (PatientId);
-- GO


-- /* ============================================================
--    Q2 — Create Another Clustered Index

--    Create ConsultantIndexDemo with:
--    ConsultantId, ConsultantName, Salary

--    Copy data from Consultants and create a clustered index
--    on ConsultantId.
--    ============================================================ */

-- IF OBJECT_ID('dbo.ConsultantIndexDemo', 'U') IS NOT NULL
--     DROP TABLE dbo.ConsultantIndexDemo;
-- GO

-- CREATE TABLE dbo.ConsultantIndexDemo
-- (
--     ConsultantId INT NOT NULL,
--     ConsultantName NVARCHAR(255) NOT NULL,
--     Salary DECIMAL(18,2) NULL
-- );
-- GO

-- -- Copy data from Consultants
-- INSERT INTO dbo.ConsultantIndexDemo
--     (ConsultantId, ConsultantName, Salary)
-- SELECT
--     Id,
--     Name,
--     Salary
-- FROM dbo.Consultants;
-- GO

-- -- Create clustered index
-- CREATE CLUSTERED INDEX IX_ConsultantIndexDemo_ConsultantId
-- ON dbo.ConsultantIndexDemo (ConsultantId);
-- GO


-- /* ============================================================
--    Q3 — Index Patients by Ward

--    Create a nonclustered index on Patients.WardId.
--    ============================================================ */

-- IF EXISTS
-- (
--     SELECT 1
--     FROM sys.indexes
--     WHERE name = 'IX_Patients_WardId'
--       AND object_id = OBJECT_ID('dbo.Patients')
-- )
--     DROP INDEX IX_Patients_WardId ON dbo.Patients;
-- GO

-- CREATE NONCLUSTERED INDEX IX_Patients_WardId
-- ON dbo.Patients (WardId);
-- GO


-- /* ============================================================
--    Q4 — Index Consultants by Salary

--    Create a nonclustered index on Consultants.Salary.
--    ============================================================ */

-- IF EXISTS
-- (
--     SELECT 1
--     FROM sys.indexes
--     WHERE name = 'IX_Consultants_Salary'
--       AND object_id = OBJECT_ID('dbo.Consultants')
-- )
--     DROP INDEX IX_Consultants_Salary ON dbo.Consultants;
-- GO

-- CREATE NONCLUSTERED INDEX IX_Consultants_Salary
-- ON dbo.Consultants (Salary);
-- GO


-- /* ============================================================
--    Q5 — Create a Composite Nonclustered Index

--    Index DrugAdministrations using:
--    PatientId + DrugCode
--    ============================================================ */

-- IF EXISTS
-- (
--     SELECT 1
--     FROM sys.indexes
--     WHERE name = 'IX_DrugAdministrations_PatientId_DrugCode'
--       AND object_id = OBJECT_ID('dbo.DrugAdministrations')
-- )
--     DROP INDEX IX_DrugAdministrations_PatientId_DrugCode
--     ON dbo.DrugAdministrations;
-- GO

-- CREATE NONCLUSTERED INDEX IX_DrugAdministrations_PatientId_DrugCode
-- ON dbo.DrugAdministrations (PatientId, DrugCode);
-- GO


-- /* ============================================================
--    Q6 — Nonclustered Index with Included Columns

--    Key:
--        WardId

--    Included:
--        Name
--        DOB
--    ============================================================ */

-- IF EXISTS
-- (
--     SELECT 1
--     FROM sys.indexes
--     WHERE name = 'IX_Patients_WardId_Include_Name_DOB'
--       AND object_id = OBJECT_ID('dbo.Patients')
-- )
--     DROP INDEX IX_Patients_WardId_Include_Name_DOB
--     ON dbo.Patients;
-- GO

-- CREATE NONCLUSTERED INDEX IX_Patients_WardId_Include_Name_DOB
-- ON dbo.Patients (WardId)
-- INCLUDE (Name, DOB);
-- GO


-- /* ============================================================
--    Q7 — Unique Consultant Names

--    Create a UNIQUE index on Consultants.Name.
--    ============================================================ */

-- -- First check whether duplicate names already exist.
-- SELECT
--     Name,
--     COUNT(*) AS DuplicateCount
-- FROM dbo.Consultants
-- GROUP BY Name
-- HAVING COUNT(*) > 1;
-- GO

-- -- If the query above returns no rows, create the unique index.

-- IF NOT EXISTS
-- (
--     SELECT 1
--     FROM sys.indexes
--     WHERE name = 'UX_Consultants_Name'
--       AND object_id = OBJECT_ID('dbo.Consultants')
-- )
-- BEGIN
--     CREATE UNIQUE NONCLUSTERED INDEX UX_Consultants_Name
--     ON dbo.Consultants (Name);
-- END;
-- GO


-- /* ============================================================
--    Q8 — Composite Unique Index

--    Create PatientDrugAssignmentDemo:
--        PatientId
--        DrugCode
--        StartDate

--    Unique combination:
--        PatientId + DrugCode
--    ============================================================ */

-- IF OBJECT_ID('dbo.PatientDrugAssignmentDemo', 'U') IS NOT NULL
--     DROP TABLE dbo.PatientDrugAssignmentDemo;
-- GO

-- CREATE TABLE dbo.PatientDrugAssignmentDemo
-- (
--     PatientId INT NOT NULL,
--     DrugCode INT NOT NULL,
--     StartDate DATE NOT NULL
-- );
-- GO

-- CREATE UNIQUE NONCLUSTERED INDEX UX_PatientDrugAssignmentDemo_Patient_Drug
-- ON dbo.PatientDrugAssignmentDemo (PatientId, DrugCode);
-- GO


-- /* ============================================================
--    Q9 — Test the Unique Index

--    First INSERT = valid
--    Second INSERT = same PatientId + DrugCode
--                    but different StartDate

--    Expected:
--        Second INSERT fails because the indexed combination
--        PatientId + DrugCode must be unique.
--    ============================================================ */

-- -- Valid row
-- INSERT INTO dbo.PatientDrugAssignmentDemo
--     (PatientId, DrugCode, StartDate)
-- VALUES
--     (1, 1001, '2026-01-01');
-- GO

-- -- Duplicate PatientId + DrugCode
-- -- This is expected to FAIL.

-- /*
-- INSERT INTO dbo.PatientDrugAssignmentDemo
--     (PatientId, DrugCode, StartDate)
-- VALUES
--     (1, 1001, '2026-02-01');
-- GO
-- */

-- -- View existing data
-- SELECT *
-- FROM dbo.PatientDrugAssignmentDemo;
-- GO


-- /* ============================================================
--    Q10 — Display Indexes

--    Display indexes defined on Patients.
--    ============================================================ */

-- EXEC sp_helpindex 'dbo.Patients';
-- GO


-- /* ============================================================
--    Q11 — Find Indexes from System Catalogs

--    Display:
--        Table Name
--        Index Name
--        Index Type

--    for all indexes in Hospital.
--    ============================================================ */

-- SELECT
--     t.name AS TableName,
--     i.name AS IndexName,
--     i.type_desc AS IndexType
-- FROM sys.tables t
-- INNER JOIN sys.indexes i
--     ON t.object_id = i.object_id
-- WHERE i.name IS NOT NULL
-- ORDER BY
--     t.name,
--     i.name;
-- GO


-- /* ============================================================
--    Q12 — Drop a Nonclustered Index

--    Remove the Consultants.Salary index created in Q4.
--    ============================================================ */

-- IF EXISTS
-- (
--     SELECT 1
--     FROM sys.indexes
--     WHERE name = 'IX_Consultants_Salary'
--       AND object_id = OBJECT_ID('dbo.Consultants')
-- )
-- BEGIN
--     DROP INDEX IX_Consultants_Salary
--     ON dbo.Consultants;
-- END;
-- GO


-- /* ============================================================
--    Q13 — Create an Index for Patient Searches

--    Create a composite nonclustered index for searches using:
--        WardId
--        DOB
--    ============================================================ */

-- IF EXISTS
-- (
--     SELECT 1
--     FROM sys.indexes
--     WHERE name = 'IX_Patients_WardId_DOB'
--       AND object_id = OBJECT_ID('dbo.Patients')
-- )
--     DROP INDEX IX_Patients_WardId_DOB
--     ON dbo.Patients;
-- GO

-- CREATE NONCLUSTERED INDEX IX_Patients_WardId_DOB
-- ON dbo.Patients (WardId, DOB);
-- GO


-- /* ============================================================
--    Q14 — Create a Reporting Index

--    Assignment asks for:

--    Key columns:
--        PatientId
--        DATE

--    Included columns:
--        DrugCode
--        Dosage
--        Quantity

--    IMPORTANT:
--    The provided Hospital database does NOT contain a Quantity
--    column in DrugAdministrations.

--    Actual DrugAdministrations columns:
--        NurseId
--        DrugCode
--        PatientId
--        Dosage
--        DATE
--        Time

--    Therefore Quantity cannot be included without changing
--    the database schema.

--    The valid index based on the actual database schema is:
--    ============================================================ */

-- IF EXISTS
-- (
--     SELECT 1
--     FROM sys.indexes
--     WHERE name = 'IX_DrugAdministrations_PatientId_DATE_Report'
--       AND object_id = OBJECT_ID('dbo.DrugAdministrations')
-- )
--     DROP INDEX IX_DrugAdministrations_PatientId_DATE_Report
--     ON dbo.DrugAdministrations;
-- GO

-- CREATE NONCLUSTERED INDEX IX_DrugAdministrations_PatientId_DATE_Report
-- ON dbo.DrugAdministrations (PatientId, [DATE])
-- INCLUDE (DrugCode, Dosage);
-- GO


-- /* ============================================================
--    FINAL CHECK

--    Display all indexes created on the relevant tables.
--    ============================================================ */

-- SELECT
--     t.name AS TableName,
--     i.name AS IndexName,
--     i.type_desc AS IndexType,
--     i.is_unique AS IsUnique
-- FROM sys.tables t
-- INNER JOIN sys.indexes i
--     ON t.object_id = i.object_id
-- WHERE
--     i.name IS NOT NULL
--     AND t.name IN
--     (
--         'Patients',
--         'Consultants',
--         'DrugAdministrations',
--         'PatientIndexDemo',
--         'ConsultantIndexDemo',
--         'PatientDrugAssignmentDemo'
--     )
-- ORDER BY
--     t.name,
--     i.name;
-- GO