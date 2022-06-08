--CREATE DATABASE M2

DROP DATABASE M2

GO

USE M2

CREATE TABLE PostGradUser(
id int primary key identity(1,1),
email varchar(50) not null,
password varchar(30) not null
)

CREATE TABLE Admin(
id int primary key foreign key references PostGradUser on delete cascade on update cascade
)

CREATE TABLE GucianStudent(
id int primary key foreign key references PostGradUser on delete cascade on update cascade,
firstName varchar(20),
lastName varchar(20),
type varchar(3),
faculty varchar(30),
address varchar(50),
GPA decimal(3,2),
undergradID int
)

CREATE TABLE NonGucianStudent(
id int primary key foreign key references PostGradUser on delete cascade on update cascade,
firstName varchar(20),
lastName varchar(20),type varchar(3),
faculty varchar(30),
address varchar(50),
GPA decimal(3,2),
)

CREATE TABLE GUCStudentPhoneNumber(
id int primary key foreign key references GucianStudent on delete cascade on update cascade,
phone int
)

CREATE TABLE NonGUCStudentPhoneNumber(
id int primary key foreign key references NonGucianStudent on delete cascade on update cascade,
phone int
)

CREATE TABLE Course(
id int primary key identity(1,1),
fees int,
creditHours int,
code varchar(10)
)

CREATE TABLE Supervisor(
id int primary key foreign key references PostGradUser,
name varchar(20),
faculty varchar(30)
);

CREATE TABLE Examiner(
id int primary key foreign key references PostGradUser on delete cascade on update cascade,
name varchar(20),
fieldOfWork varchar(100),
isNational BIT
)

CREATE TABLE Payment(
id int primary key identity(1,1),
amount decimal(7,2),
noOfInstallments int,
fundPercentage decimal(4,2)
)

CREATE TABLE Thesis(
serialNumber int primary key identity(1,1),
field varchar(20),
type varchar(3) not null,
title varchar(100) not null,
startDate date not null,
endDate date not null,
defenseDate date,
years as (year(endDate)-year(startDate)),
grade decimal(4,2),
payment_id int foreign key references payment on delete cascade on update cascade,
noOfExtensions int
)

CREATE TABLE Publication(id int primary key identity(1,1),
title varchar(100) not null,
dateOfPublication date,
place varchar(100),
accepted BIT,
host varchar(100)
);

Create table Defense (serialNumber int,
date datetime,
location varchar(15),
grade decimal(4,2),
primary key (serialNumber, date),
foreign key (serialNumber) references Thesis on delete cascade on update cascade
)

Create table GUCianProgressReport (
sid int foreign key references GUCianStudent on delete cascade on update cascade
, no int
, date datetime
, eval int
, state int
, description varchar(200)
, thesisSerialNumber int foreign key references Thesis on delete cascade on update cascade
, supid int foreign key references Supervisor
, primary key (sid, no) 
)

Create table NonGUCianProgressReport (sid int foreign key references NonGUCianStudent on delete
cascade on update cascade,
no int
, date datetime
, eval int
, state int
, description varchar(200)
, thesisSerialNumber int foreign key references Thesis on delete cascade on update cascade
, supid int foreign key references Supervisor
, primary key (sid, no) 
)

Create table Installment (date datetime,
paymentId int foreign key references Payment on delete cascade on update cascade
, amount decimal(8,2)
, done bit
, primary key (date, paymentId)
)

Create table NonGucianStudentPayForCourse(sid int foreign key references NonGucianStudent on
delete cascade on update cascade,
paymentNo int foreign key references Payment on delete cascade on update cascade,
cid int foreign key references Course on delete cascade on update cascade,
primary key (sid, paymentNo, cid))
Create table NonGucianStudentTakeCourse (sid int foreign key references NonGUCianStudent on delete
cascade on update cascade
, cid int foreign key references Course on delete cascade on update cascade
, grade decimal (4,2)
, primary key (sid, cid) )Create table GUCianStudentRegisterThesis (sid int foreign key references GUCianStudent on delete
cascade on update cascade,
supid int foreign key references Supervisor
, serial_no int foreign key references Thesis on delete cascade on update cascade
, primary key(sid, supid, serial_no)
)

Create table NonGUCianStudentRegisterThesis (sid int foreign key references NonGUCianStudent on
delete cascade on update cascade,
supid int foreign key references Supervisor,
serial_no int foreign key references Thesis on delete cascade on update cascade ,
primary key (sid, supid, serial_no)
)

Create table ExaminerEvaluateDefense(date datetime,
serialNo int,
examinerId int foreign key references Examiner on delete cascade on update cascade,
comment varchar(300),
primary key(date, serialNo, examinerId),
foreign key (serialNo, date) references Defense (serialNumber, date) on delete cascade on update
cascade)
Create table ThesisHasPublication(serialNo int foreign key references Thesis on delete cascade on
update cascade,
pubid int foreign key references Publication on delete cascade on update cascade,
primary key(serialNo,pubid)
)







go 
create proc studentRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@faculty varchar(20),
@Gucian bit,
@email varchar(50),
@address varchar(50)
as
begin
insert into PostGradUser(email,password)
values(@email,@password)
declare @id int
SELECT @id=SCOPE_IDENTITY()
if(@Gucian=1)
insert into GucianStudent(id,firstName,lastName,faculty,address)
values(@id,@first_name,@last_name,@faculty,@address)
else
insert into NonGucianStudent(id,firstName,lastName,faculty,address)
values(@id,@first_name,@last_name,@faculty,@address)
end
go
create proc supervisorRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@faculty varchar(20),
@email varchar(50)as
begin
insert into PostGradUser(email,password)
values(@email,@password)
declare @id int
SELECT @id=SCOPE_IDENTITY()
declare @name varchar(50)
set @name = CONCAT(@first_name,@last_name)
insert into Supervisor(id,name,faculty) values(@id,@name,@faculty)
end
go
Create proc userLogin
@id int,
@password varchar(20),
@success bit output
as
begin
if exists(
select ID,password
from PostGradUser
where id=@id and password=@password)
set @success =1
else
set @success=0
end
return @success
go
create proc addMobile
@ID varchar(20),
@mobile_number varchar(20)
as
begin
if @ID is not null and @mobile_number is not null
begin
--check Gucian student or not
if(exists(select * from GucianStudent where id=@ID))
insert into GUCStudentPhoneNumber values(@ID,@mobile_number)
if(exists(select * from NonGucianStudent where id=@ID))
insert into NonGUCStudentPhoneNumber values(@ID,@mobile_number)
end
end
go
CREATE Proc AdminListSup
As
Select u.id,u.email,u.password,s.name, s.faculty
from PostGradUser u inner join Supervisor s on u.id = s.id
go
CREATE Proc AdminViewSupervisorProfile
@supId int
As
Select u.id,u.email,u.password,s.name, s.faculty
from PostGradUser u inner join Supervisor s on u.id = s.id
WHERE @supId = s.id
go
CREATE Proc AdminViewAllTheses
As
Select
serialNumber,field,type,title,startDate,endDate,defenseDate,years,grade,payment_id,noOfExtensions
From Thesis
go
CREATE Proc AdminViewOnGoingTheses
@thesesCount int output
As
Select @thesesCount=Count(*)
From Thesis
where endDate > Convert(Date,CURRENT_TIMESTAMP)
go
CREATE Proc AdminViewStudentThesisBySupervisor
As
Select s.name,t.title,gs.firstName
From Thesis t inner join GUCianStudentRegisterThesis sr on t.serialNumber=sr.serial_no
inner join Supervisor s on s.id=sr.supid inner join GucianStudent gs on sr.sid=gs.id
where t.endDate > Convert(Date,CURRENT_TIMESTAMP)
union
Select s.name,t.title,gs.firstName
From Thesis t inner join NonGUCianStudentRegisterThesis sr on t.serialNumber=sr.serial_no
inner join Supervisor s on s.id=sr.supid inner join NonGucianStudent gs on sr.sid=gs.id
where t.endDate > Convert(Date,CURRENT_TIMESTAMP)
go
go
CREATE Proc AdminListNonGucianCourse
@courseID int
As
if(exists(select * from Course where id=@courseID))
Select ng.firstName,ng.lastName,c.code,n.grade
From NonGucianStudentTakeCourse n inner join Course c on n.cid=c.id inner join NonGucianStudent ng
on ng.id=n.sid
where n.cid=@courseID
go
CREATE Proc AdminUpdateExtension
@ThesisSerialNo int
As
if(exists(select * from Thesis where serialNumber=@ThesisSerialNo))
begin
declare @noOfExtensions int
select @noOfExtensions=noOfExtensions from Thesis where serialNumber=@ThesisSerialNo
update Thesis
set noOfExtensions=@noOfExtensions+1
where serialNumber=@ThesisSerialNo
end
go
CREATE Proc AdminIssueThesisPayment
@ThesisSerialNo int,@amount decimal,
@noOfInstallments int,
@fundPercentage decimal
As
if(exists(select * from Thesis where serialNumber=@ThesisSerialNo))
begin
insert into Payment(amount,noOfInstallments,fundPercentage)
values(@amount,@noOfInstallments,@fundPercentage)
declare @id int
SELECT @id=SCOPE_IDENTITY()
update Thesis
set payment_id=@id
where serialNumber=@ThesisSerialNo
end
go
CREATE Proc AdminViewStudentProfile
@sid int
As
if(exists(select * from GucianStudent where id=@sid))
Select u.id,u.email,u.password,s.firstName,s.lastName,s.type,s.faculty,s.address,s.address,s.GPA
from PostGradUser u inner join GucianStudent s on u.id=s.id
WHERE @sid = s.id
else if(exists(select * from NonGucianStudent where id=@sid))
Select u.id,u.email,u.password,s.firstName,s.lastName,s.type,s.faculty,s.address,s.address,s.GPA
from PostGradUser u inner join NonGucianStudent s on u.id=s.id
WHERE @sid = s.id
Go
Go
CREATE Proc AdminIssueInstallPayment
@paymentID int,
@InstallStartDate date
As
if(exists(select * from Payment where id=@paymentID))
	begin
	declare @numOfInst int
	select @numOfInst=noOfInstallments
	from Payment
	where id=@paymentID
	declare @payAmount int
	select @payAmount=amount
	from Payment
	where id=@paymentID
	DECLARE @Counter INT
	SET @Counter=1
	WHILE (@counter<=@numOfInst)
	BEGIN
	declare @instdate date
	set @instdate=@InstallStartDate
	declare @instAmount int
	set @instAmount=@payAmount/@numOfInst
	if(@counter=1)
	insert into
	Installment(date,paymentId,amount,done)values(@InstallStartDate,@paymentID,@instAmount,0)
