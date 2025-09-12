CREATE OR ALTER TRIGGER [dbo].[SharedServicesPATIENT] 
   ON  dbo.PATIENT
   AFTER  insert
AS 
BEGIN
set nocount on

declare @patname varchar(100)
declare @MyID int=(SELECT cast(replace(replace(sm.text,'(',''),')','') as int)
							FROM sys.sysobjects so
								JOIN sys.syscolumns sc ON sc.id = so.id
								LEFT JOIN sys.syscomments sm ON sm.id = sc.cdefault
						WHERE so.xtype = 'U' AND so.name = 'patient' And sc.name = 'shospitalid'
						)
declare @HID int
declare @patient_id varchar(20) 
select @patient_id=patient_id,@hid=shospitalid from inserted

	if @HID = @MyID and @patient_id not like'-%'
	begin

		insert into SharedServiesQUEUE(	[TableName] ,	[HospitalID] ,	[Status],KeyField,keyfield_value,TransType ) 
		select 'patient' TableName,@MyID HospitalID,0 Status,'patient_id' KeyField , ltrim(cast(@patient_id as varchar(30))) keyfield_value,1 TransType	
	end
	if @HID <> @MyID and @patient_id not like'-%'
	begin
		
		exec ChartTracking_CreateNew @patient_id,616,@HID,@patient_id
	end
END

GO
CREATE OR ALTER TRIGGER [dbo].[SharedServicesUpdPATIENT] 
   ON  dbo.PATIENT
   AFTER  update
AS 
BEGIN
	set nocount on
	declare @patient_id varchar(20)
	declare @old_patient_id varchar(20)
	select top 1 @patient_id= patient_id from inserted with (nolock)
	select top 1 @old_patient_id= patient_id  from deleted with (nolock)
	if not update (ProcessUser) and  not update (UnderProcess) and  not update (weight) and  not update (height)
	begin
		if not update(shospitalid)	
			begin		
				if (select count(patient_id) from inserted with (nolock))=1 and @patient_id not like'-%'
					begin
							declare @MyID int=(SELECT cast(replace(replace(sm.text,'(',''),')','') as int)
													 FROM sys.sysobjects so
														  JOIN sys.syscolumns sc ON sc.id = so.id
														  LEFT JOIN sys.syscomments sm ON sm.id = sc.cdefault
													WHERE so.xtype = 'U' AND so.name = 'patient' And sc.name = 'shospitalid'
												   )

							insert into SharedServiesQUEUE(	[TableName] ,	[HospitalID] ,	[Status],KeyField,keyfield_value,TransType ) 
							select 'patient' TableName,@MyID HospitalID,0 Status,'patient_id' KeyField, ltrim(cast(@patient_id as varchar(30))) keyfield_value,iif(@old_patient_id like'-%',1, 2) TransType
	
							
					end	
					
			end
	END	
end

GO

ENABLE TRIGGER [SharedServicesPATIENT] ON PATIENT;
ENABLE TRIGGER [SharedServicesUpdPATIENT] ON PATIENT;