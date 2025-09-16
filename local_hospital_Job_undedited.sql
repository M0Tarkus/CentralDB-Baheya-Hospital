if exists(select ars.role_desc
    from sys.dm_hadr_availability_replica_states ars
    inner join sys.availability_groups ag on ars.group_id = ag.group_id 
	inner join sys.availability_databases_cluster db on db.group_id=ag.group_id
	where database_name=db_name() and ars.role_desc='PRIMARY') 
	or 
	not exists(select ars.role_desc
    from sys.dm_hadr_availability_replica_states ars
    inner join sys.availability_groups ag on ars.group_id = ag.group_id 
	inner join sys.availability_databases_cluster db on db.group_id=ag.group_id
	where database_name=db_name())
begin
	select top 500 * 
	into #temp
	from SharedServiesQUEUE with(nolock) where status=0
	declare @sys_key bigint ,@transType int,@tblname varchar(50),@keyfield  nvarchar(500),@keyfield_value varchar(50)
	declare @db_name varchar(50)=db_name()

	while exists(select * from #temp)
	begin
		select top 1 @sys_key =sys_key ,@transType =TransType,@tblname =TableName,@keyfield =KeyField,@keyfield_value=keyfield_value
		from #temp order by sys_key
		begin try
			Set NOCOUNT ON
			SET XACT_ABORT ON
				exec University_Central.dbo.Sync_Master_Broker @transType,@tblname,@keyfield,@keyfield_value,@db_name,'University_Central','MedicaCloud_Repository'

				insert centraldb.dbo.SharedServiesQUEUE(TableName,HospitalID,Status,TransType,KeyField,systime,keyfield_value)
				select @tblname TableName,hosp.HospitalID,Status,TransType,KeyField,systime,t.keyfield_value
				from #temp t inner join  centraldb.dbo.HospitalsList as hosp  with(nolock)  on 1=1
				where  hosp.hospitalid<>t.HospitalID and hosp.HospitalID<>99 and t.sys_key=@sys_key
		
				update shared set status=1	from SharedServiesQUEUE as shared with(nolock) where shared.sys_key=@sys_key
				delete #temp where sys_key=@sys_key
		end try
		begin catch
				update shared set Status=-1,ERR=isnull( ERROR_MESSAGE(),'') from SharedServiesQUEUE as shared with(nolock) where shared.sys_key=@sys_key
				delete #temp where sys_key=@sys_key
		end catch
	end

	drop table #temp
end