else
	begin
	set @instdate=DATEADD(MM, 6, @instdate);
	insert into
	Installment(date,paymentId,amount,done)values(@instdate,@paymentID,@instAmount,0)
	end
	SET @counter=@counter+1
	END
	end
go
CREATE Proc AdminListAcceptPublication
As
select t.serialNumber,p.title
from ThesisHasPublication tp inner join Thesis t on tp.serialNo=t.serialNumber
inner join Publication p on p.id=tp.pubid
where p.accepted=1
go
CREATE Proc AddCourse
@courseCode varchar(10),
@creditHrs int,
@fees decimal
As
insert into Course values(@fees,@creditHrs,@courseCode)
go
CREATE Proc linkCourseStudent
@courseID int,
@studentID int
As
if(exists(select * from Course ) and exists(select * from NonGucianStudent where id=@studentID))
insert into NonGucianStudentTakeCourse(sid,cid,grade)values(@studentID,@courseID,null)
go
CREATE Proc addStudentCourseGrade
@courseID int,
@studentID int,
@grade decimal
As
if(exists(select * from NonGucianStudentTakeCourse where sid=@studentID and cid=@courseID))
update NonGucianStudentTakeCourse
set grade =@grade
where cid=@courseID and sid=@studentID
go
CREATE Proc ViewExamSupDefense
@defenseDate datetime
As
select s.serial_no,ee.date,e.name,sup.name
from ExaminerEvaluateDefense ee inner join examiner e on ee.examinerId=e.id
inner join GUCianStudentRegisterThesis s on ee.serialNo=s.serial_no
inner join Supervisor sup on sup.id=s.supid
go
CREATE Proc EvaluateProgressReport
@supervisorID int,
@thesisSerialNo int,
@progressReportNo int,
@evaluation int
As
if(exists(select * from Thesis where serialNumber=@thesisSerialNo ) and @evaluation in(0,1,2,3) )
begin
if(exists(select * from GUCianStudentRegisterThesis where serial_no=@thesisSerialNo and
supid=@supervisorID))
begin
declare @gucSid int
select @gucSid=sid
from GUCianStudentRegisterThesis where serial_no=@thesisSerialNo
update GUCianProgressReport
set eval=@evaluation
where sid=@gucSid and thesisSerialNumber=@thesisSerialNo and no=@progressReportNo
end
else if(exists(select * from NonGUCianStudentRegisterThesis where serial_no=@thesisSerialNo and
supid=@supervisorID))
begin
declare @nonGucSid int
select @nonGucSid=sid
from NonGUCianStudentRegisterThesis
where serial_no=@thesisSerialNo
update NonGUCianProgressReport
set eval=@evaluation
where sid=@nonGucSid and thesisSerialNumber=@thesisSerialNo and no=@progressReportNo
end
end
go
CREATE Proc ViewSupStudentsYears
@supervisorID int
As
if(exists(select * from Supervisor where id=@supervisorID))begin
select s.firstName,s.lastName,t.years
from GUCianStudentRegisterThesis sr inner join GucianStudent s on sr.sid=s.id
inner join Thesis t on t.serialNumber=sr.serial_no
union
select s.firstName,s.lastName,t.years
from NonGUCianStudentRegisterThesis sr inner join NonGucianStudent s on sr.sid=s.id
inner join Thesis t on t.serialNumber=sr.serial_no
end
go
CREATE Proc SupViewProfile
@supervisorID int
As
if(exists(select * from Supervisor where id=@supervisorID))
begin
select u.id,u.email,u.password,s.name,s.faculty
from PostGradUser u inner join Supervisor s on u.id=s.id
end
go
---------------------------------------
create proc UpdateSupProfile
@supervisorID int, @name varchar(20), @faculty varchar(20)
as
update Supervisor 
set name = @name, faculty = @faculty
where id = @supervisorID

DROP PROC ViewAStudentPublications

