USE [BRIANE_APP]
GO
/****** Object:  StoredProcedure [dbo].[DEFAULT_ADDRESS_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DEFAULT_ADDRESS_CLIENT]
	-- Add the parameters for the stored procedure here	
	@ID_ADDRESS_CLIENT NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(250)

			UPDATE [dbo].[ADDRESS_CLIENT]
			SET [FG_PRINCIPAL] = 0
			
			UPDATE [dbo].[ADDRESS_CLIENT]
			SET [FG_PRINCIPAL] = 1
			WHERE ID_ADDRESS_CLIENT = @ID_ADDRESS_CLIENT
			
			SET @MESSAGE = 'Sucursal Actualizada Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM VIEW_ADDRESS_CLIENT WHERE ID_ADDRESS_CLIENT = @ID_ADDRESS_CLIENT
		
END






GO
/****** Object:  StoredProcedure [dbo].[DEFAULT_ADDRESS_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DEFAULT_ADDRESS_COMPANY]
	-- Add the parameters for the stored procedure here	
	@ID_ADDRESS_COMPANY NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(250)

			UPDATE [dbo].[ADDRESS_COMPANY]
			SET [FG_PRINCIPAL] = 0
			
			UPDATE [dbo].[ADDRESS_COMPANY]
			SET [FG_PRINCIPAL] = 1
			WHERE ID_ADDRESS_COMPANY = @ID_ADDRESS_COMPANY
			
			SET @MESSAGE = 'Sucursal Actualizada Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM VIEW_ADDRESS_COMPANY WHERE ID_ADDRESS_COMPANY = @ID_ADDRESS_COMPANY
		
END





GO
/****** Object:  StoredProcedure [dbo].[DELETE_ADDRESS_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_ADDRESS_CLIENT]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100), @OK INT, @ID_ADDRESS_CLIENT numeric(18,0)
	
	SET @OK = 1

	SELECT @ID_ADDRESS_CLIENT = ID_ADDRESS_CLIENT FROM ADDRESS_CLIENT WHERE ID_ADDRESS_CLIENT = @ID AND FG_ACTIVE = 1 AND FG_PRINCIPAL = 1
	BEGIN
		IF  @ID_ADDRESS_CLIENT > 0 
		BEGIN
			SET @MESSAGE = 'Disculpe, No puede eliminar la dirección principal.'
			SET @OK = 0
			SELECT ID_ADDRESS_CLIENT = 0, @MESSAGE AS MESSAGE  
		END
	END
		
	IF @OK = 1
	BEGIN	
		UPDATE [dbo].[ADDRESS_CLIENT]
		SET FG_ACTIVE =0			   		   
		WHERE ID_ADDRESS_CLIENT = @ID 
			
		SET @MESSAGE = 'Sucursal Eliminada Correctamente.'
		SELECT *, @MESSAGE AS MESSAGE FROM ADDRESS_CLIENT WHERE ID_ADDRESS_CLIENT = @ID
	END 
END




GO
/****** Object:  StoredProcedure [dbo].[DELETE_ADDRESS_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_ADDRESS_COMPANY]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100), @OK INT, @ID_ADDRESS_COMPANY numeric(18,0)
	
	SET @OK = 1

	SELECT @ID_ADDRESS_COMPANY = ID_ADDRESS_COMPANY FROM ADDRESS_COMPANY WHERE ID_ADDRESS_COMPANY = @ID AND FG_ACTIVE = 1 AND FG_PRINCIPAL = 1
	BEGIN
		IF  @ID_ADDRESS_COMPANY > 0 
		BEGIN
			SET @MESSAGE = 'Disculpe, No puede eliminar la dirección principal.'
			SET @OK = 0
			SELECT ID_ADDRESS_COMPANY = 0, @MESSAGE AS MESSAGE  
		END
	END
		
	IF @OK = 1
	BEGIN	
		UPDATE [dbo].[ADDRESS_COMPANY]
		SET FG_ACTIVE =0			   		   
		WHERE ID_ADDRESS_COMPANY = @ID 
			
		SET @MESSAGE = 'Sucursal Eliminada Correctamente.'
		SELECT *, @MESSAGE AS MESSAGE FROM ADDRESS_COMPANY WHERE ID_ADDRESS_COMPANY = @ID
	END
END



GO
/****** Object:  StoredProcedure [dbo].[DELETE_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_CLIENT]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100)	
		
	UPDATE [dbo].[CLIENT]
	SET FG_ACTIVE =0			   		   
	WHERE ID_CLIENT = @ID 
			
	SET @MESSAGE = 'Cliente Eliminado Correctamente.'
	SELECT *, @MESSAGE AS MESSAGE FROM CLIENT WHERE ID_CLIENT = @ID
END



GO
/****** Object:  StoredProcedure [dbo].[DELETE_COMPANY_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_COMPANY_USER]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100)	
		
	UPDATE [dbo].[COMPANY_USER]
	SET FG_ACTIVE =0			   		   
	WHERE ID_COMPANY_USER = @ID 
			
	SET @MESSAGE = 'Empresa Eliminada Correctamente.'
	SELECT ID_COMPANY_USER, ID_COMPANY, ID_USER, DS_COMPANY, EMAIL, PHONE, CONTACT, IMAGE, @MESSAGE AS MESSAGE FROM COMPANY_USER WHERE ID_COMPANY_USER = @ID
END


GO
/****** Object:  StoredProcedure [dbo].[DELETE_MODULE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_MODULE]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100)	
		
	UPDATE [dbo].[MODULES]
	SET FG_ACTIVE =0			   		   
	WHERE ID_MODULE = @ID 
			
	SET @MESSAGE = 'Modulo Eliminado Correctamente.'
	SELECT *, @MESSAGE AS MESSAGE FROM MODULES WHERE ID_MODULE = @ID
END



GO
/****** Object:  StoredProcedure [dbo].[DELETE_ROLE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_ROLE]
	-- Add the parameters for the stored procedure here
	@ID_ROLE INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @MESSAGE VARCHAR(100)		
		
			UPDATE [dbo].[USER_ROLES]
			SET [FG_ACTIVE] = 0
			WHERE ID_ROLE = @ID_ROLE AND FG_ACTIVE = 1

					
			SET @MESSAGE = 'Rol de Usuario Eliminado Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM USER_ROLES WHERE ID_ROLE = @ID_ROLE AND FG_ACTIVE = 0
		

END



GO
/****** Object:  StoredProcedure [dbo].[DELETE_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_USER]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100)	
		
	UPDATE [dbo].[USERS]
	SET FG_ACTIVE =0			   		   
	WHERE ID_USER = @ID 
			
	SET @MESSAGE = 'Usuario Eliminado Correctamente.'
	SELECT ID_USER, NAME, EMAIL, IMAGE, GOOGLE, ID_ROLE, @MESSAGE AS MESSAGE FROM USERS WHERE ID_USER = @ID
END

GO
/****** Object:  StoredProcedure [dbo].[GET_ADDRESS_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_ADDRESS_CLIENT]
	-- Add the parameters for the stored procedure here
	@ID_ADDRESS_CLIENT NUMERIC(18,0),
	@ID_USER NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM VIEW_ADDRESS_CLIENT WHERE ID_ADDRESS_CLIENT = @ID_ADDRESS_CLIENT AND ID_USER = @ID_USER
END





GO
/****** Object:  StoredProcedure [dbo].[GET_ADDRESS_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_ADDRESS_COMPANY]
	-- Add the parameters for the stored procedure here
	@ID_ADDRESS_COMPANY NUMERIC(18,0),
	@ID_USER NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM VIEW_ADDRESS_COMPANY WHERE ID_ADDRESS_COMPANY = @ID_ADDRESS_COMPANY AND ID_USER = @ID_USER
END




GO
/****** Object:  StoredProcedure [dbo].[GET_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_CLIENT]
	@ID NUMERIC(18,0),
	@ID_USER NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;	
		
		SELECT ROW_NUMBER() OVER (ORDER BY ID_CLIENT, ID_CLIENT) [ITEMS], * FROM CLIENT 
		WHERE ID_CLIENT = @ID AND FG_ACTIVE = 1 AND ID_USER = @ID_USER		

END


GO
/****** Object:  StoredProcedure [dbo].[GET_CLIENTS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_CLIENTS]
	@ID_USER NUMERIC(18,0),
	@SEARCH VARCHAR(100)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @SEARCH2 VARCHAR(100);
	SET NOCOUNT ON;	

	BEGIN
		IF @SEARCH = '0'
		BEGIN
			SET @SEARCH2 = ''
		END
	END

	BEGIN
		IF @SEARCH <> '0'
		BEGIN
			SET @SEARCH2 = @SEARCH
		END
	END

	BEGIN
		IF @SEARCH2 = '0'
		BEGIN
			SELECT ROW_NUMBER() OVER (ORDER BY ID_CLIENT, ID_CLIENT) [ITEMS], * FROM CLIENT 
			WHERE FG_ACTIVE = 1 
		END
	END

    BEGIN
		IF @SEARCH2 <> '0'
		BEGIN
			SELECT ROW_NUMBER() OVER (ORDER BY ID_CLIENT, ID_CLIENT) [ITEMS], * FROM CLIENT 
			WHERE FG_ACTIVE = 1 AND ID_USER = @ID_USER AND ((DS_CLIENT LIKE '%'+RTRIM(@SEARCH2)+'%') OR (EMAIL LIKE '%'+RTRIM(@SEARCH2)+'%')
			OR (PHONE LIKE '%'+RTRIM(@SEARCH2)+'%') OR (CONTACT LIKE '%'+RTRIM(@SEARCH2)+'%'))
			ORDER BY DS_CLIENT
		END
	END

END




GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANY_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_COMPANY_USER]
	
	@ID_COMPANY_USER NUMERIC(18,0),
	@ID_USER NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ID_COMPANY_USER, ID_COMPANY, ID_USER, DS_COMPANY, EMAIL, PHONE, CONTACT, IMAGE
	FROM COMPANY_USER 
	WHERE ID_COMPANY_USER = @ID_COMPANY_USER AND ID_USER = @ID_USER AND FG_ACTIVE = 1
END




GO
/****** Object:  StoredProcedure [dbo].[GET_COMPANYS_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_COMPANYS_USER]
	
	@ID_USER NUMERIC(18,0),
	@SEARCH VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @SEARCH2 VARCHAR(100);
	SET NOCOUNT ON;	

	BEGIN
		IF @SEARCH = '0'
		BEGIN
			SET @SEARCH2 = ''
		END
	END

	BEGIN
		IF @SEARCH <> '0'
		BEGIN
			SET @SEARCH2 = @SEARCH
		END
	END

	BEGIN
		IF @SEARCH2 = '0'
		BEGIN
			SELECT ROW_NUMBER() OVER (ORDER BY ID_COMPANY_USER, ID_COMPANY_USER) [ITEMS], * FROM COMPANY_USER 
			WHERE FG_ACTIVE = 1 AND ID_USER = @ID_USER
		END
	END

    BEGIN
		IF @SEARCH2 <> '0'
		BEGIN
			SELECT ROW_NUMBER() OVER (ORDER BY ID_COMPANY_USER, ID_COMPANY_USER) [ITEMS], * FROM COMPANY_USER 
			WHERE FG_ACTIVE = 1 AND ID_USER = @ID_USER AND ((DS_COMPANY LIKE '%'+RTRIM(@SEARCH2)+'%') OR (EMAIL LIKE '%'+RTRIM(@SEARCH2)+'%'))
			ORDER BY DS_COMPANY
		END
	END

END



GO
/****** Object:  StoredProcedure [dbo].[GET_MODULE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_MODULE] 
	-- Add the parameters for the stored procedure here
@ID_MODULE INT
	
AS
BEGIN
	
	
	SELECT * FROM VIEW_MODULES WHERE ID_MODULE = @ID_MODULE 


END



GO
/****** Object:  StoredProcedure [dbo].[GET_MODULE_DELETE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_MODULE_DELETE]
	-- Add the parameters for the stored procedure here
	@ID_MODULE INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON;
	-- DECLARE @ID INT

	-- SET @ID = 0

    -- Insert statements for procedure here
	SELECT ID_MODULE FROM MODULES WHERE FG_ACTIVE = 1 AND ID_MODULE_SEC = @ID_MODULE
	

END

GO
/****** Object:  StoredProcedure [dbo].[GET_ROLES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_ROLES]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM USER_ROLES WHERE FG_ACTIVE = 1 ORDER BY DS_ROLE
END

GO
/****** Object:  StoredProcedure [dbo].[GET_ROLES_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_ROLES_USER]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM USER_ROLES WHERE ID_ROLE > 1 AND FG_ACTIVE = 1 ORDER BY DS_ROLE
END


GO
/****** Object:  StoredProcedure [dbo].[GET_UBIGEO]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_UBIGEO]
	-- Add the parameters for the stored procedure here
	@DS_DISTRITO VARCHAR(100),
	@DS_PROVINCIA VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM VIEW_UBIGEOS WHERE DS_DISTRITO = @DS_DISTRITO AND DS_PROVINCIA = @DS_PROVINCIA ORDER BY DS_DISTRITO
END

GO
/****** Object:  StoredProcedure [dbo].[GET_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_USER]
	
	@ID NUMERIC(18,0)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM USERS WHERE ID_USER = @ID AND FG_ACTIVE = 1
END


GO
/****** Object:  StoredProcedure [dbo].[GET_USERS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_USERS]
	
@SEARCH VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @SEARCH2 VARCHAR(100)
	SET NOCOUNT ON;

	BEGIN
		IF @SEARCH = '0'
		BEGIN
			SET @SEARCH2 = ''
		END
	END

	BEGIN
		IF @SEARCH <> '0'
		BEGIN
			SET @SEARCH2 = @SEARCH
		END
	END


	BEGIN
		IF @SEARCH2 = '0'
		BEGIN
			SELECT ROW_NUMBER() OVER (ORDER BY ID_USER, ID_USER) [ITEMS], * FROM VIEW_USERS ORDER BY ID_USER
		END
	END

	BEGIN
		IF @SEARCH2 <> '0'
		BEGIN
			SELECT ROW_NUMBER() OVER (ORDER BY ID_USER, ID_USER) [ITEMS], *
			FROM VIEW_USERS 
			--WHERE (NUM >= @DESDE AND NUM <=@HASTA)
			WHERE (NAME LIKE '%'+RTRIM(@SEARCH2)+'%') OR (EMAIL LIKE '%'+RTRIM(@SEARCH2)+'%') OR (DS_ROLE LIKE '%'+RTRIM(@SEARCH2)+'%') OR (AUTHENTICATION LIKE '%'+RTRIM(@SEARCH2)+'%')
			ORDER BY NAME
		END
	END
	

  
	

END




GO
/****** Object:  StoredProcedure [dbo].[GET_USERS1]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_USERS1]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ID_USER, NAME, EMAIL, IMAGE, GOOGLE, ID_ROLE FROM USERS WHERE FG_ACTIVE = 1
END

GO
/****** Object:  StoredProcedure [dbo].[GETS_ADDRESS_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_ADDRESS_CLIENT]
	-- Add the parameters for the stored procedure here
	@ID_CLIENT NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM VIEW_ADDRESS_CLIENT WHERE ID_CLIENT = @ID_CLIENT ORDER BY DS_ADDRESS_CLIENT
END




GO
/****** Object:  StoredProcedure [dbo].[GETS_ADDRESS_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_ADDRESS_COMPANY]
	-- Add the parameters for the stored procedure here
	@ID_COMPANY_USER NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM VIEW_ADDRESS_COMPANY WHERE ID_COMPANY_USER = @ID_COMPANY_USER ORDER BY DS_ADDRESS_COMPANY
END



GO
/****** Object:  StoredProcedure [dbo].[GETS_ALL_MODULES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_ALL_MODULES] 
	-- Add the parameters for the stored procedure here
@ID_TYPE_MENU INT
	
AS
BEGIN
	
	-- SELECT DISTINCT ID_MENU, DS_MENU, ICON FROM VIEW_ROLES_MODULES WHERE ID_ROLE = @ID
	BEGIN
		IF @ID_TYPE_MENU = 1
			BEGIN 
				SELECT * FROM VIEW_MODULES WHERE  ID_TYPE_MENU = @ID_TYPE_MENU ORDER BY ORDEN
			END
	END

	BEGIN
		IF @ID_TYPE_MENU = 2
			BEGIN 
				SELECT * FROM VIEW_MODULES WHERE  ID_TYPE_MENU = @ID_TYPE_MENU ORDER BY ORDEN
			END
	END

	BEGIN
		IF @ID_TYPE_MENU = 3
			BEGIN 
				SELECT * FROM VIEW_MODULES WHERE  ID_TYPE_MENU = @ID_TYPE_MENU ORDER BY ORDEN
			END
	END	
	-- SELECT * FROM VIEW_MODULES -- WHERE  ID_TYPE_MENU = @ID_TYPE_MENU ORDER BY ORDEN

END


GO
/****** Object:  StoredProcedure [dbo].[GETS_ALL_MODULES_ROLES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_ALL_MODULES_ROLES] 
	-- Add the parameters for the stored procedure here
@ID_TYPE_MENU INT,
@ID_ROLE INT
	
AS
BEGIN
	
	-- SELECT DISTINCT ID_MENU, DS_MENU, ICON FROM VIEW_ROLES_MODULES WHERE ID_ROLE = @ID
	BEGIN
		IF @ID_TYPE_MENU = 1
			BEGIN 
				SELECT * FROM VIEW_ROLES_MODULES_ACCESS WHERE ID_TYPE_MENU = @ID_TYPE_MENU AND ID_ROLE = @ID_ROLE ORDER BY ORDEN
			END
	END

	BEGIN
		IF @ID_TYPE_MENU = 2
			BEGIN 
				SELECT * FROM VIEW_ROLES_MODULES_ACCESS WHERE ID_TYPE_MENU = @ID_TYPE_MENU AND ID_ROLE = @ID_ROLE ORDER BY ID_MODULE_SEC, ORDEN
			END
	END

	BEGIN
		IF @ID_TYPE_MENU = 3
			BEGIN 
				SELECT * FROM VIEW_ROLES_MODULES_ACCESS WHERE ID_TYPE_MENU = @ID_TYPE_MENU AND ID_ROLE = @ID_ROLE ORDER BY ID_MODULE_SEC, ORDEN
			END
	END	
	-- SELECT * FROM VIEW_MODULES -- WHERE  ID_TYPE_MENU = @ID_TYPE_MENU ORDER BY ORDEN

END



GO
/****** Object:  StoredProcedure [dbo].[GETS_DEPARTAMENTOS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_DEPARTAMENTOS]
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM DEPARTAMENTO ORDER BY DS_DEPARTAMENTO
END

GO
/****** Object:  StoredProcedure [dbo].[GETS_DISTRITOS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_DISTRITOS]
	-- Add the parameters for the stored procedure here
	@ID_PROVINCIA INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM DISTRITO WHERE ID_PROVINCIA = @ID_PROVINCIA ORDER BY DS_DISTRITO
END


GO
/****** Object:  StoredProcedure [dbo].[GETS_MODULES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_MODULES] 
	-- Add the parameters for the stored procedure here
	@ID_ROLE NUMERIC(18,0)
AS
BEGIN
	
	-- SELECT DISTINCT ID_MENU, DS_MENU, ICON FROM VIEW_ROLES_MODULES WHERE ID_ROLE = @ID
	IF @ID_ROLE = 1
	BEGIN 
		SELECT distinct ID_MODULE, ID_MODULE_SEC, ORDEN, FG_SUB_MENU, DS_MODULE, URL, ID_TYPE_MENU, ICON
		FROM VIEW_ROLES_MODULES_ALL ORDER BY ORDEN
	END

	IF @ID_ROLE <> 1
	BEGIN 
		SELECT * FROM VIEW_ROLES_MODULES WHERE ID_ROLE = @ID_ROLE ORDER BY ORDEN
	END

END

GO
/****** Object:  StoredProcedure [dbo].[GETS_MODULES_PRINCIPAL]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_MODULES_PRINCIPAL]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM VIEW_MODULES WHERE ID_TYPE_MENU = 1 AND FG_SUB_MENU = 1 ORDER BY ID_MODULE, ORDEN
END

GO
/****** Object:  StoredProcedure [dbo].[GETS_MODULES_SEC]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_MODULES_SEC]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM VIEW_MODULES WHERE ID_TYPE_MENU = 2 AND FG_SUB_MENU = 1 AND URL = '' ORDER BY ID_MODULE, ORDEN
END


GO
/****** Object:  StoredProcedure [dbo].[GETS_PROVINCIAS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_PROVINCIAS]
	-- Add the parameters for the stored procedure here
	@ID_DEPARTAMENTO INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM PROVINCIA WHERE ID_DEPARTAMENTO = @ID_DEPARTAMENTO ORDER BY DS_PROVINCIA
END

GO
/****** Object:  StoredProcedure [dbo].[GETS_TYPE_MENU]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETS_TYPE_MENU]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM TYPE_MENU
END

GO
/****** Object:  StoredProcedure [dbo].[LOGIN]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LOGIN]
	-- Add the parameters for the stored procedure here
	@EMAIL VARCHAR(100)
	--@PASSWORD VARCHAR(100)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @MESSAGE VARCHAR(100)
	DECLARE @EMAIL2 VARCHAR(100), @ID NUMERIC(18,0)
	SET @ID = 0
  
   SELECT @ID = ID_USER FROM USERS WHERE EMAIL = @EMAIL AND FG_ACTIVE = 1
   BEGIN
		IF @ID > 0
		BEGIN
			SET @MESSAGE = 'Email o Contraseña Incorrecto.'
			
			SELECT ID_USER, NAME, EMAIL, PASSWORD, IMAGE, GOOGLE,PHONE, ID_ROLE, @MESSAGE AS MESSAGE FROM USERS WHERE ID_USER = @ID 
		END

		IF @ID = 0
		BEGIN
			SET @MESSAGE = 'Email o Contraseña Incorrecto.'			
			SELECT 0 AS ID_USER, @MESSAGE AS MESSAGE
		END
	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[MOVE_MODULE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MOVE_MODULE]
	-- Add the parameters for the stored procedure here
	@ID_MODULE INT,
	@ID_TYPE_MENU INT,
	@ORDEN INT, 
	@MOVE INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @ORDEN_NEW INT

	SET @ORDEN_NEW = @ORDEN + (@MOVE)
	
	UPDATE MODULES SET ORDEN = @ORDEN WHERE ORDEN = @ORDEN_NEW AND ID_TYPE_MENU = @ID_TYPE_MENU
	
	UPDATE MODULES SET ORDEN = @ORDEN_NEW WHERE ID_MODULE = @ID_MODULE

	SELECT * FROM VIEW_MODULES WHERE ID_MODULE = @ID_MODULE

END

GO
/****** Object:  StoredProcedure [dbo].[REGISTER_ADDRESS_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REGISTER_ADDRESS_CLIENT]
	-- Add the parameters for the stored procedure here	
	@ID_CLIENT NUMERIC(18,0),
	@DS_ADDRESS_CLIENT VARCHAR(250),
	@ADDRESS VARCHAR(250),
	@ID_DISTRITO INT,
	@FG_PRINCIPAL BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @ID NUMERIC(18,0), @MESSAGE VARCHAR(250)
			
			INSERT INTO [dbo].ADDRESS_CLIENT
				   ([ID_CLIENT]          
				   ,[DS_ADDRESS_CLIENT]
				   ,[ADDRESS]
				   ,[ID_DISTRITO]
				   ,[FG_PRINCIPAL]				  				   			   
				   )          
			 VALUES
				   (@ID_CLIENT       
				   ,@DS_ADDRESS_CLIENT
				   ,@ADDRESS
				   ,@ID_DISTRITO,
				   @FG_PRINCIPAL				  				    				  
				   )

			SET @ID = @@IDENTITY
			SET @MESSAGE = 'Sucursal Registrada Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM VIEW_ADDRESS_CLIENT WHERE ID_ADDRESS_CLIENT = @ID
		
END




GO
/****** Object:  StoredProcedure [dbo].[REGISTER_ADDRESS_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REGISTER_ADDRESS_COMPANY]
	-- Add the parameters for the stored procedure here	
	@ID_COMPANY_USER NUMERIC(18,0),
	@DS_ADDRESS_COMPANY VARCHAR(250),
	@ADDRESS VARCHAR(250),
	@ID_DISTRITO INT,
	@FG_PRINCIPAL BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @ID NUMERIC(18,0), @MESSAGE VARCHAR(250)
			
			INSERT INTO [dbo].ADDRESS_COMPANY
				   ([ID_COMPANY_USER]          
				   ,[DS_ADDRESS_COMPANY]
				   ,[ADDRESS]
				   ,[ID_DISTRITO]
				   ,[FG_PRINCIPAL]				  				   			   
				   )          
			 VALUES
				   (@ID_COMPANY_USER       
				   ,@DS_ADDRESS_COMPANY
				   ,@ADDRESS
				   ,@ID_DISTRITO,
				   @FG_PRINCIPAL				  				    				  
				   )

			SET @ID = @@IDENTITY
			SET @MESSAGE = 'Sucursal Registrada Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM VIEW_ADDRESS_COMPANY WHERE ID_ADDRESS_COMPANY = @ID
		
END



GO
/****** Object:  StoredProcedure [dbo].[REGISTER_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REGISTER_CLIENT]
	-- Add the parameters for the stored procedure here	
	@ID_USER NUMERIC(18,0),	
	@COD_CLIENT VARCHAR(20),	
	@DS_CLIENT VARCHAR(250),
	@EMAIL VARCHAR(100),
	@PHONE VARCHAR(100),
	@CONTACT VARCHAR(100),
	@ID_TYPE INT,
	@ID_TYPE_CLIENT INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @ID NUMERIC(18,2), @MESSAGE VARCHAR(100)
	DECLARE @EMAIL2 VARCHAR(100),@COD_CLIENT2 VARCHAR(20), @OK INT
	

	SET @OK = 1
	--SELECT @EMAIL2 = EMAIL FROM CLIENT WHERE EMAIL = @EMAIL AND FG_ACTIVE = 1

	--BEGIN
		--IF @EMAIL= @EMAIL2 
		--BEGIN
			--SET @MESSAGE = 'Disculpe, el EMAIL ya se encuentra registrado.'
			--SET @OK = 0
			--SELECT ID_CLIENT = 0, @MESSAGE AS MESSAGE  
		--END
	--END

	SELECT @COD_CLIENT2 = @COD_CLIENT FROM CLIENT WHERE COD_CLIENT = @COD_CLIENT AND FG_ACTIVE = 1 AND ID_USER = @ID_USER
	BEGIN
		IF @COD_CLIENT= @COD_CLIENT2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el RUC ya se encuentra registrado.'
			SET @OK = 0
			SELECT ID_CLIENT = 0, @MESSAGE AS MESSAGE  
		END
	END

	IF @OK = 1
		BEGIN
			INSERT INTO [dbo].CLIENT
				   ([ID_USER] 
				   ,[COD_CLIENT]         
				   ,[DS_CLIENT]				   
				   ,[EMAIL]
				   ,[PHONE]
				   ,[CONTACT]
				   ,[ID_TYPE]
				   ,[ID_TYPE_CLIENT]				   			   
				   )          
			 VALUES
				   (@ID_USER
				   ,@COD_CLIENT     
				   ,@DS_CLIENT
				   ,@EMAIL
				   ,@PHONE				   
				   ,@CONTACT
				   ,@ID_TYPE
				   ,@ID_TYPE_CLIENT				    				  
				   )

			SET @ID = @@IDENTITY
			SET @MESSAGE = 'Cliente Registrado Correctamente.'
			SELECT *, 
			@MESSAGE AS MESSAGE FROM CLIENT WHERE ID_CLIENT = @ID
		END
END



GO
/****** Object:  StoredProcedure [dbo].[REGISTER_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REGISTER_COMPANY]
	-- Add the parameters for the stored procedure here	
	@ID_COMPANY VARCHAR(20),
	@ID_USER NUMERIC(18,0),
	@DS_COMPANY VARCHAR(250),
	@EMAIL VARCHAR(100),
	@PHONE VARCHAR(100),
	@CONTACT VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @ID NUMERIC(18,2), @MESSAGE VARCHAR(100)
	DECLARE @EMAIL2 VARCHAR(100),@ID_COMPANY2 VARCHAR(20), @OK INT
	

	SET @OK = 1
	SELECT @EMAIL2 = EMAIL FROM COMPANY_USER WHERE EMAIL = @EMAIL AND FG_ACTIVE = 1

	BEGIN
		IF @EMAIL= @EMAIL2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el EMAIL ya se encuentra registrado.'
			SET @OK = 0
			SELECT ID_COMPANY_USER = 0, @MESSAGE AS MESSAGE  
		END
	END

	SELECT @ID_COMPANY2 = @ID_COMPANY FROM COMPANY_USER WHERE ID_COMPANY = @ID_COMPANY AND FG_ACTIVE = 1
	BEGIN
		IF @ID_COMPANY= @ID_COMPANY2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el RUC ya se encuentra registrado.'
			SET @OK = 0
			SELECT ID_COMPANY_USER = 0, @MESSAGE AS MESSAGE  
		END
	END

	IF @OK = 1
		BEGIN
			INSERT INTO [dbo].COMPANY_USER
				   ([ID_COMPANY]          
				   ,[ID_USER]
				   ,[DS_COMPANY]
				   ,[EMAIL]
				   ,[PHONE]
				   ,[CONTACT]				   			   
				   )          
			 VALUES
				   (@ID_COMPANY       
				   ,@ID_USER
				   ,@DS_COMPANY
				   ,@EMAIL
				   ,@PHONE
				   ,@CONTACT				    				  
				   )

			SET @ID = @@IDENTITY
			SET @MESSAGE = 'Cliente Registrado Correctamente.'
			SELECT *,
			@MESSAGE AS MESSAGE FROM COMPANY_USER WHERE ID_COMPANY_USER = @ID
		END
END


GO
/****** Object:  StoredProcedure [dbo].[REGISTER_MODULE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REGISTER_MODULE]
	-- Add the parameters for the stored procedure here
	@ID_MODULE_SEC INT,
	@FG_SUB_MENU INT,
	@DS_MODULE VARCHAR(100),
	@URL VARCHAR(100), 
	@ID_TYPE_MENU INT,	
	@ICON VARCHAR(100)
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @ID INT, @MESSAGE VARCHAR(250), @ORDEN INT;

	--Prncipal
	IF @ID_TYPE_MENU = 1
		BEGIN 
			SET @ORDEN = (select max(orden) from modules where ID_TYPE_MENU = 1 and FG_ACTIVE = 1) + 1
		END

	--Sub Menu 
	IF @ID_TYPE_MENU = 2
		BEGIN 
			SET @ORDEN = (select max(orden) from modules where ID_TYPE_MENU = 2 and FG_ACTIVE = 1) + 1
		END

	--Sub Menu secundario
	IF @ID_TYPE_MENU = 3
		BEGIN 
			SET @ORDEN = (select max(orden) from modules where ID_TYPE_MENU = 3 and FG_ACTIVE = 1) + 1
		END

	

    INSERT INTO [dbo].[MODULES]
           ([ID_MODULE_SEC]
		   ,[FG_SUB_MENU]		             
           ,[DS_MODULE]
		   ,[URL]
		   ,[ID_TYPE_MENU] 
           ,[ICON]
		   ,[ORDEN])       
     VALUES
           (@ID_MODULE_SEC
		   ,@FG_SUB_MENU
		   ,@DS_MODULE
		   ,@URL
		   ,@ID_TYPE_MENU    
           ,@ICON
           ,@ORDEN)

			SET @ID = @@IDENTITY
			SET @MESSAGE = 'Modulo Registrado Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM MODULES WHERE ID_MODULE = @ID
END

GO
/****** Object:  StoredProcedure [dbo].[REGISTER_ROLE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REGISTER_ROLE]
	-- Add the parameters for the stored procedure here
	@DS_ROLE varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ID NUMERIC(18,2), @MESSAGE VARCHAR(100)
	DECLARE @DS_ROLE2 VARCHAR(100), @OK INT
	

	SET @OK = 1
	SELECT @DS_ROLE2 = DS_ROLE FROM USER_ROLES WHERE DS_ROLE = @DS_ROLE AND FG_ACTIVE = 1

	BEGIN
		IF @DS_ROLE= @DS_ROLE2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el ROL DE USUARIO ya se encuentra registrado.'
			SET @OK = 0
			SELECT ID_ROLE = 0, @MESSAGE AS MESSAGE  
		END
	END

	IF @OK = 1
		BEGIN
			INSERT INTO [dbo].[USER_ROLES]
				   ([DS_ROLE])           
			 VALUES
				   (@DS_ROLE)

			SET @ID = @@IDENTITY
			SET @MESSAGE = 'Rol de Usuario Registrado Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM USER_ROLES WHERE ID_ROLE = @ID
		END 

END

GO
/****** Object:  StoredProcedure [dbo].[REGISTER_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REGISTER_USER]
	-- Add the parameters for the stored procedure here	
	@NAME VARCHAR(100),
	@EMAIL VARCHAR(100),
	@PASSWORD VARCHAR(100),
	@IMAGE  VARCHAR(250),
	@GOOGLE BIT, 
	@PHONE VARCHAR(100),
	@ID_ROLE INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @ID NUMERIC(18,2), @MESSAGE VARCHAR(100)
	DECLARE @EMAIL2 VARCHAR(100), @OK INT
	

	SET @OK = 1
	SELECT @EMAIL2 = EMAIL FROM USERS WHERE EMAIL = @EMAIL AND FG_ACTIVE = 1

	BEGIN
		IF @EMAIL= @EMAIL2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el EMAIL ya se encuentra registrado.'
			SET @OK = 0
			SELECT ID_USER = 0, @MESSAGE AS MESSAGE  
		END
	END

	IF @OK = 1
		BEGIN
			INSERT INTO [dbo].[USERS]
				   ([NAME]          
				   ,[EMAIL]
				   ,[PASSWORD]
				   ,[IMAGE]
				   ,[GOOGLE]
				   ,[PHONE]
				   ,[ID_ROLE]
				   )          
			 VALUES
				   (@NAME          
				   ,@EMAIL
				   ,@PASSWORD
				   ,@IMAGE
				   ,@GOOGLE
				   ,@PHONE
				   ,@ID_ROLE
				   )

			SET @ID = @@IDENTITY
			SET @MESSAGE = 'Usuario Registrado Correctamente.'
			SELECT ID_USER, NAME, EMAIL, IMAGE, GOOGLE, ID_ROLE,PHONE, @MESSAGE AS MESSAGE FROM USERS WHERE ID_USER = @ID
		END
END

GO
/****** Object:  StoredProcedure [dbo].[SEARCH_USERS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SEARCH_USERS]
	
	@SEARCH VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @DESDE INT, @HASTA INT
	SET NOCOUNT ON;

	--BEGIN
		--IF @PAGE = 1 
		--BEGIN
			--SET @DESDE = 1
			--SET @HASTA = 5
		--END
	--END

	--BEGIN
		--IF @PAGE >    1 
		--BEGIN
			--SET @DESDE = (@PAGE * 5) - 4
			--SET @HASTA = @DESDE + 4
		--END
	--END
	

    -- Insert statements for procedure here
	SELECT *
	FROM VIEW_USERS 
	--WHERE (NUM >= @DESDE AND NUM <=@HASTA)
	WHERE (NAME LIKE '%'+RTRIM(@SEARCH)+'%') OR (EMAIL LIKE '%'+RTRIM(@SEARCH)+'%') OR (DS_ROLE LIKE '%'+RTRIM(@SEARCH)+'%') OR (AUTHENTICATION LIKE '%'+RTRIM(@SEARCH)+'%')
	ORDER BY ID_USER

END





GO
/****** Object:  StoredProcedure [dbo].[UPDATE_ADDRESS_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_ADDRESS_CLIENT]
	-- Add the parameters for the stored procedure here	
	@ID_ADDRESS_CLIENT NUMERIC(18,0),
	@DS_ADDRESS_CLIENT VARCHAR(250),
	@ADDRESS VARCHAR(250),
	@ID_DISTRITO INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(250)
			
			UPDATE [dbo].[ADDRESS_CLIENT]
			SET [DS_ADDRESS_CLIENT] = @ID_ADDRESS_CLIENT
			,[ADDRESS] = @ADDRESS		
			,[ID_DISTRITO] = @ID_DISTRITO
			 WHERE ID_ADDRESS_CLIENT = @ID_ADDRESS_CLIENT
			
			SET @MESSAGE = 'Sucursal Actualizada Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM VIEW_ADDRESS_CLIENT WHERE ID_ADDRESS_CLIENT = @ID_ADDRESS_CLIENT
		
END





GO
/****** Object:  StoredProcedure [dbo].[UPDATE_ADDRESS_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_ADDRESS_COMPANY]
	-- Add the parameters for the stored procedure here	
	@ID_ADDRESS_COMPANY NUMERIC(18,0),
	@DS_ADDRESS_COMPANY VARCHAR(250),
	@ADDRESS VARCHAR(250),
	@ID_DISTRITO INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(250)
			
			UPDATE [dbo].[ADDRESS_COMPANY]
			SET [DS_ADDRESS_COMPANY] = @DS_ADDRESS_COMPANY
			,[ADDRESS] = @ADDRESS		
			,[ID_DISTRITO] = @ID_DISTRITO
			 WHERE ID_ADDRESS_COMPANY = @ID_ADDRESS_COMPANY
			
			SET @MESSAGE = 'Sucursal Actualizada Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM VIEW_ADDRESS_COMPANY WHERE ID_ADDRESS_COMPANY = @ID_ADDRESS_COMPANY
		
END




GO
/****** Object:  StoredProcedure [dbo].[UPDATE_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_CLIENT]
	-- Add the parameters for the stored procedure here	
	@ID_CLIENT NUMERIC(18,0),	
	@ID_USER NUMERIC(18,0),	
	@COD_CLIENT VARCHAR(20),	
	@DS_CLIENT VARCHAR(250),
	@EMAIL VARCHAR(100),
	@PHONE VARCHAR(100),
	@CONTACT VARCHAR(100),
	@ID_TYPE INT,
	@ID_TYPE_CLIENT INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @ID NUMERIC(18,2), @MESSAGE VARCHAR(100)
	DECLARE @EMAIL2 VARCHAR(100),@COD_CLIENT2 VARCHAR(20), @OK INT
	

	SET @OK = 1
	--SELECT @EMAIL2 = EMAIL FROM CLIENT WHERE EMAIL = @EMAIL AND FG_ACTIVE = 1

	--BEGIN
		--IF @EMAIL= @EMAIL2 
		--BEGIN
			--SET @MESSAGE = 'Disculpe, el EMAIL ya se encuentra registrado.'
			--SET @OK = 0
			--SELECT ID_CLIENT = 0, @MESSAGE AS MESSAGE  
		--END
	--END

	SELECT @COD_CLIENT2 = @COD_CLIENT FROM CLIENT WHERE COD_CLIENT = @COD_CLIENT AND FG_ACTIVE = 1 AND ID_USER = @ID_USER AND ID_CLIENT <> @ID_CLIENT 
	BEGIN
		IF @COD_CLIENT= @COD_CLIENT2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el RUC ya se encuentra registrado con otro cliente.'
			SET @OK = 0
			SELECT ID_CLIENT = 0, @MESSAGE AS MESSAGE  
		END
	END

	IF @OK = 1
		BEGIN
			
			UPDATE [dbo].[CLIENT]
			   SET [COD_CLIENT] = @COD_CLIENT
				  ,[DS_CLIENT] = @DS_CLIENT
				  ,[EMAIL] = @EMAIL
				  ,[PHONE] = @PHONE
				  ,[CONTACT] = @CONTACT				  
				  ,[ID_TYPE] = @ID_TYPE
				  ,[ID_TYPE_CLIENT] = @ID_TYPE_CLIENT
			WHERE ID_CLIENT = @ID_CLIENT

			SET @MESSAGE = 'Cliente Actualizado Correctamente.'
			SELECT *, 
			@MESSAGE AS MESSAGE FROM CLIENT WHERE ID_CLIENT = @ID_CLIENT
		END
END




GO
/****** Object:  StoredProcedure [dbo].[UPDATE_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_COMPANY]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0),
	@ID_USER NUMERIC(18,0),
	@ID_COMPANY VARCHAR(20),
	@DS_COMPANY VARCHAR(250),	
	@EMAIL VARCHAR(100),
	@PHONE VARCHAR(100),
	@CONTACT VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100)
	DECLARE @EMAIL2 VARCHAR(100), @OK INT
	

	SET @OK = 1
	SELECT @EMAIL2 = EMAIL FROM COMPANY_USER WHERE EMAIL = @EMAIL AND FG_ACTIVE = 1 AND ID_COMPANY_USER <> @ID 

	BEGIN
		IF @EMAIL= @EMAIL2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el EMAIL ya se encuentra registrado con otra empresa.'
			SET @OK = 0
			SELECT ID_COMPANY_USER = 0, @MESSAGE AS MESSAGE  
		END
	END

	IF @OK = 1
		BEGIN
			UPDATE [dbo].[COMPANY_USER]
		    SET [ID_COMPANY] = @ID_COMPANY
			   ,[DS_COMPANY] = @DS_COMPANY
			   ,[EMAIL] = @EMAIL
			   ,[PHONE] = @PHONE
			   ,[CONTACT] = @CONTACT 
		     WHERE ID_COMPANY_USER = @ID 
			
			SET @MESSAGE = 'Empresa Actualizado Correctamente.'
			SELECT ID_COMPANY_USER, ID_USER, DS_COMPANY, EMAIL,PHONE, CONTACT, IMAGE, @MESSAGE AS MESSAGE FROM COMPANY_USER 
			WHERE ID_COMPANY_USER = @ID AND ID_USER = @ID_USER
		END
END



GO
/****** Object:  StoredProcedure [dbo].[UPDATE_IMAGE_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_IMAGE_COMPANY]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0),	
	@IMAGE VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100)
		
		
			UPDATE [dbo].[COMPANY_USER]
		    SET [IMAGE] = @IMAGE	   
		     WHERE ID_COMPANY_USER = @ID 
			 			
			SET @MESSAGE = 'Imagen Actualizada Correctamente.'
			SELECT ID_COMPANY_USER, ID_COMPANY, ID_USER, DS_COMPANY, EMAIL, PHONE, CONTACT, IMAGE, @MESSAGE AS MESSAGE FROM COMPANY_USER WHERE ID_COMPANY_USER = @ID
		
END




GO
/****** Object:  StoredProcedure [dbo].[UPDATE_IMAGE_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_IMAGE_USER]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0),	
	@IMAGE VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100)
		
		
			UPDATE [dbo].[USERS]
		    SET [IMAGE] = @IMAGE	   
		     WHERE ID_USER = @ID 
			 			
			SET @MESSAGE = 'Imagen Actualizada Correctamente.'
			SELECT ID_USER, NAME, EMAIL, IMAGE, GOOGLE, ID_ROLE, @MESSAGE AS MESSAGE FROM USERS WHERE ID_USER = @ID
		
END



GO
/****** Object:  StoredProcedure [dbo].[UPDATE_MODULE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_MODULE]
	-- Add the parameters for the stored procedure here
	@ID_MODULE INT,
	@ID_MODULE_SEC INT,
	@FG_SUB_MENU INT,
	@DS_MODULE VARCHAR(100),
	@URL VARCHAR(100), 
	@ID_TYPE_MENU INT,	
	@ICON VARCHAR(100)
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @ID INT, @MESSAGE VARCHAR(250), @ORDEN INT;

		UPDATE [dbo].[MODULES]
		SET [ID_MODULE_SEC] = @ID_MODULE_SEC		  
		  ,[FG_SUB_MENU] = @FG_SUB_MENU
		  ,[DS_MODULE] = @DS_MODULE
		  ,[URL] = @URL
		  ,[ID_TYPE_MENU] = @ID_TYPE_MENU
		  ,[ICON] = @ICON		  
		WHERE ID_MODULE = @ID_MODULE

			-- SET @MESSAGE = 'Modulo Actualizado Correctamente.'
			SELECT * FROM VIEW_MODULES WHERE ID_MODULE = @ID_MODULE
END


GO
/****** Object:  StoredProcedure [dbo].[UPDATE_PASSWORD]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_PASSWORD]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0),	
	@PASSWORD VARCHAR(100)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
		DECLARE @MESSAGE VARCHAR(100)

			UPDATE [dbo].[USERS]
		    SET [PASSWORD] = @PASSWORD			   	   
		    WHERE ID_USER = @ID 
			
			SET @MESSAGE = 'Usuario Actualizado Correctamente.'
			SELECT ID_USER, NAME, EMAIL,PHONE, IMAGE, GOOGLE, ID_ROLE, @MESSAGE AS MESSAGE FROM USERS WHERE ID_USER = @ID
		
END



GO
/****** Object:  StoredProcedure [dbo].[UPDATE_ROLE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_ROLE]
	-- Add the parameters for the stored procedure here
	@ID_ROLE INT,
	@DS_ROLE varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @MESSAGE VARCHAR(100)
	DECLARE @DS_ROLE2 VARCHAR(100), @OK INT
	

	SET @OK = 1
	SELECT @DS_ROLE2 = DS_ROLE FROM USER_ROLES WHERE DS_ROLE = @DS_ROLE AND ID_ROLE <> @ID_ROLE AND FG_ACTIVE = 1

	BEGIN
		IF @DS_ROLE= @DS_ROLE2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el ROL DE USUARIO ya se encuentra registrado.'
			SET @OK = 0
			SELECT ID_ROLE = 0, @MESSAGE AS MESSAGE  
		END
	END

	IF @OK = 1
		BEGIN
			UPDATE [dbo].[USER_ROLES]
			SET [DS_ROLE] = @DS_ROLE
			WHERE ID_ROLE = @ID_ROLE

			
			SET @MESSAGE = 'Rol de Usuario Actualizado Correctamente.'
			SELECT *, @MESSAGE AS MESSAGE FROM USER_ROLES WHERE ID_ROLE = @ID_ROLE
		END 

END


GO
/****** Object:  StoredProcedure [dbo].[UPDATE_ROLES_MODULES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_ROLES_MODULES]
	-- Add the parameters for the stored procedure here
	@ID_MODULE INT,
	@ID_ROLE INT,
	@ACCESS BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @ID INT

	IF @ACCESS = 1
		BEGIN
			INSERT INTO [dbo].[ROLES_MODULES]
			   ([ID_MODULE]
			   ,[ID_ROLE])
			VALUES
			   (@ID_MODULE
			   ,@ID_ROLE)

			SET @ID = @@IDENTITY
			SELECT * FROM ROLES_MODULES WHERE ID = @ID
		END

	IF @ACCESS = 0
		BEGIN
			-- SET @ID = SELECT ID FROM ROLES_MODULES WHERE ID_MODULE = @ID_MODULE AND ID_ROLE = @ID_ROLE AND FG_ACTIVE = 1
			
			UPDATE [dbo].[ROLES_MODULES]
			SET [FG_ACTIVE] = 0
			WHERE ID_MODULE = @ID_MODULE AND ID_ROLE = @ID_ROLE AND FG_ACTIVE = 1

			SELECT * FROM ROLES_MODULES WHERE ID = (SELECT MAX(ID) FROM ROLES_MODULES WHERE ID_MODULE = @ID_MODULE AND ID_ROLE = @ID_ROLE AND FG_ACTIVE = 0)

		END
	

    -- SELECT @ACCESS
END

GO
/****** Object:  StoredProcedure [dbo].[UPDATE_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_USER]
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0),	
	@NAME VARCHAR(100),
	@EMAIL VARCHAR(100),
	@PHONE VARCHAR(100),
	@ID_ROLE INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @MESSAGE VARCHAR(100)
	DECLARE @EMAIL2 VARCHAR(100), @OK INT
	

	SET @OK = 1
	SELECT @EMAIL2 = EMAIL FROM USERS WHERE EMAIL = @EMAIL AND FG_ACTIVE = 1 AND ID_USER <> @ID 

	BEGIN
		IF @EMAIL= @EMAIL2 
		BEGIN
			SET @MESSAGE = 'Disculpe, el EMAIL ya se encuentra registrado con otra cuenta.'
			SET @OK = 0
			SELECT ID_USER = 0, @MESSAGE AS MESSAGE  
		END
	END

	IF @OK = 1
		BEGIN
			UPDATE [dbo].[USERS]
		    SET [NAME] = @NAME
			   ,[EMAIL] = @EMAIL
			   ,[PHONE] = @PHONE
			   ,[ID_ROLE] = @ID_ROLE			   
		     WHERE ID_USER = @ID 
			
			SET @MESSAGE = 'Usuario Actualizado Correctamente.'
			SELECT ID_USER, NAME, EMAIL,PHONE, IMAGE, GOOGLE, ID_ROLE, @MESSAGE AS MESSAGE FROM USERS WHERE ID_USER = @ID
		END
END


GO
/****** Object:  UserDefinedFunction [dbo].[FN_MAX_NUM_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FN_MAX_NUM_USER]
(
	
)
RETURNS NUMERIC(18,0)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @TOTAL NUMERIC(18,0)

	-- Add the T-SQL statements to compute the return value here
	 SELECT @TOTAL = MAX(NUM) FROM VIEW_USERS

	-- Return the result of the function
	RETURN @TOTAL

END

GO
/****** Object:  Table [dbo].[ADDRESS_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ADDRESS_CLIENT](
	[ID_ADDRESS_CLIENT] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ID_CLIENT] [numeric](18, 0) NULL,
	[DS_ADDRESS_CLIENT] [varchar](50) NULL,
	[ADDRESS] [varchar](250) NULL,
	[FG_ACTIVE] [bit] NULL,
	[DT_REGISTRY] [datetime] NULL,
	[ID_DISTRITO] [int] NULL,
	[FG_PRINCIPAL] [bit] NULL,
 CONSTRAINT [PK_ADDRESS_CLIENT] PRIMARY KEY CLUSTERED 
(
	[ID_ADDRESS_CLIENT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ADDRESS_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ADDRESS_COMPANY](
	[ID_ADDRESS_COMPANY] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ID_COMPANY_USER] [numeric](18, 0) NOT NULL,
	[DS_ADDRESS_COMPANY] [varchar](50) NOT NULL,
	[ADDRESS] [varchar](250) NULL,
	[FG_ACTIVE] [bit] NULL,
	[DT_REGISTRY] [datetime] NULL,
	[ID_DISTRITO] [int] NULL,
	[FG_PRINCIPAL] [bit] NULL,
 CONSTRAINT [PK_ADDRESS_COMPANY] PRIMARY KEY CLUSTERED 
(
	[ID_ADDRESS_COMPANY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CLIENT](
	[ID_CLIENT] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ID_USER] [numeric](18, 0) NULL,
	[COD_CLIENT] [varchar](20) NOT NULL,
	[DS_CLIENT] [varchar](250) NOT NULL,
	[EMAIL] [varchar](250) NULL,
	[PHONE] [varchar](100) NULL,
	[CONTACT] [varchar](250) NULL,
	[FG_ACTIVE] [bit] NULL,
	[DT_REGISTRY] [datetime] NULL,
	[ID_TYPE] [int] NULL,
	[ID_TYPE_CLIENT] [int] NULL,
 CONSTRAINT [PK_CLIENT] PRIMARY KEY CLUSTERED 
(
	[ID_CLIENT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[COMPANY_USER]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[COMPANY_USER](
	[ID_COMPANY_USER] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ID_COMPANY] [varchar](20) NOT NULL,
	[ID_USER] [numeric](18, 0) NOT NULL,
	[DS_COMPANY] [varchar](250) NOT NULL,
	[EMAIL] [varchar](100) NULL,
	[PHONE] [varchar](100) NULL,
	[CONTACT] [varchar](100) NULL,
	[ADDRESS] [varchar](250) NULL,
	[IMAGE] [varchar](250) NULL,
	[FG_ACTIVE] [bit] NULL,
	[DT_REGISTRY] [datetime] NULL,
 CONSTRAINT [PK_COMPANY_USER_1] PRIMARY KEY CLUSTERED 
(
	[ID_COMPANY_USER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DEPARTAMENTO]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DEPARTAMENTO](
	[ID_DEPARTAMENTO] [int] NOT NULL,
	[DS_DEPARTAMENTO] [varchar](250) NULL,
 CONSTRAINT [PK_DEPARTAMENTO] PRIMARY KEY CLUSTERED 
(
	[ID_DEPARTAMENTO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DISTRITO]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DISTRITO](
	[ID_DISTRITO] [int] NOT NULL,
	[COD_UBIGEO] [varchar](20) NOT NULL,
	[DS_DISTRITO] [varchar](250) NULL,
	[ID_PROVINCIA] [int] NULL,
 CONSTRAINT [PK_DISTRITO_1] PRIMARY KEY CLUSTERED 
(
	[ID_DISTRITO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ID_TYPE_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ID_TYPE_CLIENT](
	[ID_TYPE] [int] IDENTITY(1,1) NOT NULL,
	[COD_ID_TYPE] [varchar](10) NULL,
	[DS_ID_TYPE] [varchar](100) NULL,
 CONSTRAINT [PK_TIPO_DOCUMENTO_IDENTIDAD] PRIMARY KEY CLUSTERED 
(
	[ID_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MODULES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MODULES](
	[ID_MODULE] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ID_MODULE_SEC] [numeric](18, 0) NULL,
	[ORDEN] [numeric](18, 0) NULL,
	[FG_SUB_MENU] [bit] NULL,
	[DS_MODULE] [varchar](50) NULL,
	[URL] [varchar](50) NULL,
	[ID_TYPE_MENU] [int] NULL,
	[ICON] [varchar](50) NULL,
	[FG_ACTIVE] [bit] NULL,
	[DT_REGISTRY] [date] NULL,
 CONSTRAINT [PK_MODULES] PRIMARY KEY CLUSTERED 
(
	[ID_MODULE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PROVINCIA]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PROVINCIA](
	[ID_PROVINCIA] [int] NOT NULL,
	[DS_PROVINCIA] [varchar](250) NULL,
	[ID_DEPARTAMENTO] [int] NULL,
 CONSTRAINT [PK_PROVINCIA] PRIMARY KEY CLUSTERED 
(
	[ID_PROVINCIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROLES_MODULES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLES_MODULES](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ID_MODULE] [numeric](18, 0) NULL,
	[ID_ROLE] [numeric](18, 0) NULL,
	[FG_ACTIVE] [bit] NULL,
	[DT_REGISTRY] [datetime] NULL,
 CONSTRAINT [PK_ROLES_MENU] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TYPE_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TYPE_CLIENT](
	[ID_TYPE_CLIENT] [int] IDENTITY(1,1) NOT NULL,
	[DS_TYPE_CLIENT] [varchar](150) NULL,
 CONSTRAINT [PK_TYPE_CLIENT] PRIMARY KEY CLUSTERED 
(
	[ID_TYPE_CLIENT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TYPE_MENU]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TYPE_MENU](
	[ID_TYPE_MENU] [int] NOT NULL,
	[DS_TYPE_MENU] [varchar](50) NULL,
 CONSTRAINT [PK_TYPE_MENU] PRIMARY KEY CLUSTERED 
(
	[ID_TYPE_MENU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[USER_ROLES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[USER_ROLES](
	[ID_ROLE] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[DS_ROLE] [varchar](100) NOT NULL,
	[FG_ACTIVE] [bit] NULL,
	[DT_REGISTRY] [datetime] NULL,
 CONSTRAINT [PK_USER_ROLES] PRIMARY KEY CLUSTERED 
(
	[ID_ROLE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[USERS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[USERS](
	[ID_USER] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](50) NULL,
	[EMAIL] [varchar](100) NULL,
	[PASSWORD] [varchar](100) NULL,
	[IMAGE] [varchar](250) NULL,
	[GOOGLE] [bit] NULL,
	[ID_ROLE] [numeric](18, 0) NULL,
	[FG_ACTIVE] [bit] NULL,
	[FG_LOCKED] [bit] NULL,
	[DT_REGISTRY] [datetime] NULL,
	[PHONE] [varchar](100) NULL,
 CONSTRAINT [PK_USER] PRIMARY KEY CLUSTERED 
(
	[ID_USER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[FN_MODULE_DELETE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[FN_MODULE_DELETE]
(	
	-- Add the parameters for the function here
	@ID_MODULE INT
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT distinct ID_MODULE_SEC FROM MODULES WHERE FG_ACTIVE = 1 AND ID_MODULE_SEC = @ID_MODULE
)

GO
/****** Object:  View [dbo].[VIEW_MODULES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_MODULES]
AS
SELECT        TOP (100) PERCENT dbo.MODULES.ID_MODULE, dbo.MODULES.ID_MODULE_SEC, dbo.MODULES.ORDEN, dbo.MODULES.FG_SUB_MENU, dbo.MODULES.DS_MODULE, dbo.MODULES.URL, dbo.MODULES.ID_TYPE_MENU, 
                         dbo.MODULES.ICON, dbo.TYPE_MENU.DS_TYPE_MENU, CASE WHEN
                             (SELECT        ID_MODULE_SEC
                               FROM            dbo.FN_MODULE_DELETE(dbo.MODULES.ID_MODULE) AS FN_MODULE_DELETE_1) > 0 THEN 1 ELSE 0 END AS FG_DELETE
FROM            dbo.MODULES INNER JOIN
                         dbo.TYPE_MENU ON dbo.MODULES.ID_TYPE_MENU = dbo.TYPE_MENU.ID_TYPE_MENU
WHERE        (dbo.MODULES.FG_ACTIVE = 1)
ORDER BY dbo.MODULES.ID_MODULE, dbo.MODULES.ORDEN

GO
/****** Object:  View [dbo].[VIEW_ROLES_MODULES]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_ROLES_MODULES]
AS
SELECT        dbo.VIEW_MODULES.ID_MODULE, dbo.VIEW_MODULES.ID_MODULE_SEC, dbo.VIEW_MODULES.ORDEN, dbo.VIEW_MODULES.FG_SUB_MENU, dbo.VIEW_MODULES.DS_MODULE, dbo.VIEW_MODULES.URL, 
                         dbo.VIEW_MODULES.ID_TYPE_MENU, dbo.VIEW_MODULES.ICON, dbo.ROLES_MODULES.ID_ROLE
FROM            dbo.VIEW_MODULES INNER JOIN
                         dbo.ROLES_MODULES ON dbo.VIEW_MODULES.ID_MODULE = dbo.ROLES_MODULES.ID_MODULE
WHERE        (dbo.ROLES_MODULES.FG_ACTIVE = 1)

GO
/****** Object:  View [dbo].[VIEW_ROLES_MODULES_ALL]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_ROLES_MODULES_ALL]
AS
SELECT        TOP (100) PERCENT dbo.MODULES.ID_MODULE, dbo.MODULES.ID_MODULE_SEC, dbo.MODULES.ORDEN, dbo.MODULES.FG_SUB_MENU, dbo.MODULES.DS_MODULE, dbo.MODULES.URL, dbo.MODULES.ID_TYPE_MENU, 
                         dbo.MODULES.ICON, dbo.TYPE_MENU.DS_TYPE_MENU, CASE WHEN
                             (SELECT        ID_MODULE_SEC
                               FROM            dbo.FN_MODULE_DELETE(dbo.MODULES.ID_MODULE) AS FN_MODULE_DELETE_1) > 0 THEN 1 ELSE 0 END AS FG_DELETE, dbo.USER_ROLES.ID_ROLE, dbo.USER_ROLES.DS_ROLE
FROM            dbo.MODULES INNER JOIN
                         dbo.TYPE_MENU ON dbo.MODULES.ID_TYPE_MENU = dbo.TYPE_MENU.ID_TYPE_MENU CROSS JOIN
                         dbo.USER_ROLES
WHERE        (dbo.MODULES.FG_ACTIVE = 1) AND (dbo.USER_ROLES.FG_ACTIVE = 1)
ORDER BY dbo.MODULES.ID_MODULE, dbo.MODULES.ORDEN

GO
/****** Object:  View [dbo].[VIEW_MODULE_DELETE]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_MODULE_DELETE]
AS
SELECT DISTINCT dbo.MODULES.ID_MODULE
FROM            dbo.VIEW_MODULES INNER JOIN
                         dbo.MODULES ON dbo.VIEW_MODULES.ID_MODULE_SEC = dbo.MODULES.ID_MODULE

GO
/****** Object:  View [dbo].[VIEW_ROLES_MODULES_ACCESS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_ROLES_MODULES_ACCESS]
AS
SELECT        dbo.VIEW_ROLES_MODULES_ALL.ID_MODULE, dbo.VIEW_ROLES_MODULES_ALL.ID_MODULE_SEC, dbo.VIEW_ROLES_MODULES_ALL.ORDEN, dbo.VIEW_ROLES_MODULES_ALL.DS_MODULE, 
                         dbo.VIEW_ROLES_MODULES_ALL.ID_TYPE_MENU, dbo.VIEW_ROLES_MODULES_ALL.ID_ROLE, dbo.VIEW_ROLES_MODULES_ALL.DS_ROLE, dbo.VIEW_ROLES_MODULES.ID_ROLE AS ACCESS
FROM            dbo.VIEW_ROLES_MODULES_ALL LEFT OUTER JOIN
                         dbo.VIEW_ROLES_MODULES ON dbo.VIEW_ROLES_MODULES_ALL.ID_MODULE = dbo.VIEW_ROLES_MODULES.ID_MODULE AND dbo.VIEW_ROLES_MODULES_ALL.ID_ROLE = dbo.VIEW_ROLES_MODULES.ID_ROLE
WHERE        (dbo.VIEW_ROLES_MODULES_ALL.ID_ROLE > 1)

GO
/****** Object:  View [dbo].[VIEW_ADDRESS_CLIENT]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_ADDRESS_CLIENT]
AS
SELECT        dbo.ADDRESS_CLIENT.ID_ADDRESS_CLIENT, dbo.ADDRESS_CLIENT.ID_CLIENT, dbo.ADDRESS_CLIENT.DS_ADDRESS_CLIENT, dbo.ADDRESS_CLIENT.ADDRESS, dbo.DEPARTAMENTO.ID_DEPARTAMENTO, 
                         dbo.PROVINCIA.ID_PROVINCIA, dbo.DISTRITO.ID_DISTRITO, dbo.CLIENT.ID_USER, dbo.DEPARTAMENTO.DS_DEPARTAMENTO, dbo.PROVINCIA.DS_PROVINCIA, dbo.DISTRITO.COD_UBIGEO, dbo.DISTRITO.DS_DISTRITO, 
                         dbo.CLIENT.DS_CLIENT, dbo.ADDRESS_CLIENT.FG_PRINCIPAL
FROM            dbo.ADDRESS_CLIENT INNER JOIN
                         dbo.DISTRITO ON dbo.ADDRESS_CLIENT.ID_DISTRITO = dbo.DISTRITO.ID_DISTRITO INNER JOIN
                         dbo.PROVINCIA INNER JOIN
                         dbo.DEPARTAMENTO ON dbo.PROVINCIA.ID_DEPARTAMENTO = dbo.DEPARTAMENTO.ID_DEPARTAMENTO ON dbo.DISTRITO.ID_PROVINCIA = dbo.PROVINCIA.ID_PROVINCIA INNER JOIN
                         dbo.CLIENT ON dbo.ADDRESS_CLIENT.ID_CLIENT = dbo.CLIENT.ID_CLIENT
WHERE        (dbo.ADDRESS_CLIENT.FG_ACTIVE = 1)

GO
/****** Object:  View [dbo].[VIEW_ADDRESS_COMPANY]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_ADDRESS_COMPANY]
AS
SELECT        dbo.ADDRESS_COMPANY.ID_ADDRESS_COMPANY, dbo.ADDRESS_COMPANY.ID_COMPANY_USER, dbo.ADDRESS_COMPANY.DS_ADDRESS_COMPANY, dbo.ADDRESS_COMPANY.ADDRESS, 
                         dbo.DEPARTAMENTO.ID_DEPARTAMENTO, dbo.PROVINCIA.ID_PROVINCIA, dbo.DISTRITO.ID_DISTRITO, dbo.COMPANY_USER.ID_USER, dbo.DEPARTAMENTO.DS_DEPARTAMENTO, dbo.PROVINCIA.DS_PROVINCIA, 
                         dbo.DISTRITO.COD_UBIGEO, dbo.DISTRITO.DS_DISTRITO, dbo.COMPANY_USER.DS_COMPANY, dbo.ADDRESS_COMPANY.FG_PRINCIPAL
FROM            dbo.ADDRESS_COMPANY INNER JOIN
                         dbo.DISTRITO ON dbo.ADDRESS_COMPANY.ID_DISTRITO = dbo.DISTRITO.ID_DISTRITO INNER JOIN
                         dbo.PROVINCIA INNER JOIN
                         dbo.DEPARTAMENTO ON dbo.PROVINCIA.ID_DEPARTAMENTO = dbo.DEPARTAMENTO.ID_DEPARTAMENTO ON dbo.DISTRITO.ID_PROVINCIA = dbo.PROVINCIA.ID_PROVINCIA INNER JOIN
                         dbo.COMPANY_USER ON dbo.ADDRESS_COMPANY.ID_COMPANY_USER = dbo.COMPANY_USER.ID_COMPANY_USER
WHERE        (dbo.ADDRESS_COMPANY.FG_ACTIVE = 1)

GO
/****** Object:  View [dbo].[VIEW_UBIGEOS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_UBIGEOS]
AS
SELECT        dbo.DISTRITO.ID_DISTRITO, dbo.DISTRITO.COD_UBIGEO, dbo.DISTRITO.DS_DISTRITO, dbo.PROVINCIA.ID_PROVINCIA, dbo.PROVINCIA.DS_PROVINCIA, dbo.DEPARTAMENTO.ID_DEPARTAMENTO, 
                         dbo.DEPARTAMENTO.DS_DEPARTAMENTO
FROM            dbo.DISTRITO INNER JOIN
                         dbo.PROVINCIA ON dbo.DISTRITO.ID_PROVINCIA = dbo.PROVINCIA.ID_PROVINCIA INNER JOIN
                         dbo.DEPARTAMENTO ON dbo.PROVINCIA.ID_DEPARTAMENTO = dbo.DEPARTAMENTO.ID_DEPARTAMENTO

GO
/****** Object:  View [dbo].[VIEW_USERS]    Script Date: 19/05/2020 9:08:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_USERS]
AS
SELECT        dbo.USERS.ID_USER, dbo.USERS.NAME, dbo.USERS.EMAIL, dbo.USERS.PASSWORD, dbo.USERS.IMAGE, dbo.USERS.GOOGLE, dbo.USERS.ID_ROLE, dbo.USERS.FG_ACTIVE, dbo.USERS.FG_LOCKED, 
                         dbo.USERS.DT_REGISTRY, dbo.USERS.PHONE, dbo.USER_ROLES.DS_ROLE, CASE WHEN GOOGLE = 1 THEN 'GOOGLE' ELSE 'NORMAL' END AS AUTHENTICATION
FROM            dbo.USERS INNER JOIN
                         dbo.USER_ROLES ON dbo.USERS.ID_ROLE = dbo.USER_ROLES.ID_ROLE
WHERE        (dbo.USERS.FG_ACTIVE = 1)

GO
SET IDENTITY_INSERT [dbo].[ADDRESS_CLIENT] ON 

INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(2 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'2', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB5D01025A62 AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(3 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'CALLAO', N'MZ H1 LT 32', 0, CAST(0x0000AB6000F87063 AS DateTime), 50, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(4 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'terwtwer', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB6000FE39F4 AS DateTime), 1514, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(5 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'callao2', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB6000FE4D04 AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(6 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'CALLAO', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB600102B968 AS DateTime), 1694, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(7 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'rerfwqer', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB6001094750 AS DateTime), 1697, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(8 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'EEW', N'Venezuela', 0, CAST(0x0000AB60012B8A7C AS DateTime), 1523, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(9 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'4534534', N'Venezuela', 0, CAST(0x0000AB61009305D3 AS DateTime), 1523, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(10 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), N'tewtwert', N'Venezuela', 1, CAST(0x0000AB61009F4E3D AS DateTime), 1483, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(11 AS Numeric(18, 0)), CAST(29 AS Numeric(18, 0)), N'11', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB6100A292C7 AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(12 AS Numeric(18, 0)), CAST(29 AS Numeric(18, 0)), N'callao', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB6100A2ABE2 AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(13 AS Numeric(18, 0)), CAST(30 AS Numeric(18, 0)), N'13', N'AV. BOLIVIA NRO. 148 INT. 607 (C.C. CENTRO LIMA 1ER PISO) LIMA - LIMA - LIMA', 1, CAST(0x0000AB610123E98C AS DateTime), 1567, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(14 AS Numeric(18, 0)), CAST(31 AS Numeric(18, 0)), N'14', N'AV. BOLIVIA NRO. 148 INT. 607 (C.C. CENTRO LIMA 1ER PISO) LIMA - LIMA - LIMA', 1, CAST(0x0000AB6101244776 AS DateTime), 1250, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(15 AS Numeric(18, 0)), CAST(32 AS Numeric(18, 0)), N'Principal', N'AV. CANADA NRO. 3792 INT. 3798 URB. VILLA JARDIN LIMA - LIMA - SAN LUIS', 1, CAST(0x0000AB6400C1461A AS DateTime), 1283, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(16 AS Numeric(18, 0)), CAST(33 AS Numeric(18, 0)), N'Principal', N'AV. CANADA NRO. 3792 INT. 3798 URB. VILLA JARDIN LIMA - LIMA - SAN LUIS', 1, CAST(0x0000AB650117A553 AS DateTime), 1283, 0)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(17 AS Numeric(18, 0)), CAST(30 AS Numeric(18, 0)), N'45345', N'Venezuela', 1, CAST(0x0000AB6C00930A45 AS DateTime), 1684, 1)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(18 AS Numeric(18, 0)), CAST(34 AS Numeric(18, 0)), N'Principal', N'AV. NICOLAS ARRIOLA NRO. 480 URB. SANTA CATALINA LIMA - LIMA - LA VICTORIA', 1, CAST(0x0000AB7400CD1B8D AS DateTime), 1264, 1)
INSERT [dbo].[ADDRESS_CLIENT] ([ID_ADDRESS_CLIENT], [ID_CLIENT], [DS_ADDRESS_CLIENT], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(19 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), N'Principal', N'----JICAMARCA MZA. BJ LOTE. 04 SAN ANTONIO DE CHACLLA (AL FINAL DE AV WIESE. ARCO DE SAN ANTONI) LIMA - HUAROCHIRI - SAN ANTONIO', 1, CAST(0x0000AB7500F21B62 AS DateTime), 1353, 1)
SET IDENTITY_INSERT [dbo].[ADDRESS_CLIENT] OFF
SET IDENTITY_INSERT [dbo].[ADDRESS_COMPANY] ON 

INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(25 AS Numeric(18, 0)), CAST(45 AS Numeric(18, 0)), N'principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB4B00B72B4A AS DateTime), 350, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(26 AS Numeric(18, 0)), CAST(46 AS Numeric(18, 0)), N'Lima', N'Lima jiron junin', 1, CAST(0x0000AB4B00B76E05 AS DateTime), 1250, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(27 AS Numeric(18, 0)), CAST(45 AS Numeric(18, 0)), N'principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB4B00E4BDAD AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(28 AS Numeric(18, 0)), CAST(50 AS Numeric(18, 0)), N'principal', N'Los Olivos', 1, CAST(0x0000AB4B00FA6625 AS DateTime), 1266, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(29 AS Numeric(18, 0)), CAST(45 AS Numeric(18, 0)), N'principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB5000D6AAE8 AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(30 AS Numeric(18, 0)), CAST(51 AS Numeric(18, 0)), N'principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB5000D7AED7 AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(31 AS Numeric(18, 0)), CAST(56 AS Numeric(18, 0)), N'principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB5700D3F2D1 AS DateTime), 17, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(32 AS Numeric(18, 0)), CAST(58 AS Numeric(18, 0)), N'principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB5700D83DA3 AS DateTime), 234, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(33 AS Numeric(18, 0)), CAST(59 AS Numeric(18, 0)), N'undefined', N'AV. CARLOS A.IZAGUIRRE NRO. 216 INT. 1S-3 URB. NARANJAL (GALERIA SAN LAZARO) LIMA - LIMA - INDEPENDENCIA', 1, CAST(0x0000AB5700D85C9C AS DateTime), 1261, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(34 AS Numeric(18, 0)), CAST(60 AS Numeric(18, 0)), N'Principal', N'AV. CARLOS A.IZAGUIRRE NRO. 216 INT. 1S-3 URB. NARANJAL (GALERIA SAN LAZARO) LIMA - LIMA - INDEPENDENCIA', 1, CAST(0x0000AB5700D94210 AS DateTime), 1261, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(35 AS Numeric(18, 0)), CAST(60 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB5700D97509 AS DateTime), 234, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(36 AS Numeric(18, 0)), CAST(61 AS Numeric(18, 0)), N'Principal', N'AV. CARLOS A.IZAGUIRRE NRO. 216 INT. 1S-3 URB. NARANJAL (GALERIA SAN LAZARO) LIMA - LIMA - INDEPENDENCIA', 1, CAST(0x0000AB5700D9F937 AS DateTime), 1261, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(37 AS Numeric(18, 0)), CAST(61 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB5700DAB7B9 AS DateTime), 19, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(38 AS Numeric(18, 0)), CAST(62 AS Numeric(18, 0)), N'Principal', N'AV. CARLOS A.IZAGUIRRE NRO. 216 INT. 1S-3 URB. NARANJAL (GALERIA SAN LAZARO) LIMA - LIMA - INDEPENDENCIA', 1, CAST(0x0000AB5700DACA72 AS DateTime), 1261, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(39 AS Numeric(18, 0)), CAST(63 AS Numeric(18, 0)), N'Principal', N'JR. LAS ENCINAS NRO. 575 (PIS 6) LIMA - LIMA - SAN MARTIN DE PORRES', 1, CAST(0x0000AB5700E92F5A AS DateTime), 1284, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(40 AS Numeric(18, 0)), CAST(63 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB5700E9469F AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(41 AS Numeric(18, 0)), CAST(64 AS Numeric(18, 0)), N'Principal', N'AV. JAVIER PRADO ESTE NRO. 2955 DPTO. 402 LIMA - LIMA - SAN BORJA', 1, CAST(0x0000AB5700EFF188 AS DateTime), 1279, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(42 AS Numeric(18, 0)), CAST(65 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB5701276FA7 AS DateTime), 1250, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(43 AS Numeric(18, 0)), CAST(66 AS Numeric(18, 0)), N'Principal', N'AV. SCT 0989 MZT 003 MZA. A LOTE. 2A URB. MAMACONA S/N (PLAYA MAMACONA) LIMA - LIMA - LURIN', 1, CAST(0x0000AB5800D20FBB AS DateTime), 1268, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(44 AS Numeric(18, 0)), CAST(67 AS Numeric(18, 0)), N'Principal', N'AV. CARLOS A.IZAGUIRRE NRO. 216 INT. 1S-3 URB. NARANJAL (GALERIA SAN LAZARO) LIMA - LIMA - INDEPENDENCIA', 1, CAST(0x0000AB58011C62B4 AS DateTime), 1261, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(45 AS Numeric(18, 0)), CAST(68 AS Numeric(18, 0)), N'Principal', N'AV. NICOLAS ARRIOLA NRO. 480 URB. SANTA CATALINA LIMA - LIMA - LA VICTORIA', 1, CAST(0x0000AB59009568E0 AS DateTime), 1264, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(46 AS Numeric(18, 0)), CAST(69 AS Numeric(18, 0)), N'Principal', N'CAL.ISAAC NEWTON NRO. 2164 URB. EL TREBOL ET. UNO (ALT CDA 2 DE ANGELICA GAMARRA Y P. NORTE) LIMA - LIMA - LOS OLIVOS', 1, CAST(0x0000AB5900987F27 AS DateTime), 1266, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(47 AS Numeric(18, 0)), CAST(70 AS Numeric(18, 0)), N'Principal', N'AV. BOLIVIA NRO. 148 INT. 607 (C.C. CENTRO LIMA 1ER PISO) LIMA - LIMA - LIMA', 1, CAST(0x0000AB5900B2D78F AS DateTime), 1250, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(48 AS Numeric(18, 0)), CAST(71 AS Numeric(18, 0)), N'Principal', N'AV. CUBA NRO. 638 INT. 101 LIMA - LIMA - JESUS MARIA', 1, CAST(0x0000AB5900B310E3 AS DateTime), 1262, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(49 AS Numeric(18, 0)), CAST(72 AS Numeric(18, 0)), N'Principal1', N'JR. LAS ENCINAS NRO. 575 (PIS 6) LIMA - LIMA - SAN MARTIN DE PORRES', 0, CAST(0x0000AB5A009106A0 AS DateTime), 1284, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(50 AS Numeric(18, 0)), CAST(73 AS Numeric(18, 0)), N'Principal', N'AV. BOLIVIA NRO. 148 INT. 607 (C.C. CENTRO LIMA 1ER PISO) LIMA - LIMA - LIMA', 1, CAST(0x0000AB5A00911E85 AS DateTime), 1250, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(51 AS Numeric(18, 0)), CAST(74 AS Numeric(18, 0)), N'Principal', N'-', 1, CAST(0x0000AB5A0091657A AS DateTime), 1250, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(52 AS Numeric(18, 0)), CAST(72 AS Numeric(18, 0)), N'Callao', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB5B00C0215E AS DateTime), 678, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(53 AS Numeric(18, 0)), CAST(72 AS Numeric(18, 0)), N'Principal', N'Venezuela', 0, CAST(0x0000AB5B00C249F0 AS DateTime), 243, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(54 AS Numeric(18, 0)), CAST(75 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB5B00C2781E AS DateTime), 1250, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(55 AS Numeric(18, 0)), CAST(75 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 1, CAST(0x0000AB5B00C288B5 AS DateTime), 226, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(56 AS Numeric(18, 0)), CAST(76 AS Numeric(18, 0)), N'Principal', N'AV. JAVIER PRADO ESTE NRO. 2955 DPTO. 402 LIMA - LIMA - SAN BORJA', 1, CAST(0x0000AB5D01025A62 AS DateTime), 1279, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(57 AS Numeric(18, 0)), CAST(72 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB60012B4C23 AS DateTime), 1557, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(58 AS Numeric(18, 0)), CAST(72 AS Numeric(18, 0)), N'Principal1', N'234234', 1, CAST(0x0000AB600131389B AS DateTime), 1473, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(59 AS Numeric(18, 0)), CAST(72 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB6100920E3A AS DateTime), 1499, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(60 AS Numeric(18, 0)), CAST(77 AS Numeric(18, 0)), N'Principal', N'AV. CARLOS A.IZAGUIRRE NRO. 216 INT. 1S-3 URB. NARANJAL (GALERIA SAN LAZARO) LIMA - LIMA - INDEPENDENCIA', 1, CAST(0x0000AB610092AC6B AS DateTime), 1261, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(61 AS Numeric(18, 0)), CAST(78 AS Numeric(18, 0)), N'Principal333', N'CAL.CLEMENTE X NRO. 135 URB. SAN FELIPE LIMA - LIMA - MAGDALENA DEL MAR', 1, CAST(0x0000AB6101237EB9 AS DateTime), 1269, 1)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(62 AS Numeric(18, 0)), CAST(79 AS Numeric(18, 0)), N'Principal', N'AV. BOLIVIA NRO. 148 INT. 607 (C.C. CENTRO LIMA 1ER PISO) LIMA - LIMA - LIMA', 1, CAST(0x0000AB61012518D5 AS DateTime), 1250, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(63 AS Numeric(18, 0)), CAST(78 AS Numeric(18, 0)), N'Principal', N'URB. SAN JUAN MASIAS
MZ H1 LT 32', 0, CAST(0x0000AB68009E5659 AS DateTime), 1549, 0)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(64 AS Numeric(18, 0)), CAST(80 AS Numeric(18, 0)), N'Principal', N'CAL.LOS ALHELIS MZA. F LOTE. 9 URB. PEREGRINOS DEL SE?OR LIMA - LIMA - LOS OLIVOS', 1, CAST(0x0000AB6B009164A2 AS DateTime), 1266, 1)
INSERT [dbo].[ADDRESS_COMPANY] ([ID_ADDRESS_COMPANY], [ID_COMPANY_USER], [DS_ADDRESS_COMPANY], [ADDRESS], [FG_ACTIVE], [DT_REGISTRY], [ID_DISTRITO], [FG_PRINCIPAL]) VALUES (CAST(65 AS Numeric(18, 0)), CAST(81 AS Numeric(18, 0)), N'Principal333', N'CAL.SIN NOMBRE MZA. C LOTE. 12 URB. LAS GARZAS DE VILLA LAMBAYEQUE - CHICLAYO - LA VICTORIA', 1, CAST(0x0000AB6C0091D6A3 AS DateTime), 1217, 1)
SET IDENTITY_INSERT [dbo].[ADDRESS_COMPANY] OFF
SET IDENTITY_INSERT [dbo].[CLIENT] ON 

INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(22 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20100047307', N'ADMINISTRADORA DEL COMERCIO S.A.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 0, CAST(0x0000AB5F012EA5A4 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(23 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20100047307', N'ADMINISTRADORA DEL COMERCIO S.A.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 0, CAST(0x0000AB5F012ECDEB AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(24 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20601759447', N'AFG SERVICES & COURIER S.A.C.', N'luisgalic@gmail.com', N'929647791', N'luis galicia LUGO', 0, CAST(0x0000AB5F012EF2C9 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(25 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20100047307', N'ADMINISTRADORA DEL COMERCIO S.A.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 0, CAST(0x0000AB5F012F5BD3 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(26 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'206017594471', N'AFG SERVICES & COURIER S.A.C.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 0, CAST(0x0000AB6000EEC819 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(27 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20601759447', N'AFG SERVICES & COURIER S.A.C.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 0, CAST(0x0000AB610092E340 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(28 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20601759447', N'AFG SERVICES & COURIER S.A.C.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 0, CAST(0x0000AB6100A2251E AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(29 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20100047307', N'ADMINISTRADORA DEL COMERCIO S.A.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 0, CAST(0x0000AB6100A292BB AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(30 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20510530951', N'C & C COMPUTER SERVICE S.A.C.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 1, CAST(0x0000AB610123E97F AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(31 AS Numeric(18, 0)), CAST(145 AS Numeric(18, 0)), N'20510530951', N'C & C COMPUTER SERVICE S.A.C.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 1, CAST(0x0000AB6101244768 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(32 AS Numeric(18, 0)), CAST(145 AS Numeric(18, 0)), N'20250406941', N'AGROVET MARKET S.A', N'luisgalic@gmail.com', N'929647791', N'lus galicia', 1, CAST(0x0000AB6400C14607 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(33 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20250406941', N'AGROVET MARKET S.A', N'luisgalic@gmail.com', N'332343', N'Luis R Galicia L', 1, CAST(0x0000AB650117A543 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(34 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20467534026', N'AMERICA MOVIL PERU S.A.C.', N'luisgalic@gmail.com1223', N'929647791', N'lus galicia', 1, CAST(0x0000AB7400CD1B77 AS DateTime), 4, 1)
INSERT [dbo].[CLIENT] ([ID_CLIENT], [ID_USER], [COD_CLIENT], [DS_CLIENT], [EMAIL], [PHONE], [CONTACT], [FG_ACTIVE], [DT_REGISTRY], [ID_TYPE], [ID_TYPE_CLIENT]) VALUES (CAST(35 AS Numeric(18, 0)), CAST(103 AS Numeric(18, 0)), N'20336107262', N'TRANSPORT TIGRILLO S.A. - TRANSTIGRILLO S.A.', N'luisgalic@gmail.com4545', N'929647791', N'lus galicia', 1, CAST(0x0000AB7500F21B50 AS DateTime), 4, 1)
SET IDENTITY_INSERT [dbo].[CLIENT] OFF
SET IDENTITY_INSERT [dbo].[COMPANY_USER] ON 

INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(38 AS Numeric(18, 0)), N'14785236987', CAST(103 AS Numeric(18, 0)), N'Empresa 1', N'empresa1@gmail.com', N'929647791', N'Luis Galicia', NULL, N'38-344.JPG', 0, CAST(0x0000AB49010CBCF2 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(39 AS Numeric(18, 0)), N'85479632510', CAST(103 AS Numeric(18, 0)), N'Empresa 2', N'empresa2@gmail.com', N'929647791', N'Galicia Luis', NULL, NULL, 0, CAST(0x0000AB49010D7A1B AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(40 AS Numeric(18, 0)), N'1478523698755', CAST(103 AS Numeric(18, 0)), N'Empresa 1', N'empresa1@gmail.com11', N'929647791', N'Luis Galicia', NULL, NULL, 0, CAST(0x0000AB4A00E211D2 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(41 AS Numeric(18, 0)), N'6546456456', CAST(103 AS Numeric(18, 0)), N'gdfhfgh', N'luisgalic@gmail.com667676', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB4A00E2AEAE AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(42 AS Numeric(18, 0)), N'4534534', CAST(103 AS Numeric(18, 0)), N'rtetert', N'luisgalic@gmail.com56546776', N'rtert', N'retert', NULL, NULL, 0, CAST(0x0000AB4A00E37772 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(43 AS Numeric(18, 0)), N'874965485411', CAST(103 AS Numeric(18, 0)), N'Empresa 3', N'luisgalic@gmail.com3', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB4A00E3E565 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(44 AS Numeric(18, 0)), N'87965845202', CAST(103 AS Numeric(18, 0)), N'Empresa 4', N'luisgalic@gmail.com4', N'929647791', N'lus galicia', NULL, N'44-235.JPG', 0, CAST(0x0000AB4A00E4232A AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(45 AS Numeric(18, 0)), N'17458965852', CAST(103 AS Numeric(18, 0)), N'Empresa 1', N'luisgalic@gmail.com', N'929647791', N'Luis Galicia', NULL, N'45-114.JPG', 0, CAST(0x0000AB4A01091555 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(46 AS Numeric(18, 0)), N'8985482365', CAST(108 AS Numeric(18, 0)), N'empresa666', N'luisgalic@gmail.com1', N'929647791', N'Luis R Galicia L', NULL, NULL, 1, CAST(0x0000AB4A0109403A AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(47 AS Numeric(18, 0)), N'53453453434234', CAST(103 AS Numeric(18, 0)), N'Empresa 1', N'luisgalic@gmail.com66', N'45454', N'Luis R Galicia L', NULL, N'47-360.JPG', 0, CAST(0x0000AB4A011B25DB AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(48 AS Numeric(18, 0)), N'55', CAST(103 AS Numeric(18, 0)), N'55', N'555@hotmail', N'55', N'444', NULL, NULL, 0, CAST(0x0000AB4B00AA0C67 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(49 AS Numeric(18, 0)), N'8496564646', CAST(103 AS Numeric(18, 0)), N'empresa 3', N'luisgalic@gmail.com45454', N'929647791', N'Galicia Luis', NULL, N'49-561.JPG', 0, CAST(0x0000AB4B00E7B713 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(50 AS Numeric(18, 0)), N'12485479652', CAST(103 AS Numeric(18, 0)), N'Soporte Tecnico de Pacifico sac', N'galicialuis@hotmail.es', N'929647791', N'Galicia Luis', NULL, N'50-473.JPG', 0, CAST(0x0000AB4B00EC5389 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(51 AS Numeric(18, 0)), N'874589644', CAST(137 AS Numeric(18, 0)), N'Empresa 1', N'luisgalic@gmail.com11', N'929647791', N'lus galicia', NULL, N'51-106.JPG', 1, CAST(0x0000AB5000D79ED7 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(52 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com1252', N'6585', N'galicia luis', NULL, NULL, 0, CAST(0x0000AB5700C91B9B AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(53 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com1111', N'454545', N'luis', NULL, NULL, 0, CAST(0x0000AB5700D041B7 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(54 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com111', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5700D16C3B AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(55 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com111111', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5700D2D9B4 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(56 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com111', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5700D3C0E8 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(57 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com11111', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5700D4A662 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(58 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com1111', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5700D6FA1D AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(59 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com11111', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5700D85C8D AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(60 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com1111', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5700D94201 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(61 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com11111', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5700D9F929 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(62 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com11111', N'929647791', N'lus galicia', NULL, N'62-93.JPG', 0, CAST(0x0000AB5700DACA5C AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(63 AS Numeric(18, 0)), N'20601759447', CAST(103 AS Numeric(18, 0)), N'AFG SERVICES & COURIER S.A.C.', N'luisgalic@gmail.com666', N'929647791', N'lus galicia', NULL, N'63-236.JPG', 0, CAST(0x0000AB5700E92F4A AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(64 AS Numeric(18, 0)), N'20122562728', CAST(103 AS Numeric(18, 0)), N'AUDI CONSULT ASESORES Y CONSULTORES DE EMPRESAS SOCIEDAD COMERCIAL DE RESPONSABILIDAD LIMITADA', N'luisgalic@gmail.com3334', N'tytyt', N'Luis R Galicia L', NULL, N'64-819.JPG', 0, CAST(0x0000AB5700EFF17B AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(65 AS Numeric(18, 0)), N'10446740038', CAST(103 AS Numeric(18, 0)), N'BALBUENA LEON ROSARIO MILAGROS', N'luisgalic@gmail.com222222', N'929647791', N'lus galicia1111111', NULL, N'65-531.JPG', 0, CAST(0x0000AB5701276F9A AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(66 AS Numeric(18, 0)), N'20511604444', CAST(103 AS Numeric(18, 0)), N'DERMADI S.R.L.', N'luisgalic@gmail.com445', N'929647791', N'lus galicia', NULL, N'66-572.JPG', 0, CAST(0x0000AB5800D20F78 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(67 AS Numeric(18, 0)), N'20520899481555', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com22343434', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB58011C629F AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(68 AS Numeric(18, 0)), N'20467534026', CAST(103 AS Numeric(18, 0)), N'AMERICA MOVIL PERU S.A.C.', N'luisgalic@gmail.com565656', N'929647791', N'lus galicia', NULL, N'68-789.JPG', 0, CAST(0x0000AB59009568CD AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(69 AS Numeric(18, 0)), N'20422012606', CAST(103 AS Numeric(18, 0)), N'ASOCIADOS MIKOFER S.A.', N'luisgalic@gmail.com33434', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5900987F18 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(70 AS Numeric(18, 0)), N'20510530951', CAST(103 AS Numeric(18, 0)), N'C & C COMPUTER SERVICE S.A.C.', N'luisgalic@gmail.com445454', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5900B2D781 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(71 AS Numeric(18, 0)), N'20523655893', CAST(103 AS Numeric(18, 0)), N'CONTROL AUDIOVISUAL S.A.C.', N'luisgalic@gmail.com66767', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5900B310D6 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(72 AS Numeric(18, 0)), N'20601759447', CAST(103 AS Numeric(18, 0)), N'AFG SERVICES & COURIER S.A.C.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5A00910690 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(73 AS Numeric(18, 0)), N'20510530951', CAST(103 AS Numeric(18, 0)), N'C & C COMPUTER SERVICE S.A.C.', N'luisgalic@gmail.com2', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB5A00911E77 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(74 AS Numeric(18, 0)), N'10067954446', CAST(103 AS Numeric(18, 0)), N'CANTU MALLQUI JAVIER PEDRO', N'JAVIERPEDRO@gmail.com', N'145258996', N'CANTU MALLQUI JAVIER PEDRO', NULL, NULL, 0, CAST(0x0000AB5A0091656E AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(75 AS Numeric(18, 0)), N'10067954446', CAST(103 AS Numeric(18, 0)), N'CANTU MALLQUI JAVIER PEDRO', N'luisgalic@gmail.com6565656', N'929647791', N'56456456', NULL, NULL, 0, CAST(0x0000AB5B00C27812 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(76 AS Numeric(18, 0)), N'20122562728', CAST(103 AS Numeric(18, 0)), N'AUDI CONSULT ASESORES Y CONSULTORES DE EMPRESAS SOCIEDAD COMERCIAL DE RESPONSABILIDAD LIMITADA', N'luisgalic@gmail.com3343', N'929647791', N'343434', NULL, NULL, 0, CAST(0x0000AB5D01025A4F AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(77 AS Numeric(18, 0)), N'20520899481', CAST(103 AS Numeric(18, 0)), N'AVM INVERSIONES E.I.R.L.', N'luisgalic@gmail.com44', N'929647791', N'lus galicia', NULL, NULL, 0, CAST(0x0000AB610092AC5D AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(78 AS Numeric(18, 0)), N'20100047307', CAST(103 AS Numeric(18, 0)), N'ADMINISTRADORA DEL COMERCIO S.A.', N'luisgalic@gmail.com', N'929647791', N'lus galicia', NULL, N'78-787.jpg', 1, CAST(0x0000AB6101237EAA AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(79 AS Numeric(18, 0)), N'20510530951', CAST(145 AS Numeric(18, 0)), N'C & C COMPUTER SERVICE S.A.C.', N'luisgalic@gmail.com111', N'929647791', N'lus galicia', NULL, NULL, 1, CAST(0x0000AB61012518C7 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(80 AS Numeric(18, 0)), N'20538236021', CAST(103 AS Numeric(18, 0)), N'CORPORACION CYBER POWER SOCIEDAD ANONIMA CERRADA', N'galicialuis@hotmail.es', N'939248818', N'Del Moral ', NULL, NULL, 1, CAST(0x0000AB6B00916478 AS DateTime))
INSERT [dbo].[COMPANY_USER] ([ID_COMPANY_USER], [ID_COMPANY], [ID_USER], [DS_COMPANY], [EMAIL], [PHONE], [CONTACT], [ADDRESS], [IMAGE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(81 AS Numeric(18, 0)), N'20602270841', CAST(103 AS Numeric(18, 0)), N'BUSES Y CAMIONES CHICLAYO E.I.R.L.', N'luisgalic@gmail.com333', N'929647791', N'lus galicia', NULL, NULL, 1, CAST(0x0000AB6C0091D694 AS DateTime))
SET IDENTITY_INSERT [dbo].[COMPANY_USER] OFF
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (1, N'Amazonas')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (2, N'Ancash')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (3, N'Apurimac')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (4, N'Arequipa')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (5, N'Ayacucho')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (6, N'Cajamarca')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (7, N'Callao')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (8, N'Cusco')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (10, N'Huancavelica')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (11, N'Huanuco')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (12, N'Ica')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (13, N'Junin')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (14, N'La Libertad')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (15, N'Lambayeque')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (16, N'Lima')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (17, N'Loreto')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (18, N'Madre de Dios')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (19, N'Moquegua')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (20, N'Pasco')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (21, N'Piura')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (22, N'Puno')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (23, N'San Martin')
INSERT [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO], [DS_DEPARTAMENTO]) VALUES (24, N'Tacna')
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1, N'10101', N'Chachapoyas', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (2, N'10102', N'Asuncion', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (3, N'10103', N'Balsas', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (4, N'10104', N'Cheto', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (5, N'10105', N'Chiliquin', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (6, N'10106', N'Chuquibamba', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (7, N'10107', N'Granada', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (8, N'10108', N'Huancas', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (9, N'10109', N'La Jalca', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (10, N'10110', N'Leimebamba', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (11, N'10111', N'Levanto', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (12, N'10112', N'Magdalena', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (13, N'10113', N'Mariscal Castilla', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (14, N'10114', N'Molinopampa', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (15, N'10115', N'Montevideo', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (16, N'10116', N'Olleros', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (17, N'10117', N'Quinjalca', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (18, N'10118', N'San Francisco de Daguas', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (19, N'10119', N'San Isidro de Maino', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (20, N'10120', N'Soloco', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (21, N'10121', N'Sonche', 1)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (22, N'10201', N'Bagua', 2)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (23, N'10202', N'Aramango', 2)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (24, N'10203', N'Copallin', 2)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (25, N'10204', N'El Parco', 2)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (26, N'10205', N'Imaza', 2)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (27, N'10206', N'La Peca', 2)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (28, N'10301', N'Jumbilla', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (29, N'10302', N'Chisquilla', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (30, N'10303', N'Churuja', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (31, N'10304', N'Corosha', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (32, N'10305', N'Cuispes', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (33, N'10306', N'Florida', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (34, N'10307', N'Jazan', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (35, N'10308', N'Recta', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (36, N'10309', N'San Carlos', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (37, N'10310', N'Shipasbamba', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (38, N'10311', N'Valera', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (39, N'10312', N'Yambrasbamba', 3)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (40, N'10401', N'Nieva', 4)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (41, N'10402', N'El Cenepa', 4)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (42, N'10403', N'Rio Santiago', 4)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (43, N'10501', N'Lamud', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (44, N'10502', N'Camporredondo', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (45, N'10503', N'Cocabamba', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (46, N'10504', N'Colcamar', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (47, N'10505', N'Conila', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (48, N'10506', N'Inguilpata', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (49, N'10507', N'Longuita', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (50, N'10508', N'Lonya Chico', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (51, N'10509', N'Luya', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (52, N'10510', N'Luya Viejo', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (53, N'10511', N'Maria', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (54, N'10512', N'Ocalli', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (55, N'10513', N'Ocumal', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (56, N'10514', N'Pisuquia', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (57, N'10515', N'Providencia', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (58, N'10516', N'San Cristobal', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (59, N'10517', N'San Francisco del Yeso', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (60, N'10518', N'San Jeronimo', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (61, N'10519', N'San Juan de Lopecancha', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (62, N'10520', N'Santa Catalina', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (63, N'10521', N'Santo Tomas', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (64, N'10522', N'Tingo', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (65, N'10523', N'Trita', 5)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (66, N'10601', N'San Nicolas', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (67, N'10602', N'Chirimoto', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (68, N'10603', N'Cochamal', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (69, N'10604', N'Huambo', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (70, N'10605', N'Limabamba', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (71, N'10606', N'Longar', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (72, N'10607', N'Mariscal Benavides', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (73, N'10608', N'Milpuc', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (74, N'10609', N'Omia', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (75, N'10610', N'Santa Rosa', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (76, N'10611', N'Totora', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (77, N'10612', N'Vista Alegre', 6)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (78, N'10701', N'Bagua Grande', 7)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (79, N'10702', N'Cajaruro', 7)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (80, N'10703', N'Cumba', 7)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (81, N'10704', N'El Milagro', 7)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (82, N'10705', N'Jamalca', 7)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (83, N'10706', N'Lonya Grande', 7)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (84, N'10707', N'Yamon', 7)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (85, N'20101', N'Huaraz', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (86, N'20102', N'Cochabamba', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (87, N'20103', N'Colcabamba', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (88, N'20104', N'Huanchay', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (89, N'20105', N'Independencia', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (90, N'20106', N'Jangas', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (91, N'20107', N'La Libertad', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (92, N'20108', N'Olleros', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (93, N'20109', N'Pampas', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (94, N'20110', N'Pariacoto', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (95, N'20111', N'Pira', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (96, N'20112', N'Tarica', 8)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (97, N'20201', N'Aija', 9)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (98, N'20202', N'Coris', 9)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (99, N'20203', N'Huacllan', 9)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (100, N'20204', N'La Merced', 9)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (101, N'20205', N'Succha', 9)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (102, N'20301', N'Llamellin', 10)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (103, N'20302', N'Aczo', 10)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (104, N'20303', N'Chaccho', 10)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (105, N'20304', N'Chingas', 10)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (106, N'20305', N'Mirgas', 10)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (107, N'20306', N'San Juan de Rontoy', 10)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (108, N'20401', N'Chacas', 11)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (109, N'20402', N'Acochaca', 11)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (110, N'20501', N'Chiquian', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (111, N'20502', N'Abelardo Pardo Lezameta', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (112, N'20503', N'Antonio Raymondi', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (113, N'20504', N'Aquia', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (114, N'20505', N'Cajacay', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (115, N'20506', N'Canis', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (116, N'20507', N'Colquioc', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (117, N'20508', N'Huallanca', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (118, N'20509', N'Huasta', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (119, N'20510', N'Huayllacayan', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (120, N'20511', N'La Primavera', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (121, N'20512', N'Mangas', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (122, N'20513', N'Pacllon', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (123, N'20514', N'San Miguel de Corpanqui', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (124, N'20515', N'Ticllos', 12)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (125, N'20601', N'Carhuaz', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (126, N'20602', N'Acopampa', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (127, N'20603', N'Amashca', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (128, N'20604', N'Anta', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (129, N'20605', N'Ataquero', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (130, N'20606', N'Marcara', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (131, N'20607', N'Pariahuanca', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (132, N'20608', N'San Miguel de Aco', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (133, N'20609', N'Shilla', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (134, N'20610', N'Tinco', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (135, N'20611', N'Yungar', 13)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (136, N'20701', N'San Luis', 14)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (137, N'20702', N'San Nicolas', 14)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (138, N'20703', N'Yauya', 14)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (139, N'20801', N'Casma', 15)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (140, N'20802', N'Buena Vista Alta', 15)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (141, N'20803', N'Comandante Noel', 15)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (142, N'20804', N'Yautan', 15)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (143, N'20901', N'Corongo', 16)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (144, N'20902', N'Aco', 16)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (145, N'20903', N'Bambas', 16)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (146, N'20904', N'Cusca', 16)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (147, N'20905', N'La Pampa', 16)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (148, N'20906', N'Yanac', 16)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (149, N'20907', N'Yupan', 16)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (150, N'21001', N'Huari', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (151, N'21002', N'Anra', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (152, N'21003', N'Cajay', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (153, N'21004', N'Chavin de Huantar', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (154, N'21005', N'Huacachi', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (155, N'21006', N'Huacchis', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (156, N'21007', N'Huachis', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (157, N'21008', N'Huantar', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (158, N'21009', N'Masin', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (159, N'21010', N'Paucas', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (160, N'21011', N'Ponto', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (161, N'21012', N'Rahuapampa', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (162, N'21013', N'Rapayan', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (163, N'21014', N'San Marcos', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (164, N'21015', N'San Pedro de Chana', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (165, N'21016', N'Uco', 17)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (166, N'21101', N'Huarmey', 18)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (167, N'21102', N'Cochapeti', 18)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (168, N'21103', N'Culebras', 18)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (169, N'21104', N'Huayan', 18)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (170, N'21105', N'Malvas', 18)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (171, N'21201', N'Caraz', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (172, N'21202', N'Huallanca', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (173, N'21203', N'Huata', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (174, N'21204', N'Huaylas', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (175, N'21205', N'Mato', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (176, N'21206', N'Pamparomas', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (177, N'21207', N'Pueblo Libre', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (178, N'21208', N'Santa Cruz', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (179, N'21209', N'Santo Toribio', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (180, N'21210', N'Yuracmarca', 19)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (181, N'21301', N'Piscobamba', 20)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (182, N'21302', N'Casca', 20)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (183, N'21303', N'Eleazar Guzman Barron', 20)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (184, N'21304', N'Fidel Olivas Escudero', 20)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (185, N'21305', N'Llama', 20)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (186, N'21306', N'Llumpa', 20)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (187, N'21307', N'Lucma', 20)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (188, N'21308', N'Musga', 20)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (189, N'21401', N'Ocros', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (190, N'21402', N'Acas', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (191, N'21403', N'Cajamarquilla', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (192, N'21404', N'Carhuapampa', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (193, N'21405', N'Cochas', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (194, N'21406', N'Congas', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (195, N'21407', N'Llipa', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (196, N'21408', N'San Cristobal de Rajan', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (197, N'21409', N'San Pedro', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (198, N'21410', N'Santiago de Chilcas', 21)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (199, N'21501', N'Cabana', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (200, N'21502', N'Bolognesi', 22)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (201, N'21503', N'Conchucos', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (202, N'21504', N'Huacaschuque', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (203, N'21505', N'Huandoval', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (204, N'21506', N'Lacabamba', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (205, N'21507', N'Llapo', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (206, N'21508', N'Pallasca', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (207, N'21509', N'Pampas', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (208, N'21510', N'Santa Rosa', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (209, N'21511', N'Tauca', 22)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (210, N'21601', N'Pomabamba', 23)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (211, N'21602', N'Huayllan', 23)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (212, N'21603', N'Parobamba', 23)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (213, N'21604', N'Quinuabamba', 23)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (214, N'21701', N'Recuay', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (215, N'21702', N'Catac', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (216, N'21703', N'Cotaparaco', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (217, N'21704', N'Huayllapampa', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (218, N'21705', N'Llacllin', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (219, N'21706', N'Marca', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (220, N'21707', N'Pampas Chico', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (221, N'21708', N'Pararin', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (222, N'21709', N'Tapacocha', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (223, N'21710', N'Ticapampa', 24)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (224, N'21801', N'Chimbote', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (225, N'21802', N'Caceres del Peru', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (226, N'21803', N'Coishco', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (227, N'21804', N'Macate', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (228, N'21805', N'Moro', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (229, N'21806', N'Nepeña', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (230, N'21807', N'Samanco', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (231, N'21808', N'Santa', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (232, N'21809', N'Nuevo Chimbote', 25)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (233, N'21901', N'Sihuas', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (234, N'21902', N'Acobamba', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (235, N'21903', N'Alfonso Ugarte', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (236, N'21904', N'Cashapampa', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (237, N'21905', N'Chingalpo', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (238, N'21906', N'Huayllabamba', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (239, N'21907', N'Quiches', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (240, N'21908', N'Ragash', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (241, N'21909', N'San Juan', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (242, N'21910', N'Sicsibamba', 26)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (243, N'22001', N'Yungay', 27)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (244, N'22002', N'Cascapara', 27)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (245, N'22003', N'Mancos', 27)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (246, N'22004', N'Matacoto', 27)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (247, N'22005', N'Quillo', 27)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (248, N'22006', N'Ranrahirca', 27)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (249, N'22007', N'Shupluy', 27)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (250, N'22008', N'Yanama', 27)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (251, N'30101', N'Abancay', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (252, N'30102', N'Chacoche', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (253, N'30103', N'Circa', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (254, N'30104', N'Curahuasi', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (255, N'30105', N'Huanipaca', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (256, N'30106', N'Lambrama', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (257, N'30107', N'Pichirhua', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (258, N'30108', N'San Pedro de Cachora', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (259, N'30109', N'Tamburco', 28)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (260, N'30201', N'Andahuaylas', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (261, N'30202', N'Andarapa', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (262, N'30203', N'Chiara', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (263, N'30204', N'Huancarama', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (264, N'30205', N'Huancaray', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (265, N'30206', N'Huayana', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (266, N'30207', N'Kishuara', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (267, N'30208', N'Pacobamba', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (268, N'30209', N'Pacucha', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (269, N'30210', N'Pampachiri', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (270, N'30211', N'Pomacocha', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (271, N'30212', N'San Antonio de Cachi', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (272, N'30213', N'San Jeronimo', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (273, N'30214', N'San Miguel de Chaccrampa', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (274, N'30215', N'Santa Maria de Chicmo', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (275, N'30216', N'Talavera', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (276, N'30217', N'Tumay Huaraca', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (277, N'30218', N'Turpo', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (278, N'30219', N'Kaquiabamba', 29)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (279, N'30301', N'Antabamba', 30)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (280, N'30302', N'El Oro', 30)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (281, N'30303', N'Huaquirca', 30)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (282, N'30304', N'Juan Espinoza Medrano', 30)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (283, N'30305', N'Oropesa', 30)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (284, N'30306', N'Pachaconas', 30)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (285, N'30307', N'Sabaino', 30)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (286, N'30401', N'Chalhuanca', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (287, N'30402', N'Capaya', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (288, N'30403', N'Caraybamba', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (289, N'30404', N'Chapimarca', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (290, N'30405', N'Colcabamba', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (291, N'30406', N'Cotaruse', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (292, N'30407', N'Huayllo', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (293, N'30408', N'Justo Apu Sahuaraura', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (294, N'30409', N'Lucre', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (295, N'30410', N'Pocohuanca', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (296, N'30411', N'San Juan de Chacña', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (297, N'30412', N'Sañayca', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (298, N'30413', N'Soraya', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (299, N'30414', N'Tapairihua', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (300, N'30415', N'Tintay', 31)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (301, N'30416', N'Toraya', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (302, N'30417', N'Yanaca', 31)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (303, N'30501', N'Tambobamba', 32)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (304, N'30502', N'Cotabambas', 32)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (305, N'30503', N'Coyllurqui', 32)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (306, N'30504', N'Haquira', 32)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (307, N'30505', N'Mara', 32)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (308, N'30506', N'Challhuahuacho', 32)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (309, N'30601', N'Chincheros', 33)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (310, N'30602', N'Anco_Huallo', 33)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (311, N'30603', N'Cocharcas', 33)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (312, N'30604', N'Huaccana', 33)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (313, N'30605', N'Ocobamba', 33)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (314, N'30606', N'Ongoy', 33)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (315, N'30607', N'Uranmarca', 33)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (316, N'30608', N'Ranracancha', 33)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (317, N'30701', N'Chuquibambilla', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (318, N'30702', N'Curpahuasi', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (319, N'30703', N'Gamarra', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (320, N'30704', N'Huayllati', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (321, N'30705', N'Mamara', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (322, N'30706', N'Micaela Bastidas', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (323, N'30707', N'Pataypampa', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (324, N'30708', N'Progreso', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (325, N'30709', N'San Antonio', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (326, N'30710', N'Santa Rosa', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (327, N'30711', N'Turpay', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (328, N'30712', N'Vilcabamba', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (329, N'30713', N'Virundo', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (330, N'30714', N'Curasco', 34)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (331, N'40101', N'Arequipa', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (332, N'40102', N'Alto Selva Alegre', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (333, N'40103', N'Cayma', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (334, N'40104', N'Cerro Colorado', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (335, N'40105', N'Characato', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (336, N'40106', N'Chiguata', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (337, N'40107', N'Jacobo Hunter', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (338, N'40108', N'La Joya', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (339, N'40109', N'Mariano Melgar', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (340, N'40110', N'Miraflores', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (341, N'40111', N'Mollebaya', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (342, N'40112', N'Paucarpata', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (343, N'40113', N'Pocsi', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (344, N'40114', N'Polobaya', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (345, N'40115', N'Quequeña', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (346, N'40116', N'Sabandia', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (347, N'40117', N'Sachaca', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (348, N'40118', N'San Juan de Siguas', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (349, N'40119', N'San Juan de Tarucani', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (350, N'40120', N'Santa Isabel de Siguas', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (351, N'40121', N'Santa Rita de Siguas', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (352, N'40122', N'Socabaya', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (353, N'40123', N'Tiabaya', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (354, N'40124', N'Uchumayo', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (355, N'40125', N'Vitor', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (356, N'40126', N'Yanahuara', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (357, N'40127', N'Yarabamba', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (358, N'40128', N'Yura', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (359, N'40129', N'Jose Luis Bustamante y Rivero', 35)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (360, N'40201', N'Camana', 36)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (361, N'40202', N'Jose Maria Quimper', 36)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (362, N'40203', N'Mariano Nicolas Valcarcel', 36)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (363, N'40204', N'Mariscal Caceres', 36)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (364, N'40205', N'Nicolas de Pierola', 36)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (365, N'40206', N'Ocoña', 36)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (366, N'40207', N'Quilca', 36)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (367, N'40208', N'Samuel Pastor', 36)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (368, N'40301', N'Caraveli', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (369, N'40302', N'Acari', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (370, N'40303', N'Atico', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (371, N'40304', N'Atiquipa', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (372, N'40305', N'Bella Union', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (373, N'40306', N'Cahuacho', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (374, N'40307', N'Chala', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (375, N'40308', N'Chaparra', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (376, N'40309', N'Huanuhuanu', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (377, N'40310', N'Jaqui', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (378, N'40311', N'Lomas', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (379, N'40312', N'Quicacha', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (380, N'40313', N'Yauca', 37)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (381, N'40401', N'Aplao', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (382, N'40402', N'Andagua', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (383, N'40403', N'Ayo', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (384, N'40404', N'Chachas', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (385, N'40405', N'Chilcaymarca', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (386, N'40406', N'Choco', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (387, N'40407', N'Huancarqui', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (388, N'40408', N'Machaguay', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (389, N'40409', N'Orcopampa', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (390, N'40410', N'Pampacolca', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (391, N'40411', N'Tipan', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (392, N'40412', N'Uñon', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (393, N'40413', N'Uraca', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (394, N'40414', N'Viraco', 38)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (395, N'40501', N'Chivay', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (396, N'40502', N'Achoma', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (397, N'40503', N'Cabanaconde', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (398, N'40504', N'Callalli', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (399, N'40505', N'Caylloma', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (400, N'40506', N'Coporaque', 39)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (401, N'40507', N'Huambo', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (402, N'40508', N'Huanca', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (403, N'40509', N'Ichupampa', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (404, N'40510', N'Lari', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (405, N'40511', N'Lluta', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (406, N'40512', N'Maca', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (407, N'40513', N'Madrigal', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (408, N'40514', N'San Antonio de Chuca', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (409, N'40515', N'Sibayo', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (410, N'40516', N'Tapay', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (411, N'40517', N'Tisco', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (412, N'40518', N'Tuti', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (413, N'40519', N'Yanque', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (414, N'40520', N'Majes', 39)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (415, N'40601', N'Chuquibamba', 40)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (416, N'40602', N'Andaray', 40)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (417, N'40603', N'Cayarani', 40)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (418, N'40604', N'Chichas', 40)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (419, N'40605', N'Iray', 40)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (420, N'40606', N'Rio Grande', 40)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (421, N'40607', N'Salamanca', 40)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (422, N'40608', N'Yanaquihua', 40)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (423, N'40701', N'Mollendo', 41)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (424, N'40702', N'Cocachacra', 41)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (425, N'40703', N'Dean Valdivia', 41)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (426, N'40704', N'Islay', 41)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (427, N'40705', N'Mejia', 41)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (428, N'40706', N'Punta de Bombon', 41)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (429, N'40801', N'Cotahuasi', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (430, N'40802', N'Alca', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (431, N'40803', N'Charcana', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (432, N'40804', N'Huaynacotas', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (433, N'40805', N'Pampamarca', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (434, N'40806', N'Puyca', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (435, N'40807', N'Quechualla', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (436, N'40808', N'Sayla', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (437, N'40809', N'Tauria', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (438, N'40810', N'Tomepampa', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (439, N'40811', N'Toro', 42)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (440, N'50101', N'Ayacucho', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (441, N'50102', N'Acocro', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (442, N'50103', N'Acos Vinchos', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (443, N'50104', N'Carmen Alto', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (444, N'50105', N'Chiara', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (445, N'50106', N'Ocros', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (446, N'50107', N'Pacaycasa', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (447, N'50108', N'Quinua', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (448, N'50109', N'San Jose de Ticllas', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (449, N'50110', N'San Juan Bautista', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (450, N'50111', N'Santiago de Pischa', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (451, N'50112', N'Socos', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (452, N'50113', N'Tambillo', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (453, N'50114', N'Vinchos', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (454, N'50115', N'Jesus Nazareno', 43)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (455, N'50201', N'Cangallo', 44)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (456, N'50202', N'Chuschi', 44)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (457, N'50203', N'Los Morochucos', 44)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (458, N'50204', N'Maria Parado de Bellido', 44)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (459, N'50205', N'Paras', 44)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (460, N'50206', N'Totos', 44)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (461, N'50301', N'Sancos', 45)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (462, N'50302', N'Carapo', 45)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (463, N'50303', N'Sacsamarca', 45)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (464, N'50304', N'Santiago de Lucanamarca', 45)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (465, N'50401', N'Huanta', 46)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (466, N'50402', N'Ayahuanco', 46)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (467, N'50403', N'Huamanguilla', 46)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (468, N'50404', N'Iguain', 46)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (469, N'50405', N'Luricocha', 46)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (470, N'50406', N'Santillana', 46)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (471, N'50407', N'Sivia', 46)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (472, N'50408', N'Llochegua', 46)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (473, N'50501', N'San Miguel', 47)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (474, N'50502', N'Anco', 47)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (475, N'50503', N'Ayna', 47)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (476, N'50504', N'Chilcas', 47)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (477, N'50505', N'Chungui', 47)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (478, N'50506', N'Luis Carranza', 47)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (479, N'50507', N'Santa Rosa', 47)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (480, N'50508', N'Tambo', 47)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (481, N'50601', N'Puquio', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (482, N'50602', N'Aucara', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (483, N'50603', N'Cabana', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (484, N'50604', N'Carmen Salcedo', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (485, N'50605', N'Chaviña', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (486, N'50606', N'Chipao', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (487, N'50607', N'Huac-Huas', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (488, N'50608', N'Laramate', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (489, N'50609', N'Leoncio Prado', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (490, N'50610', N'Llauta', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (491, N'50611', N'Lucanas', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (492, N'50612', N'Ocaña', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (493, N'50613', N'Otoca', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (494, N'50614', N'Saisa', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (495, N'50615', N'San Cristobal', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (496, N'50616', N'San Juan', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (497, N'50617', N'San Pedro', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (498, N'50618', N'San Pedro de Palco', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (499, N'50619', N'Sancos', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (500, N'50620', N'Santa Ana de Huaycahuacho', 48)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (501, N'50621', N'Santa Lucia', 48)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (502, N'50701', N'Coracora', 49)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (503, N'50702', N'Chumpi', 49)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (504, N'50703', N'Coronel Castañeda', 49)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (505, N'50704', N'Pacapausa', 49)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (506, N'50705', N'Pullo', 49)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (507, N'50706', N'Puyusca', 49)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (508, N'50707', N'San Francisco de Ravacayco', 49)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (509, N'50708', N'Upahuacho', 49)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (510, N'50801', N'Pausa', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (511, N'50802', N'Colta', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (512, N'50803', N'Corculla', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (513, N'50804', N'Lampa', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (514, N'50805', N'Marcabamba', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (515, N'50806', N'Oyolo', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (516, N'50807', N'Pararca', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (517, N'50808', N'San Javier de Alpabamba', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (518, N'50809', N'San Jose de Ushua', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (519, N'50810', N'Sara Sara', 50)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (520, N'50901', N'Querobamba', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (521, N'50902', N'Belen', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (522, N'50903', N'Chalcos', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (523, N'50904', N'Chilcayoc', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (524, N'50905', N'Huacaña', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (525, N'50906', N'Morcolla', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (526, N'50907', N'Paico', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (527, N'50908', N'San Pedro de Larcay', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (528, N'50909', N'San Salvador de Quije', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (529, N'50910', N'Santiago de Paucaray', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (530, N'50911', N'Soras', 51)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (531, N'51001', N'Huancapi', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (532, N'51002', N'Alcamenca', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (533, N'51003', N'Apongo', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (534, N'51004', N'Asquipata', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (535, N'51005', N'Canaria', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (536, N'51006', N'Cayara', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (537, N'51007', N'Colca', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (538, N'51008', N'Huamanquiquia', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (539, N'51009', N'Huancaraylla', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (540, N'51010', N'Huaya', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (541, N'51011', N'Sarhua', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (542, N'51012', N'Vilcanchos', 52)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (543, N'51101', N'Vilcas Huaman', 53)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (544, N'51102', N'Accomarca', 53)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (545, N'51103', N'Carhuanca', 53)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (546, N'51104', N'Concepcion', 53)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (547, N'51105', N'Huambalpa', 53)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (548, N'51106', N'Independencia', 53)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (549, N'51107', N'Saurama', 53)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (550, N'51108', N'Vischongo', 53)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (551, N'60101', N'Cajamarca', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (552, N'60102', N'Asuncion', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (553, N'60103', N'Chetilla', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (554, N'60104', N'Cospan', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (555, N'60105', N'Encañada', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (556, N'60106', N'Jesus', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (557, N'60107', N'Llacanora', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (558, N'60108', N'Los Baños del Inca', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (559, N'60109', N'Magdalena', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (560, N'60110', N'Matara', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (561, N'60111', N'Namora', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (562, N'60112', N'San Juan', 54)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (563, N'60201', N'Cajabamba', 55)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (564, N'60202', N'Cachachi', 55)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (565, N'60203', N'Condebamba', 55)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (566, N'60204', N'Sitacocha', 55)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (567, N'60301', N'Celendin', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (568, N'60302', N'Chumuch', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (569, N'60303', N'Cortegana', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (570, N'60304', N'Huasmin', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (571, N'60305', N'Jorge Chavez', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (572, N'60306', N'Jose Galvez', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (573, N'60307', N'Miguel Iglesias', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (574, N'60308', N'Oxamarca', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (575, N'60309', N'Sorochuco', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (576, N'60310', N'Sucre', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (577, N'60311', N'Utco', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (578, N'60312', N'La Libertad de Pallan', 56)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (579, N'60401', N'Chota', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (580, N'60402', N'Anguia', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (581, N'60403', N'Chadin', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (582, N'60404', N'Chiguirip', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (583, N'60405', N'Chimban', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (584, N'60406', N'Choropampa', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (585, N'60407', N'Cochabamba', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (586, N'60408', N'Conchan', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (587, N'60409', N'Huambos', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (588, N'60410', N'Lajas', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (589, N'60411', N'Llama', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (590, N'60412', N'Miracosta', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (591, N'60413', N'Paccha', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (592, N'60414', N'Pion', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (593, N'60415', N'Querocoto', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (594, N'60416', N'San Juan de Licupis', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (595, N'60417', N'Tacabamba', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (596, N'60418', N'Tocmoche', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (597, N'60419', N'Chalamarca', 57)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (598, N'60501', N'Contumaza', 58)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (599, N'60502', N'Chilete', 58)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (600, N'60503', N'Cupisnique', 58)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (601, N'60504', N'Guzmango', 58)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (602, N'60505', N'San Benito', 58)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (603, N'60506', N'Santa Cruz de Toled', 58)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (604, N'60507', N'Tantarica', 58)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (605, N'60508', N'Yonan', 58)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (606, N'60601', N'Cutervo', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (607, N'60602', N'Callayuc', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (608, N'60603', N'Choros', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (609, N'60604', N'Cujillo', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (610, N'60605', N'La Ramada', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (611, N'60606', N'Pimpingos', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (612, N'60607', N'Querocotillo', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (613, N'60608', N'San Andres de Cutervo', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (614, N'60609', N'San Juan de Cutervo', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (615, N'60610', N'San Luis de Lucma', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (616, N'60611', N'Santa Cruz', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (617, N'60612', N'Santo Domingo de La Capilla', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (618, N'60613', N'Santo Tomas', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (619, N'60614', N'Socota', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (620, N'60615', N'Toribio Casanova', 59)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (621, N'60701', N'Bambamarca', 60)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (622, N'60702', N'Chugur', 60)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (623, N'60703', N'Hualgayoc', 60)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (624, N'60801', N'Jaen', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (625, N'60802', N'Bellavista', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (626, N'60803', N'Chontali', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (627, N'60804', N'Colasay', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (628, N'60805', N'Huabal', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (629, N'60806', N'Las Pirias', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (630, N'60807', N'Pomahuaca', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (631, N'60808', N'Pucara', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (632, N'60809', N'Sallique', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (633, N'60810', N'San Felipe', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (634, N'60811', N'San Jose del Alto', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (635, N'60812', N'Santa Rosa', 61)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (636, N'60901', N'San Ignacio', 62)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (637, N'60902', N'Chirinos', 62)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (638, N'60903', N'Huarango', 62)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (639, N'60904', N'La Coipa', 62)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (640, N'60905', N'Namballe', 62)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (641, N'60906', N'San Jose de Lourdes', 62)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (642, N'60907', N'Tabaconas', 62)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (643, N'61001', N'Pedro Galvez', 63)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (644, N'61002', N'Chancay', 63)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (645, N'61003', N'Eduardo Villanueva', 63)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (646, N'61004', N'Gregorio Pita', 63)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (647, N'61005', N'Ichocan', 63)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (648, N'61006', N'Jose Manuel Quiroz', 63)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (649, N'61007', N'Jose Sabogal', 63)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (650, N'61101', N'San Miguel', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (651, N'61102', N'Bolivar', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (652, N'61103', N'Calquis', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (653, N'61104', N'Catilluc', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (654, N'61105', N'El Prado', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (655, N'61106', N'La Florida', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (656, N'61107', N'Llapa', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (657, N'61108', N'Nanchoc', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (658, N'61109', N'Niepos', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (659, N'61110', N'San Gregorio', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (660, N'61111', N'San Silvestre de Cochan', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (661, N'61112', N'Tongod', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (662, N'61113', N'Union Agua Blanca', 64)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (663, N'61201', N'San Pablo', 65)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (664, N'61202', N'San Bernardino', 65)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (665, N'61203', N'San Luis', 65)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (666, N'61204', N'Tumbaden', 65)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (667, N'61301', N'Santa Cruz', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (668, N'61302', N'Andabamba', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (669, N'61303', N'Catache', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (670, N'61304', N'Chancaybaños', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (671, N'61305', N'La Esperanza', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (672, N'61306', N'Ninabamba', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (673, N'61307', N'Pulan', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (674, N'61308', N'Saucepampa', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (675, N'61309', N'Sexi', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (676, N'61310', N'Uticyacu', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (677, N'61311', N'Yauyucan', 66)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (678, N'70101', N'Callao', 67)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (679, N'70102', N'Bellavista', 67)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (680, N'70103', N'Carmen de La Legua', 67)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (681, N'70104', N'La Perla', 67)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (682, N'70105', N'La Punta', 67)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (683, N'70106', N'Ventanilla', 67)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (684, N'70107', N'Mi Peru', 67)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (685, N'80101', N'Cusco', 69)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (686, N'80102', N'Ccorca', 69)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (687, N'80103', N'Poroy', 69)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (688, N'80104', N'San Jeronimo', 69)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (689, N'80105', N'San Sebastian', 69)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (690, N'80106', N'Santiago', 69)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (691, N'80107', N'Saylla', 69)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (692, N'80108', N'Wanchaq', 69)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (693, N'80201', N'Acomayo', 70)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (694, N'80202', N'Acopia', 70)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (695, N'80203', N'Acos', 70)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (696, N'80204', N'Mosoc Llacta', 70)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (697, N'80205', N'Pomacanchi', 70)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (698, N'80206', N'Rondocan', 70)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (699, N'80207', N'Sangarara', 70)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (700, N'80301', N'Anta', 71)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (701, N'80302', N'Ancahuasi', 71)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (702, N'80303', N'Cachimayo', 71)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (703, N'80304', N'Chinchaypujio', 71)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (704, N'80305', N'Huarocondo', 71)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (705, N'80306', N'Limatambo', 71)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (706, N'80307', N'Mollepata', 71)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (707, N'80308', N'Pucyura', 71)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (708, N'80309', N'Zurite', 71)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (709, N'80401', N'Calca', 72)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (710, N'80402', N'Coya', 72)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (711, N'80403', N'Lamay', 72)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (712, N'80404', N'Lares', 72)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (713, N'80405', N'Pisac', 72)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (714, N'80406', N'San Salvador', 72)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (715, N'80407', N'Taray', 72)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (716, N'80408', N'Yanatile', 72)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (717, N'80501', N'Yanaoca', 73)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (718, N'80502', N'Checca', 73)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (719, N'80503', N'Kunturkanki', 73)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (720, N'80504', N'Langui', 73)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (721, N'80505', N'Layo', 73)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (722, N'80506', N'Pampamarca', 73)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (723, N'80507', N'Quehue', 73)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (724, N'80508', N'Tupac Amaru', 73)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (725, N'80601', N'Sicuani', 74)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (726, N'80602', N'Checacupe', 74)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (727, N'80603', N'Combapata', 74)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (728, N'80604', N'Marangani', 74)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (729, N'80605', N'Pitumarca', 74)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (730, N'80606', N'San Pablo', 74)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (731, N'80607', N'San Pedro', 74)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (732, N'80608', N'Tinta', 74)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (733, N'80701', N'Santo Tomas', 75)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (734, N'80702', N'Capacmarca', 75)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (735, N'80703', N'Chamaca', 75)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (736, N'80704', N'Colquemarca', 75)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (737, N'80705', N'Livitaca', 75)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (738, N'80706', N'Llusco', 75)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (739, N'80707', N'Quiñota', 75)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (740, N'80708', N'Velille', 75)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (741, N'80801', N'Espinar', 76)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (742, N'80802', N'Condoroma', 76)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (743, N'80803', N'Coporaque', 76)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (744, N'80804', N'Ocoruro', 76)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (745, N'80805', N'Pallpata', 76)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (746, N'80806', N'Pichigua', 76)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (747, N'80807', N'Suyckutambo', 76)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (748, N'80808', N'Alto Pichigua', 76)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (749, N'80901', N'Santa Ana', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (750, N'80902', N'Echarate', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (751, N'80903', N'Huayopata', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (752, N'80904', N'Maranura', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (753, N'80905', N'Ocobamba', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (754, N'80906', N'Quellouno', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (755, N'80907', N'Kimbiri', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (756, N'80908', N'Santa Teresa', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (757, N'80909', N'Vilcabamba', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (758, N'80910', N'Pichari', 77)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (759, N'81001', N'Paruro', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (760, N'81002', N'Accha', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (761, N'81003', N'Ccapi', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (762, N'81004', N'Colcha', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (763, N'81005', N'Huanoquite', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (764, N'81006', N'Omacha', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (765, N'81007', N'Paccaritambo', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (766, N'81008', N'Pillpinto', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (767, N'81009', N'Yaurisque', 78)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (768, N'81101', N'Paucartambo', 79)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (769, N'81102', N'Caicay', 79)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (770, N'81103', N'Challabamba', 79)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (771, N'81104', N'Colquepata', 79)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (772, N'81105', N'Huancarani', 79)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (773, N'81106', N'Kosñipata', 79)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (774, N'81201', N'Urcos', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (775, N'81202', N'Andahuaylillas', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (776, N'81203', N'Camanti', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (777, N'81204', N'Ccarhuayo', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (778, N'81205', N'Ccatca', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (779, N'81206', N'Cusipata', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (780, N'81207', N'Huaro', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (781, N'81208', N'Lucre', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (782, N'81209', N'Marcapata', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (783, N'81210', N'Ocongate', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (784, N'81211', N'Oropesa', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (785, N'81212', N'Quiquijana', 80)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (786, N'81301', N'Urubamba', 81)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (787, N'81302', N'Chinchero', 81)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (788, N'81303', N'Huayllabamba', 81)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (789, N'81304', N'Machupicchu', 81)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (790, N'81305', N'Maras', 81)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (791, N'81306', N'Ollantaytambo', 81)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (792, N'81307', N'Yucay', 81)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (793, N'90101', N'Huancavelica', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (794, N'90102', N'Acobambilla', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (795, N'90103', N'Acoria', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (796, N'90104', N'Conayca', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (797, N'90105', N'Cuenca', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (798, N'90106', N'Huachocolpa', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (799, N'90107', N'Huayllahuara', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (800, N'90108', N'Izcuchaca', 82)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (801, N'90109', N'Laria', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (802, N'90110', N'Manta', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (803, N'90111', N'Mariscal Caceres', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (804, N'90112', N'Moya', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (805, N'90113', N'Nuevo Occoro', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (806, N'90114', N'Palca', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (807, N'90115', N'Pilchaca', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (808, N'90116', N'Vilca', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (809, N'90117', N'Yauli', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (810, N'90118', N'Ascension', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (811, N'90119', N'Huando', 82)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (812, N'90201', N'Acobamba', 83)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (813, N'90202', N'Andabamba', 83)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (814, N'90203', N'Anta', 83)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (815, N'90204', N'Caja', 83)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (816, N'90205', N'Marcas', 83)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (817, N'90206', N'Paucara', 83)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (818, N'90207', N'Pomacocha', 83)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (819, N'90208', N'Rosario', 83)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (820, N'90301', N'Lircay', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (821, N'90302', N'Anchonga', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (822, N'90303', N'Callanmarca', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (823, N'90304', N'Ccochaccasa', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (824, N'90305', N'Chincho', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (825, N'90306', N'Congalla', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (826, N'90307', N'Huanca-Huanca', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (827, N'90308', N'Huayllay Grande', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (828, N'90309', N'Julcamarca', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (829, N'90310', N'San Antonio de Antaparco', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (830, N'90311', N'Santo Tomas de Pata', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (831, N'90312', N'Secclla', 84)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (832, N'90401', N'Castrovirreyna', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (833, N'90402', N'Arma', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (834, N'90403', N'Aurahua', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (835, N'90404', N'Capillas', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (836, N'90405', N'Chupamarca', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (837, N'90406', N'Cocas', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (838, N'90407', N'Huachos', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (839, N'90408', N'Huamatambo', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (840, N'90409', N'Mollepampa', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (841, N'90410', N'San Juan', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (842, N'90411', N'Santa Ana', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (843, N'90412', N'Tantara', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (844, N'90413', N'Ticrapo', 85)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (845, N'90501', N'Churcampa', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (846, N'90502', N'Anco', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (847, N'90503', N'Chinchihuasi', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (848, N'90504', N'El Carmen', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (849, N'90505', N'La Merced', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (850, N'90506', N'Locroja', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (851, N'90507', N'Paucarbamba', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (852, N'90508', N'San Miguel de Mayocc', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (853, N'90509', N'San Pedro de Coris', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (854, N'90510', N'Pachamarca', 86)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (855, N'90601', N'Huaytara', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (856, N'90602', N'Ayavi', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (857, N'90603', N'Cordova', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (858, N'90604', N'Huayacundo Arma', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (859, N'90605', N'Laramarca', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (860, N'90606', N'Ocoyo', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (861, N'90607', N'Pilpichaca', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (862, N'90608', N'Querco', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (863, N'90609', N'Quito-Arma', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (864, N'90610', N'San Antonio de Cusicancha', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (865, N'90611', N'San Francisco de Sangayaico', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (866, N'90612', N'San Isidro', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (867, N'90613', N'Santiago de Chocorvos', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (868, N'90614', N'Santiago de Quirahuara', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (869, N'90615', N'Santo Domingo de Capillas', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (870, N'90616', N'Tambo', 87)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (871, N'90701', N'Pampas', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (872, N'90702', N'Acostambo', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (873, N'90703', N'Acraquia', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (874, N'90704', N'Ahuaycha', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (875, N'90705', N'Colcabamba', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (876, N'90706', N'Daniel Hernandez', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (877, N'90707', N'Huachocolpa', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (878, N'90709', N'Huaribamba', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (879, N'90710', N'Ñahuimpuquio', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (880, N'90711', N'Pazos', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (881, N'90713', N'Quishuar', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (882, N'90714', N'Salcabamba', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (883, N'90715', N'Salcahuasi', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (884, N'90716', N'San Marcos de Rocchac', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (885, N'90717', N'Surcubamba', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (886, N'90718', N'Tintay Puncu', 88)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (887, N'100101', N'Huanuco', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (888, N'100102', N'Amarilis', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (889, N'100103', N'Chinchao', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (890, N'100104', N'Churubamba', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (891, N'100105', N'Margos', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (892, N'100106', N'Quisqui', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (893, N'100107', N'San Francisco de Cayran', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (894, N'100108', N'San Pedro de Chaulan', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (895, N'100109', N'Santa Maria del Valle', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (896, N'100110', N'Yarumayo', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (897, N'100111', N'Pillco Marca', 89)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (898, N'100201', N'Ambo', 90)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (899, N'100202', N'Cayna', 90)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (900, N'100203', N'Colpas', 90)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (901, N'100204', N'Conchamarca', 90)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (902, N'100205', N'Huacar', 90)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (903, N'100206', N'San Francisco', 90)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (904, N'100207', N'San Rafael', 90)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (905, N'100208', N'Tomay Kichwa', 90)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (906, N'100301', N'La Union', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (907, N'100307', N'Chuquis', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (908, N'100311', N'Marias', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (909, N'100313', N'Pachas', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (910, N'100316', N'Quivilla', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (911, N'100317', N'Ripan', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (912, N'100321', N'Shunqui', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (913, N'100322', N'Sillapata', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (914, N'100323', N'Yanas', 91)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (915, N'100401', N'Huacaybamba', 92)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (916, N'100402', N'Canchabamba', 92)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (917, N'100403', N'Cochabamba', 92)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (918, N'100404', N'Pinra', 92)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (919, N'100501', N'Llata', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (920, N'100502', N'Arancay', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (921, N'100503', N'Chavin de Pariarca', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (922, N'100504', N'Jacas Grande', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (923, N'100505', N'Jircan', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (924, N'100506', N'Miraflores', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (925, N'100507', N'Monzon', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (926, N'100508', N'Punchao', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (927, N'100509', N'Puños', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (928, N'100510', N'Singa', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (929, N'100511', N'Tantamayo', 93)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (930, N'100601', N'Rupa-Rupa', 94)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (931, N'100602', N'Daniel Alomias Robles', 94)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (932, N'100603', N'Hermilio Valdizan', 94)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (933, N'100604', N'Jose Crespo y Castillo', 94)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (934, N'100605', N'Luyando', 94)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (935, N'100606', N'Mariano Damaso Beraun', 94)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (936, N'100701', N'Huacrachuco', 95)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (937, N'100702', N'Cholon', 95)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (938, N'100703', N'San Buenaventura', 95)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (939, N'100801', N'Panao', 96)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (940, N'100802', N'Chaglla', 96)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (941, N'100803', N'Molino', 96)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (942, N'100804', N'Umari', 96)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (943, N'100901', N'Puerto Inca', 97)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (944, N'100902', N'Codo del Pozuzo', 97)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (945, N'100903', N'Honoria', 97)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (946, N'100904', N'Tournavista', 97)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (947, N'100905', N'Yuyapichis', 97)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (948, N'101001', N'Jesus', 98)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (949, N'101002', N'Baños', 98)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (950, N'101003', N'Jivia', 98)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (951, N'101004', N'Queropalca', 98)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (952, N'101005', N'Rondos', 98)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (953, N'101006', N'San Francisco de Asis', 98)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (954, N'101007', N'San Miguel de Cauri', 98)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (955, N'101101', N'Chavinillo', 99)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (956, N'101102', N'Cahuac', 99)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (957, N'101103', N'Chacabamba', 99)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (958, N'101104', N'Aparicio Pomares', 99)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (959, N'101105', N'Jacas Chico', 99)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (960, N'101106', N'Obas', 99)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (961, N'101107', N'Pampamarca', 99)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (962, N'101108', N'Choras', 99)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (963, N'110101', N'Ica', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (964, N'110102', N'La Tinguiña', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (965, N'110103', N'Los Aquijes', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (966, N'110104', N'Ocucaje', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (967, N'110105', N'Pachacutec', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (968, N'110106', N'Parcona', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (969, N'110107', N'Pueblo Nuevo', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (970, N'110108', N'Salas', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (971, N'110109', N'San Jose de los Molinos', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (972, N'110110', N'San Juan Bautista', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (973, N'110111', N'Santiago', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (974, N'110112', N'Subtanjalla', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (975, N'110113', N'Tate', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (976, N'110114', N'Yauca del Rosario', 100)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (977, N'110201', N'Chincha Alta', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (978, N'110202', N'Alto Laran', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (979, N'110203', N'Chavin', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (980, N'110204', N'Chincha Baja', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (981, N'110205', N'El Carmen', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (982, N'110206', N'Grocio Prado', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (983, N'110207', N'Pueblo Nuevo', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (984, N'110208', N'San Juan de Yanac', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (985, N'110209', N'San Pedro de Huacarpana', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (986, N'110210', N'Sunampe', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (987, N'110211', N'Tambo de Mora', 101)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (988, N'110301', N'Nazca', 102)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (989, N'110302', N'Changuillo', 102)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (990, N'110303', N'El Ingenio', 102)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (991, N'110304', N'Marcona', 102)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (992, N'110305', N'Vista Alegre', 102)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (993, N'110401', N'Palpa', 103)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (994, N'110402', N'Llipata', 103)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (995, N'110403', N'Rio Grande', 103)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (996, N'110404', N'Santa Cruz', 103)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (997, N'110405', N'Tibillo', 103)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (998, N'110501', N'Pisco', 104)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (999, N'110502', N'Huancano', 104)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1000, N'110503', N'Humay', 104)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1001, N'110504', N'Independencia', 104)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1002, N'110505', N'Paracas', 104)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1003, N'110506', N'San Andres', 104)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1004, N'110507', N'San Clemente', 104)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1005, N'110508', N'Tupac Amaru Inca', 104)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1006, N'120101', N'Huancayo', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1007, N'120104', N'Carhuacallanga', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1008, N'120105', N'Chacapampa', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1009, N'120106', N'Chicche', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1010, N'120107', N'Chilca', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1011, N'120108', N'Chongos Alto', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1012, N'120111', N'Chupuro', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1013, N'120112', N'Colca', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1014, N'120113', N'Cullhuas', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1015, N'120114', N'El Tambo', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1016, N'120116', N'Huacrapuquio', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1017, N'120117', N'Hualhuas', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1018, N'120119', N'Huancan', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1019, N'120120', N'Huasicancha', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1020, N'120121', N'Huayucachi', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1021, N'120122', N'Ingenio', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1022, N'120124', N'Pariahuanca', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1023, N'120125', N'Pilcomayo', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1024, N'120126', N'Pucara', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1025, N'120127', N'Quichuay', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1026, N'120128', N'Quilcas', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1027, N'120129', N'San Agustin', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1028, N'120130', N'San Jeronimo de Tunan', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1029, N'120132', N'Saño', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1030, N'120133', N'Sapallanga', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1031, N'120134', N'Sicaya', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1032, N'120135', N'Santo Domingo de Acobamba', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1033, N'120136', N'Viques', 105)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1034, N'120201', N'Concepcion', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1035, N'120202', N'Aco', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1036, N'120203', N'Andamarca', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1037, N'120204', N'Chambara', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1038, N'120205', N'Cochas', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1039, N'120206', N'Comas', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1040, N'120207', N'Heroinas Toledo', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1041, N'120208', N'Manzanares', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1042, N'120209', N'Mariscal Castilla', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1043, N'120210', N'Matahuasi', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1044, N'120211', N'Mito', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1045, N'120212', N'Nueve de Julio', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1046, N'120213', N'Orcotuna', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1047, N'120214', N'San Jose de Quero', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1048, N'120215', N'Santa Rosa de Ocopa', 106)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1049, N'120301', N'Chanchamayo', 107)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1050, N'120302', N'Perene', 107)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1051, N'120303', N'Pichanaqui', 107)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1052, N'120304', N'San Luis de Shuaro', 107)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1053, N'120305', N'San Ramon', 107)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1054, N'120306', N'Vitoc', 107)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1055, N'120401', N'Jauja', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1056, N'120402', N'Acolla', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1057, N'120403', N'Apata', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1058, N'120404', N'Ataura', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1059, N'120405', N'Canchayllo', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1060, N'120406', N'Curicaca', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1061, N'120407', N'El Mantaro', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1062, N'120408', N'Huamali', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1063, N'120409', N'Huaripampa', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1064, N'120410', N'Huertas', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1065, N'120411', N'Janjaillo', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1066, N'120412', N'Julcan', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1067, N'120413', N'Leonor Ordoñez', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1068, N'120414', N'Llocllapampa', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1069, N'120415', N'Marco', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1070, N'120416', N'Masma', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1071, N'120417', N'Masma Chicche', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1072, N'120418', N'Molinos', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1073, N'120419', N'Monobamba', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1074, N'120420', N'Muqui', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1075, N'120421', N'Muquiyauyo', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1076, N'120422', N'Paca', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1077, N'120423', N'Paccha', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1078, N'120424', N'Pancan', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1079, N'120425', N'Parco', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1080, N'120426', N'Pomacancha', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1081, N'120427', N'Ricran', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1082, N'120428', N'San Lorenzo', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1083, N'120429', N'San Pedro de Chunan', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1084, N'120430', N'Sausa', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1085, N'120431', N'Sincos', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1086, N'120432', N'Tunan Marca', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1087, N'120433', N'Yauli', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1088, N'120434', N'Yauyos', 108)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1089, N'120501', N'Junin', 109)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1090, N'120502', N'Carhuamayo', 109)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1091, N'120503', N'Ondores', 109)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1092, N'120504', N'Ulcumayo', 109)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1093, N'120601', N'Satipo', 110)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1094, N'120602', N'Coviriali', 110)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1095, N'120603', N'Llaylla', 110)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1096, N'120604', N'Mazamari', 110)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1097, N'120605', N'Pampa Hermosa', 110)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1098, N'120606', N'Pangoa', 110)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1099, N'120607', N'Rio Negro', 110)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1100, N'120608', N'Rio Tambo', 110)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1101, N'120701', N'Tarma', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1102, N'120702', N'Acobamba', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1103, N'120703', N'Huaricolca', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1104, N'120704', N'Huasahuasi', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1105, N'120705', N'La Union', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1106, N'120706', N'Palca', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1107, N'120707', N'Palcamayo', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1108, N'120708', N'San Pedro de Cajas', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1109, N'120709', N'Tapo', 111)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1110, N'120801', N'La Oroya', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1111, N'120802', N'Chacapalpa', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1112, N'120803', N'Huay-Huay', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1113, N'120804', N'Marcapomacocha', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1114, N'120805', N'Morococha', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1115, N'120806', N'Paccha', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1116, N'120807', N'Santa Barbara de Carhuacayan', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1117, N'120808', N'Santa Rosa de Sacco', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1118, N'120809', N'Suitucancha', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1119, N'120810', N'Yauli', 112)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1120, N'120901', N'Chupaca', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1121, N'120902', N'Ahuac', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1122, N'120903', N'Chongos Bajo', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1123, N'120904', N'Huachac', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1124, N'120905', N'Huamancaca Chico', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1125, N'120906', N'San Juan de Yscos', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1126, N'120907', N'San Juan de Jarpa', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1127, N'120908', N'Tres de Diciembre', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1128, N'120909', N'Yanacancha', 113)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1129, N'130101', N'Trujillo', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1130, N'130102', N'El Porvenir', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1131, N'130103', N'Florencia de Mora', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1132, N'130104', N'Huanchaco', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1133, N'130105', N'La Esperanza', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1134, N'130106', N'Laredo', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1135, N'130107', N'Moche', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1136, N'130108', N'Poroto', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1137, N'130109', N'Salaverry', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1138, N'130110', N'Simbal', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1139, N'130111', N'Victor Larco Herrera', 114)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1140, N'130201', N'Ascope', 115)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1141, N'130202', N'Chicama', 115)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1142, N'130203', N'Chocope', 115)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1143, N'130204', N'Magdalena de Cao', 115)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1144, N'130205', N'Paijan', 115)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1145, N'130206', N'Razuri', 115)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1146, N'130207', N'Santiago de Cao', 115)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1147, N'130208', N'Casa Grande', 115)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1148, N'130301', N'Bolivar', 116)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1149, N'130302', N'Bambamarca', 116)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1150, N'130303', N'Condormarca', 116)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1151, N'130304', N'Longotea', 116)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1152, N'130305', N'Uchumarca', 116)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1153, N'130306', N'Ucuncha', 116)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1154, N'130401', N'Chepen', 117)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1155, N'130402', N'Pacanga', 117)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1156, N'130403', N'Pueblo Nuevo', 117)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1157, N'130501', N'Julcan', 118)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1158, N'130502', N'Calamarca', 118)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1159, N'130503', N'Carabamba', 118)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1160, N'130504', N'Huaso', 118)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1161, N'130601', N'Otuzco', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1162, N'130602', N'Agallpampa', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1163, N'130604', N'Charat', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1164, N'130605', N'Huaranchal', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1165, N'130606', N'La Cuesta', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1166, N'130608', N'Mache', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1167, N'130610', N'Paranday', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1168, N'130611', N'Salpo', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1169, N'130613', N'Sinsicap', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1170, N'130614', N'Usquil', 119)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1171, N'130701', N'San Pedro de Lloc', 120)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1172, N'130702', N'Guadalupe', 120)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1173, N'130703', N'Jequetepeque', 120)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1174, N'130704', N'Pacasmayo', 120)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1175, N'130705', N'San Jose', 120)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1176, N'130801', N'Tayabamba', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1177, N'130802', N'Buldibuyo', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1178, N'130803', N'Chillia', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1179, N'130804', N'Huancaspata', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1180, N'130805', N'Huaylillas', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1181, N'130806', N'Huayo', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1182, N'130807', N'Ongon', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1183, N'130808', N'Parcoy', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1184, N'130809', N'Pataz', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1185, N'130810', N'Pias', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1186, N'130811', N'Santiago de Challas', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1187, N'130812', N'Taurija', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1188, N'130813', N'Urpay', 121)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1189, N'130901', N'Huamachuco', 122)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1190, N'130902', N'Chugay', 122)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1191, N'130903', N'Cochorco', 122)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1192, N'130904', N'Curgos', 122)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1193, N'130905', N'Marcabal', 122)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1194, N'130906', N'Sanagoran', 122)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1195, N'130907', N'Sarin', 122)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1196, N'130908', N'Sartimbamba', 122)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1197, N'131001', N'Santiago de Chuco', 123)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1198, N'131002', N'Angasmarca', 123)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1199, N'131003', N'Cachicadan', 123)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1200, N'131004', N'Mollebamba', 123)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1201, N'131005', N'Mollepata', 123)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1202, N'131006', N'Quiruvilca', 123)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1203, N'131007', N'Santa Cruz de Chuca', 123)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1204, N'131008', N'Sitabamba', 123)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1205, N'131101', N'Cascas', 124)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1206, N'131102', N'Lucma', 124)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1207, N'131103', N'Compin', 124)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1208, N'131104', N'Sayapullo', 124)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1209, N'131201', N'Viru', 125)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1210, N'131202', N'Chao', 125)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1211, N'131203', N'Guadalupito', 125)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1212, N'140101', N'Chiclayo', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1213, N'140102', N'Chongoyape', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1214, N'140103', N'Eten', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1215, N'140104', N'Eten Puerto', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1216, N'140105', N'Jose Leonardo Ortiz', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1217, N'140106', N'La Victoria', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1218, N'140107', N'Lagunas', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1219, N'140108', N'Monsefu', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1220, N'140109', N'Nueva Arica', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1221, N'140110', N'Oyotun', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1222, N'140111', N'Picsi', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1223, N'140112', N'Pimentel', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1224, N'140113', N'Reque', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1225, N'140114', N'Santa Rosa', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1226, N'140115', N'Saña', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1227, N'140116', N'Cayalti', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1228, N'140117', N'Patapo', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1229, N'140118', N'Pomalca', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1230, N'140119', N'Pucala', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1231, N'140120', N'Tuman', 126)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1232, N'140201', N'Ferreñafe', 127)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1233, N'140202', N'Cañaris', 127)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1234, N'140203', N'Incahuasi', 127)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1235, N'140204', N'Manuel Antonio Mesones Muro', 127)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1236, N'140205', N'Pitipo', 127)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1237, N'140206', N'Pueblo Nuevo', 127)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1238, N'140301', N'Lambayeque', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1239, N'140302', N'Chochope', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1240, N'140303', N'Illimo', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1241, N'140304', N'Jayanca', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1242, N'140305', N'Mochumi', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1243, N'140306', N'Morrope', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1244, N'140307', N'Motupe', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1245, N'140308', N'Olmos', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1246, N'140309', N'Pacora', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1247, N'140310', N'Salas', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1248, N'140311', N'San Jose', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1249, N'140312', N'Tucume', 128)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1250, N'150101', N'Lima', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1251, N'150102', N'Ancon', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1252, N'150103', N'Ate', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1253, N'150104', N'Barranco', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1254, N'150105', N'Breña', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1255, N'150106', N'Carabayllo', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1256, N'150107', N'Chaclacayo', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1257, N'150108', N'Chorrillos', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1258, N'150109', N'Cieneguilla', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1259, N'150110', N'Comas', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1260, N'150111', N'El Agustino', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1261, N'150112', N'Independencia', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1262, N'150113', N'Jesus Maria', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1263, N'150114', N'La Molina', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1264, N'150115', N'La Victoria', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1265, N'150116', N'Lince', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1266, N'150117', N'Los Olivos', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1267, N'150118', N'Lurigancho', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1268, N'150119', N'Lurin', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1269, N'150120', N'Magdalena del Mar', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1270, N'150121', N'Pueblo Libre', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1271, N'150122', N'Miraflores', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1272, N'150123', N'Pachacamac', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1273, N'150124', N'Pucusana', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1274, N'150125', N'Puente Piedra', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1275, N'150126', N'Punta Hermosa', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1276, N'150127', N'Punta Negra', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1277, N'150128', N'Rimac', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1278, N'150129', N'San Bartolo', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1279, N'150130', N'San Borja', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1280, N'150131', N'San Isidro', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1281, N'150132', N'San Juan de Lurigancho', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1282, N'150133', N'San Juan de Miraflores', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1283, N'150134', N'San Luis', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1284, N'150135', N'San Martin de Porres', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1285, N'150136', N'San Miguel', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1286, N'150137', N'Santa Anita', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1287, N'150138', N'Santa Maria del Mar', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1288, N'150139', N'Santa Rosa', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1289, N'150140', N'Santiago de Surco', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1290, N'150141', N'Surquillo', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1291, N'150142', N'Villa El Salvador', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1292, N'150143', N'Villa Maria del Triunfo', 129)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1293, N'150201', N'Barranca', 130)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1294, N'150202', N'Paramonga', 130)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1295, N'150203', N'Pativilca', 130)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1296, N'150204', N'Supe', 130)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1297, N'150205', N'Supe Puerto', 131)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1298, N'150301', N'Cajatambo', 131)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1299, N'150302', N'Copa', 131)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1300, N'150303', N'Gorgor', 131)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1301, N'150304', N'Huancapon', 131)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1302, N'150305', N'Manas', 131)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1303, N'150401', N'Canta', 132)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1304, N'150402', N'Arahuay', 132)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1305, N'150403', N'Huamantanga', 132)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1306, N'150404', N'Huaros', 132)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1307, N'150405', N'Lachaqui', 132)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1308, N'150406', N'San Buenaventura', 132)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1309, N'150407', N'Santa Rosa de Quives', 132)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1310, N'150501', N'San Vicente de Cañete', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1311, N'150502', N'Asia', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1312, N'150503', N'Calango', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1313, N'150504', N'Cerro Azul', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1314, N'150505', N'Chilca', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1315, N'150506', N'Coayllo', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1316, N'150507', N'Imperial', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1317, N'150508', N'Lunahuana', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1318, N'150509', N'Mala', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1319, N'150510', N'Nuevo Imperial', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1320, N'150511', N'Pacaran', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1321, N'150512', N'Quilmana', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1322, N'150513', N'San Antonio', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1323, N'150514', N'San Luis', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1324, N'150515', N'Santa Cruz de Flores', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1325, N'150516', N'Zuñiga', 133)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1326, N'150601', N'Huaral', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1327, N'150602', N'Atavillos Alto', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1328, N'150603', N'Atavillos Bajo', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1329, N'150604', N'Aucallama', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1330, N'150605', N'Chancay', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1331, N'150606', N'Ihuari', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1332, N'150607', N'Lampian', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1333, N'150608', N'Pacaraos', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1334, N'150609', N'San Miguel de Acos', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1335, N'150610', N'Santa Cruz de Andamarca', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1336, N'150611', N'Sumbilca', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1337, N'150612', N'Veintisiete de Noviembre', 134)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1338, N'150701', N'Matucana', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1339, N'150702', N'Antioquia', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1340, N'150703', N'Callahuanca', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1341, N'150704', N'Carampoma', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1342, N'150705', N'Chicla', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1343, N'150706', N'Cuenca', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1344, N'150707', N'Huachupampa', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1345, N'150708', N'Huanza', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1346, N'150709', N'Huarochiri', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1347, N'150710', N'Lahuaytambo', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1348, N'150711', N'Langa', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1349, N'150712', N'Laraos', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1350, N'150713', N'Mariatana', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1351, N'150714', N'Ricardo Palma', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1352, N'150715', N'San Andres de Tupicocha', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1353, N'150716', N'San Antonio', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1354, N'150717', N'San Bartolome', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1355, N'150718', N'San Damian', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1356, N'150719', N'San Juan de Iris', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1357, N'150720', N'San Juan de Tantaranche', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1358, N'150721', N'San Lorenzo de Quinti', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1359, N'150722', N'San Mateo', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1360, N'150723', N'San Mateo de Otao', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1361, N'150724', N'San Pedro de Casta', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1362, N'150725', N'San Pedro de Huancayre', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1363, N'150726', N'Sangallaya', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1364, N'150727', N'Santa Cruz de Cocachacra', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1365, N'150728', N'Santa Eulalia', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1366, N'150729', N'Santiago de Anchucaya', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1367, N'150730', N'Santiago de Tuna', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1368, N'150731', N'Santo Domingo de los Olleros', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1369, N'150732', N'Surco', 135)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1370, N'150801', N'Huacho', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1371, N'150802', N'Ambar', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1372, N'150803', N'Caleta de Carquin', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1373, N'150804', N'Checras', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1374, N'150805', N'Hualmay', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1375, N'150806', N'Huaura', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1376, N'150807', N'Leoncio Prado', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1377, N'150808', N'Paccho', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1378, N'150809', N'Santa Leonor', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1379, N'150810', N'Santa Maria', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1380, N'150811', N'Sayan', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1381, N'150812', N'Vegueta', 136)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1382, N'150901', N'Oyon', 137)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1383, N'150902', N'Andajes', 137)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1384, N'150903', N'Caujul', 137)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1385, N'150904', N'Cochamarca', 137)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1386, N'150905', N'Navan', 137)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1387, N'150906', N'Pachangara', 137)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1388, N'151001', N'Yauyos', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1389, N'151002', N'Alis', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1390, N'151003', N'Ayauca', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1391, N'151004', N'Ayaviri', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1392, N'151005', N'Azangaro', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1393, N'151006', N'Cacra', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1394, N'151007', N'Carania', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1395, N'151008', N'Catahuasi', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1396, N'151009', N'Chocos', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1397, N'151010', N'Cochas', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1398, N'151011', N'Colonia', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1399, N'151012', N'Hongos', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1400, N'151013', N'Huampara', 138)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1401, N'151014', N'Huancaya', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1402, N'151015', N'Huangascar', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1403, N'151016', N'Huantan', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1404, N'151017', N'Huañec', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1405, N'151018', N'Laraos', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1406, N'151019', N'Lincha', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1407, N'151020', N'Madean', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1408, N'151021', N'Miraflores', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1409, N'151022', N'Omas', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1410, N'151023', N'Putinza', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1411, N'151024', N'Quinches', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1412, N'151025', N'Quinocay', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1413, N'151026', N'San Joaquin', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1414, N'151027', N'San Pedro de Pilas', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1415, N'151028', N'Tanta', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1416, N'151029', N'Tauripampa', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1417, N'151030', N'Tomas', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1418, N'151031', N'Tupe', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1419, N'151032', N'Viñac', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1420, N'151033', N'Vitis', 138)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1421, N'160101', N'Iquitos', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1422, N'160102', N'Alto Nanay', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1423, N'160103', N'Fernando Lores', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1424, N'160104', N'Indiana', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1425, N'160105', N'Las Amazonas', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1426, N'160106', N'Mazan', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1427, N'160107', N'Napo', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1428, N'160108', N'Punchana', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1429, N'160109', N'Putumayo', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1430, N'160110', N'Torres Causana', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1431, N'160112', N'Belen', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1432, N'160113', N'San Juan Bautista', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1433, N'160114', N'Teniente Manuel Clavero', 139)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1434, N'160201', N'Yurimaguas', 140)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1435, N'160202', N'Balsapuerto', 140)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1436, N'160205', N'Jeberos', 140)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1437, N'160206', N'Lagunas', 140)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1438, N'160210', N'Santa Cruz', 140)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1439, N'160211', N'Teniente Cesar Lopez Rojas', 140)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1440, N'160301', N'Nauta', 141)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1441, N'160302', N'Parinari', 141)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1442, N'160303', N'Tigre', 141)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1443, N'160304', N'Trompeteros', 141)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1444, N'160305', N'Urarinas', 141)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1445, N'160401', N'Ramon Castilla', 142)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1446, N'160402', N'Pebas', 142)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1447, N'160403', N'Yavari', 142)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1448, N'160404', N'San Pablo', 142)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1449, N'160501', N'Requena', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1450, N'160502', N'Alto Tapiche', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1451, N'160503', N'Capelo', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1452, N'160504', N'Emilio San Martin', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1453, N'160505', N'Maquia', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1454, N'160506', N'Puinahua', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1455, N'160507', N'Saquena', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1456, N'160508', N'Soplin', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1457, N'160509', N'Tapiche', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1458, N'160510', N'Jenaro Herrera', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1459, N'160511', N'Yaquerana', 143)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1460, N'160601', N'Contamana', 144)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1461, N'160602', N'Inahuaya', 144)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1462, N'160603', N'Padre Marquez', 144)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1463, N'160604', N'Pampa Hermosa', 144)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1464, N'160605', N'Sarayacu', 144)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1465, N'160606', N'Vargas Guerra', 144)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1466, N'160701', N'Barranca', 145)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1467, N'160702', N'Cahuapanas', 145)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1468, N'160703', N'Manseriche', 145)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1469, N'160704', N'Morona', 145)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1470, N'160705', N'Pastaza', 145)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1471, N'160706', N'Andoas', 145)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1472, N'170101', N'Tambopata', 146)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1473, N'170102', N'Inambari', 146)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1474, N'170103', N'Las Piedras', 146)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1475, N'170104', N'Laberinto', 146)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1476, N'170201', N'Manu', 147)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1477, N'170202', N'Fitzcarrald', 147)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1478, N'170203', N'Madre de Dios', 147)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1479, N'170204', N'Huepetuhe', 147)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1480, N'170301', N'Iñapari', 148)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1481, N'170302', N'Iberia', 148)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1482, N'170303', N'Tahuamanu', 148)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1483, N'180101', N'Moquegua', 149)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1484, N'180102', N'Carumas', 149)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1485, N'180103', N'Cuchumbaya', 149)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1486, N'180104', N'Samegua', 149)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1487, N'180105', N'San Cristobal', 149)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1488, N'180106', N'Torata', 149)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1489, N'180201', N'Omate', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1490, N'180202', N'Chojata', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1491, N'180203', N'Coalaque', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1492, N'180204', N'Ichuña', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1493, N'180205', N'La Capilla', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1494, N'180206', N'Lloque', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1495, N'180207', N'Matalaque', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1496, N'180208', N'Puquina', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1497, N'180209', N'Quinistaquillas', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1498, N'180210', N'Ubinas', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1499, N'180211', N'Yunga', 150)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1500, N'180301', N'Ilo', 151)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1501, N'180302', N'El Algarrobal', 151)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1502, N'180303', N'Pacocha', 151)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1503, N'190101', N'Chaupimarca', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1504, N'190102', N'Huachon', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1505, N'190103', N'Huariaca', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1506, N'190104', N'Huayllay', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1507, N'190105', N'Ninacaca', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1508, N'190106', N'Pallanchacra', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1509, N'190107', N'Paucartambo', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1510, N'190108', N'San Francisco de Asis de Yarusyacan', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1511, N'190109', N'Simon Bolivar', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1512, N'190110', N'Ticlacayan', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1513, N'190111', N'Tinyahuarco', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1514, N'190112', N'Vicco', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1515, N'190113', N'Yanacancha', 152)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1516, N'190201', N'Yanahuanca', 153)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1517, N'190202', N'Chacayan', 153)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1518, N'190203', N'Goyllarisquizga', 153)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1519, N'190204', N'Paucar', 153)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1520, N'190205', N'San Pedro de Pillao', 153)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1521, N'190206', N'Santa Ana de Tusi', 153)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1522, N'190207', N'Tapuc', 153)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1523, N'190208', N'Vilcabamba', 153)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1524, N'190301', N'Oxapampa', 154)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1525, N'190302', N'Chontabamba', 154)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1526, N'190303', N'Huancabamba', 154)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1527, N'190304', N'Palcazu', 154)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1528, N'190305', N'Pozuzo', 154)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1529, N'190306', N'Puerto Bermudez', 154)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1530, N'190307', N'Villa Rica', 154)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1531, N'200101', N'Piura', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1532, N'200104', N'Castilla', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1533, N'200105', N'Catacaos', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1534, N'200107', N'Cura Mori', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1535, N'200108', N'El Tallan', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1536, N'200109', N'La Arena', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1537, N'200110', N'La Union', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1538, N'200111', N'Las Lomas', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1539, N'200114', N'Tambo Grande', 155)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1540, N'200201', N'Ayabaca', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1541, N'200202', N'Frias', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1542, N'200203', N'Jilili', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1543, N'200204', N'Lagunas', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1544, N'200205', N'Montero', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1545, N'200206', N'Pacaipampa', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1546, N'200207', N'Paimas', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1547, N'200208', N'Sapillica', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1548, N'200209', N'Sicchez', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1549, N'200210', N'Suyo', 156)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1550, N'200301', N'Huancabamba', 157)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1551, N'200302', N'Canchaque', 157)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1552, N'200303', N'El Carmen de La Frontera', 157)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1553, N'200304', N'Huarmaca', 157)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1554, N'200305', N'Lalaquiz', 157)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1555, N'200306', N'San Miguel de El Faique', 157)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1556, N'200307', N'Sondor', 157)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1557, N'200308', N'Sondorillo', 157)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1558, N'200401', N'Chulucanas', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1559, N'200402', N'Buenos Aires', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1560, N'200403', N'Chalaco', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1561, N'200404', N'La Matanza', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1562, N'200405', N'Morropon', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1563, N'200406', N'Salitral', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1564, N'200407', N'San Juan de Bigote', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1565, N'200408', N'Santa Catalina de Mossa', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1566, N'200409', N'Santo Domingo', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1567, N'200410', N'Yamango', 158)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1568, N'200501', N'Paita', 159)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1569, N'200502', N'Amotape', 159)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1570, N'200503', N'Arenal', 159)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1571, N'200504', N'Colan', 159)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1572, N'200505', N'La Huaca', 159)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1573, N'200506', N'Tamarindo', 159)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1574, N'200507', N'Vichayal', 159)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1575, N'200601', N'Sullana', 160)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1576, N'200602', N'Bellavista', 160)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1577, N'200603', N'Ignacio Escudero', 160)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1578, N'200604', N'Lancones', 160)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1579, N'200605', N'Marcavelica', 160)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1580, N'200606', N'Miguel Checa', 160)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1581, N'200607', N'Querecotillo', 160)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1582, N'200608', N'Salitral', 160)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1583, N'200701', N'Pariñas', 161)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1584, N'200702', N'El Alto', 161)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1585, N'200703', N'La Brea', 161)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1586, N'200704', N'Lobitos', 161)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1587, N'200705', N'Los Organos', 161)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1588, N'200706', N'Mancora', 161)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1589, N'200801', N'Sechura', 162)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1590, N'200802', N'Bellavista de La Union', 162)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1591, N'200803', N'Bernal', 162)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1592, N'200804', N'Cristo Nos Valga', 162)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1593, N'200805', N'Vice', 162)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1594, N'200806', N'Rinconada Llicuar', 162)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1595, N'210101', N'Puno', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1596, N'210102', N'Acora', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1597, N'210103', N'Amantani', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1598, N'210104', N'Atuncolla', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1599, N'210105', N'Capachica', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1600, N'210106', N'Chucuito', 163)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1601, N'210107', N'Coata', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1602, N'210108', N'Huata', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1603, N'210109', N'Mañazo', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1604, N'210110', N'Paucarcolla', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1605, N'210111', N'Pichacani', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1606, N'210112', N'Plateria', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1607, N'210113', N'San Antonio', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1608, N'210114', N'Tiquillaca', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1609, N'210115', N'Vilque', 163)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1610, N'210201', N'Azangaro', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1611, N'210202', N'Achaya', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1612, N'210203', N'Arapa', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1613, N'210204', N'Asillo', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1614, N'210205', N'Caminaca', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1615, N'210206', N'Chupa', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1616, N'210207', N'Jose Domingo Choquehuanca', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1617, N'210208', N'Muñani', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1618, N'210209', N'Potoni', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1619, N'210210', N'Saman', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1620, N'210211', N'San Anton', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1621, N'210212', N'San Jose', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1622, N'210213', N'San Juan de Salinas', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1623, N'210214', N'Santiago de Pupuja', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1624, N'210215', N'Tirapata', 164)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1625, N'210301', N'Macusani', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1626, N'210302', N'Ajoyani', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1627, N'210303', N'Ayapata', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1628, N'210304', N'Coasa', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1629, N'210305', N'Corani', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1630, N'210306', N'Crucero', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1631, N'210307', N'Ituata', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1632, N'210308', N'Ollachea', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1633, N'210309', N'San Gaban', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1634, N'210310', N'Usicayos', 165)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1635, N'210401', N'Juli', 166)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1636, N'210402', N'Desaguadero', 166)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1637, N'210403', N'Huacullani', 166)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1638, N'210404', N'Kelluyo', 166)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1639, N'210405', N'Pisacoma', 166)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1640, N'210406', N'Pomata', 166)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1641, N'210407', N'Zepita', 166)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1642, N'210501', N'Ilave', 167)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1643, N'210502', N'Capazo', 167)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1644, N'210503', N'Pilcuyo', 167)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1645, N'210504', N'Santa Rosa', 167)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1646, N'210505', N'Conduriri', 167)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1647, N'210601', N'Huancane', 168)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1648, N'210602', N'Cojata', 168)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1649, N'210603', N'Huatasani', 168)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1650, N'210604', N'Inchupalla', 168)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1651, N'210605', N'Pusi', 168)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1652, N'210606', N'Rosaspata', 168)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1653, N'210607', N'Taraco', 168)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1654, N'210608', N'Vilque Chico', 168)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1655, N'210701', N'Lampa', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1656, N'210702', N'Cabanilla', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1657, N'210703', N'Calapuja', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1658, N'210704', N'Nicasio', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1659, N'210705', N'Ocuviri', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1660, N'210706', N'Palca', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1661, N'210707', N'Paratia', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1662, N'210708', N'Pucara', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1663, N'210709', N'Santa Lucia', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1664, N'210710', N'Vilavila', 169)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1665, N'210801', N'Ayaviri', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1666, N'210802', N'Antauta', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1667, N'210803', N'Cupi', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1668, N'210804', N'Llalli', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1669, N'210805', N'Macari', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1670, N'210806', N'Nuñoa', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1671, N'210807', N'Orurillo', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1672, N'210808', N'Santa Rosa', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1673, N'210809', N'Umachiri', 170)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1674, N'210901', N'Moho', 171)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1675, N'210902', N'Conima', 171)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1676, N'210903', N'Huayrapata', 171)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1677, N'210904', N'Tilali', 171)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1678, N'211001', N'Putina', 172)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1679, N'211002', N'Ananea', 172)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1680, N'211003', N'Pedro Vilca Apaza', 172)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1681, N'211004', N'Quilcapuncu', 172)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1682, N'211005', N'Sina', 172)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1683, N'211101', N'Juliaca', 173)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1684, N'211102', N'Cabana', 173)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1685, N'211103', N'Cabanillas', 173)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1686, N'211104', N'Caracoto', 173)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1687, N'211201', N'Sandia', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1688, N'211202', N'Cuyocuyo', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1689, N'211203', N'Limbani', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1690, N'211204', N'Patambuco', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1691, N'211205', N'Phara', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1692, N'211206', N'Quiaca', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1693, N'211207', N'San Juan del Oro', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1694, N'211208', N'Yanahuaya', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1695, N'211209', N'Alto Inambari', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1696, N'211210', N'San Pedro de Putina Punco', 174)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1697, N'211301', N'Yunguyo', 175)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1698, N'211302', N'Anapia', 175)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1699, N'211303', N'Copani', 175)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1700, N'211304', N'Cuturapi', 175)
GO
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1701, N'211305', N'Ollaraya', 175)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1702, N'211306', N'Tinicachi', 175)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1703, N'211307', N'Unicachi', 175)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1704, N'220101', N'Moyobamba', 176)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1705, N'220102', N'Calzada', 176)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1706, N'220103', N'Habana', 176)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1707, N'220104', N'Jepelacio', 176)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1708, N'220105', N'Soritor', 176)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1709, N'220106', N'Yantalo', 176)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1710, N'220201', N'Bellavista', 177)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1711, N'220202', N'Alto Biavo', 177)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1712, N'220203', N'Bajo Biavo', 177)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1713, N'220204', N'Huallaga', 177)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1714, N'220205', N'San Pablo', 177)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1715, N'220206', N'San Rafael', 177)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1716, N'220301', N'San Jose de Sisa', 178)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1717, N'220302', N'Agua Blanca', 178)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1718, N'220303', N'San Martin', 178)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1719, N'220304', N'Santa Rosa', 178)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1720, N'220305', N'Shatoja', 178)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1721, N'220401', N'Saposoa', 179)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1722, N'220402', N'Alto Saposoa', 179)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1723, N'220403', N'El Eslabon', 179)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1724, N'220404', N'Piscoyacu', 179)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1725, N'220405', N'Sacanche', 179)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1726, N'220406', N'Tingo de Saposoa', 179)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1727, N'220501', N'Lamas', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1728, N'220502', N'Alonso de Alvarado', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1729, N'220503', N'Barranquita', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1730, N'220504', N'Caynarachi', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1731, N'220505', N'Cuñumbuqui', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1732, N'220506', N'Pinto Recodo', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1733, N'220507', N'Rumisapa', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1734, N'220508', N'San Roque de Cumbaza', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1735, N'220509', N'Shanao', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1736, N'220510', N'Tabalosos', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1737, N'220511', N'Zapatero', 180)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1738, N'220601', N'Juanjui', 181)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1739, N'220602', N'Campanilla', 181)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1740, N'220603', N'Huicungo', 181)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1741, N'220604', N'Pachiza', 181)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1742, N'220605', N'Pajarillo', 181)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1743, N'220701', N'Picota', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1744, N'220702', N'Buenos Aires', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1745, N'220703', N'Caspisapa', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1746, N'220704', N'Pilluana', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1747, N'220705', N'Pucacaca', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1748, N'220706', N'San Cristobal', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1749, N'220707', N'San Hilarion', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1750, N'220708', N'Shamboyacu', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1751, N'220709', N'Tingo de Ponasa', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1752, N'220710', N'Tres Unidos', 182)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1753, N'220801', N'Rioja', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1754, N'220802', N'Awajun', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1755, N'220803', N'Elias Soplin Vargas', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1756, N'220804', N'Nueva Cajamarca', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1757, N'220805', N'Pardo Miguel', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1758, N'220806', N'Posic', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1759, N'220807', N'San Fernando', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1760, N'220808', N'Yorongos', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1761, N'220809', N'Yuracyacu', 183)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1762, N'220901', N'Tarapoto', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1763, N'220902', N'Alberto Leveau', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1764, N'220903', N'Cacatachi', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1765, N'220904', N'Chazuta', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1766, N'220905', N'Chipurana', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1767, N'220906', N'El Porvenir', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1768, N'220907', N'Huimbayoc', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1769, N'220908', N'Juan Guerra', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1770, N'220909', N'La Banda de Shilcayo', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1771, N'220910', N'Morales', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1772, N'220911', N'Papaplaya', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1773, N'220912', N'San Antonio', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1774, N'220913', N'Sauce', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1775, N'220914', N'Shapaja', 184)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1776, N'221001', N'Tocache', 185)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1777, N'221002', N'Nuevo Progreso', 185)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1778, N'221003', N'Polvora', 185)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1779, N'221004', N'Shunte', 185)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1780, N'221005', N'Uchiza', 185)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1781, N'230101', N'Tacna', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1782, N'230102', N'Alto de La Alianza', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1783, N'230103', N'Calana', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1784, N'230104', N'Ciudad Nueva', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1785, N'230105', N'Inclan', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1786, N'230106', N'Pachia', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1787, N'230107', N'Palca', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1788, N'230108', N'Pocollay', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1789, N'230109', N'Sama', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1790, N'230110', N'Coronel Gregorio Albarracin Lanchipa', 186)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1791, N'230201', N'Candarave', 187)
INSERT [dbo].[DISTRITO] ([ID_DISTRITO], [COD_UBIGEO], [DS_DISTRITO], [ID_PROVINCIA]) VALUES (1792, N'230202', N'Cairani', 187)
SET IDENTITY_INSERT [dbo].[ID_TYPE_CLIENT] ON 

INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (1, N'0', N'DOC.TRIB.NO.DOM.SIN.RUC')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (2, N'1', N'Documento Nacional de Identidad')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (3, N'4', N'Carnet de extranjería')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (4, N'6', N'Registro Unico de Contribuyentes')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (5, N'7', N'Pasaporte')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (6, N'A', N'Cédula Diplomática de identidad')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (7, N'B', N'DOC.IDENT.PAIS.RESIDENCIA-NO.D')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (8, N'C', N'Tax Identification Number - TIN – Doc Trib PP.NN')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (9, N'D', N'Identification Number - IN – Doc Trib PP. JJ')
INSERT [dbo].[ID_TYPE_CLIENT] ([ID_TYPE], [COD_ID_TYPE], [DS_ID_TYPE]) VALUES (10, N'E', N'TAM- Tarjeta Andina de Migración ')
SET IDENTITY_INSERT [dbo].[ID_TYPE_CLIENT] OFF
SET IDENTITY_INSERT [dbo].[MODULES] ON 

INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(1 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, N'Dashboard', N'/dashboard', 1, N'mdi mdi-gauge', 1, CAST(0x9E400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(2 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), 1, N'Ventas', N'', 1, N'mdi mdi-currency-usd', 0, CAST(0x9E400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(3 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 1, N'Registro', N'', 1, N'mdi mdi-database-plus', 0, CAST(0x9E400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(4 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), 0, N'Compras', N'77', 1, N'mdi mdi-cart', 0, CAST(0x9E400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(5 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), 1, N'Reportes', N'', 1, N'mdi mdi-chart-line', 0, CAST(0x9E400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(6 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, N'Configuraciones', N'', 1, N'mdi mdi-settings', 1, CAST(0x9E400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(7 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(8 AS Numeric(18, 0)), 1, N'Tablas', N'', 1, N'mdi mdi-database', 0, CAST(0x9E400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(11 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), CAST(13 AS Numeric(18, 0)), 0, N'Comprobantes Enviados', N'**', 3, N'', 0, CAST(0xA6400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(21 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(19 AS Numeric(18, 0)), 1, N'NOMBRE', N'', 1, N'ICONO', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(22 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(20 AS Numeric(18, 0)), 1, N'PRUEBA1', N'', 1, N'PRUEBA1', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(23 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), 1, N'SUB VENTAS', N'', 2, N'', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(24 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), CAST(21 AS Numeric(18, 0)), 0, N'boletas', N'434343', 3, N'', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(25 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(22 AS Numeric(18, 0)), 0, N'PRUEBA2', N'1', 1, N'PRUEBA2', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(26 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(23 AS Numeric(18, 0)), 1, N'PRUEBA 3', N'', 1, N'ERER', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(27 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(24 AS Numeric(18, 0)), 1, N'prueba 4', N'', 1, N'4', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(28 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(25 AS Numeric(18, 0)), 1, N'prueba1', N'', 1, N'1', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(29 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), CAST(26 AS Numeric(18, 0)), 1, N'prueba', N'', 2, N'', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(30 AS Numeric(18, 0)), CAST(29 AS Numeric(18, 0)), CAST(27 AS Numeric(18, 0)), 0, N'prueba', N'1', 3, N'', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(31 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(28 AS Numeric(18, 0)), 0, N'prueba', N'22', 1, N'11', 0, CAST(0xA7400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(34 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(8 AS Numeric(18, 0)), 0, N'Modulos', N'/modules', 2, N'mdi mdi-menu', 0, CAST(0xAA400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(35 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(29 AS Numeric(18, 0)), 0, N'Roles de Usuario', N'/roles', 2, N'mdi mdi-account-multiple', 0, CAST(0xAA400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(36 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(30 AS Numeric(18, 0)), 1, N'Comprobantes', N'', 2, N'', 0, CAST(0xAA400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(37 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), CAST(31 AS Numeric(18, 0)), 0, N'Enviados', N'/users', 3, N'mdi mdi-gauge', 0, CAST(0xAA400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(38 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(32 AS Numeric(18, 0)), 1, N'Ventas', N'', 2, N'***', 0, CAST(0xAA400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(39 AS Numeric(18, 0)), CAST(38 AS Numeric(18, 0)), CAST(33 AS Numeric(18, 0)), 0, N'POS', N'/profile', 3, N'***', 0, CAST(0xAA400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(40 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(34 AS Numeric(18, 0)), 0, N'Usuarios', N'/users', 2, N'mdi mdi-account', 0, CAST(0xAA400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(41 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), 0, N'Permisología', N'/permissions', 2, N'mdi mdi-account-switch', 0, CAST(0xAC400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(42 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), 0, N'Enviados', N'/profile', 3, N'**', 0, CAST(0xAC400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(43 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, N'Tablas', N'', 2, N'mdi mdi-database', 0, CAST(0xAC400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(44 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), 1, N'Seguridad', N'', 2, N'mdi mdi-security', 1, CAST(0xAC400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(45 AS Numeric(18, 0)), CAST(44 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), 0, N'Modulos', N'/modules', 3, N'mdi mdi-menu', 1, CAST(0xAC400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(46 AS Numeric(18, 0)), CAST(44 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, N'Roles de Usuario', N'/roles', 3, N'mdi mdi-account-multiple', 1, CAST(0xAC400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(47 AS Numeric(18, 0)), CAST(44 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, N'Usuarios', N'/users', 3, N'mdi mdi-account', 1, CAST(0xAC400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(48 AS Numeric(18, 0)), CAST(44 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), 0, N'Permisología', N'/permissions', 3, N'mdi mdi-account-switch', 1, CAST(0xAC400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(49 AS Numeric(18, 0)), CAST(43 AS Numeric(18, 0)), CAST(10 AS Numeric(18, 0)), 0, N'Tipo de Documento', N'*', 3, N'*', 0, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(50 AS Numeric(18, 0)), CAST(43 AS Numeric(18, 0)), CAST(8 AS Numeric(18, 0)), 0, N'Monedas', N'*', 3, N'*', 0, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(51 AS Numeric(18, 0)), CAST(43 AS Numeric(18, 0)), CAST(7 AS Numeric(18, 0)), 0, N'Unidad de Medidas', N'*', 3, N'*', 0, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(52 AS Numeric(18, 0)), CAST(0 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), 0, N'Inicio', N'/home', 1, N'mdi mdi-home', 1, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(53 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), 0, N'Clientes', N'/clients', 2, N'mdi mdi-account-card-details', 0, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(54 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, N'Productos', N'*', 2, N'*', 0, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(55 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, N'Nuevo Comprobante', N'*', 2, N'*', 0, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(56 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(4 AS Numeric(18, 0)), 1, N'Comprobantes', N'', 2, N'*', 0, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(57 AS Numeric(18, 0)), CAST(56 AS Numeric(18, 0)), CAST(9 AS Numeric(18, 0)), 0, N'Enviados', N'*', 3, N'*', 0, CAST(0xAD400B00 AS Date))
INSERT [dbo].[MODULES] ([ID_MODULE], [ID_MODULE_SEC], [ORDEN], [FG_SUB_MENU], [DS_MODULE], [URL], [ID_TYPE_MENU], [ICON], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(58 AS Numeric(18, 0)), CAST(56 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), 0, N'No enviados', N'*', 3, N'*', 0, CAST(0xAD400B00 AS Date))
SET IDENTITY_INSERT [dbo].[MODULES] OFF
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (1, N'Chachapoyas', 1)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (2, N'Bagua', 1)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (3, N'Bongara', 1)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (4, N'Condorcanqui', 1)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (5, N'Luya', 1)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (6, N'Rodriguez de Mendoza', 1)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (7, N'Utcubamba', 1)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (8, N'Huaraz', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (9, N'Aija', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (10, N'Antonio Raymondi', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (11, N'Asuncion', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (12, N'Bolognesi', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (13, N'Carhuaz', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (14, N'Carlos Fermin Fitzca', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (15, N'Casma', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (16, N'Corongo', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (17, N'Huari', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (18, N'Huarmey', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (19, N'Huaylas', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (20, N'Mariscal Luzuriaga', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (21, N'Ocros', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (22, N'Pallasca', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (23, N'Pomabamba', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (24, N'Recuay', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (25, N'Santa', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (26, N'Sihuas', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (27, N'Yungay', 2)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (28, N'Abancay', 3)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (29, N'Andahuaylas', 3)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (30, N'Antabamba', 3)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (31, N'Aymaraes', 3)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (32, N'Cotabambas', 3)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (33, N'Chincheros', 3)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (34, N'Grau', 3)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (35, N'Arequipa', 4)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (36, N'Camana', 4)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (37, N'Caraveli', 4)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (38, N'Castilla', 4)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (39, N'Caylloma', 4)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (40, N'Condesuyos', 4)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (41, N'Islay', 4)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (42, N'La Union', 4)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (43, N'Huamanga', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (44, N'Cangallo', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (45, N'Huanca Sancos', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (46, N'Huanta', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (47, N'La Mar', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (48, N'Lucanas', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (49, N'Parinacochas', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (50, N'Paucar del Sara Sara', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (51, N'Sucre', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (52, N'Victor Fajardo', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (53, N'Vilcas Huaman', 5)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (54, N'Cajamarca', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (55, N'Cajabamba', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (56, N'Celendin', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (57, N'Chota', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (58, N'Contumaza', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (59, N'Cutervo', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (60, N'Hualgayoc', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (61, N'Jaen', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (62, N'San Ignacio', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (63, N'San Marcos', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (64, N'San Miguel', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (65, N'San Pablo', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (66, N'Santa Cruz', 6)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (67, N'Callao', 7)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (69, N'Cusco', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (70, N'Acomayo', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (71, N'Anta', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (72, N'Calca', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (73, N'Canas', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (74, N'Canchis', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (75, N'Chumbivilcas', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (76, N'Espinar', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (77, N'La Convencion', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (78, N'Paruro', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (79, N'Paucartambo', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (80, N'Quispicanchi', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (81, N'Urubamba', 8)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (82, N'Huancavelica', 10)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (83, N'Acobamba', 10)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (84, N'Angaraes', 10)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (85, N'Castrovirreyna', 10)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (86, N'Churcampa', 10)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (87, N'Huaytara', 10)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (88, N'Tayacaja', 10)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (89, N'Huanuco', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (90, N'Ambo', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (91, N'Dos de Mayo', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (92, N'Huacaybamba', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (93, N'Huamalies', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (94, N'Leoncio Prado', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (95, N'Marañon', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (96, N'Pachitea', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (97, N'Puerto Inca', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (98, N'Lauricocha', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (99, N'Yarowilca', 11)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (100, N'Ica', 12)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (101, N'Chincha', 12)
GO
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (102, N'Nazca', 12)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (103, N'Palpa', 12)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (104, N'Pisco', 12)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (105, N'Huancayo', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (106, N'Concepcion', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (107, N'Chanchamayo', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (108, N'Jauja', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (109, N'Junin', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (110, N'Satipo', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (111, N'Tarma', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (112, N'Yauli', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (113, N'Chupaca', 13)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (114, N'Trujillo', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (115, N'Ascope', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (116, N'Bolivar', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (117, N'Chepen', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (118, N'Julcan', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (119, N'Otuzco', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (120, N'Pacasmayo', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (121, N'Pataz', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (122, N'Sanchez Carrion', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (123, N'Santiago de Chuco', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (124, N'Gran Chimu', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (125, N'Viru', 14)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (126, N'Chiclayo', 15)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (127, N'Ferreñafe', 15)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (128, N'Lambayeque', 15)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (129, N'Lima', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (130, N'Barranca', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (131, N'Barranca', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (132, N'Canta', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (133, N'Cañete', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (134, N'Huaral', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (135, N'Huarochiri', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (136, N'Huaura', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (137, N'Oyon', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (138, N'Yauyos', 16)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (139, N'Maynas', 17)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (140, N'Alto Amazonas', 17)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (141, N'Loreto', 17)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (142, N'Mariscal Ramon Casti', 17)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (143, N'Requena', 17)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (144, N'Ucayali', 17)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (145, N'Datem del Marañon', 17)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (146, N'Tambopata', 18)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (147, N'Manu', 18)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (148, N'Tahuamanu', 18)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (149, N'Mariscal Nieto', 19)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (150, N'General Sanchez Cerr', 19)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (151, N'Ilo', 19)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (152, N'Pasco', 20)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (153, N'Daniel Alcides Carri', 20)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (154, N'Oxapampa', 20)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (155, N'Piura', 21)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (156, N'Ayabaca', 21)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (157, N'Huancabamba', 21)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (158, N'Morropon', 21)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (159, N'Paita', 21)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (160, N'Sullana', 21)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (161, N'Talara', 21)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (162, N'Sechura', 21)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (163, N'Puno', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (164, N'Azangaro', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (165, N'Carabaya', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (166, N'Chucuito', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (167, N'El Collao', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (168, N'Huancane', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (169, N'Lampa', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (170, N'Melgar', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (171, N'Moho', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (172, N'San Antonio de Putin', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (173, N'San Roman', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (174, N'Sandia', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (175, N'Yunguyo', 22)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (176, N'Moyobamba', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (177, N'Bellavista', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (178, N'El Dorado', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (179, N'Huallaga', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (180, N'Lamas', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (181, N'Mariscal Caceres', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (182, N'Picota', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (183, N'Rioja', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (184, N'San Martin', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (185, N'Tocache', 23)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (186, N'Tacna', 24)
INSERT [dbo].[PROVINCIA] ([ID_PROVINCIA], [DS_PROVINCIA], [ID_DEPARTAMENTO]) VALUES (187, N'Candarave', 24)
SET IDENTITY_INSERT [dbo].[ROLES_MODULES] ON 

INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(75 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100E0008D AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(76 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, CAST(0x0000AB5100E02C9C AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(77 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F673F6 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(78 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F675FA AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(79 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F67818 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(80 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F679D9 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(81 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F67C3A AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(82 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F6F99D AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(83 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F6FA7B AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(84 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F6FB4E AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(85 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F6FC0B AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(86 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F6FCCA AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(87 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F74F1C AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(88 AS Numeric(18, 0)), CAST(38 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F74F9B AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(89 AS Numeric(18, 0)), CAST(34 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F75033 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(90 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F750EC AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(91 AS Numeric(18, 0)), CAST(40 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F7517D AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(92 AS Numeric(18, 0)), CAST(41 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F7520B AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(93 AS Numeric(18, 0)), CAST(42 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F7A1DE AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(94 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F80079 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(95 AS Numeric(18, 0)), CAST(40 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F800FA AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(96 AS Numeric(18, 0)), CAST(41 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F80179 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(97 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F82CCA AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(98 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F8309A AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(99 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F83136 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(100 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F834FC AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(101 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F835B6 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(102 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F8388D AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(103 AS Numeric(18, 0)), CAST(38 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F85B6E AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(104 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F85D40 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(105 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F876CF AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(106 AS Numeric(18, 0)), CAST(38 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F878A4 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(107 AS Numeric(18, 0)), CAST(34 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F87DE5 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(108 AS Numeric(18, 0)), CAST(40 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F87F47 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(109 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F88679 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(110 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F886E6 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(111 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F8875A AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(112 AS Numeric(18, 0)), CAST(5 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F88807 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(113 AS Numeric(18, 0)), CAST(36 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F88F4C AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(114 AS Numeric(18, 0)), CAST(38 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F88FB6 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(115 AS Numeric(18, 0)), CAST(34 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F89065 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(116 AS Numeric(18, 0)), CAST(40 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F89A3A AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(117 AS Numeric(18, 0)), CAST(41 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F89B05 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(118 AS Numeric(18, 0)), CAST(35 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F8A644 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(119 AS Numeric(18, 0)), CAST(42 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F8AB36 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(120 AS Numeric(18, 0)), CAST(42 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F8AEDC AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(121 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), 1, CAST(0x0000AB5100F9268A AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(122 AS Numeric(18, 0)), CAST(42 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5100F986AF AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(123 AS Numeric(18, 0)), CAST(1 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB510102164C AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(124 AS Numeric(18, 0)), CAST(3 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5101021D3A AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(125 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5101028297 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(126 AS Numeric(18, 0)), CAST(43 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5101028670 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(127 AS Numeric(18, 0)), CAST(45 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB51010289E3 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(128 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 0, CAST(0x0000AB5101229F99 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(129 AS Numeric(18, 0)), CAST(6 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 1, CAST(0x0000AB510122A9A8 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(130 AS Numeric(18, 0)), CAST(44 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 1, CAST(0x0000AB510122B001 AS DateTime))
INSERT [dbo].[ROLES_MODULES] ([ID], [ID_MODULE], [ID_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(131 AS Numeric(18, 0)), CAST(45 AS Numeric(18, 0)), CAST(2 AS Numeric(18, 0)), 1, CAST(0x0000AB510122B3B0 AS DateTime))
SET IDENTITY_INSERT [dbo].[ROLES_MODULES] OFF
SET IDENTITY_INSERT [dbo].[TYPE_CLIENT] ON 

INSERT [dbo].[TYPE_CLIENT] ([ID_TYPE_CLIENT], [DS_TYPE_CLIENT]) VALUES (1, N'CLIENTE')
INSERT [dbo].[TYPE_CLIENT] ([ID_TYPE_CLIENT], [DS_TYPE_CLIENT]) VALUES (2, N'PROVEEDOR')
INSERT [dbo].[TYPE_CLIENT] ([ID_TYPE_CLIENT], [DS_TYPE_CLIENT]) VALUES (3, N'EMPRESA DE TRANSPORTE')
SET IDENTITY_INSERT [dbo].[TYPE_CLIENT] OFF
INSERT [dbo].[TYPE_MENU] ([ID_TYPE_MENU], [DS_TYPE_MENU]) VALUES (1, N'PRINCIPAL')
INSERT [dbo].[TYPE_MENU] ([ID_TYPE_MENU], [DS_TYPE_MENU]) VALUES (2, N'SUB MENU')
INSERT [dbo].[TYPE_MENU] ([ID_TYPE_MENU], [DS_TYPE_MENU]) VALUES (3, N'SUB MENU SECUNDARIO')
SET IDENTITY_INSERT [dbo].[USER_ROLES] ON 

INSERT [dbo].[USER_ROLES] ([ID_ROLE], [DS_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(1 AS Numeric(18, 0)), N'ADMIN_ROLE', 1, CAST(0x0000AB3F00C40A74 AS DateTime))
INSERT [dbo].[USER_ROLES] ([ID_ROLE], [DS_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(2 AS Numeric(18, 0)), N'USER_ROLE', 1, CAST(0x0000AB3F00C558E5 AS DateTime))
INSERT [dbo].[USER_ROLES] ([ID_ROLE], [DS_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(3 AS Numeric(18, 0)), N'SUPER_ROLE', 1, CAST(0x0000AB4F00A64682 AS DateTime))
INSERT [dbo].[USER_ROLES] ([ID_ROLE], [DS_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(4 AS Numeric(18, 0)), N'SUPER_ROLE', 0, CAST(0x0000AB4F00AAB923 AS DateTime))
INSERT [dbo].[USER_ROLES] ([ID_ROLE], [DS_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(5 AS Numeric(18, 0)), N'ADVANCED_ROLE', 0, CAST(0x0000AB4F00AB0824 AS DateTime))
INSERT [dbo].[USER_ROLES] ([ID_ROLE], [DS_ROLE], [FG_ACTIVE], [DT_REGISTRY]) VALUES (CAST(6 AS Numeric(18, 0)), N'ADVANCED_ROLE', 1, CAST(0x0000AB4F00C2F10F AS DateTime))
SET IDENTITY_INSERT [dbo].[USER_ROLES] OFF
SET IDENTITY_INSERT [dbo].[USERS] ON 

INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(103 AS Numeric(18, 0)), N'Luis Galicia', N'galicialuis@hotmail.es', N'$2a$10$Y1nXIanvHqXWWGxso7lgRu8mGoe7gCi3saBKM5PQw33uz9j6ecbdq', N'103-555.png', 0, CAST(1 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB41012A6CDD AS DateTime), N'929647791')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(108 AS Numeric(18, 0)), N'Luis Galicia', N'luisgalic@gmail.com', N'$2a$10$aS9wdDkNzv1Es2/t2i2qWObKB8sa3/aslWFZU124zE0UUnxd.mU0e', N'https://lh3.googleusercontent.com/a-/AAuE7mDGU4xf6fM903H1uOpC5DYHnAKYkBKJpD6B70qPcg=s96-c', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB4400F290E0 AS DateTime), NULL)
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(132 AS Numeric(18, 0)), N'Luis Galicia', N'luisgalic@gmail.com', N'$2a$10$dDZQcRibEdppqzSMiY3wmujSUtfOWUUbm.uF0VfqjwmN0sBSs1Fx6', N'https://lh3.googleusercontent.com/a-/AAuE7mDGU4xf6fM903H1uOpC5DYHnAKYkBKJpD6B70qPcg=s96-c', 1, CAST(1 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5000C88D1C AS DateTime), N'999555666')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(133 AS Numeric(18, 0)), N'LORENA DEL MORAL', N'lorenadelmoral06@gmail.com', N'$2a$10$mzJ7dc1FKu95YAAOo5679ePx2VSDKh2Lw2/laWqTDs9TwGMccDIp6', N'https://lh5.googleusercontent.com/-WNB-Nv2umEY/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rdAz5JkMYZwS-Pt0bJ71-2I_CpB1A/s96-c/photo.jpg', 1, CAST(1 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5000CD54B8 AS DateTime), N'888999444')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(134 AS Numeric(18, 0)), N'Luciano Galicia', N'luciano@gmail.com', N'$2a$10$auvI2M6gOBqejR.lE1AoG.dDFek/7PSKSgLkdWQFUFliI8mCh27c2', N'', 0, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5000CF032C AS DateTime), N'874596325')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(135 AS Numeric(18, 0)), N'Luciano Galicia', N'luciano@gmail.com', N'$2a$10$vwES3M8HjbLZa6Ldx064eueOFMWeTa10oLfhWhcM0uKPoSkvBU4tK', N'135-86.JPG', 0, CAST(1 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5000D040CE AS DateTime), N'929647791')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(136 AS Numeric(18, 0)), N'xml miner', N'xml.miner@gmail.com', N'$2a$10$H4b2jaMtA9M46kYNyqogXOh9Hx.ytL3KYIgSvNGBuhT2vyb4NpuCS', N'https://lh3.googleusercontent.com/-41xl4xXIApI/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rdNt7MuSCLG__2Zb6g27T9LpgAijw/s96-c/photo.jpg', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5000D0942E AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(137 AS Numeric(18, 0)), N'Luciano Galicia', N'luciano@gmail.com', N'$2a$10$fYkJQPE7qyLU0AguUEZMIOicPNfhzYx7bnPIqO8cV4BotmSg3cfY.', N'137-108.JPG', 0, CAST(3 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5000D75858 AS DateTime), N'987856987')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(138 AS Numeric(18, 0)), N'LORENA DEL MORAL', N'lorena_d06@hotmail.com', N'$2a$10$ZfQzOLWDQET3cin3.hG99.oNBIBm7xqfmBMDxxsooBdYWvKNEuRy2', N'138-493.JPG', 0, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5000D818FA AS DateTime), N'958624589')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(139 AS Numeric(18, 0)), N'Luis Galicia', N'luisgalic@gmail.com', N'$2a$10$ef1jY/BNzvMoofMZGIJpPed9r4afc/CDgVUBw8bogd0g3VhsTtz26', N'https://lh3.googleusercontent.com/a-/AAuE7mDGU4xf6fM903H1uOpC5DYHnAKYkBKJpD6B70qPcg=s96-c', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5000EE0FBD AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(140 AS Numeric(18, 0)), N'LORENA DEL MORAL', N'lorenadelmoral06@gmail.com', N'$2a$10$crR84VP0Kg2kASis1INF4ui3YpzFBO6lzY5hkyc2bItiDnLeGP.je', N'https://lh5.googleusercontent.com/-WNB-Nv2umEY/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rdAz5JkMYZwS-Pt0bJ71-2I_CpB1A/s96-c/photo.jpg', 1, CAST(6 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB510094BC12 AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(141 AS Numeric(18, 0)), N'xml miner', N'xml.miner@gmail.com', N'$2a$10$ed0I7/N1nWHpNNb0Yk5F7Oh9HDerhx4Z.7OftSQg7LP9iNFIf4T2W', N'https://lh3.googleusercontent.com/-41xl4xXIApI/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rdNt7MuSCLG__2Zb6g27T9LpgAijw/s96-c/photo.jpg', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB510094C479 AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(142 AS Numeric(18, 0)), N'EL ALTILLO RESTOBAR', N'elaltillorestobar@gmail.com', N'$2a$10$1/5qmJYtH4uRuyyvEzRh6uqjtQSsUWDfxFDbSPNJTMqBuBh0TKT/C', N'https://lh3.googleusercontent.com/-iDpfke_QOd8/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rea4e6wi8FHbiih0WY8x9KQQWd8Yg/s96-c/photo.jpg', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB510094CD18 AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(143 AS Numeric(18, 0)), N'Luis Galicia', N'luisgalic@gmail.com', N'$2a$10$xICmVT3jGJ80JCDE7i80dOJdCuSBZzPOrTzrXsGLAsKr7h96UqONa', N'https://lh3.googleusercontent.com/a-/AAuE7mDGU4xf6fM903H1uOpC5DYHnAKYkBKJpD6B70qPcg=s96-c', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5200E27A13 AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(144 AS Numeric(18, 0)), N'xml miner', N'xml.miner@gmail.com', N'$2a$10$F8TAjvSzwSQ3jL4j.k1cOOhpFAP6ElTRsYqg/Zn0tb45FcJRDroam', N'https://lh3.googleusercontent.com/-41xl4xXIApI/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rdNt7MuSCLG__2Zb6g27T9LpgAijw/s96-c/photo.jpg', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5200E282EC AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(145 AS Numeric(18, 0)), N'Luis Galicia', N'luisgalic@gmail.com', N'$2a$10$jFNmFt8pRlFFs1dZngPuRe3Q8xae2WMGmgo9fMGz2kWagrHoJk3Aa', N'https://lh3.googleusercontent.com/a-/AAuE7mDGU4xf6fM903H1uOpC5DYHnAKYkBKJpD6B70qPcg=s96-c', 1, CAST(1 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5700F97F34 AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(146 AS Numeric(18, 0)), N'xml miner', N'xml.miner@gmail.com', N'$2a$10$6Ug6BFJdLZx4RMtFUbVRpO4dosSkGkHCjYggLhaVc5KhRbr/.qPLW', N'https://lh3.googleusercontent.com/-41xl4xXIApI/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rdNt7MuSCLG__2Zb6g27T9LpgAijw/s96-c/photo.jpg', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB5700F9AA36 AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(147 AS Numeric(18, 0)), N'LORENA DEL MORAL', N'lorenadelmoral06@gmail.com', N'$2a$10$k3UA3q/vzcPlIoRN6E7VU..ysUH5UvJY0UnInB4Pb5stThXH/n3nK', N'https://lh5.googleusercontent.com/-WNB-Nv2umEY/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rdAz5JkMYZwS-Pt0bJ71-2I_CpB1A/s96-c/photo.jpg', 1, CAST(2 AS Numeric(18, 0)), 0, 0, CAST(0x0000AB57012841F9 AS DateTime), N'')
INSERT [dbo].[USERS] ([ID_USER], [NAME], [EMAIL], [PASSWORD], [IMAGE], [GOOGLE], [ID_ROLE], [FG_ACTIVE], [FG_LOCKED], [DT_REGISTRY], [PHONE]) VALUES (CAST(148 AS Numeric(18, 0)), N'Luis Galicia', N'luis.galicia@supervan.pe', N'$2a$10$Xo85uyG/lNBJgSm8e0NVouAcRPR4OEsQLQYUAE/n6x9Vimc7ZSQJe', N'', 0, CAST(1 AS Numeric(18, 0)), 1, 0, CAST(0x0000ABB800DE0CFD AS DateTime), N'')
SET IDENTITY_INSERT [dbo].[USERS] OFF
ALTER TABLE [dbo].[ADDRESS_CLIENT] ADD  CONSTRAINT [DF_ADDRESS_CLIENT_FG_ACTIVE]  DEFAULT ((1)) FOR [FG_ACTIVE]
GO
ALTER TABLE [dbo].[ADDRESS_CLIENT] ADD  CONSTRAINT [DF_ADDRESS_CLIENT_DT_REGISTRY]  DEFAULT (getdate()) FOR [DT_REGISTRY]
GO
ALTER TABLE [dbo].[ADDRESS_CLIENT] ADD  CONSTRAINT [DF_ADDRESS_CLIENT_ID_DISTRITO]  DEFAULT ((0)) FOR [ID_DISTRITO]
GO
ALTER TABLE [dbo].[ADDRESS_CLIENT] ADD  CONSTRAINT [DF_ADDRESS_CLIENT_FG_PRINCIPAL]  DEFAULT ((0)) FOR [FG_PRINCIPAL]
GO
ALTER TABLE [dbo].[ADDRESS_COMPANY] ADD  CONSTRAINT [DF_ADDRESS_COMPANY_FG_ACTIVE]  DEFAULT ((1)) FOR [FG_ACTIVE]
GO
ALTER TABLE [dbo].[ADDRESS_COMPANY] ADD  CONSTRAINT [DF_ADDRESS_COMPANY_DT_REGISTRY]  DEFAULT (getdate()) FOR [DT_REGISTRY]
GO
ALTER TABLE [dbo].[ADDRESS_COMPANY] ADD  CONSTRAINT [DF_ADDRESS_COMPANY_FG_PRINCIPAL]  DEFAULT ((0)) FOR [FG_PRINCIPAL]
GO
ALTER TABLE [dbo].[CLIENT] ADD  CONSTRAINT [DF_CLIENT_FG_ACTIVE]  DEFAULT ((1)) FOR [FG_ACTIVE]
GO
ALTER TABLE [dbo].[CLIENT] ADD  CONSTRAINT [DF_CLIENT_DT_REGISTRY]  DEFAULT (getdate()) FOR [DT_REGISTRY]
GO
ALTER TABLE [dbo].[COMPANY_USER] ADD  CONSTRAINT [DF_COMPANY_USER_FG_ACTIVE]  DEFAULT ((1)) FOR [FG_ACTIVE]
GO
ALTER TABLE [dbo].[COMPANY_USER] ADD  CONSTRAINT [DF_COMPANY_USER_DT_REGISTRY]  DEFAULT (getdate()) FOR [DT_REGISTRY]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES__ID_MODULE_SEC]  DEFAULT ((0)) FOR [ID_MODULE_SEC]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES_ORDEN]  DEFAULT ((0)) FOR [ORDEN]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES_FG_SUB_MENU]  DEFAULT ((0)) FOR [FG_SUB_MENU]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES_DS_MODULE]  DEFAULT ('') FOR [DS_MODULE]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES_URL]  DEFAULT ('') FOR [URL]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES_ID_TYPE_MENU]  DEFAULT ((0)) FOR [ID_TYPE_MENU]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES_ICON]  DEFAULT ('') FOR [ICON]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES__FG_ACTIVE]  DEFAULT ((1)) FOR [FG_ACTIVE]
GO
ALTER TABLE [dbo].[MODULES] ADD  CONSTRAINT [DF_MODULES__DT_REGISTRY]  DEFAULT (getdate()) FOR [DT_REGISTRY]
GO
ALTER TABLE [dbo].[ROLES_MODULES] ADD  CONSTRAINT [DF_ROLES_MENU_FG_ACTIVE]  DEFAULT ((1)) FOR [FG_ACTIVE]
GO
ALTER TABLE [dbo].[ROLES_MODULES] ADD  CONSTRAINT [DF_ROLES_MENU_DT_REGISTRY]  DEFAULT (getdate()) FOR [DT_REGISTRY]
GO
ALTER TABLE [dbo].[USER_ROLES] ADD  CONSTRAINT [DF_USER_ROLES_FG_ACTIVE]  DEFAULT ((1)) FOR [FG_ACTIVE]
GO
ALTER TABLE [dbo].[USER_ROLES] ADD  CONSTRAINT [DF_USER_ROLES_DT_REGISTRY]  DEFAULT (getdate()) FOR [DT_REGISTRY]
GO
ALTER TABLE [dbo].[USERS] ADD  CONSTRAINT [DF_USER_GOOGLE]  DEFAULT ((0)) FOR [GOOGLE]
GO
ALTER TABLE [dbo].[USERS] ADD  CONSTRAINT [DF_USER_ID_ROLE]  DEFAULT ((2)) FOR [ID_ROLE]
GO
ALTER TABLE [dbo].[USERS] ADD  CONSTRAINT [DF_USER_FG_ACTIVE]  DEFAULT ((1)) FOR [FG_ACTIVE]
GO
ALTER TABLE [dbo].[USERS] ADD  CONSTRAINT [DF_USER_FG_LOCKED]  DEFAULT ((0)) FOR [FG_LOCKED]
GO
ALTER TABLE [dbo].[USERS] ADD  CONSTRAINT [DF_USER_DT_REGISTRY]  DEFAULT (getdate()) FOR [DT_REGISTRY]
GO
ALTER TABLE [dbo].[ADDRESS_CLIENT]  WITH CHECK ADD  CONSTRAINT [FK_ADDRESS_CLIENT_CLIENT] FOREIGN KEY([ID_CLIENT])
REFERENCES [dbo].[CLIENT] ([ID_CLIENT])
GO
ALTER TABLE [dbo].[ADDRESS_CLIENT] CHECK CONSTRAINT [FK_ADDRESS_CLIENT_CLIENT]
GO
ALTER TABLE [dbo].[ADDRESS_CLIENT]  WITH CHECK ADD  CONSTRAINT [FK_ADDRESS_CLIENT_DISTRITO] FOREIGN KEY([ID_DISTRITO])
REFERENCES [dbo].[DISTRITO] ([ID_DISTRITO])
GO
ALTER TABLE [dbo].[ADDRESS_CLIENT] CHECK CONSTRAINT [FK_ADDRESS_CLIENT_DISTRITO]
GO
ALTER TABLE [dbo].[ADDRESS_COMPANY]  WITH CHECK ADD  CONSTRAINT [FK_ADDRESS_COMPANY_COMPANY_USER] FOREIGN KEY([ID_COMPANY_USER])
REFERENCES [dbo].[COMPANY_USER] ([ID_COMPANY_USER])
GO
ALTER TABLE [dbo].[ADDRESS_COMPANY] CHECK CONSTRAINT [FK_ADDRESS_COMPANY_COMPANY_USER]
GO
ALTER TABLE [dbo].[ADDRESS_COMPANY]  WITH CHECK ADD  CONSTRAINT [FK_ADDRESS_COMPANY_DISTRITO] FOREIGN KEY([ID_DISTRITO])
REFERENCES [dbo].[DISTRITO] ([ID_DISTRITO])
GO
ALTER TABLE [dbo].[ADDRESS_COMPANY] CHECK CONSTRAINT [FK_ADDRESS_COMPANY_DISTRITO]
GO
ALTER TABLE [dbo].[CLIENT]  WITH CHECK ADD  CONSTRAINT [FK_CLIENT_ID_TYPE_CLIENT] FOREIGN KEY([ID_TYPE])
REFERENCES [dbo].[ID_TYPE_CLIENT] ([ID_TYPE])
GO
ALTER TABLE [dbo].[CLIENT] CHECK CONSTRAINT [FK_CLIENT_ID_TYPE_CLIENT]
GO
ALTER TABLE [dbo].[CLIENT]  WITH CHECK ADD  CONSTRAINT [FK_CLIENT_TYPE_CLIENT] FOREIGN KEY([ID_TYPE_CLIENT])
REFERENCES [dbo].[TYPE_CLIENT] ([ID_TYPE_CLIENT])
GO
ALTER TABLE [dbo].[CLIENT] CHECK CONSTRAINT [FK_CLIENT_TYPE_CLIENT]
GO
ALTER TABLE [dbo].[CLIENT]  WITH CHECK ADD  CONSTRAINT [FK_CLIENT_USERS] FOREIGN KEY([ID_USER])
REFERENCES [dbo].[USERS] ([ID_USER])
GO
ALTER TABLE [dbo].[CLIENT] CHECK CONSTRAINT [FK_CLIENT_USERS]
GO
ALTER TABLE [dbo].[COMPANY_USER]  WITH CHECK ADD  CONSTRAINT [FK_COMPANY_USER_USERS] FOREIGN KEY([ID_USER])
REFERENCES [dbo].[USERS] ([ID_USER])
GO
ALTER TABLE [dbo].[COMPANY_USER] CHECK CONSTRAINT [FK_COMPANY_USER_USERS]
GO
ALTER TABLE [dbo].[DISTRITO]  WITH CHECK ADD  CONSTRAINT [FK_DISTRITO_PROVINCIA] FOREIGN KEY([ID_PROVINCIA])
REFERENCES [dbo].[PROVINCIA] ([ID_PROVINCIA])
GO
ALTER TABLE [dbo].[DISTRITO] CHECK CONSTRAINT [FK_DISTRITO_PROVINCIA]
GO
ALTER TABLE [dbo].[MODULES]  WITH CHECK ADD  CONSTRAINT [FK_MODULES_TYPE_MENU] FOREIGN KEY([ID_TYPE_MENU])
REFERENCES [dbo].[TYPE_MENU] ([ID_TYPE_MENU])
GO
ALTER TABLE [dbo].[MODULES] CHECK CONSTRAINT [FK_MODULES_TYPE_MENU]
GO
ALTER TABLE [dbo].[PROVINCIA]  WITH CHECK ADD  CONSTRAINT [FK_PROVINCIA_DEPARTAMENTO] FOREIGN KEY([ID_DEPARTAMENTO])
REFERENCES [dbo].[DEPARTAMENTO] ([ID_DEPARTAMENTO])
GO
ALTER TABLE [dbo].[PROVINCIA] CHECK CONSTRAINT [FK_PROVINCIA_DEPARTAMENTO]
GO
ALTER TABLE [dbo].[ROLES_MODULES]  WITH CHECK ADD  CONSTRAINT [FK_ROLES_MODULES_MODULES] FOREIGN KEY([ID_MODULE])
REFERENCES [dbo].[MODULES] ([ID_MODULE])
GO
ALTER TABLE [dbo].[ROLES_MODULES] CHECK CONSTRAINT [FK_ROLES_MODULES_MODULES]
GO
ALTER TABLE [dbo].[ROLES_MODULES]  WITH CHECK ADD  CONSTRAINT [FK_ROLES_MODULES_USER_ROLES] FOREIGN KEY([ID_ROLE])
REFERENCES [dbo].[USER_ROLES] ([ID_ROLE])
GO
ALTER TABLE [dbo].[ROLES_MODULES] CHECK CONSTRAINT [FK_ROLES_MODULES_USER_ROLES]
GO
ALTER TABLE [dbo].[USERS]  WITH CHECK ADD  CONSTRAINT [FK_USERS_USER_ROLES1] FOREIGN KEY([ID_ROLE])
REFERENCES [dbo].[USER_ROLES] ([ID_ROLE])
GO
ALTER TABLE [dbo].[USERS] CHECK CONSTRAINT [FK_USERS_USER_ROLES1]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ADDRESS_CLIENT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 232
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DISTRITO"
            Begin Extent = 
               Top = 6
               Left = 284
               Bottom = 136
               Right = 492
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PROVINCIA"
            Begin Extent = 
               Top = 6
               Left = 530
               Bottom = 119
               Right = 738
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DEPARTAMENTO"
            Begin Extent = 
               Top = 6
               Left = 776
               Bottom = 102
               Right = 984
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CLIENT"
            Begin Extent = 
               Top = 102
               Left = 776
               Bottom = 232
               Right = 984
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ADDRESS_CLIENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1605
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ADDRESS_CLIENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ADDRESS_CLIENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[49] 4[23] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DISTRITO"
            Begin Extent = 
               Top = 125
               Left = 302
               Bottom = 255
               Right = 510
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PROVINCIA"
            Begin Extent = 
               Top = 7
               Left = 517
               Bottom = 131
               Right = 725
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DEPARTAMENTO"
            Begin Extent = 
               Top = 7
               Left = 287
               Bottom = 114
               Right = 495
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "COMPANY_USER"
            Begin Extent = 
               Top = 84
               Left = 757
               Bottom = 238
               Right = 965
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ADDRESS_COMPANY"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 215
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 2115
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 15' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ADDRESS_COMPANY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'00
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3105
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ADDRESS_COMPANY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ADDRESS_COMPANY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[20] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MODULES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 217
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_MODULES"
            Begin Extent = 
               Top = 6
               Left = 332
               Bottom = 226
               Right = 540
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2880
         Width = 2010
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_MODULE_DELETE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_MODULE_DELETE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[19] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MODULES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 267
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TYPE_MENU"
            Begin Extent = 
               Top = 87
               Left = 277
               Bottom = 183
               Right = 485
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1785
         Width = 1500
         Width = 1500
         Width = 2055
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1800
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 9390
         Alias = 3000
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_MODULES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_MODULES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_MODULES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 226
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ROLES_MODULES"
            Begin Extent = 
               Top = 6
               Left = 284
               Bottom = 210
               Right = 492
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROLES_MODULES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROLES_MODULES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[46] 4[37] 2[1] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VIEW_ROLES_MODULES_ALL"
            Begin Extent = 
               Top = 6
               Left = 44
               Bottom = 278
               Right = 431
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VIEW_ROLES_MODULES"
            Begin Extent = 
               Top = 7
               Left = 649
               Bottom = 235
               Right = 857
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2625
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1530
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7890
         Alias = 2115
         Table = 2565
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROLES_MODULES_ACCESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROLES_MODULES_ACCESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[36] 4[4] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MODULES"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TYPE_MENU"
            Begin Extent = 
               Top = 6
               Left = 284
               Bottom = 102
               Right = 492
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "USER_ROLES"
            Begin Extent = 
               Top = 6
               Left = 530
               Bottom = 136
               Right = 738
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROLES_MODULES_ALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_ROLES_MODULES_ALL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "DISTRITO"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 190
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PROVINCIA"
            Begin Extent = 
               Top = 6
               Left = 284
               Bottom = 119
               Right = 492
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DEPARTAMENTO"
            Begin Extent = 
               Top = 6
               Left = 530
               Bottom = 102
               Right = 738
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 3105
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_UBIGEOS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_UBIGEOS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[38] 4[26] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "USERS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "USER_ROLES"
            Begin Extent = 
               Top = 6
               Left = 284
               Bottom = 164
               Right = 492
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 14
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 9585
         Alias = 2670
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USERS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VIEW_USERS'
GO
