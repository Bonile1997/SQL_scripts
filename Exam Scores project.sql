/*QUESTIONS to address

What features or factors which affect the test results the most?
Are there interacting features that affect test scores?
*/
Clean the data

-- replacing “none” and “completed” which two texts describing test preparation in TestPrep column. Replacing them wit more consistent texts, that is, “not_prepared”, and “prepared”, respectively  

UPDATE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
SET TestPrep = replace(TestPrep, 'none', 'not_prepared')

UPDATE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
SET TestPrep = replace(TestPrep, 'completed', 'prepared')


--Replace "05-Oct" with "null" since “05-Oct” does not accurately describe the number of hours studied

UPDATE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
SET WklyStudyHours = Replace(WklyStudyHours, '05-Oct', 'null')



 --Creating Average column for average scores 

ALTER table [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
ADD AverageScores INT


--Calculating average scores

UPDATE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
SET AverageScores = (CONVERT(FLOAT, MathScore) + CONVERT(FLOAT, ReadingScore) + CONVERT(FLOAT, WritingScore))/3


--ADD Performance table to have passed or failed. 
  
ALTER TABLE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
ADD SportParticipation VARCHAR(15)

--Creating a qualifier to populate the Peformance column. A passed  will be given to students that have an average >= 50 and Fail for an average below 50

UPDATE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
SET Performance = case when AverageScores >=50 THEN 'Passed'
			   ELSE 'Failed' END 

--Adding a Sport participation column to assess how do learners who participate in sport fare against those who do not

ALTER TABLE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
ADD SportParticipation VARCHAR(15) 
-- create a grouping of two from three groupings to group together learners who participate and against those who do not.

UPDATE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
SET SportParticipation  = CASE WHEN PracticeSport = 'never' THEN 'not_participate'	
					ELSE 'Participate' END


-- ADD  a column to Analyse parents education. reduce the grouping in the column from multiple grouping to just two. 
-- The grouping will be either a parent has teritiary education or HighSchool education

ALTER TABLE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
ADD ParentEducation VARCHAR(20)

-- ADD  a column to Analyse parents education. reduce the grouping in the column from multiple grouping to just two. 
-- The grouping will be either a parent has teritiary education or HighSchool education

UPDATE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
SET ParentEducation = CASE  WHEN ParentEduc IS NULL THEN 'Null'
			WHEN ParentEduc = 'some high school' THEN 'High school edu'
			WHEN ParentEduc = 'high school' THEN 'High school edu'
			WHEN ParentEduc = 'bachelor''s degree' THEN 'Tertiary edu'
			WHEN ParentEduc = 'associate''s degree' THEN 'Tertiary edu'
			WHEN ParentEduc = 'some college' THEN 'Tertiary edu'
			WHEN ParentEduc = 'Master''s degree' THEN 'Tertiary edu'
			ELSE 'Null' END;

--Creating a column to add parent marital status in a more concise grouping that is easier for analysis

ALTER TABLE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
ADD Parent_Marital_Status varchar(15)


UPDATE [Project_exam_scores].[dbo].[Expanded_data_with_more_features]
SET Parent_Marital_Status = CASE WHEN ParentMaritalStatus = 'married' THEN 'Married'
			WHEN ParentMaritalStatus = 'single' THEN 'Not_married'
			WHEN ParentMaritalStatus = 'divorced' THEN 'Not_married'
			WHEN ParentMaritalStatus = 'widowed' THEN 'Not_married'
			ELSE 'NULL' END 
--Data cleaning complete

--Next stage is analysis


-- Calculating the average Mathscore for the entire class 

 SELECT AVG(CAST(MathScore AS DECIMAL(10, 2))) AS AverageMathScore
FROM [Project_exam_scores].[dbo].[Expanded_data_with_more_features]


-- calculate the percentage of pupils passed
SELECT (COUNT(CASE WHEN Performance = 'Passed' THEN 1 END) *100.0)/COUNT(*)
FROM [Project_exam_scores].[dbo].[Expanded_data_with_more_features]

--The pass rate is 89.31%
