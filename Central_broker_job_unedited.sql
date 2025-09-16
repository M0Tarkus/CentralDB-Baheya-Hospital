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
exec Master_Broker
end