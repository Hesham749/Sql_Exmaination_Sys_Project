CREATE PROCEDURE sp_InsertExam @Name NVARCHAR(30) = NULL,
@Start DATETIME = NULL,
@Duration TINYINT = NULL,
@Count tinyint = NULL,
@TotalMark TINYINT = NULL,
@CrsID INT = NULL,
@InsID INT = NULL AS BEGIN BEGIN TRY BEGIN TRANSACTION;
INSERT INTO Exam(
        Name,
        StartTime,
        Duration,
        QuestionCount,
        TotalMark,
        CrsID,
        InsID
    )
VALUES (
        @Name,
        @Start,
        @Duration,
        @Count,
        @TotalMark,
        @CrsID,
        @InsID
    );
COMMIT TRANSACTION;
END TRY BEGIN CATCH ROLLBACK TRANSACTION;
PRINT 'Exam did not insert';
END CATCH
END;
select *
from Exam ----------------------------------------------------
    alter procedure sp_SelectExam @ExamID int = NULL as begin if @ExamID IS NULL begin
select ID,
    Name,
    StartTime,
    Duration,
    EndTime,
    QuestionCount,
    TotalMark,
    CrsID,
    InsID
from Exam;
end
else if exists (
    select 1
    from Exam
    where ID = @ExamID
) begin
select ID,
    Name,
    StartTime,
    Duration,
    EndTime,
    QuestionCount,
    TotalMark,
    CrsID,
    InsID
from Exam
where ID = @ExamID;
end
else begin print 'Exam ID does not exist.';
end
end;
GO -------------------------------------------------
    create PROCEDURE sp_updateExam @ID INT,
    @Name NVARCHAR(30) = NULL,
    @Start DATETIME = NULL,
    @Duration TINYINT = NULL,
    @Count tinyint = NULL,
    @TotalMark TINYINT = NULL,
    @CrsID INT = NULL,
    @InsID INT = NULL AS BEGIN -- Update the exam table
UPDATE exam
SET Name = ISNULL(@Name, Name),
    StartTime = ISNULL(@Start, StartTime),
    Duration = ISNULL(@Duration, Duration),
    QuestionCount = ISNULL(@Count, QuestionCount),
    TotalMark = ISNULL(@TotalMark, TotalMark),
    CrsID = ISNULL(@CrsID, CrsID),
    InsID = ISNULL(@InsID, InsID)
WHERE ID = @ID;
-- Check if any row was updated
IF @@ROWCOUNT = 0 BEGIN PRINT 'No row found with the specified ID.';
END
ELSE BEGIN PRINT 'Row updated successfully.';
END
END ---------------
EXEC sp_updateExam @ID = 6,
@Name = 'Final Exam',
@Start = '2023-12-20 10:00:00',
@Duration = 120,
@Count = 25,
@TotalMark = 150,
@CrsID = 2,
@InsID = 1;
select *
from exam ------------------------------------------------------------
    CREATE PROC sp_DeleteExam @ExamID int AS BEGIN BEGIN TRY BEGIN TRANSACTION;
DELETE Exam
WHERE ID = @ExamID COMMIT TRANSACTION;
END TRY BEGIN CATCH ROLLBACK TRANSACTION;
PRINT 'exam did not delete';
END CATCH
END;
GO