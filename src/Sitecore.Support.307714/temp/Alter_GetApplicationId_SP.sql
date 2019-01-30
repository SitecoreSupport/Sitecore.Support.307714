SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetApplicationId]
  @name NVARCHAR(280),
  @id UNIQUEIDENTIFIER OUTPUT
AS
BEGIN

  SET NOCOUNT ON;

  SET @name = LOWER( @name );
  SET @id = NULL;

  SELECT
    @id = [Id]
  FROM
    [Applications]
  WHERE
    [Name] = @name;

  IF( @id IS NULL )
  BEGIN

    BEGIN TRANSACTION;

    SELECT
      @id = [Id]
    FROM
      [Applications] WITH (TABLOCKX)
    WHERE
      [Name] = @name;

    IF( @id IS NOT NULL )
    BEGIN
	  ROLLBACK TRANSACTION;
	  RETURN 0;
	END;

    SET @id = NEWID( );
            
    INSERT INTO
    [Applications]
    VALUES
    (
    @id,
    @name
    );

    COMMIT TRANSACTION;

  END;

  RETURN 0;

END;
GO