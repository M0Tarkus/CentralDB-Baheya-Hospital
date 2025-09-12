SELECT 
    ISNULL(a.table_name, b.table_name) AS TableName,
    ISNULL(a.column_name, b.column_name) AS ColumnName,
    a.data_type AS Hosp_DataType,
    b.data_type AS Central_DataType,
    a.character_maximum_length AS Hosp_Length,
    b.character_maximum_length AS Central_Length,
    CASE 
        WHEN a.column_name IS NULL THEN '❌ Missing in Hospital'
        WHEN b.column_name IS NULL THEN '❌ Missing in Central'
        WHEN a.data_type <> b.data_type THEN '⚠️ Datatype mismatch'
        WHEN ISNULL(a.character_maximum_length,-1) <> ISNULL(b.character_maximum_length,-1) 
             THEN '⚠️ Length mismatch'
        ELSE 'OK'
    END AS Difference
FROM Baheya.information_schema.columns a
FULL OUTER JOIN Baheya_Central.information_schema.columns b
    ON a.table_name = b.table_name 
   AND a.column_name = b.column_name
WHERE (a.table_name = 'PATIENT' OR b.table_name = 'PATIENT')
  AND (
        a.column_name IS NULL 
     OR b.column_name IS NULL
     OR a.data_type <> b.data_type
     OR ISNULL(a.character_maximum_length,-1) <> ISNULL(b.character_maximum_length,-1)
      )
ORDER BY TableName, ColumnName;





SELECT 
    a.table_name, a.column_name, a.data_type, a.character_maximum_length,
    b.column_name as central_column, b.data_type as central_type, b.character_maximum_length as central_length
FROM Baheya.information_schema.columns a
FULL OUTER JOIN Baheya_Central.information_schema.columns b
    ON a.table_name = b.table_name AND a.column_name = b.column_name
WHERE a.table_name = 'PATIENT'
ORDER BY a.table_name, a.column_name;