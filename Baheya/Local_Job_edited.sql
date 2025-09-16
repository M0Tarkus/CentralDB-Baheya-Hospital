IF (
		-- Condition 1: Check if it's a standalone instance.
		-- This is true if the AG feature isn't enabled OR if it's enabled but no AGs exist.
		ISNULL(SERVERPROPERTY('IsHadrEnabled'), 0) = 0
		OR NOT EXISTS (
			SELECT 1
			FROM sys.availability_groups
			)
		)
	OR (
		-- Condition 2: If AGs ARE configured, check if this is the PRIMARY for the specific AG.
		-- This part only runs if the first condition is false, avoiding errors on standalone instances.
		sys.fn_hadr_is_primary_replica('MCCDBBA') = 1
		)
BEGIN
	-- The rest of your original logic remains unchanged.
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL
		DROP TABLE #temp;

	SELECT TOP 500 *
	INTO #temp
	FROM Mansoura_Git.dbo.SharedServiesQUEUE WITH (NOLOCK)
	WHERE STATUS = 0;

	DECLARE @sys_key BIGINT
		,@transType INT
		,@tblname VARCHAR(50)
		,@keyfield NVARCHAR(500)
		,@keyfield_value VARCHAR(50);
	DECLARE @db_name VARCHAR(50) = DB_NAME();
	DECLARE @sql_st VARCHAR(2000) = '';

	WHILE EXISTS (
			SELECT 1
			FROM #temp
			)
	BEGIN
		SELECT TOP 1 @sys_key = sys_key
			,@transType = TransType
			,@tblname = TableName
			,@keyfield = KeyField
			,@keyfield_value = keyfield_value
		FROM #temp
		ORDER BY sys_key;

		SET @sql_st = '';
		SET @sql_st = CONCAT (
				'exec University_Central.dbo.Sync_Master_Broker '
				,@transType
				,','''
				,@tblname
				,''','
				,''''
				,@keyfield
				,''','
				,''''
				,@keyfield_value
				,''','
				,''''
				,@db_name
				,''''
				);

		PRINT @sql_st;

		EXEC (@sql_st);

		INSERT INTO CentralDB.dbo.SharedServiesQUEUE (
			TableName
			,HospitalID
			,STATUS
			,TransType
			,KeyField
			,systime
			,keyfield_value
			)
		SELECT @tblname TableName
			,hosp.HospitalID
			,STATUS
			,TransType
			,KeyField
			,systime
			,keyfield_value
		FROM #temp
		INNER JOIN CentralDB.dbo.HospitalsList  AS hosp WITH (NOLOCK) ON 1 = 1
		WHERE hosp.hospitalid <> #temp.HospitalID
			AND hosp.HospitalID <> 99
			AND #temp.sys_key = @sys_key;

		UPDATE shared
		SET STATUS = 1
		FROM Mansoura_Git.dbo.SharedServiesQUEUE AS shared WITH (NOLOCK)
		WHERE shared.sys_key = @sys_key;

		DELETE #temp
		WHERE sys_key = @sys_key;
	END

	DROP TABLE #temp;
END