go
create proc ViewAStudentPublications
@StudentID int
as
select P.*
from GUCianStudentRegisterThesis GUC
inner join Thesis T
on GUC.serial_no = T.serialNumber
inner join ThesisHasPublication TP
on T.serialNumber = TP.serialNo
inner join Publication P
on P.id = TP.pubid
where GUC.sid = @StudentID
union all
select P.*
from NonGUCianStudentRegisterThesis NON
inner join Thesis T
on NON.serial_no = T.serialNumber
inner join ThesisHasPublication TP
on T.serialNumber = TP.serialNo
inner join Publication P
on P.id = TP.pubid
where NON.sid = @StudentID
go
create proc AddDefenseGucian
@ThesisSerialNo int , @DefenseDate Datetime , @DefenseLocation varchar(15)
as
insert into Defense values(@ThesisSerialNo,@DefenseDate,@DefenseLocation,null)
go
create proc AddDefenseNonGucian
@ThesisSerialNo int , @DefenseDate Datetime , @DefenseLocation varchar(15)
as
declare @idOfStudent int
select @idOfStudent = sid
from NonGUCianStudentRegisterThesis
where serial_no = @ThesisSerialNo
if(not exists(select grade
from NonGucianStudentTakeCourse
where sid = @idOfStudent and grade < 50))
begin
insert into Defense values(@ThesisSerialNo,@DefenseDate,@DefenseLocation,null)
end
go
create proc AddExaminer
@ThesisSerialNo int , @DefenseDate Datetime , @ExaminerName varchar(20),@Password varchar(30),
@National bit, @fieldOfWork varchar(20)
as
insert into PostGradUser values(@ExaminerName,@Password)
declare @id int
set @id = SCOPE_IDENTITY()
insert into Examiner values(@id,@ExaminerName,@fieldOfWork,@National)
insert into ExaminerEvaluateDefense values(@DefenseDate,@ThesisSerialNo,@id,null)
go
create proc CancelThesis
@ThesisSerialNo int
as
if(exists(
select *
from GUCianProgressReport
where thesisSerialNumber = @ThesisSerialNo
))
begin
declare @gucianEval int
set @gucianEval = (
select top 1 eval
from GUCianProgressReport
where thesisSerialNumber = @ThesisSerialNo order by no desc
)
if(@gucianEval = 0)
begin
delete from Thesis where serialNumber = @ThesisSerialNo
end
end
else
begin
declare @nonGucianEval int
set @nonGucianEval = (
select top 1 eval
from NonGUCianProgressReport
where thesisSerialNumber = @ThesisSerialNo
order by no desc
)
if(@nonGucianEval = 0)
begin
delete from Thesis where serialNumber = @ThesisSerialNo
end
end
go
create proc AddGrade
@ThesisSerialNo int
as
declare @grade decimal(4,2)
select @grade = grade
from Defense
where serialNumber = @ThesisSerialNo
update Thesis
set grade = @grade
where serialNumber = @ThesisSerialNo
go
create proc AddDefenseGrade
@ThesisSerialNo int , @DefenseDate Datetime , @grade decimal(4,2)
as
update Defense
set grade = @grade
where serialNumber = @ThesisSerialNo and date = @DefenseDate
go
create proc AddCommentsGrade
@ThesisSerialNo int , @DefenseDate Datetime , @comments varchar(300)
as
update ExaminerEvaluateDefense
set comment = @comments
where serialNo = @ThesisSerialNo and date = @DefenseDate
go
create proc viewMyProfile
@studentId int
as
if(exists(
select * from GucianStudent where id = @studentId
))
begin
select G.*,P.email
from GucianStudent G
inner join PostGradUser P
on G.id = P.id
where G.id = @studentId
end
else
begin
select N.*,P.email
from NonGucianStudent N
inner join PostGradUser P
on N.id = P.id
where N.id = @studentId
end
go
create proc editMyProfile
@studentID int, @firstName varchar(20), @lastName varchar(20), @password varchar(30), @email
varchar(50)
, @address varchar(50), @type varchar(3)
as
update GucianStudent
set firstName = @firstName, lastName = @lastName, address = @address, type = @type
where id = @studentID
update NonGucianStudent
set firstName = @firstName, lastName = @lastName, address = @address, type = @type
where id = @studentID
update PostGradUser
set email = @email, password = @password
where id = @studentID
go
create proc addUndergradID
@studentID int, @undergradID varchar(10)
as
update GucianStudent
set undergradID = @undergradID
where id = @studentID
go
create proc ViewCoursesGrades
@studentID int
as
select grade
from NonGucianStudentTakeCourse where sid = @studentID
go
create proc ViewCoursePaymentsInstall
@studentID int
as
select P.id as 'Payment Number', P.amount as 'Amount of Payment',P.fundPercentage as 'Percentage of
fund for payment', P.noOfInstallments as 'Number of installments',
I.amount as 'Installment Amount',I.date as 'Installment date', I.done as 'Installment done or not'
from NonGucianStudentPayForCourse NPC
inner join Payment P
on NPC.paymentNo = P.id and NPC.sid = @studentID
inner join Installment I
on I.paymentId = P.id
go
create proc ViewThesisPaymentsInstall
@studentID int
as
select P.id as 'Payment Number', P.amount as 'Amount of Payment', P.fundPercentage as
'Fund',P.noOfInstallments as 'Number of installments',
I.amount as 'Installment amount',I.date as 'Installment date', I.done as 'Installment done or not'
from GUCianStudentRegisterThesis G
inner join Thesis T
on G.serial_no = T.serialNumber and G.sid = @studentID
inner join Payment P on T.payment_id = P.id
inner join Installment I
on I.paymentId = P.id
union
select P.id as 'Payment Number',P.amount as 'Amount of Payment', P.fundPercentage as
'Fund',P.noOfInstallments as 'Number of installments',
I.amount as 'Installment amount',I.date as 'Installment date', I.done as 'Installment done or not'
from NonGUCianStudentRegisterThesis NG
inner join Thesis T
on NG.serial_no = T.serialNumber and NG.sid = @studentID
inner join Payment P
on T.payment_id = P.id
inner join Installment I
on I.paymentId = P.id
go
create proc ViewUpcomingInstallments
@studentID int
as
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Installment I
inner join NonGucianStudentPayForCourse NPC
on I.paymentId = NPC.paymentNo and NPC.sid = @studentID and I.date > CURRENT_TIMESTAMP
union
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Thesis T
inner join Payment P on T.payment_id = P.id
inner join Installment I
on I.paymentId = P.id
inner join GUCianStudentRegisterThesis G
on G.serial_no = T.serialNumber and G.sid = @studentID
where I.date > CURRENT_TIMESTAMP
union
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Thesis T
inner join Payment P
on T.payment_id = P.id
inner join Installment I
on I.paymentId = P.id
inner join NonGUCianStudentRegisterThesis G
on G.serial_no = T.serialNumber and G.sid = @studentID
where I.date > CURRENT_TIMESTAMP
go
create proc ViewMissedInstallments
@studentID int
as
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Installment I
inner join NonGucianStudentPayForCourse NPC
on I.paymentId = NPC.paymentNo and NPC.sid = @studentID and I.date < CURRENT_TIMESTAMP and
I.done = '0'
union
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Thesis T inner join Payment P
on T.payment_id = P.id
inner join Installment I
on I.paymentId = P.id
inner join GUCianStudentRegisterThesis G
on G.serial_no = T.serialNumber and G.sid = @studentID
where I.date < CURRENT_TIMESTAMP and I.done = '0'
union
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Thesis T
inner join Payment P
on T.payment_id = P.id
inner join Installment I
on I.paymentId = P.id
inner join NonGUCianStudentRegisterThesis G
on G.serial_no = T.serialNumber and G.sid = @studentID
where I.date < CURRENT_TIMESTAMP and I.done = '0'
go
create proc AddProgressReport
@thesisSerialNo int, @progressReportDate date, @studentID int,@progressReportNo int
as
declare @gucian int
if(exists(
select id
from GucianStudent
where id = @studentID
))begin
set @gucian = '1'
end
else
begin
set @gucian = '0'
end
if(@gucian = '1')
begin
insert into GUCianProgressReport
values(@studentID,@progressReportNo,@progressReportDate,null,null,null,@thesisSerialNo,null)
end
else
begin
insert into NonGUCianProgressReport
values(@studentID,@progressReportNo,@progressReportDate,null,null,null,@thesisSerialNo,null)
end
go
create proc FillProgressReport
@thesisSerialNo int, @progressReportNo int, @state int, @description varchar(200),@studentID int
as
declare @gucian bit
if(exists(
select * from GucianStudent
where id = @studentID))
begin
set @gucian = '1'
end
else
begin
set @gucian = '0'
end
if(@gucian = '1')
begin
update GUCianProgressReport
set state = @state, description = @description, date = CURRENT_TIMESTAMP
where thesisSerialNumber = @thesisSerialNo and sid = @studentID and no = @progressReportNo
end
else
begin
update NonGUCianProgressReport
set state = @state, description = @description, date = CURRENT_TIMESTAMP
where thesisSerialNumber = @thesisSerialNo and sid = @studentID and no = @progressReportNo
end
go
create proc ViewEvalProgressReport
@thesisSerialNo int, @progressReportNo int,@studentID int
as
select eval
from GUCianProgressReport where sid = @studentID and thesisSerialNumber = @thesisSerialNo and no = @progressReportNo
union
select eval
from NonGUCianProgressReport
where sid = @studentID and thesisSerialNumber = @thesisSerialNo and no = @progressReportNo
go
create proc addPublication
@title varchar(50), @pubDate datetime, @host varchar(50), @place varchar(50), @accepted bit
as
insert into Publication values(@title,@pubDate,@place,@accepted,@host)
go
go
create proc linkPubThesis
@PubID int, @thesisSerialNo int
as
insert into ThesisHasPublication values(@thesisSerialNo,@PubID)
go
go
create trigger deleteSupervisor
on Supervisor
instead of delete
as
delete from GUCianProgressReport where supid in (select id from deleted)
delete from NonGUCianProgressReport where supid in (select id from deleted)
delete from GUCianStudentRegisterThesis where supid in (select id from deleted)
delete from NonGUCianStudentRegisterThesis where supid in (select id from deleted)
delete from Supervisor where id in (select id from deleted)
delete from PostGradUser where id in (select id from deleted)
go
--------------------------------------------------------------------------
--Shewayet nadafa ba2a


