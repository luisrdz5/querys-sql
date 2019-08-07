SELECT [UserName] = ulogin.[name],
       [UserType]             = CASE princ.[type]
                         WHEN 'S' THEN 'SQL User'
                         WHEN 'U' THEN 'Windows User'
                         WHEN 'G' THEN 'Windows Group'
                    END,
       [DatabaseUserName]     = princ.[name],
       [Role]                 = NULL,
       [PermissionState]      = perm.[state_desc],
       [PermissionType]       = perm.[permission_name],
       [ObjectType]           = CASE perm.[class]
                           WHEN 1 THEN obj.type_desc -- Schema-contained objects
                           ELSE perm.[class_desc] -- Higher-level objects
                      END,
       [ObjectName]           = CASE perm.[class]
                           WHEN 1 THEN OBJECT_NAME(perm.major_id) -- General objects
                           WHEN 3 THEN schem.[name] -- Schemas
                           WHEN 4 THEN imp.[name] -- Impersonations
                      END,
       [ColumnName]           = col.[name]
FROM   --database user
       sys.database_principals princ
       LEFT JOIN --Login accounts
            sys.server_principals ulogin
            ON  princ.[sid] = ulogin.[sid]
       LEFT JOIN --Permissions
            sys.database_permissions perm
            ON  perm.[grantee_principal_id] = princ.[principal_id]
       LEFT JOIN --Table columns
            sys.columns col
            ON  col.[object_id] = perm.major_id
            AND col.[column_id] = perm.[minor_id]
       LEFT JOIN sys.objects obj
            ON  perm.[major_id] = obj.[object_id]
       LEFT JOIN sys.schemas schem
            ON  schem.[schema_id] = perm.[major_id]
       LEFT JOIN sys.database_principals imp
            ON  imp.[principal_id] = perm.[major_id]
WHERE  princ.[type] IN ('S', 'U', 'G')
       AND -- No need for these system accounts
           princ.[name] NOT IN ('sys', 'INFORMATION_SCHEMA')
       and 
			princ.[name] in (SELECT name FROM sys.sql_logins where is_disabled=0)
		and   (OBJECT_NAME(perm.major_id) in ('pagos')
		or
		perm.[permission_name] = 'DROP'
		or OBJECT_NAME(perm.major_id) in ('solicitudese19')
		--or	perm.[permission_name] = 'delete'
		)
ORDER BY
       ulogin.[name],
       [ObjectName],
       OBJECT_NAME(perm.major_id)