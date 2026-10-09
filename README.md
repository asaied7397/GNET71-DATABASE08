# Hospital Database — SQL Indexes Assignment

This assignment is part of the **ASP.NET Backend Development Course — SQL Server Module**.

It focuses on creating and managing SQL Server indexes using the existing `Hospital` database.

## Technologies

- Microsoft SQL Server
- T-SQL
- Docker
- Visual Studio Code
- MSSQL Extension

## Topics Covered

The assignment contains **14 questions** covering:

- Clustered indexes
- Nonclustered indexes
- Composite indexes
- Unique indexes
- Included columns
- Covering indexes
- Viewing indexes
- SQL Server system catalogs
- Dropping indexes

## Index Types

### Clustered Index

A clustered index determines how the table data is physically organized.

Example:

```sql
CREATE CLUSTERED INDEX IX_PatientIndexDemo_PatientId
ON PatientIndexDemo (PatientId);
```

A table can have only one clustered index.

### Nonclustered Index

A nonclustered index provides a separate structure for faster data retrieval.

Example:

```sql
CREATE NONCLUSTERED INDEX IX_Patients_WardId
ON Patients (WardId);
```

### Composite Index

A composite index uses multiple columns as its key.

```sql
CREATE NONCLUSTERED INDEX IX_DrugAdministrations_PatientId_DrugCode
ON DrugAdministrations (PatientId, DrugCode);
```

### Included Columns

Additional columns can be stored inside an index without becoming part of its search key.

```sql
CREATE NONCLUSTERED INDEX IX_Patients_WardId_Include
ON Patients (WardId)
INCLUDE (Name, DOB);
```

This can help create a covering index for frequently used queries.

### Unique Index

A unique index improves lookup performance while also preventing duplicate indexed values.

```sql
CREATE UNIQUE INDEX UX_Consultants_Name
ON Consultants (Name);
```

## Viewing Indexes

Indexes on a specific table can be inspected using:

```sql
EXEC sp_helpindex 'dbo.Patients';
```

Indexes can also be retrieved from SQL Server system catalogs:

```sql
SELECT
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM sys.tables t
JOIN sys.indexes i
    ON t.object_id = i.object_id
WHERE i.name IS NOT NULL;
```

## Database Note

`DrugAdministrations` contains:

```text
NurseId
DrugCode
PatientId
Dosage
DATE
Time
```

The assignment's final question refers to a `Quantity` column, but this column does not exist in the provided database. Therefore, the reporting index uses the available columns:

```sql
CREATE NONCLUSTERED INDEX IX_DrugAdministrations_PatientId_DATE_Report
ON DrugAdministrations (PatientId, [DATE])
INCLUDE (DrugCode, Dosage);
```

## Assignment Coverage

| Questions | Topic                      |
| --------- | -------------------------- |
| Q1–Q2     | Clustered Indexes          |
| Q3–Q4     | Nonclustered Indexes       |
| Q5        | Composite Index            |
| Q6        | Included Columns           |
| Q7–Q9     | Unique Indexes             |
| Q10–Q11   | Inspecting Indexes         |
| Q12       | Dropping Indexes           |
| Q13–Q14   | Search & Reporting Indexes |

## Project File

```text
Hospital_Indexes.sql
```

The file contains the complete solutions for all 14 indexing questions.

## Key Learning Outcomes

This assignment demonstrates how indexes can:

- Improve query performance
- Optimize filtering and searching
- Support multi-column queries
- Cover queries using included columns
- Enforce uniqueness
- Be inspected through SQL Server system catalogs

---

**ASP.NET Backend Development Course — SQL Server Module**