GO
CREATE PROC listExaminerData
@ID INT,
@success BIT OUTPUT
AS
IF(NOT EXISTS((SELECT T.title AS 'Thesis Title', S.name AS 'Supervisor', GS.firstName + ' ' + GS.lastName AS 'Student Name'
				FROM Defense D INNER JOIN ExaminerEvaluateDefense EED ON D.date = EED.date AND D.serialNumber = EED.serialNo
							   INNER JOIN Examiner E ON E.id = EED.examinerId
							   INNER JOIN Thesis T ON T.serialNumber = D.serialNumber
							   INNER JOIN GUCianStudentRegisterThesis GST ON GST.serial_no = T.serialNumber
							   INNER JOIN Supervisor S ON S.id = GST.supid
							   INNER JOIN GucianStudent GS ON GS.id = GST.sid
				WHERE E.id = @ID AND D.date < CURRENT_TIMESTAMP)
				UNION
				(SELECT T.title AS 'Thesis Title', S.name AS 'Supervisor', NGS.firstName + ' ' + NGS.lastName AS 'Student Name'
				FROM Defense D INNER JOIN ExaminerEvaluateDefense EED ON D.date = EED.date AND D.serialNumber = EED.serialNo
							   INNER JOIN Examiner E ON E.id = EED.examinerId
							   INNER JOIN Thesis T ON T.serialNumber = D.serialNumber
							   INNER JOIN NonGUCianStudentRegisterThesis NGST ON NGST.serial_no = T.serialNumber
							   INNER JOIN Supervisor S ON S.id = NGST.supid
							   INNER JOIN NonGucianStudent NGS ON NGS.id = NGST.sid
				WHERE E.id = @ID AND D.date < CURRENT_TIMESTAMP)))
	SET @success = '0'
ELSE
	BEGIN
		SET @success = '1'
		(SELECT T.title AS 'Thesis Title', S.name AS 'Supervisor', GS.firstName + ' ' + GS.lastName AS 'Student Name'
		FROM Defense D INNER JOIN ExaminerEvaluateDefense EED ON D.date = EED.date AND D.serialNumber = EED.serialNo
					   INNER JOIN Examiner E ON E.id = EED.examinerId
					   INNER JOIN Thesis T ON T.serialNumber = D.serialNumber
					   INNER JOIN GUCianStudentRegisterThesis GST ON GST.serial_no = T.serialNumber
					   INNER JOIN Supervisor S ON S.id = GST.supid
					   INNER JOIN GucianStudent GS ON GS.id = GST.sid
		WHERE E.id = @ID AND D.date < CURRENT_TIMESTAMP)
		UNION
		(SELECT T.title AS 'Thesis Title', S.name AS 'Supervisor', NGS.firstName + ' ' + NGS.lastName AS 'Student Name'
		FROM Defense D INNER JOIN ExaminerEvaluateDefense EED ON D.date = EED.date AND D.serialNumber = EED.serialNo
					   INNER JOIN Examiner E ON E.id = EED.examinerId
					   INNER JOIN Thesis T ON T.serialNumber = D.serialNumber
					   INNER JOIN NonGUCianStudentRegisterThesis NGST ON NGST.serial_no = T.serialNumber
					   INNER JOIN Supervisor S ON S.id = NGST.supid
					   INNER JOIN NonGucianStudent NGS ON NGS.id = NGST.sid
		WHERE E.id = @ID AND D.date < CURRENT_TIMESTAMP)
	END
RETURN @success
GO


DECLARE @success BIT 
EXEC listExaminerData 29, @success OUTPUT
PRINT @success

GO
CREATE PROC editExaminer
@ID INT,
@name VARCHAR(20),
@fieldOfWork VARCHAR(100)
AS
UPDATE Examiner
SET name = @name, fieldOfWork = @fieldOfWork
WHERE id = @ID
GO


GO
CREATE PROC searchThesis
@keyword VARCHAR(100),
@success BIT OUTPUT
AS
IF(NOT EXISTS(SELECT *
	FROM Thesis
	WHERE title LIKE '%'+@keyword+'%'))
	SET @success = '0'
ELSE IF(@keyword = '')
	SET @success = '0'
ELSE
BEGIN
	SET @success = '1'
	SELECT *
	FROM Thesis
	WHERE title LIKE '%'+@keyword+'%'
END
RETURN @success
GO

DECLARE @success BIT 
EXEC searchThesis 'the', @success OUTPUT
PRINT @success
PRINT @success
PRINT @success
PRINT @success
PRINT @success

GO
create proc getID
@email varchar(50),
@password varchar(50),
@id int output 
AS
select @id= id 
from PostGradUser
where email=@email AND password=@password 
return @id
Go

GO
CREATE PROC getLoginType     
@id INT,     
@type INT OUTPUT     
AS     
IF(EXISTS(SELECT *         
		  FROM GucianStudent        
		  WHERE id = @id))     
BEGIN         
	SET @type = 1     
END     
IF(EXISTS(SELECT *         
		  FROM NonGucianStudent         
		  WHERE id = @id))    
BEGIN         
	SET @type = 2    
END     
IF(EXISTS(SELECT *         
		  FROM Supervisor         
		  WHERE id = @id))     
BEGIN         
	SET @type = 3     
END     
IF(EXISTS(SELECT *         
		  FROM Examiner         
		  WHERE id = @id))     
BEGIN         
	SET @type = 5     
END     
IF(EXISTS(SELECT *         
		  FROM Admin        
		  WHERE id = @id))     
BEGIN         
	SET @type = 4    
END
GO

GO
CREATE PROC AddDefenseGrade
@id INT,
@ThesisSerialNo INT , 
@DefenseDate DATETIME , 
@grade DECIMAL(4,2),
@success BIT OUTPUT
AS
IF(EXISTS(SELECT *
		  FROM Defense D INNER JOIN ExaminerEvaluateDefense EED ON D.date = EED.date 
													   AND D.serialNumber = EED.serialNo
		  WHERE EED.examinerId = @id AND EED.serialNo = @ThesisSerialNo AND D.date = @DefenseDate))
	BEGIN
		SET @success = '1' 
		UPDATE Defense
		SET grade = @grade
		WHERE serialNumber = @ThesisSerialNo AND date = @DefenseDate
	END
ELSE
	SET @success = '0'
RETURN @success
GO

DECLARE @success BIT 
EXEC AddDefenseGrade 29, 8, '7/1/2021', 14, @success OUTPUT
PRINT @success


GO
CREATE PROC AddCommentsGrade
@id INT,
@ThesisSerialNo INT , 
@DefenseDate DATETIME , 
@comments varchar(300),
@success BIT OUTPUT
AS
IF(EXISTS(SELECT *
		  FROM Defense D INNER JOIN ExaminerEvaluateDefense EED ON D.date = EED.date 
													   AND D.serialNumber = EED.serialNo
		  WHERE EED.examinerId = @id AND EED.serialNo = @ThesisSerialNo AND D.date = @DefenseDate))
	BEGIN
		SET @success = '1' 
		UPDATE ExaminerEvaluateDefense
		SET comment = @comments
		WHERE serialNo = @ThesisSerialNo AND date = @DefenseDate
	END
ELSE
	SET @success = '0'
RETURN @success
GO

DECLARE @success BIT 
EXEC AddCommentsGrade 23, 8, '7/1/2021', '3azaamaa', @success OUTPUT
PRINT @success

--extra procedures
--1		
GO
create proc getID
@email varchar(50),
@password varchar(50),
@id int output 
AS
select @id= id 
from PostGradUser
where email=@email AND password=@password 
 return @id
 
--2
GO
create proc getLoginType
@id int,
@type int output 
AS 
if(exists(select* from GucianStudent where id=@id))
begin
set @type=1
end
if(exists(select* from NonGucianStudent where id=@id))
begin
set @type=2
end
if(exists(select* from Admin where id=@id))
begin
set @type=3
end
if(exists(select* from Supervisor where id=@id))
begin
set @type=4
end
if(exists(select* from Examiner where id=@id))
begin
set @type=5
end
return @type

--3
go
create proc createExaminer
@first_name varchar(20),
@last_name varchar(20),
@fieldOfWork varchar(20),
@isNational bit,
@email varchar(20),
@password varchar(20)
AS
declare @ExaminerID int
INSERT  INTO PostGradUser (email, password)
VALUES (@email, @password)
set @ExaminerID=scope_identity()
INSERT  INTO Examiner (id,name,fieldOfWork,isNational) 
VALUES (@ExaminerID,@first_name + ' ' + @last_name,@fieldOfWork,@isNational )
GO

