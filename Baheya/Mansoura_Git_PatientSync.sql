USE [msdb]
GO

/****** Object:  Job [Mansoura_Git_PatientSync]    Script Date: 9/12/2025 4:48:18 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 9/12/2025 4:48:19 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Mansoura_Git_PatientSync', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step1]    Script Date: 9/12/2025 4:48:19 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF (
		-- Condition 1: Check if it''s a standalone instance.
		-- This is true if the AG feature isn''t enabled OR if it''s enabled but no AGs exist.
		ISNULL(SERVERPROPERTY(''IsHadrEnabled''), 0) = 0
		OR NOT EXISTS (
			SELECT 1
			FROM sys.availability_groups
			)
		)
	OR (
		-- Condition 2: If AGs ARE configured, check if this is the PRIMARY for the specific AG.
		-- This part only runs if the first condition is false, avoiding errors on standalone instances.
		sys.fn_hadr_is_primary_replica(''MCCDBBA'') = 1
		)
BEGIN
	-- The rest of your original logic remains unchanged.
	IF OBJECT_ID(''tempdb..#temp'') IS NOT NULL
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
	DECLARE @sql_st VARCHAR(2000) = '''';

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

		SET @sql_st = '''';
		SET @sql_st = CONCAT (
				''exec University_Central.dbo.Sync_Master_Broker ''
				,@transType
				,'',''''''
				,@tblname
				,'''''',''
				,''''''''
				,@keyfield
				,'''''',''
				,''''''''
				,@keyfield_value
				,'''''',''
				,''''''''
				,@db_name
				,''''''''
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
END', 
		@database_name=N'Mansoura_Git', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'sch', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20231009, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'f26a81ca-57bd-4040-ac0c-20c986e270fb'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


