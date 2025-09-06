CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Gl_AssEff] ON  [dbo].[HR_Effect_Gl_AssEff]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Gl_AssEff_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Gl_AssEff_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect] ON  [dbo].[HR_Effect]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select SYS_KEY
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select SYS_KEY
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesPur_Quotations_Details ] ON  [dbo].[Pur_Quotations_Details ]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_VacRule_Age] ON  [dbo].[Hr_VacRule_Age]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Vac_Age_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Vac_Age_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Historical] ON  [dbo].[HR_Effect_Historical]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Historic_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Historic_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Group] ON  [dbo].[HR_Effect_Group]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Effect_Grp_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Effect_Grp_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_VacRule_Class] ON  [dbo].[Hr_VacRule_Class]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Vac_Class_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Vac_Class_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_MaxDeduction] ON  [dbo].[HR_Effect_MaxDeduction]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicespur_Quot_Tiers] ON  [dbo].[pur_Quot_Tiers]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesBank_Acc_Type] ON  [dbo].[Bank_Acc_Type]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Time_DiectDisc] ON  [dbo].[HR_Effect_Time_DiectDisc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_EFFECT_GROUP_ORDER] ON  [dbo].[HR_EFFECT_GROUP_ORDER]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select SYS_KEY
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select SYS_KEY
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_VacRule_ClassPaid] ON  [dbo].[Hr_VacRule_ClassPaid]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Vac_ClassPaid_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Vac_ClassPaid_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_External_Sites] ON  [dbo].[HR_External_Sites]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesDiagnosis10] ON  [dbo].[Diagnosis10]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesBank_Branches] ON  [dbo].[Bank_Branches]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Family] ON  [dbo].[HR_Family]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Inc] ON  [dbo].[HR_Effect_Inc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Inc_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Inc_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_VacRule_Main] ON  [dbo].[Hr_VacRule_Main]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Vac_Main_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Vac_Main_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Language] ON  [dbo].[HR_Language]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesStaff] ON  dbo.Staff    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Staff_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Staff_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_ArcheiveImage] ON  [dbo].[HR_Staff_ArcheiveImage]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesBanks] ON  [dbo].[Banks]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Phone] ON  [dbo].[HR_Phone]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Job] ON  [dbo].[HR_Effect_Job]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select EffJob_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select EffJob_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_VacRule_Sub] ON  [dbo].[Hr_VacRule_Sub]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Vac_Sub_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Vac_Sub_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Shift_AdminRules] ON  [dbo].[HR_Shift_AdminRules]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesPHARMALOGICALACTION] ON  [dbo].[PHARMALOGICALACTION]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select ID
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select ID
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO

CREATE TRIGGER [dbo].[SharedServicesLIST_PRICE_H] ON  [dbo].[LIST_PRICE_H]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Visa_Available] ON  [dbo].[HR_Visa_Available]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Shift_AdminRules_Contract] ON  [dbo].[HR_Shift_AdminRules_Contract]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_WeekEnd] ON  [dbo].[HR_WeekEnd]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select WeekEnd_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select WeekEnd_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_vacation_Dep] ON  [dbo].[Hr_vacation_Dep]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_MaxMin] ON  [dbo].[HR_Effect_MaxMin]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select MaxMin_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select MaxMin_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesINVESTIGATION] ON  [dbo].[INVESTIGATION]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Violation_Degree] ON  [dbo].[HR_Violation_Degree]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesSts_Reports_files] ON  [dbo].[Sts_Reports_files]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sr_no
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sr_no
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesCOMPANIES] ON  [dbo].[COMPANIES]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select comp_cod
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select comp_cod
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Violation_Rules] ON  [dbo].[HR_Violation_Rules]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Violation_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Violation_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_PayCommission] ON  [dbo].[HR_Effect_PayCommission]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesItemFile] ON  [dbo].[ItemFile]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesALERT_ACTIONS] ON  [dbo].[ALERT_ACTIONS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesItemUnit] ON  [dbo].[ItemUnit]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesPatientBlackListDtl] ON  [dbo].[PatientBlackListDtl]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Relation] ON  [dbo].[HR_Effect_Relation]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Effect_Rel_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Effect_Rel_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesCONTRACTES] ON  [dbo].[CONTRACTES]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select cont_no
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select cont_no
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesALTERNATIVE_FILE] ON  [dbo].[ALTERNATIVE_FILE]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesItemUnit_s] ON  [dbo].[ItemUnit_s]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Setup] ON  [dbo].[HR_Effect_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Effect_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Effect_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesCost_Center] ON  [dbo].[Cost_Center]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesCOMPANY] ON  [dbo].[COMPANY]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Company_ID
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Company_ID
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesJOBDESCRIPTION] ON  [dbo].[JOBDESCRIPTION]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select JD_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select JD_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_TypePayRoll] ON  [dbo].[HR_Effect_TypePayRoll]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select TypePay_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select TypePay_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesCredit_DebitNotes_Setup] ON  [dbo].[Credit_DebitNotes_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesCSSDTrayItems] ON  [dbo].[CSSDTrayItems]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesJournal] ON  [dbo].[Journal]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Vacation] ON  [dbo].[HR_Effect_Vacation]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesCURR_CONV] ON  [dbo].[CURR_CONV]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesMERGLOG] ON  dbo.MERGLOG    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesCSSDTrays] ON  [dbo].[CSSDTrays]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesLabelInstructions] ON  [dbo].[LabelInstructions]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDbSt_ReportsFieldslists] ON  [dbo].[DbSt_ReportsFieldslists]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesINVGROUPS] ON  [dbo].[INVGROUPS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesLIST_PRICE] ON  [dbo].[LIST_PRICE]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Events_Setup] ON  [dbo].[HR_Events_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDep_Structure] ON  [dbo].[Dep_Structure]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Dep_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Dep_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Experience] ON  [dbo].[HR_Experience]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesINVRESULTS] ON  [dbo].[INVRESULTS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesIVCompatability] ON  [dbo].[IVCompatability]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesMT_SetupType] ON  [dbo].[MT_SetupType]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesPHMCDM] ON  [dbo].[PHMCDM]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDoctor_Cont_Det] ON  [dbo].[Doctor_Cont_Det]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Job_Details] ON  [dbo].[HR_Job_Details]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesMT_SetupType_ShareModel] ON  [dbo].[MT_SetupType_ShareModel]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesRad_Loinc] ON  [dbo].[Rad_Loinc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDocu_Type_Fil] ON  [dbo].[Docu_Type_Fil]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Job_Locations] ON  [dbo].[HR_Job_Locations]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key_1
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key_1
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesMT_ShareModel] ON  [dbo].[MT_ShareModel]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSTORE_TYPE] ON  [dbo].[STORE_TYPE]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select store_type_code
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select store_type_code
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDrugBillingGroup] ON  [dbo].[DrugBillingGroup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Job_Qual] ON  [dbo].[HR_Job_Qual]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesMT_ShareNode] ON  [dbo].[MT_ShareNode]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesTRADENAME_ACTION] ON  [dbo].[TRADENAME_ACTION]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDrugClasses] ON  [dbo].[DrugClasses]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select DrgID
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select DrgID
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Jobs] ON  [dbo].[HR_Jobs]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select JD_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select JD_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesMT_ShareNode_Hospital] ON  [dbo].[MT_ShareNode_Hospital]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicestrans_type] ON  [dbo].[trans_type]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select trans_type_code
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select trans_type_code
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDrugOrderTemplate] ON  [dbo].[DrugOrderTemplate]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServiceschargemappingsetup] ON  [dbo].[chargemappingsetup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesOTHER_PERS_ACC] ON  [dbo].[OTHER_PERS_ACC]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Medical_Prereq] ON  [dbo].[HR_Medical_Prereq]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDrugRoutes] ON  [dbo].[DrugRoutes]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select SysKey
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select SysKey
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesAgencies] ON  [dbo].[Agencies]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesOutService_Contract_det] ON  [dbo].[OutService_Contract_det]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDrugsToRoutes] ON  [dbo].[DrugsToRoutes]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Menue_Setup] ON  [dbo].[HR_Menue_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesOutService_Contract_head] ON  [dbo].[OutService_Contract_head]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Nationality] ON  [dbo].[HR_Nationality]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDrugToInstructions] ON  [dbo].[DrugToInstructions]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Paper_Prereq] ON  [dbo].[HR_Paper_Prereq]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesPACKAGE_DISC_ACC] ON  [dbo].[PACKAGE_DISC_ACC]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesEFECT_ACC] ON  [dbo].[EFECT_ACC]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesCONTRULES] ON  [dbo].[CONTRULES]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesPACKAGE_SETUP] ON  [dbo].[PACKAGE_SETUP]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Permission_Setup] ON  [dbo].[HR_Permission_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Perm_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Perm_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesEFECT_FIL] ON  [dbo].[EFECT_FIL]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Public_Vacation] ON  [dbo].[HR_Public_Vacation]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesPAT_TYP_ACC] ON  [dbo].[PAT_TYP_ACC]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesINSURERSTERM] ON  [dbo].[INSURERSTERM]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select SYS_KEY
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select SYS_KEY
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesEND_FIL] ON  [dbo].[END_FIL]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Shift_Setup] ON  [dbo].[HR_Shift_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Shift_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Shift_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesPAYABLE_TYPES] ON  [dbo].[PAYABLE_TYPES]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesInvEffect_Insurers_Exclu] ON  [dbo].[InvEffect_Insurers_Exclu]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesENTRY_JOUR_PAT_SERV] ON  [dbo].[ENTRY_JOUR_PAT_SERV]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_Shift_StaffType] ON  [dbo].[Hr_Shift_StaffType]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Shift_Cont_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Shift_Cont_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicespaymethods] ON  [dbo].[paymethods]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesInvEffects_PaidBy] ON  [dbo].[InvEffects_PaidBy]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesFixed_Assets_Acc] ON  [dbo].[Fixed_Assets_Acc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Skill_Setup] ON  [dbo].[HR_Skill_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesPHARMALOGICALACTION_TRADENAME] ON  [dbo].[PHARMALOGICALACTION_TRADENAME]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select ID
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select ID
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Skill_Unit] ON  [dbo].[HR_Skill_Unit]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Skill_Unit_Code
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Skill_Unit_Code
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesFixed_Assets_Group] ON  [dbo].[Fixed_Assets_Group]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Social_Status] ON  [dbo].[HR_Social_Status]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesProcedures] ON  [dbo].[Procedures]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Specialty] ON  [dbo].[HR_Specialty]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Spec_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Spec_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesFixedAssetsPara] ON  [dbo].[FixedAssetsPara]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Accommodation] ON  [dbo].[HR_Staff_Accommodation]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesRECEIVABLE_TYPES] ON  [dbo].[RECEIVABLE_TYPES]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Asset] ON  [dbo].[HR_Staff_Asset]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesG_ApplicableRule] ON  [dbo].[G_ApplicableRule]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Courses] ON  [dbo].[HR_Staff_Courses]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Staff_Course_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Staff_Course_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSecurityRoles] ON  [dbo].[SecurityRoles]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Job] ON  [dbo].[HR_Staff_Job]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Education] ON  [dbo].[HR_Staff_Education]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesG_AppRule_PaidBy] ON  [dbo].[G_AppRule_PaidBy]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_MiscellConfig] ON  [dbo].[HR_Staff_MiscellConfig]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Injury] ON  [dbo].[HR_Staff_Injury]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSERVICES_ACCOUNT] ON  [dbo].[SERVICES_ACCOUNT]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Schedule_Standard] ON  [dbo].[HR_Staff_Schedule_Standard]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesExternalReferralSetup] ON  [dbo].[ExternalReferralSetup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select ExRefID
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select ExRefID
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesG_CalculationRule] ON  [dbo].[G_CalculationRule]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Medical] ON  [dbo].[HR_Staff_Medical]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSPECIALTY] ON  [dbo].[SPECIALTY]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Specialty_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Specialty_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesIGDETAIL] ON  [dbo].[IGDETAIL]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesG_EffectCode] ON  [dbo].[G_EffectCode]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Paper] ON  [dbo].[HR_Staff_Paper]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSponAllowedDiscAcc] ON  [dbo].[SponAllowedDiscAcc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesMedicaVisionCategories] ON  [dbo].[MedicaVisionCategories]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Id
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Id
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesG_EffectTypes] ON  [dbo].[G_EffectTypes]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_JobDegree] ON  [dbo].[HR_Staff_JobDegree]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Salary] ON  [dbo].[HR_Staff_Salary]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSponsorCtg_Acc] ON  [dbo].[SponsorCtg_Acc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesMedicaVisionDocumentTypes] ON  [dbo].[MedicaVisionDocumentTypes]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Id
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Id
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesGen_Sub_Acc] ON  [dbo].[Gen_Sub_Acc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_Staff_Attend] ON  [dbo].[Hr_Staff_Attend]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Staff_Attend_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Staff_Attend_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Separation] ON  [dbo].[HR_Staff_Separation]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesStaffMedicalFacility] ON  [dbo].[StaffMedicalFacility]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Shift_Staff] ON  [dbo].[HR_Shift_Staff]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select StaffShift_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select StaffShift_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesPATIENTFIELDS] ON  [dbo].[PATIENTFIELDS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesStockAcc_Params] ON  [dbo].[StockAcc_Params]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServiceshr_Pun_Comp] ON  [dbo].[hr_Pun_Comp]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Ticket] ON  [dbo].[HR_Staff_Ticket]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesGenericName] ON  [dbo].[GenericName]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select GenericName_ID
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select GenericName_ID
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_DailyAttend] ON  [dbo].[HR_Staff_DailyAttend]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select DailyAttend_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select DailyAttend_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesLANG_CONTROLS] ON  [dbo].[LANG_CONTROLS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesStockAccounts_Detail] ON  [dbo].[StockAccounts_Detail]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Schedule] ON  [dbo].[HR_Staff_Schedule]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Type] ON  [dbo].[HR_Staff_Type]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesGL_AP_AR_ACC_SETUP] ON  [dbo].[GL_AP_AR_ACC_SETUP]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Attend_Log] ON  [dbo].[HR_Staff_Attend_Log]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Staff_Attend_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Staff_Attend_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesLANG_FORMS] ON  [dbo].[LANG_FORMS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesStockAccounts_Head] ON  [dbo].[StockAccounts_Head]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>=1 and (select count(*) from deleted )=0 
		begin
				update st set NonStock_Flag=1
				from StockAccounts_Head as st inner join 
				inserted on st.sys_key=inserted.sys_key  inner join 
				itemfile on itemfile.item_code=inserted.item_code
				where inserted.Item_Type=3 and (itemfile.Is_Service=1 or itemfile.IsNonStock=1)
				and st.NonStock_Flag=0

				update st set NonStock_Flag=1
				from StockAccounts_Head as st inner join 
				inserted on st.sys_key=inserted.sys_key  inner join 
				groupfile on groupfile.group_code=inserted.group_code
				where inserted.Item_Type=3 and (groupfile.Non_Stock_Items=1 or groupfile.ServiceGroup=1)
				and st.NonStock_Flag=0 and st.item_code=-76666


					update st set NonStock_Flag=0
				from StockAccounts_Head as st inner join 
				inserted on st.sys_key=inserted.sys_key  inner join 
				itemfile on itemfile.item_code=inserted.item_code
				where inserted.Item_Type=3 and (itemfile.Is_Service=0 and itemfile.IsNonStock=0)
				and st.NonStock_Flag=1



				update StockAccounts_Head set NonStock_Flag=0
				where exists(
								select g.group_code 
								from itemfile inner join groupfile as g on itemfile.Group_Code =g.group_code 
								 where (IsNonStock=1 or Is_Service =1) 
								and  (g.Non_Stock_Items=1 or g.ServiceGroup=1)
								and exists (select * from itemfile as proth where (IsNonStock=1 or Is_Service =1) and proth.group_code= itemfile.group_code and 
											not exists (select * from StockAccounts_Head where StockAccounts_Head.item_code=proth.Item_Code  and StockAccounts_Head.item_type=3) )
								and exists (select * from itemfile as i where i.group_code= g.group_code and (i.IsNonStock=0 and i.Is_Service =0) and 
											not exists (select * from StockAccounts_Head as acc where acc.item_code=i.Item_Code  and acc.item_type=3))
								and g.group_code=(select top 1 inserted.group_code from inserted )
							)
				and group_code=(select top 1 inserted.group_code from inserted )
				and item_type=3 and NonStock_Flag=1
				and Item_Code=-76666
		end


	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Staff_Visa] ON  [dbo].[HR_Staff_Visa]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesGL_AP_AR_jour_docuType] ON  [dbo].[GL_AP_AR_jour_docuType]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesLANG_MESSAGES] ON  [dbo].[LANG_MESSAGES]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_AdvancedReports] ON  [dbo].[Sts_AdvancedReports]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_TypePayRoll_Vacation] ON  [dbo].[HR_TypePayRoll_Vacation]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesgroupfile] ON  [dbo].[groupfile]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesLANG_MULTIUSE_CONTROLS] ON  [dbo].[LANG_MULTIUSE_CONTROLS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_AdvancedReports_details] ON  [dbo].[Sts_AdvancedReports_details]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vac_Contract] ON  [dbo].[HR_Vac_Contract]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_DetailsfieldsLists] ON  [dbo].[Sts_DetailsfieldsLists]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesLANG_MULTIUSE_FORMS] ON  [dbo].[LANG_MULTIUSE_FORMS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Asset_Setup] ON  [dbo].[HR_Asset_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vac_Reasons] ON  [dbo].[HR_Vac_Reasons]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_DetailsRelations] ON  [dbo].[Sts_DetailsRelations]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesGen_Acc] ON  [dbo].[Gen_Acc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_AssRole_Dep] ON  [dbo].[HR_AssRole_Dep]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Ass_Dep_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Ass_Dep_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create  TRIGGER [dbo].[SharedServicesPricing] ON  [dbo].[PRICING]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END