--4
GO
create proc getLastEval
@thesisSerialNo int,
@bool int output
AS
Declare @maxDate Date
Declare @evaluation int 
IF(exists(SELECT thesisSerialNumber from GUCianProgressReport where thesisSerialNumber=@ThesisSerialNo))
BEGIN
SELECT @maxDate=max(date)
from GUCianProgressReport
where thesisSerialNumber=@ThesisSerialNo

SELECT	@evaluation=eval 
from GUCianProgressReport
where thesisSerialNumber=@ThesisSerialNo  AND  date=@maxdate

IF(@evaluation=0)
BEGIN
set @bool=1
END
Else
BEgin
set @bool=0
ENd
END
IF(exists(SELECT thesisSerialNumber from NonGUCianProgressReport where thesisSerialNumber=@ThesisSerialNo))
BEGIN
SELECT @maxDate=max(date)
from NonGUCianProgressReport
where thesisSerialNumber=@ThesisSerialNo

SELECT	@evaluation=eval 
from NonGUCianProgressReport
where thesisSerialNumber=@ThesisSerialNo  AND  @maxDate= date 

IF(@evaluation=0)
BEGIN
set @bool=1;
END
Else
BEgin
set @bool=0
ENd
END
return @bool

--5 
go
create proc checkThesisValid
@thesisSerialNo int,
@bool int output
AS
if(exists(select * from Thesis where Thesis.serialNumber=@thesisSerialNo))
begin
set @bool=1;
end
else
begin 
set @bool=0
end 
return @bool

--6
go
create proc checkProgressNoValid
@progress int,
@bool int output
AS
if(exists(select * from GUCianProgressReport where no=@progress))
begin
set @bool=1;
end
else
begin
if(exists(select* from NonGucianProgressReport where no=@progress))
begin
set @bool=1;
end
else
begin
set @bool=0;
end
end
return @bool;

--7
go
create proc checkifstudent
@progress int,
@supid int,
@bool int output
AS
if(exists(select* from GUCianProgressReport where no=@progress and supid=@supid))
begin
set @bool= 1
end
else
begin
if(exists(select* from NonGucianProgressReport where no =@progress and supid=@supid))
begin
set @bool=1
end
else
begin
set @bool =0
end
end
return @bool
--8
GO
CREATE PROC AddDefenseGuciantwo
@ThesisSerialNo INT, 
@DefenseDate DATETIME, 
@DefenseLocation VARCHAR(15)
AS
INSERT INTO Defense(serialNumber, date, location)
VALUES(@ThesisSerialNo, @DefenseDate, @DefenseLocation)
UPDATE Thesis
SET defenseDate = @DefenseDate
WHERE serialNumber = @ThesisSerialNo
--9
GO
Create Proc CheckIFDEF
@ThesisSerialNo INT,
@bool int output
AS
if(exists(select* from Defense where serialNumber=@ThesisSerialNo))
Begin
set @bool=1
end
else
begin
set @bool=0
end
return @bool

--10
go
create proc ThesisBelongs
@ThesisSerialNo INT,
@bool int output
AS
if(exists(Select* from GUCianStudentRegisterThesis where serial_no=@ThesisSerialNo))
begin 
set @bool =1
end
else
begin
if(exists(select* from NonGUCianStudentRegisterThesis where serial_no=@ThesisSerialNo))
begin
set @bool =0
end
else
begin
set @bool=2
end 
end
return @bool

--11
go
CREATE PROC AddDefenseNonGuciantwo
@ThesisSerialNo INT, 
@DefenseDate DATETIME, 
@DefenseLocation VARCHAR(15)
AS
IF(50 < ALL(SELECT ngts.grade
		FROM NonGUCianStudentRegisterThesis ngrt
        INNER JOIN NonGucianStudentTakeCourse ngts ON ngrt.sid = ngts.sid
        WHERE ngrt.serial_no = @ThesisSerialNo))
    BEGIN
        INSERT INTO Defense(serialNumber, date, location)
        VALUES(@ThesisSerialNo, @DefenseDate, @DefenseLocation)
        UPDATE Thesis
        SET defenseDate = @DefenseDate
        WHERE serialNumber = @ThesisSerialNo
END
--12
GO
create proc checkAllCourses
@ThesisSerialNo INT,
@bool int output
As
IF(50 < ALL(SELECT ngts.grade
		FROM NonGUCianStudentRegisterThesis ngrt
        INNER JOIN NonGucianStudentTakeCourse ngts ON ngrt.sid = ngts.sid
        WHERE ngrt.serial_no = @ThesisSerialNo))
Begin
set @bool = 1
ENd
else
begin
Set @bool =0
end
return @bool
--13
GO
create proc defDate
@ThesisSerialNo INT,
@DefDate Datetime output
AS
select @DefDate=D.date
from Defense D
where D.serialNumber=@ThesisSerialNo

--14 
go
create proc checkValidStudent
@studentid int ,
@bool int output
AS 
if(exists( select* from GucianStudent where id=@studentid))
begin
set @bool =1
end
else
begin
if(exists( select * from NonGucianStudent where id=@studentid))
begin
set @bool=1
end
else
begin
set @bool =0
end
end
return @bool


go
create proc checkifThesisMyStudent
@ThesisSerialNo int,
@supid int,
@bool int output
AS
if(exists(select* from GUCianStudentRegisterThesis where serial_no=@ThesisSerialNo and supid=@supid))
begin
set @bool= 1
end
else
begin
if(exists(select* from NonGUCianStudentRegisterThesis where serial_no =@ThesisSerialNo and supid=@supid))
begin
set @bool=1
end
else
begin
set @bool =0
end
end
return @bool



--extra procedures getID and getLoginType done by mo3taz (first two)
			
GO
create proc getID
@email varchar(50),
@password varchar(50),
@id int output 
AS
select @id= id 
from PostGradUser
where email=@email AND password=@password 
 return @id
 go

-----------------------------Sasa

CREATE PROC mythesis  
@ID int
AS
if(exists(select * From GucianStudent where id=@ID))
BEGIN
Select T.*
from Thesis T inner join GUCianStudentRegisterThesis GRT on GRT.serial_no = T.serialNumber INNER JOIN GucianStudent G ON G.id = GRT.sid
WHERE g.id = @ID
END
ELSE
BEGIN
Select T.*
from Thesis T inner join NonGUCianStudentRegisterThesis NGRT on NGRT.serial_no = T.serialNumber INNER JOIN NonGucianStudent G ON G.id = NGRT.sid
WHERE g.id = @ID
END
go

create Proc ongoingthesis
@thesisSerialNO int,
@success bit Output
AS
IF(EXISTS(SELECT *
        FROM  Thesis T
        WHERE T.serialNumber = @thesisSerialNO AND T.endDate > CURRENT_TIMESTAMP AND T.startDate < CURRENT_TIMESTAMP  ))
	BEGIN
	set @success = 1
	end
Else
	begin
	set @success = 0
	end
return @success;

DECLARE @output BIT
EXEC @output = ongoingthesis 15,@output
PRINT @output

go
create proc getMyThesis
@StudentID int,
@thesisSerialNO int,
@myThesis bit output
AS
if(exists(select * from GUCianStudentRegisterThesis where sid=@studentID and serial_no = @thesisSerialNO ))
BEGIN
set @myThesis = 1
END
ELse if(exists(select * from NonGUCianStudentRegisterThesis where sid=@StudentID and serial_no = @thesisSerialNO))
begin
set @myThesis= 1
end
else
	begin
	set @myThesis= 0;
	end
return @myThesis


go
create Proc ifFoundLink
@thesisSerialNO int,
@PubID  int,
@found bit Output
AS
IF(EXISTS(SELECT *
        FROM  ThesisHasPublication T
        WHERE T.serialNo = @thesisSerialNO AND T.pubid = @PubID ))
	BEGIN
	set @found = 1
	end
Else
	begin
	set @found = 0
	end
return @found;

DECLARE @output BIT
EXEC @output = ifFoundLink 1,5, @output
PRINT @output
go
create Proc ifFoundmobile
@ID int, 
@mobile_number varchar(20),
@found bit output
AS
IF(EXISTS(SELECT id FROM GucianStudent WHERE id = @ID))
	begin
	IF(EXISTS(SELECT * FROM GucStudentPhoneNumber WHERE id = @ID and phone = @mobile_number ))
		begin
		set @found = 1
		end
	else
		begin
		set @found = 0
		end
	end
