if (select
        ars.role_desc
    from sys.dm_hadr_availability_replica_states ars
    inner join sys.availability_groups ag
    on ars.group_id = ag.group_id
    where ag.name = 'MCCDBBA'-- name of AG
    and ars.is_local = 1) = 'PRIMARY' or not exists(select * from sys.availability_groups)
begin
	select top 500 * 
	into #temp
	from Baheya_Zayed.dbo.SharedServiesQUEUE with(nolock) where status=0
	declare @sys_key bigint ,@transType int,@tblname varchar(50),@keyfield  nvarchar(500),@keyfield_value varchar(50)
	declare @db_name varchar(50)=db_name()
	declare @sql_st varchar(2000)=''
	while exists(select * from #temp)
	begin
		select top 1 @sys_key =sys_key ,@transType =TransType,@tblname =TableName,@keyfield =KeyField,@keyfield_value=keyfield_value
		from #temp order by sys_key
		set @sql_st=''
		set @sql_st=concat('exec Baheya_Central.dbo.Sync_Master_Broker ',@transType,',''',@tblname,''',''',@keyfield,''',''',@keyfield_value,''',''',@db_name,'''')
		print @sql_st
		exec (@sql_st)

		insert centraldb.dbo.SharedServiesQUEUE(TableName,HospitalID,Status,TransType,KeyField,systime,keyfield_value)
		select @tblname TableName,hosp.HospitalID,Status,TransType,KeyField,systime,keyfield_value
		from #temp inner join  centraldb.dbo.HospitalsList as hosp  with(nolock)  on 1=1
		where  hosp.hospitalid<>#temp.HospitalID and hosp.HospitalID<>99 and #temp.sys_key=@sys_key
		
		update shared set status=1	from Baheya_Zayed.dbo.SharedServiesQUEUE as shared with(nolock) where shared.sys_key=@sys_key
		delete #temp where sys_key=@sys_key
	end

	drop table #temp
end