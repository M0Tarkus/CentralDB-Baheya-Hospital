USE [Baheya_Zayed]
GO
/****** Object:  StoredProcedure [dbo].[Master_Broker]    Script Date: 9/12/2025 2:32:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[Master_Broker]
as
begin
declare @DB_name nvarchar(250)
DECLARE @SQLQUERY nvarchar(max)
declare @key bigint
declare @hospitalid int
declare @tblname varchar(50)
declare @transType int
declare @keyfield nvarchar(500)
declare @keyfield_value varchar(50)


select top 500 * 
into #temp
from CentralDB.dbo.SharedServiesQUEUE with(nolock) where status=0
order by Sys_Key

declare @centralDB_name nvarchar(250)

select @centralDB_name=data
from 
			CentralDB.dbo.HospitalsList as CL with(nolock) 
		cross apply ( select data from 
									Split_FN(
											(select top 1 ConnectionSTR from CentralDB.dbo.HospitalsList as L where L.hospitalid=cl.hospitalid)
											,'=' 
											) where  id=5
					) as a 
where cl.HospitalID=99

--select @centralDB_name

declare @Repository_db_name nvarchar(50)='MedicaCloud_Repository'
declare @full_Repository_db_name nvarchar(250)
declare @full_central_master_db_name nvarchar(250)
select @full_Repository_db_name=concat(iif(ipaddress='.','',concat('[',ipaddress,'].')),@Repository_db_name),
       @full_central_master_db_name=concat(iif(ipaddress='.','',concat('[',ipaddress,'].')),data)  
from 
		CentralDB.dbo.HospitalsList as CL with(nolock) 
	cross apply ( select data from 
								Split_FN(
										(select top 1 ConnectionSTR from CentralDB.dbo.HospitalsList as L where L.hospitalid=cl.hospitalid)
										,'=' 
										) where  id=5
				) as a 
where cl.HospitalID=99
--select @full_Repository_db_name



while  exists(select sys_key from #temp)
	begin
		
		select top 1 @key=sys_key,@hospitalid=hospitalid,@transType=TransType,@keyfield=KeyField,@keyfield_value=keyfield_value,
		             --@recordstr=REPLACE(recordstr,char(0x0002),''),
					 @tblname=tablename
		from  #temp 
		order by Sys_Key
		------------------------------------------------------------
		select @DB_name=concat(iif(ipaddress='.','',concat('[',ipaddress,'].')),data)  
		from 
					CentralDB.dbo.HospitalsList as CL with(nolock) 
				cross apply ( select data from 
											Split_FN(
													(select top 1 ConnectionSTR from CentralDB.dbo.HospitalsList as L where L.hospitalid=cl.hospitalid)
													,'=' 
													) where  id=5
							) as a 
		where cl.HospitalID=@hospitalid
		
		--------------------------------------
		

		select  @SQLQUERY=concat( 'exec ',iif(@hospitalid=99,'', @DB_name+'.'),'dbo.Sync_Master_Broker ', cast(@transType as nvarchar(20)),',',''''+@tblname,''',',''''+@keyfield+''',''',@keyfield_value,'''',',''',@full_central_master_db_name,'''',',''',@full_central_master_db_name,'''',',''',@full_Repository_db_name,'''')
		
		begin try
			Set NOCOUNT ON
			SET XACT_ABORT ON
			set @SQLQuery=replace(REPLACE(@SQLQuery,char(0x0002),''),char(0x001F),'')
			Execute sp_Executesql   @SQLQuery
			update  CentralDB.dbo.SharedServiesQUEUE set Status=1,err='' where Sys_Key=@key
		end try
		begin catch
				update  CentralDB.dbo.SharedServiesQUEUE set Status=-1,ERR=isnull( ERROR_MESSAGE(),'') where Sys_Key=@key
		end catch
		
		delete #temp where sys_key=@key
	end
END