ELSE IF(EXISTS(SELECT id FROM NonGucianStudent WHERE id = @ID))
	begin
	IF(EXISTS(SELECT * FROM NonGucStudentPhoneNumber WHERE id = @ID and phone = @mobile_number ))
		begin
		set @found = 1
		end
	else
		begin
		set @found = 0
		end
	end
return @found;

DECLARE @output BIT
EXEC @output = ifFoundmobile 1,'010025555545', @output
PRINT @output

go
create proc getMyPublicationNo
@title varchar(50),
@host varchar(50),
@place varchar(50),
@myPublication int output
AS
select @myPublication= p.id from Publication P where P.host = @host and P.title = @title And p.place = @place
return @myPublication;


DECLARE @output int
EXEC @output = getMyPublicationNo 'as','dcadc','ss', @output
PRINT @output
go

create proc getMyProgressReportNo
@thesisSerialNo int,
@progressReportDate date,
@MyProgressReportNo int output
AS
if (exists(select * from GUCianProgressReport P where P.date = @progressReportDate AND P.thesisSerialNumber = @thesisSerialNo))
BEGIN
select @MyProgressReportNo= p.no from GUCianProgressReport P where P.date = @progressReportDate AND P.thesisSerialNumber = @thesisSerialNo
END
ELSE IF  (exists(select * from GUCianProgressReport P where P.date = @progressReportDate AND P.thesisSerialNumber = @thesisSerialNo))
BEGIN
select @MyProgressReportNo= p.no from GUCianProgressReport P where P.date = @progressReportDate AND P.thesisSerialNumber = @thesisSerialNo
END
return @MyProgressReportNo;

DECLARE @output int
EXEC @output = getMyProgressReportNo 9, "03/05/2021", @output
PRINT @output
go

create proc IfMyProgressreportExists
@thesisSerialNo int,
@MyProgressReportNo int,
@Myexists bit output
AS
if (exists(select * from GUCianProgressReport P where p.no= @MyProgressReportNo AND P.thesisSerialNumber = @thesisSerialNo))
	BEGIN
	set @Myexists = 1
	END
ELSE IF  (exists(select * from GUCianProgressReport P where p.no= @MyProgressReportNo AND P.thesisSerialNumber = @thesisSerialNo))
	BEGIN
	set @Myexists = 1
	end
Else
	begin
	set @Myexists = 0
	end
return @Myexists;


DECLARE @output bit
EXEC @output = IfMyProgressreportExists 1,2 , @output
PRINT @output
go


--largest Payment Id
GO
create proc largestPayment
@largest int output
as
select @largest=max(id) from Payment
go

--largest Thesis serial
GO
create proc largestSerial
@maximum int output
as
select @maximum=max(serialNumber) from Thesis
GO










--use ROMA
--					                     INSERTIONS

SET DATEFORMAT dmy 
--                                      Thesis Payment

INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 1
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 2
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 3
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 4
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 5
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 6
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 7
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 8
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (250000, 5, 0.167)--thesis 9
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (250000, 5, 0.167)--thesis 10
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (250000, 5, 0.167)--thesis 11
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (250000, 5, 0.167)--thesis 12
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (250000, 5, 0.167)--thesis 13
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 14
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (120000, 2, 0.167)--thesis 15


--           						   Course Payments

INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (6000, 1, 0.167)  --16
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (4000, 1, 0.167)  --17
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (6000, 1, 0.111)  --18
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (4000, 1, 0.111)  --19
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (6000, 1, 0.111)  --20
INSERT INTO Payment (amount, no_Installments, fundPercentage) VALUES (4000, 1, 0.111)  --21


--                                       INSTALLMENT


--		                             Thesis Installments

INSERT INTO Installment (date, paymentId, amount, done) VALUES ('12/11/2020', 1, 60000, '1')--1 for thesis 1 
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('12/11/2021', 1, 60000, '1')--2 for thesis 1
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('23/2/2021', 2, 60000, '1')--3 for thesis 2
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('23/2/2022', 2, 60000, '0')--4 for thesis 2
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('15/1/2015', 3, 60000, '1')--5 for thesis 3
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('15/1/2016', 3, 60000, '1')--6 for thesis 3
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('24/3/2017', 4, 60000, '1')--7 for thesis 4
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('24/3/2018', 4, 60000, '1')--8 for thesis 4
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('6/7/2019', 5, 60000, '1')--9 for thesis 5
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('6/7/2020', 5, 60000, '1')--10 for thesis 5
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('29/10/2021', 6, 60000, '0')--11 for thesis 6
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('29/10/2022', 6, 60000, '1')--12 for thesis 6
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('6/9/2015', 7, 60000, '1')--13 for thesis 7
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('6/9/2016', 7, 60000, '1')--14 for thesis 7
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('17/7/2019', 8, 60000, '1')--15 for thesis 8
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('17/7/2020', 8, 60000, '1')--16 for thesis 8
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('9/5/2017', 9, 50000, '1')--17 for thesis 9
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('9/5/2018', 9, 50000, '1')--18 for thesis 9
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('9/5/2019', 9, 50000, '1')--19 for thesis 9
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('9/5/2020', 9, 50000, '1')--20 for thesis 9
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('9/5/2021', 9, 50000, '1')--21 for thesis 9
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('15/3/2015', 10, 50000, '1')--22 for thesis 10
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('15/3/2016', 10, 50000, '1')--23 for thesis 10
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('15/3/2017', 10, 50000, '1')--24 for thesis 10
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('15/3/2018', 10, 50000, '1')--25 for thesis 10
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('15/3/2019', 10, 50000, '1')--26 for thesis 10
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/6/2016', 11, 50000, '1')--27 for thesis 11
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/6/2017', 11, 50000, '1')--28 for thesis 11
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/6/2018', 11, 50000, '1')--29 for thesis 11
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/6/2019', 11, 50000, '1')--30 for thesis 11
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/6/2020', 11, 50000, '1')--31 for thesis 11
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('25/1/2015', 12, 50000, '1')--32 for thesis 12
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('25/1/2016', 12, 50000, '1')--33 for thesis 12
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('25/1/2017', 12, 50000, '1')--34 for thesis 12
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('25/1/2018', 12, 50000, '1')--35 for thesis 12
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('25/1/2019', 12, 50000, '1')--36 for thesis 12
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('4/7/2012', 13, 50000, '1')--37 for thesis 13
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('4/7/2013', 13, 50000, '1')--38 for thesis 13
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('4/7/2014', 13, 50000, '1')--39 for thesis 13
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('4/7/2015', 13, 50000, '1')--40 for thesis 13
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('4/7/2016', 13, 50000, '1')--41 for thesis 13
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('28/4/2021', 14, 60000, '1')--42 for thesis 14
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('28/4/2022', 14, 60000, '0')--43 for thesis 14
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('4/3/2012', 15, 60000, '1')--44 for thesis 15
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('4/3/2013', 15, 60000, '1')--45 for thesis 15


--                                    Course Installments

INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/12/2019',16,6000,'1') --46
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/1/2020',17,4000,'1')  --47
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('28/2/2021',18,6000,'1')  --48
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/1/2022',19,4000,'0')  --49
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('26/2/2021',20,6000,'1')  --50
INSERT INTO Installment (date, paymentId, amount, done) VALUES ('30/3/2021',21,4000,'1')  --51


--                                      GUCians


INSERT INTO PostGradUser(email,password) --1
VALUES ('omarmoataz123@gmail.com','Omar123')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (1,'Omar','Moataz','Masters','Computer Science','NASR CITY STREET 1 Villa 13',1.22) 

INSERT INTO PostGradUser(email,password) --2
VALUES ('Alymoataz123@hotmail.com','Aly123')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (2,'Aly','Moataz','Masters','Computer Science','rehab street 19 building 2',1.3) 

INSERT INTO PostGradUser(email,password) --3
VALUES ('hamzamohamed@gmail.com','H_abcdefg123')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (3,'Hamza','Mohamed','Masters','Applied Arts','Masr el gedida street 12',1.9) 

INSERT INTO PostGradUser(email,password) --4
VALUES ('radwan1921@gmail.com','rodo2001')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (4,'Radwan','Waleed','Masters','Applied Arts','Sheraton street 1 building 5',1.0) 