GO
create TRIGGER [dbo].[SharedServicesLANG_PROJECTS] ON  [dbo].[LANG_PROJECTS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_DetailsReports] ON  [dbo].[Sts_DetailsReports]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sr_no
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sr_no
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Company_Course] ON  [dbo].[HR_Company_Course]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesINVPREVALUES] ON  [dbo].[INVPREVALUES]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vac_Rule] ON  [dbo].[HR_Vac_Rule]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_Reports_Desc] ON  [dbo].[Sts_Reports_Desc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Consult_Company] ON  [dbo].[HR_Consult_Company]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_Reports_Params] ON  [dbo].[Sts_Reports_Params]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Course_Setup] ON  [dbo].[HR_Course_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_Reports_SubReport] ON  [dbo].[Sts_Reports_SubReport]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_RptGrp_desc] ON  [dbo].[Sts_RptGrp_desc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesCONT_CONTROL] ON  [dbo].[CONT_CONTROL]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_UserChartsDetails] ON  [dbo].[Sts_UserChartsDetails]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select syskey
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select syskey
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSts_UserChartsmaster] ON  [dbo].[Sts_UserChartsmaster]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select chartcode
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select chartcode
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSub_Acc] ON  [dbo].[Sub_Acc]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicessuppliers] ON  [dbo].[suppliers]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSUPPLIERS_TYPE] ON  [dbo].[SUPPLIERS_TYPE]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_DocLoEndRep] ON  [dbo].[Hr_DocLoEndRep]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicestbl_Note_Types_Setup] ON  [dbo].[tbl_Note_Types_Setup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Note_Type_ID
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Note_Type_ID
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicestrade_drug] ON  [dbo].[trade_drug]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select trade_code
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select trade_code
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicestrade_drugParameters] ON  [dbo].[trade_drugParameters]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_DocReports] ON  [dbo].[Hr_DocReports]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select No_Rep
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select No_Rep
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesTradeName_GenericName] ON  [dbo].[TradeName_GenericName]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Doctor_CateEndry] ON  [dbo].[HR_Doctor_CateEndry]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesUnit] ON  [dbo].[Unit]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO

CREATE TRIGGER [dbo].[SharedServicesGL_ACC_CC_Ctg] ON  [dbo].[GL_ACC_CC_Ctg]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END



GO

CREATE   TRIGGER [dbo].[SharedServicessampletypes] ON  [dbo].[sampletypes]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select SYS_KEY
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select SYS_KEY
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END



GO
CREATE TRIGGER [dbo].[SharedServicesCPParamsTypes] ON  [dbo].[CPParamsTypes]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select id
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select id
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_AssConttractToTypePayRoll] ON  [dbo].[HR_Effect_AssConttractToTypePayRoll]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesFollowup_Category] ON  [dbo].[Followup_Category]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_effect_AssignMonth] ON  [dbo].[HR_effect_AssignMonth]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesFollowup_Parameters] ON  [dbo].[Followup_Parameters]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_AssignWages] ON  [dbo].[HR_Effect_AssignWages]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Ass_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Ass_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesFollowup_Params_choices] ON  [dbo].[Followup_Params_choices]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO


CREATE   TRIGGER [dbo].[SharedServicesPACKAGE_SETUP_DET] ON  [dbo].[PACKAGE_SETUP_DET]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Branch] ON  [dbo].[HR_Effect_Branch]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Branch_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Branch_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO


CREATE TRIGGER [dbo].[SharedServicesGL_ACC_CC_Ctg_Assign] ON  [dbo].[GL_ACC_CC_Ctg_Assign]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END



