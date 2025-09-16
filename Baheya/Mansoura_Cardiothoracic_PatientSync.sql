USE [msdb]
GO

/****** Object:  Job [Mansoura_Cardiothoracic_PatientSync]    Script Date: 9/12/2025 4:48:10 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 9/12/2025 4:48:10 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Mansoura_Cardiothoracic_PatientSync', 
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
/****** Object:  Step [step1]    Script Date: 9/12/2025 4:48:10 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'step1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF EXISTS (
		SELECT ars.role_desc
		FROM sys.dm_hadr_availability_replica_states ars
		INNER JOIN sys.availability_groups ag ON ars.group_id = ag.group_id
		INNER JOIN sys.availability_databases_cluster db ON db.group_id = ag.group_id
		WHERE database_name = db_name()
			AND ars.role_desc = ''PRIMARY''
		)
	OR NOT EXISTS (
		SELECT ars.role_desc
		FROM sys.dm_hadr_availability_replica_states ars
		INNER JOIN sys.availability_groups ag ON ars.group_id = ag.group_id
		INNER JOIN sys.availability_databases_cluster db ON db.group_id = ag.group_id
		WHERE database_name = db_name()
		)
BEGIN
	SELECT TOP 500 *
	INTO #temp
	FROM Mansoura_Cardiothoracic.SharedServiesQUEUE WITH (NOLOCK)
	WHERE STATUS = 0

	DECLARE @sys_key BIGINT
		,@transType INT
		,@tblname VARCHAR(50)
		,@keyfield NVARCHAR(500)
		,@keyfield_value VARCHAR(50)
	DECLARE @db_name VARCHAR(50) = db_name()

	WHILE EXISTS (
			SELECT *
			FROM #temp
			)
	BEGIN
		SELECT TOP 1 @sys_key = sys_key
			,@transType = TransType
			,@tblname = TableName
			,@keyfield = KeyField
			,@keyfield_value = keyfield_value
		FROM #temp
		ORDER BY sys_key

		BEGIN TRY
			SET NOCOUNT ON
			SET XACT_ABORT ON

			EXEC University_Central.dbo.Sync_Master_Broker @transType
				,@tblname
				,@keyfield
				,@keyfield_value
				,@db_name
				,''University_Central''
				,''MedicaCloud_Repository''

			INSERT centraldb.dbo.SharedServiesQUEUE (
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
				,t.keyfield_value
			FROM #temp t
			INNER JOIN centraldb.dbo.HospitalsList AS hosp WITH (NOLOCK) ON 1 = 1
			WHERE hosp.hospitalid <> t.HospitalID
				AND hosp.HospitalID <> 99
				AND t.sys_key = @sys_key

			UPDATE shared
			SET STATUS = 1
			FROM SharedServiesQUEUE AS shared WITH (NOLOCK)
			WHERE shared.sys_key = @sys_key

			DELETE #temp
			WHERE sys_key = @sys_key
		END TRY

		BEGIN CATCH
			UPDATE shared
			SET STATUS = - 1
				,ERR = isnull(ERROR_MESSAGE(), '''')
			FROM SharedServiesQUEUE AS shared WITH (NOLOCK)
			WHERE shared.sys_key = @sys_key

			DELETE #temp
			WHERE sys_key = @sys_key
		END CATCH
	END

	DROP TABLE #temp
END', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'sch1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20250912, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'de6248e6-eee6-45d2-b3e8-d6d669daee50'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