INSERT INTO PostGradUser(email,password) --5
VALUES ('haythamahmed@hotmail.com','aho1956')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (5,'Haytham','Ahmed','Masters','Law','Fifth Settlement street 15 ',0.7) 

INSERT INTO PostGradUser(email,password) --6
VALUES ('sarahamdy@gmail.com','s123abc')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (6,'Sara','hamdy','Masters','Law','Madinty street 12 building 11',2.0) 

INSERT INTO PostGradUser(email,password) --7
VALUES ('yaramohamed@hotmail.com','yara123abc')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (7,'yara','mohamed','Masters','Civil Engineering','Nasr city street 13 district 2 building 11',1.1) 

INSERT INTO PostGradUser(email,password) --8
VALUES ('yassermohamed@hotmail.com','yasser123abc')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (8,'yasser','mohamed','Masters','Pharmacy','Nasr city street 12 villa 11',2.2) 

INSERT INTO PostGradUser(email,password) --9
VALUES ('yasminmaher@hotmail.com','yaso123abc')
INSERT INTO GucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES (9,'yasmin','maher','PHD','Computer Science','Fifth settlement street 13 villa 99',2.3) 


--                                     Non GUCians


INSERT INTO PostGradUser(email,password) --10
VALUES ('marwanmagdy@gmail.com','MAro123')
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES(10,'Marwan','Magdy','PHD','Applied Arts','Nasr City Street 123 villa 155',0.8)

INSERT INTO PostGradUser(email,password) --11
VALUES ('youssefmagdy@hotmail.com','youabc123')
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES(11,'Youssef','Magdy','PHD','Law','Rehab District 15 street 12 villa 11',1.2)

INSERT INTO PostGradUser(email,password) --12
VALUES ('tasneemkhaled@hotmail.com','tasneem_g123')
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES(12,'tasneem','khaled','PHD','Civil Engineering','Madinty district 1 street 1 villa 123',1.8)

INSERT INTO PostGradUser(email,password) --13
VALUES ('OmarMohamed@gmail.com','omar2001')
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES(13,'Omar','Mohamed','PHD','Pharmacy','Nasr City building 12345 ',0.88)

INSERT INTO PostGradUser(email,password) --14
VALUES ('kareemmohamed@hotmail.com','kimo_123')
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES(14,'kareem','mohamed','Masters','Civil Engineering','Rehab 1 street 123456 building 123 ',1.1)

INSERT INTO PostGradUser(email,password) --15
VALUES ('salmafarouk@gmail.com','sara_123abc')
INSERT INTO NonGucianStudent(id,firstName,lastName,type,faculty,address,gpa)
VALUES(15,'Salma','Farouk','Masters','Pharmacy','Fifth Settlement street 105 villa 123',1.4)



--                                         Admins

INSERT INTO PostGradUser(email,password) --16
VALUES ('Meriamamgad@gmail.com','M_ADmin123')
INSERT INTO admin(id)
VALUES (16)

INSERT INTO PostGradUser(email,password) --17
VALUES ('mahermagdy@gmail.com','MAher_admin123')
INSERT INTO admin (id)
VALUES(17)


--                                       Supervisors


INSERT INTO PostGradUser(email,password) --18
VALUES ('omarmagdy@gmail.com','omar_super123')
INSERT INTO supervisor(id,name,faculty)
VALUES(18,'Omar Magdy','Computer Science')

INSERT INTO PostGradUser(email,password) --19
VALUES ('saramagdy@gmail.com','sara_magdy123')
INSERT INTO supervisor(id,name,faculty)
VALUES(19,'Sara Magdy','Applied Arts')

INSERT INTO PostGradUser(email,password) --20
VALUES ('tamaraamgad@gmail.com','T_superabc')
INSERT INTO supervisor(id,name,faculty)
VALUES(20,'Tamara Amgad','Pharmacy')

INSERT INTO PostGradUser(email,password) --21
VALUES ('MariamSherif@gmail.com','Mar_superabc2342')
INSERT INTO supervisor(id,name,faculty)
VALUES(21,'Mariam sherif ','Civil Engineering')

INSERT INTO PostGradUser(email,password) --22
VALUES ('Habibakhaled@gmail.com','Hab_super1234')
INSERT INTO supervisor(id,name,faculty)
VALUES(22,'Habiba Khaled','Law')


--                                         Examiners


INSERT INTO PostGradUser(email,password) --23
VALUES ('DavidFarouk@hotmail.com','D_exam123')
INSERT INTO Examiner (id, name, fieldOfWork, isNational)
VALUES(23,'David Farouk', 'Engineering','0')

INSERT INTO PostGradUser(email,password) --24
VALUES ('BasselKareem@gmail.com','bassel_magdy123')
INSERT INTO Examiner (id, name, fieldOfWork, isNational)
VALUES(24,'Bassel Kareem', 'Science','1')


--                                          Course


INSERT INTO Course (fees,creditHours,code) -- Applied Arts 1
VALUES(6000,6,'CI301')
INSERT INTO Course (fees,creditHours,code) -- Civil 2
VALUES(6000,6,'CIS602')
INSERT INTO Course (fees,creditHours,code) -- Computer Science 3
VALUES(4000,4,'CSEN503')
INSERT INTO Course (fees,creditHours,code) -- Law 4
VALUES(4000,4,'CILA')
INSERT INTO Course (fees,creditHours,code) -- Pharmacy 5
VALUES(4000,4,'PHBC621')


--                               Non Gucian Student Pay For Course


INSERT INTO NonGucianStudentPayForCourse (sid, paymentNo, cid) VALUES (10, 16, 1) -- Student 10 pays for course 1 with payment 16
INSERT INTO NonGucianStudentPayForCourse (sid, paymentNo, cid) VALUES (11, 17, 4) -- Student 11 pays for course 4 with payment 17
INSERT INTO NonGucianStudentPayForCourse (sid, paymentNo, cid) VALUES (12, 18, 2) -- Student 11 pays for course 2 with payment 18
INSERT INTO NonGucianStudentPayForCourse (sid, paymentNo, cid) VALUES (13, 19, 5) -- Student 11 pays for course 5 with payment 19
INSERT INTO NonGucianStudentPayForCourse (sid, paymentNo, cid) VALUES (14, 20, 2) -- Student 12 pays for course 2 with payment 20
INSERT INTO NonGucianStudentPayForCourse (sid, paymentNo, cid) VALUES (15, 21, 5) -- Student 12 pays for course 5 with payment 21


--                                Non Gucian Student Take Course


INSERT INTO NonGucianStudentTakeCourse (sid, cid,grade) VALUES (10, 1,95) -- Student 10 takes Course 1 
INSERT INTO NonGucianStudentTakeCourse (sid, cid,grade) VALUES (11, 4,70) -- Student 11 takes Course 4 
INSERT INTO NonGucianStudentTakeCourse (sid, cid,grade) VALUES (12, 2,40) -- Student 12 takes Course 2
INSERT INTO NonGucianStudentTakeCourse (sid, cid) VALUES (13, 5)		  -- Student 13 takes Course 5
INSERT INTO NonGucianStudentTakeCourse (sid, cid,grade) VALUES (14, 2,87) -- Student 14 takes Course 2
INSERT INTO NonGucianStudentTakeCourse (sid, cid,grade) VALUES (15, 5,76) -- Student 15 takes Course 5


--                                          Thesis


insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension) --1
values('Computer Science','Masters','Low power interconnected embedded devices for IoT','12/11/2020','12/11/2022','1/11/2022',1,0)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension) --2
values('Computer Science', 'Masters','Cyber-physical security of an electric microgrid','23/2/2021','23/2/2023','11/1/2023',2,0)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --3
values('Applied Arts','Masters','PHOTO PUBLICITY OF TOURISM IN ENUGU STATE','15/1/2015','15/1/2017','1/1/2017',3,0,97)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --4
values('Applied Arts','Masters','SUPPLICATION A CASE STUDY OF FORMS IN WOOD CARVING','24/3/2017','24/3/2019','1/3/2019',4,0,90)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --5
values('Law','Masters','Digital Matchmaking and the Law','6/7/2019','6/7/2021','28/6/2021',5,0,80)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension) --6
values('Law','Masters','Rights, autonomy and pregnancy','29/10/2021','29/10/2023','4/10/2023',6,0)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --7
values('Civil Engineering','Masters','Effects of Truck Impacts on Bridge Piers','6/9/2015','6/9/2017','25/8/2017',7,0,75)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --8
values('Pharmacy','Masters','IMPLICATIONS OF THE COST OF END OF LIFE CARE','17/7/2019','17/7/2021','1/7/2021',8,0,99)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension) --9
values('Computer Science', 'PHD', 'MACHINE LEARNING IN MEDICAL IMAGE ANALYSIS','9/5/2017','9/5/2022','25/4/2022',9,0)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --10
values('Applied Arts','PHD','ART FORMS ON OPOTO FESTIVAL IN ENUGWU- AGIDI','15/3/2015','15/3/2020','1/3/2020',10,1,100)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --11
values('Law','PHD','The action for injunction in EU consumer law','30/6/2016','30/6/2021','15/6/2021',11,1,92)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --12
values('Civil Engineering','PHD','Settlement Analysis Of Stabilized Sand Bed','25/1/2015','25/1/2020','10/1/2020',12,2,91)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --13
values('Pharmacy','PHD','Analyzing natural drugs for cancer','4/7/2012','4/7/2017','25/6/2017',13,0,98)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension) --14
values('Civil Engineering','Masters','Analysis and Design of Reinforced Soil Wall','28/4/2021','28/4/2023','5/4/2023',14,0)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,payment_id,noExtension,grade) --15
values('Pharmacy','Masters','Factor Influencing Postpartum Contraception Uptake','4/3/2012','4/3/2014','25/2/2014',15,0,78)

insert into Thesis (field,type,title,startDate,endDate,defenseDate,noExtension) --16
values('Computer Science','Masters','Data Mining','4/6/2020','4/6/2022','25/5/2022',0)



--                                    Gucian Register Thesis


INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --1
VALUES (1,18,1)
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --2
VALUES (2,18,2)
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --3
VALUES (3,19,3)
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --4
VALUES (4,19,4)
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --5
VALUES (5,22,5)
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --6
VALUES (6,22,6)
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --7
VALUES (7,21,7)
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --8
VALUES (8,20,8)
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) --9
VALUES (9,18,9)


--                                   Non Gucian register thesis


INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) --10
VALUES (10,19,10)
INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) --11
VALUES (11,22,11)
INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) --12
VALUES (12,21,12)
INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) --13
VALUES (13,20,13)
INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) --14
VALUES (14,21,14)
INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) --15
VALUES (15,20,15)

--                                   GUCian Progress Report

INSERT INTO GUCianProgressReport (sid, date, state, thesisSerialNumber, supid, description) -- Omar Moataz --> Algorithms & Architectures
VALUES (1, '13/9/2021', 50, 1, 18, 'Finished Algorithms')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Aly Moataz --> Artificial Intelligence
VALUES (2, '7/1/2023', 0, 84, 2, 18, 'Done with software')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Hamza Mohamed --> A Thematic Analysis of Ben Ibebe's Paintings
VALUES (3, '26/6/2016', 92, 83, 3, 19, 'Only Details is left')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Radwan Waleed --> Supplication
VALUES (4,'14/4/2018', 69, 93, 4, 19, 'Finished all calculactions')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Haytham Ahmed --> Jury Directions
VALUES (5, '29/3/2021', 67, 90, 5, 22, 'Studied some laws')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Sara Hamdy --> Artificial Intelligence
VALUES (6, '29/10/2022', 92, 67, 6, 22, 'Parts designed')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Yara mohamed --> Settlement Analysis of a Foundation in Sandy Ground
VALUES (7, '6/9/2016', 85, 79, 7, 21, 'Simulation left')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Yasser mohamed --> Electronic Nicotine Delivery System
VALUES (8, '19/6/2020', 76, 81, 8, 20, 'Connecting everything')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Yasmin Maher 1 --> A Convex Optimisation Approach to Optimal Control in Queueing Systems
VALUES (9, '5/3/2020', 98, 30, 9, 18, 'Simulation done, implementation still required')
INSERT INTO GUCianProgressReport (sid, date, eval, state, thesisSerialNumber, supid, description) -- Yasmin Maher 2 --> A Convex Optimisation Approach to Optimal Control in Queueing Systems
VALUES (9, '5/3/2021', 95, 89, 9, 18, 'Implementation in progress')



--                                 Non GUCian Progress Report



INSERT INTO NonGUCianProgressReport (sid, date, thesisSerialNumber, supid, description, state) -- Kareem Mohamed --> Numerical Analysis Of Excavation Movements’ Stresses And Deformations
VALUES (14,'30/12/2021', 14,21, 'Implemented all movements',80)
INSERT INTO NonGUCianProgressReport (sid, date, thesisSerialNumber, supid, description ,eval, state) -- Salma Farouk --> Factors Influencing Postpartum Contraception Uptake
VALUES (15,'25/6/2013', 15,20, 'Wrapping up',80,96)

---                                         Add a Defence 


INSERT INTO Defense (serialNumber,date,location) --1
VALUES(1,'1/11/2022','Lecture Hall 2')

INSERT INTO Defense (serialNumber,date,location,grade) --3
VALUES(3,'1/1/2017','C5 211',97)
INSERT INTO Defense (serialNumber,date,location,grade) --4
VALUES(4,'1/3/2019','D4 209',92)
INSERT INTO Defense (serialNumber,date,location,grade) --5
VALUES(5,'28/6/2021','Lecture Hall 12',88)
INSERT INTO Defense (serialNumber,date,location) --6
VALUES(6,'4/10/2023','Lecture 18')
INSERT INTO Defense (serialNumber,date,location,grade) --7
VALUES(7,'25/8/2017','Lecture Hall 16',83)
INSERT INTO Defense (serialNumber,date,location,grade) --8
VALUES(8,'1/7/2021','Lecture Hall 14',95)
INSERT INTO Defense (serialNumber,date,location) --9
VALUES(9,'25/4/2022','D4 101')
INSERT INTO Defense (serialNumber,date,location,grade) --10
VALUES(10,'1/3/2020','C7 212',87)

INSERT INTO Defense (serialNumber,date,location,grade) --12
VALUES(12,'10/1/2020','Lecture Hall 17',93)
INSERT INTO Defense (serialNumber,date,location,grade) --13
VALUES(13,'25/6/2017','B2 201',81)
INSERT INTO Defense (serialNumber,date,location) --14
VALUES(14,'5/4/2023','Lecture Hall 3')
INSERT INTO Defense (serialNumber,date,location,grade) --15
VALUES(15,'25/2/2014','Lecture Hall 4',96)


--                                      Add Examiner for a Defence 



INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --3
VALUES('1/1/2017',3,24,'Excellent')
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --4
VALUES('1/3/2019',4,23,'very good job')
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --5
VALUES('28/6/2021',5,24,'good job')
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId) --6
VALUES('4/10/2023',6,23)
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --7
VALUES('25/8/2017',7,24,'needs improvement')
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --8
VALUES('1/7/2021',8,23,'excellent work')
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId) --9
VALUES('25/4/2022',9,24)
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --10
VALUES('1/3/2020',10,23,'Needs a little bit of work')

INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --12
VALUES('10/1/2020',12,23,'Good work')
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --13
VALUES('25/6/2017',13,24,'Needs a bit of work')
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId) --14
VALUES('5/4/2023',14,23)
INSERT INTO ExaminerEvaluateDefense(date,serialNo,examinerId,comment) --15
VALUES('25/2/2014',15,24,'Keep up the good work')

--												ADD PUBLICATION

INSERT INTO Publication( title, date, place, accepted, host) -- Publication 1 has Thesis 10
VALUES ('OPOTO FESTIVAL IN ENUGWU- AGIDI','15/3/2021','H4','1','Balabizo')

INSERT INTO Publication( title, date, place, accepted, host) -- Publication 2 has Thesis 13
VALUES ('relation between drugs and cancer','25/6/2017','H13','1','Shaher')

INSERT INTO Publication( title, date, place, accepted, host) -- Publication 3 has Thesis 15
VALUES ('Influence of Postpartum Contraception Uptake','25/2/2015','H3','0','Salma Tammam')

INSERT INTO ThesisHasPublication(serialNo, pubid)
VALUES (10,1)

INSERT INTO ThesisHasPublication(serialNo, pubid)
VALUES (13,2)

INSERT INTO ThesisHasPublication(serialNo, pubid)
VALUES (15,3)