GO
CREATE TRIGGER [dbo].[SharedServicesVitalsignssetup] ON  [dbo].[Vitalsignssetup]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Serial
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Serial
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesDep_Type] ON  dbo.Dep_Type    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select DT_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select DT_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Classes] ON  [dbo].[HR_Effect_Classes]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Effect_Class_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Effect_Class_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO


CREATE TRIGGER [dbo].[SharedServicesGL_FS_Types] ON  [dbo].[GL_FS_Types]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END



GO

Create  TRIGGER [dbo].[SharedServicesPricing_H] ON  [dbo].[PRICING_H]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END




GO
CREATE TRIGGER [dbo].[SharedServicesgchart] ON  [dbo].[gchart]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_JobDeg] ON  dbo.HR_Effect_JobDeg    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Eff_JobDeg_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Eff_JobDeg_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Dep] ON  [dbo].[HR_Effect_Dep]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Eff_Dep_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Eff_Dep_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesLANGLABLES] ON  [dbo].[LANGLABLES]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select SYS_KEY
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select SYS_KEY
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO




CREATE TRIGGER [dbo].[SharedServicesGL_FS_Lines] ON  [dbo].[GL_FS_Lines]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END



GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vac_To_Reason] ON  [dbo].[HR_Vac_To_Reason]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Vac_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Vac_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesSupplier_Locations] ON  [dbo].[Supplier_Locations]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
create TRIGGER [dbo].[SharedServicesMCPROCS] ON  [dbo].[MCPROCS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_WorkType] ON  dbo.HR_Effect_WorkType    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Effect_Work_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Effect_Work_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Entry] ON  [dbo].[HR_Effect_Entry]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vacation_Balance] ON  [dbo].[HR_Vacation_Balance]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Staff_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Staff_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO



CREATE TRIGGER [dbo].[SharedServicesGL_FS_Line_Accounts] ON  [dbo].[GL_FS_Line_Accounts]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END



GO
create TRIGGER [dbo].[SharedServicesREPORTSTRUCTURE] ON  [dbo].[REPORTSTRUCTURE]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select ITEMCODE
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select ITEMCODE
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Medical_Setup] ON  dbo.HR_Medical_Setup    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Medical_Code
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Medical_Code
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesSupplier_locations_Contacts] ON  [dbo].[Supplier_locations_Contacts]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHr_vacation_DisBalance] ON  [dbo].[Hr_vacation_DisBalance]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_Event] ON  [dbo].[HR_Effect_Event]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vacation_Migration] ON  [dbo].[HR_Vacation_Migration]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Paper_Setup] ON  dbo.HR_Paper_Setup    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Paper_Code
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Paper_Code
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesSupplier_Principals] ON  [dbo].[Supplier_Principals]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vacation_Request] ON  [dbo].[HR_Vacation_Request]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Vac_Req_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Vac_Req_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Abs_Late_rules] ON  [dbo].[HR_Abs_Late_rules]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Abs_Late_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Abs_Late_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHr_Effect_Exclude] ON  [dbo].[Hr_Effect_Exclude]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesBank_PaymentSite] ON  [dbo].[Bank_PaymentSite]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Address] ON  [dbo].[HR_Address]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesSupplier_Principals_Items] ON  [dbo].[Supplier_Principals_Items]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vacation_Restore] ON  [dbo].[HR_Vacation_Restore]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Replace_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Replace_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_ATS_ApplicantEducation] ON  [dbo].[HR_ATS_ApplicantEducation]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_EFFECT_FAMILY] ON  [dbo].[HR_EFFECT_FAMILY]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select SYS_KEY
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select SYS_KEY
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesActualOPERATIONS] ON  [dbo].[ActualOPERATIONS]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_ATS_ApplicantExperiences] ON  [dbo].[HR_ATS_ApplicantExperiences]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesLocationContacts_Principals] ON  [dbo].[LocationContacts_Principals]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO

