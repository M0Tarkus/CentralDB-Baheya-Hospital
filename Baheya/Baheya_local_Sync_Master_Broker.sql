USE [baheya]
GO
/****** Object:  StoredProcedure [dbo].[Sync_Master_Broker]    Script Date: 9/12/2025 2:49:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER    Procedure [dbo].[Sync_Master_Broker]
@transType int,
@tblname varchar(50),
@keyfield  nvarchar(500),
@keyfield_value varchar(50),
@source_db varchar(50)
as
begin
	print '@source_db'
	print @source_db
	declare @fieldsList nvarchar(max)=''
	declare @insert_List nvarchar(max)=''
	declare @upd_list  nvarchar(max)=''
	
	
	declare @is_identity int
	DECLARE @SQLQUERY nvarchar(max)=''
	
	declare @staff_key nvarchar(20)			
	--declare @source_db varchar(100)='lo.db'
	declare @master_listener varchar(200)=''
	if @source_db like'%.%' and @source_db not like'%.%.%.%'
		begin
			print 'Src_with listener'
			print charindex('.',@source_db,1)
			select @master_listener=substring(@source_db,1,charindex('.',@source_db,1)-1)
			print @master_listener

			set @source_db=right(@source_db,len(@source_db)-len(@master_listener)-1)
			print @source_db
		end

	declare @Repository_db_name nvarchar(50)='MedicaCloud_Repository'
	declare @hosp_key int
	
	if db_name()=@Repository_db_name
	begin
		set @hosp_key=0
	end
	else
		begin
				DECLARE @Hosp_QUERY nvarchar(4000)
				DECLARE @ParamDef nvarchar(2000)
				set @Hosp_QUERY= ' Select top 1 @hosp_key=sys_key from hospstruct with(nolock) where loc_type=11 order by sys_key  '
				Set @ParamDef =      '@hosp_key int output
															'
				Execute sp_Executesql   @Hosp_QUERY, 
										@ParamDef, 
										@hosp_key output			
		end
							
	if exists (select * from sys.objects where name=@tblname and type='U' )
	BEGIN
	print 'Hi'
		create table #master_columns  (column_name varchar(100))
				declare @master_columns_query varchar(max)=concat('select col.name
									   from ',iif(@master_listener='','', @master_listener+'.') +@source_db,'.sys.objects as obj inner join 
											',iif(@master_listener='','', @master_listener+'.')+@source_db,'.sys.columns as col on col.object_id=obj.object_id 
										where obj.name=''',@tblname,'''')
				insert into #master_columns
				exec(@master_columns_query)
print 'Bye'
declare @is_centraldb int=(select count(*) from sys.databases where name='centraldb') 
				
		if @transType=1 -- exclude computed, set identity on/off, set hospital id
			begin
				
				select @fieldsList=@fieldsList+',['+c.name+']',
					   @insert_List=@insert_List+','+iif(c.name in ('HOSPITAL','HospId','Hospital_Code','HOSPITAL_ID','Hospital_Key','HospitalCode','HospitalID','HOSPCODE','Hosp_id'),'@hospital_id','['+c.name+']')
					from sys.objects o inner join sys.columns c on c.object_id=o.object_id
					where o.name=@tblname
					      and not exists(select * 
									   from sys.objects as obj inner join 
											sys.columns as col on col.object_id=obj.object_id 
										where obj.name=@tblname  and c.name=col.name and col.is_computed=1  
									  )
						  and exists(select * 
									   from #master_columns col 
										where col.column_name=c.name )

				select @fieldsList=right(@fieldsList,len(@fieldsList)-1),@insert_List=right(@insert_List,len(@insert_List)-1)
				set @insert_List =replace(@insert_List,'@hospital_id',@hosp_key)

				select @is_identity=c.is_identity from sys.objects o inner join sys.columns c on o.object_id=c.object_id where o.name=@tblname and c.name=@keyfield
				if db_name()<>@Repository_db_name
				begin
				select @SQLQUERY=iif(@is_identity=1,'SET IDENTITY_INSERT '+@TblName +' ON'+char(10) ,'')+
				                 'insert ['+@tblname+'] (' + (@fieldsList)+')'+char(10)+
				                 'select '+@insert_List+char(10)+
								 'from '+iif(@master_listener='','', @master_listener+'.')+@source_db+'.dbo.['+@tblname+']'+char(10)+
								 'where ['+@keyfield+']='''+@keyfield_value+''''+
								 iif(@is_identity=1,char(10)+'SET IDENTITY_INSERT '+@TblName +' OFF' ,'')
				exec (@SQLQUERY)
				print 'insert'
				end
			end

		if @transType=2  -- to exclude computed , identity, set hospital id
			begin
				
				
				create table #Table_keys  (excluded_upd_columns varchar(max))
				declare @Table_keys_query varchar(max)=concat('select Table_keys.excluded_upd_columns
						                                             from ',+iif(@master_listener='' or @is_centraldb=1,'', @master_listener+'.'),'centraldb.dbo.Table_keys with(nolock) 
																	 where Table_keys.TableName=''',@tblname,'''')
				insert into #Table_keys
				exec(@Table_keys_query)


				select @upd_list=@upd_list+',['+c.name+']='+iif(c.name in ('HOSPITAL','HospId','Hospital_Code','HOSPITAL_ID','Hospital_Key','HospitalCode','HospitalID','HOSPCODE','Hosp_id'),'@hospital_id','cen.['+c.name+']')
				from sys.objects o inner join sys.columns c on c.object_id=o.object_id
				where o.name=@tblname
					      and not exists(select * 
									   from sys.objects as obj inner join 
											sys.columns as col on col.object_id=obj.object_id 
										where obj.name=@tblname and c.name=col.name and (col.is_computed=1 or col.is_identity=1 or col.name=@keyfield )
									  )
						  and exists(select * 
									   from #master_columns col 
										where col.column_name=c.name )

						 and c.name not in(select value 
						                     from string_split((select replace(Table_keys.excluded_upd_columns,' ','') 
						                                             from #Table_keys Table_keys),','
															  )
									        )
                print 'X'
				select @upd_list=right(@upd_list,len(@upd_list)-1)
				set @upd_list=replace(@upd_list,'@hospital_id',@hosp_key)
				
				select @SQLQUERY='update ['+@tblname+'] set '+@upd_list+char(10)+
								 'from '+iif(@master_listener='','', @master_listener+'.')+@source_db+'.dbo.['+@tblname+'] cen inner join ['+@tblname+'] on cen.[' +@keyfield+']=['+@tblname+'].['+@keyfield+']'+char(10)+
								 'where cen.['+@keyfield+']='''+@keyfield_value+''''
				print left(@SQLQUERY,500)
				print right(@SQLQUERY,500)
				exec (@SQLQUERY)
			end
		
		if @transType=3
			begin
				select @SQLQUERY='delete ['+@tblname+'] where ['+@keyfield+']='''+@keyfield_value+''''
				exec (@SQLQUERY)
			end

				
					if @Repository_db_name is not null and @tblname='Patient'
					   and db_name()<>@Repository_db_name
						begin
							
							set @staff_key=(select userid from dbo.patient with(nolock) where patient_id=@keyfield_value)							
							
							declare @mapper_sql nvarchar(max)
							declare @hosp_key_var nvarchar(20)=(select cast(@hosp_key as nvarchar(20)))
							
							declare @db_key_map int
									declare  @ParamDB nvarchar(2000)='@db_key_map int output
															'
									declare @db_query nvarchar(2000)=
									'
										select  @db_key_map =(select mtdb_sys_key from '+iif(@master_listener='' or @is_centraldb=1,'', @master_listener+'.')+@Repository_db_name+'.dbo.MT_Databases where MTDB_Dbname=DB_NAME())
										'
										
									Execute sp_Executesql   @db_query, 
															@ParamDB, 
															@db_key_map output


							if @transType=1
								begin
									
									Set @mapper_sql='
										INSERT INTO [dbo].[SharedMRN_Mapper] ([HospId],[GMRN],[HMRN],[AddDate],[AddedBy],[Original]) 
										values('+@hosp_key_var+','+@keyfield_value+','+@keyfield_value+',GETDATE(),'+isnull(@staff_key,0)+',0)        

										'

										print '@mapper_sql='
										print @mapper_sql
										if  @is_centraldb=1
											begin
												set @mapper_sql=@mapper_sql+concat('exec ',@Repository_db_name,'.dbo.SharedMRN_AddtoMapper ',@keyfield_value,',',@keyfield_value,',',@hosp_key_var,',',isnull(@staff_key,0),',',@db_key_map)
												print 'D'
											end
											else 
												begin
												  set @mapper_sql=@mapper_sql+concat( 'exec (''execute ',@Repository_db_name,'.dbo.SharedMRN_AddtoMapper ',@keyfield_value,',',@keyfield_value,',',@hosp_key_var,',',isnull(@staff_key,0),',',@db_key_map,''') AT ',@master_listener)

												end
										print 'Z'
							    end
							if @transType=2
								begin
									--print @master_listener
									--print @Repository_db_name
								    
									Set @mapper_sql=
										'
										exec SharedMRN_UpdateSpeicalData '+@keyfield_value+','+@hosp_key_var+','+isnull(@staff_key,0)+'
										'
										print '@mapper_sql='
										print @mapper_sql
									if @is_centraldb=1
											begin
												Set @mapper_sql =@mapper_sql+'
														exec '+@Repository_db_name+'.dbo.SharedMRN_UpdateSpeicalData '+@keyfield_value+','+@hosp_key_var+','+isnull(@staff_key,0)+','+cast(@db_key_map as varchar(20))
											end
											else 
											begin
												print 'N'
												Set @mapper_sql =@mapper_sql+concat( 'exec (''execute ',@Repository_db_name,'.dbo.SharedMRN_UpdateSpeicalData '+@keyfield_value+','+@hosp_key_var+','+isnull(@staff_key,0),',',@db_key_map,''') AT ',@master_listener)
											end
							    end
								print '@master_listener'
								
								DECLARE @Repository_sql nvarchar(max)
								if isnull(@master_listener,'')='' or @is_centraldb=1
											begin
												set @Repository_sql=concat( 'exec '+@Repository_db_name+'.dbo.Sync_Master_Broker ', cast(@transType as nvarchar(20)),',',''''+@tblname,''',',''''+@keyfield+''',''',@keyfield_value,''',''',@source_db,'''')
											end
											else if @is_centraldb=1 and isnull(@master_listener,'')<>''
											begin
											set @Repository_sql=concat( 'exec '+@Repository_db_name+'.dbo.Sync_Master_Broker ', cast(@transType as nvarchar(20)),',',''''+@tblname,''',',''''+@keyfield+''',''',@keyfield_value,''',''',@master_listener,'.',@source_db,'''')
											end
											
											else 
											begin
											  set @Repository_sql=concat( 'exec (''execute ',@Repository_db_name,'.dbo.Sync_Master_Broker ', cast(@transType as nvarchar(20)),',',''''''+@tblname,''''',',''''''+@keyfield+''''',''''',@keyfield_value,''''',''''',@source_db,''''''') AT ',@master_listener)

											  

											end

								--print @mapper_sql
								print @master_listener
								print 'M'
								print @Repository_sql
								print '@mapper_sql='
								print @mapper_sql
								exec (@mapper_sql)
								print 'z'
								exec(@Repository_sql)
						end
						
	END
END