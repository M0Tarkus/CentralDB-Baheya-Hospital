IF (
		-- Condition 1: It's a standalone instance (AG feature not enabled or no AGs are configured).
		ISNULL(SERVERPROPERTY('IsHadrEnabled'), 0) = 0
		OR NOT EXISTS (
			SELECT 1
			FROM sys.availability_groups
			)
		)
	OR (
		-- Condition 2: It's an AG instance AND this is the PRIMARY replica for the specific AG.
		-- This part is only evaluated if the first condition is false, preventing errors.
		sys.fn_hadr_is_primary_replica('MCCDBBA') = 1
		)
BEGIN
	EXEC University_Central.dbo.Master_Broker;
END