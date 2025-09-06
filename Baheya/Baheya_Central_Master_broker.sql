USE [Baheya_Central]
GO
/****** Object:  StoredProcedure [dbo].[Master_Broker]    Script Date: 9/4/2025 3:29:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER   Procedure [dbo].[Master_Broker]
as
begin
declare @DB_name nvarchar(250)
declare @DB_name_master nvarchar(250)=db_name()
declare @IP_Address_master nvarchar(200)=(select IPaddress from centraldb.dbo.hospitalslist with(nolock) where hospitalid=99)
declare @IP_Address nvarchar(250)
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

while  exists(select sys_key from #temp)
	begin
		
		select top 1 @key=sys_key,@hospitalid=hospitalid,@transType=TransType,@keyfield=KeyField,@keyfield_value=keyfield_value,
		             --@recordstr=REPLACE(recordstr,char(0x0002),''),
					 @tblname=tablename
		from  #temp 
		order by Sys_Key
		
		select @DB_name=data  ,@IP_Address=concat('[',ipaddress,']')
		from 
					CentralDB.dbo.HospitalsList as CL with(nolock) 
				cross apply ( select data from 
											split(
													(select top 1 ConnectionSTR from CentralDB.dbo.HospitalsList as L where L.hospitalid=cl.hospitalid)
													,'=' 
													) where  id=5
							) as a 
		where cl.HospitalID=@hospitalid
		
		if @IP_Address<>'[.]'
		begin
		select  @SQLQUERY=concat( 'exec (''execute ',@DB_name,'.dbo.','Sync_Master_Broker ', cast(@transType as nvarchar(20)),',',''''''+@tblname,''''',',''''''+@keyfield+''''',''''',@keyfield_value,'''''',',''''',@IP_Address_master,'.',@DB_name_master,'''''',''') AT ',@IP_Address)
			print @sqlquery
		end
		else
			begin
				select  @SQLQUERY=concat( 'exec ',iif(@hospitalid=99,'', @DB_name+'.'),'dbo.Sync_Master_Broker ', cast(@transType as nvarchar(20)),',',''''+@tblname,''',',''''+@keyfield+''',''',@keyfield_value,'''',',''',@DB_name_master,'''')
			end
		begin try
			Set NOCOUNT ON
			SET XACT_ABORT ON
			set @SQLQuery=replace(REPLACE(@SQLQuery,char(0x0002),''),char(0x001F),'')
			Execute sp_Executesql   @SQLQuery
			update  CentralDB.dbo.SharedServiesQUEUE set Status=1,err='' where Sys_Key=@key
		end try
		begin catch
				update  CentralDB.dbo.SharedServiesQUEUE set Status=-1,ERR=isnull( ERROR_MESSAGE()+@SQLQUERY,'') where Sys_Key=@key --and keyfield_value!='10123236414'
		end catch
		
		delete #temp where sys_key=@key
	end
END