CREATE   TRIGGER [dbo].[SharedServicescontainer_types] ON  [dbo].[container_types]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select SYS_KEY
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select SYS_KEY
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END



GO
CREATE TRIGGER [dbo].[SharedServicesHR_ATS_ApplicantPrimaryPool] ON  [dbo].[HR_ATS_ApplicantPrimaryPool]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesHR_Effect_GL] ON  [dbo].[HR_Effect_GL]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesGENERAL_COD] ON  [dbo].[GENERAL_COD]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select gen_sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select gen_sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	
	where not exists(select * from inserted where inserted.gen_sys_key=v.value and inserted.main_cod=1)
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_benefits] ON  [dbo].[HR_benefits]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO
CREATE TRIGGER [dbo].[SharedServicesPur_Quotations_Head] ON  [dbo].[Pur_Quotations_Head]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_Vacation_Type] ON  [dbo].[HR_Vacation_Type]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END


GO
CREATE TRIGGER [dbo].[SharedServicesHR_comp_course_time] ON  [dbo].[HR_comp_course_time]    
AFTER  insert ,update ,delete
AS   
BEGIN
	declare @table_name varchar(100)=(select o.name from sys.triggers t inner join sys.objects o on t.parent_id=o.object_id where t.name=OBJECT_NAME(@@PROCID))

	declare @key_name varchar(100)
	declare @prevent_delete_flag int
	declare @is_prevent_bulkInsert int
	declare @is_prevent_bulkUpd int
	

	
	select @key_name=keyfield, @prevent_delete_flag=prevent_delete_flag,@is_prevent_bulkInsert=is_prevent_bulkInsert,@is_prevent_bulkUpd=is_prevent_bulkUpd
	from CentralDB.dbo.Table_keys with(nolock)
	where Table_keys.TableName=@table_name
	 
	if @key_name is null
	begin	
         RAISERROR('Cannot proceed central data not defined.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )>1 and @is_prevent_bulkUpd=1
	begin	
         RAISERROR('Cannot update more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )>1 and (select count(*) from deleted )=0 and @is_prevent_bulkInsert=1
	begin	
         RAISERROR('Cannot insert more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>1 and @prevent_delete_flag=1
	begin	
         RAISERROR('Cannot delete more than one record.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	if (select count(*) from inserted )=0 and (select count(*) from deleted )>=1 and @prevent_delete_flag=2
	begin	
         --RAISERROR('Delete not allowed.',16,1) 
         ROLLBACK TRANSACTION
         RETURN;     
	end

	declare @trans_type int
	if (select count(*) from deleted )>=1
	   begin
			if (select count(*) from inserted )>=1
				begin
				  set @trans_type=2
				end
			else
				begin
				  set @trans_type=3
				end
	   end
	   else 
			begin
				set @trans_type=1
			end

	
	set nocount on 
	declare @key_values table(value varchar(50))

	if @trans_type=3
		begin
			insert @key_values(value)
			select Sys_Key
			from deleted
		end
		else
			begin
				insert @key_values(value)
			select Sys_Key
				from inserted
			end
			 
	 insert into CentralDB.dbo.SharedServiesQUEUE( [TableName] , [HospitalID] , TransType, KeyField,keyfield_value, [Status] )
	 select @table_name,HospitalsList.HospitalID,@trans_type TransType,@key_name KeyField,v.value keyfield_value,0 Status
	 from @key_values v
	      cross apply(select HospitalID from CentralDB.dbo.HospitalsList where HospitalsList.HospitalID<>99) HospitalsList
	 
	 
END

GO