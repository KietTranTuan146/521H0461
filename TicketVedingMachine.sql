Create Database TicketVendingMachine
use TicketVendingMachine

CREATE FUNCTION auto_passId()
RETURNS int
AS
BEGIN
	DECLARE @ID int
	IF (SELECT COUNT(passId) FROM Passenger) = 0
		SET @ID = 0
	ELSE
		SELECT @ID = MAX(passId) FROM Passenger
		SELECT @ID = @ID + 1
	RETURN @ID
END

CREATE FUNCTION auto_ticketId()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(ticketId) FROM Ticket) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(ticketId, 3)) FROM Ticket
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'TK00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'TK0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END

create table Ticket(
	ticketId varchar(5) primary key constraint auto_TC default dbo.auto_ticketId(),
	passId int,
	desId int,
	payId char(5),
)

Create table Destination (
	desId int primary key,
	desname varchar(50),
)

create table Passenger(
	passId int primary key constraint auto_PC default dbo.auto_passId(),
	desId int, 
	constraint fk_passenger_desId foreign key (desId)
	references Destination (desId)
)

create table Payment(
	payId char(5) primary key,
	paymethod varchar(30),
)

alter table ticket add constraint fk_ticket_desId foreign key (desId) references Destination (desId)
alter table ticket add constraint fk_ticket_passId foreign key (passId) references Passenger (passId)
alter table ticket add constraint fk_ticket_payId foreign key (payId) references Payment (payId)



insert into Payment values ('PAYCD', 'Pay by Credit Card')
insert into Payment values ('PAYOW', 'Pay by Online Wallet')

insert into Destination values('01', 'Dai Hoc Ton Duc Thang')
insert into Destination values('02', 'Dai Hoc RMIT')
insert into Destination values('03', 'Dai Hoc Canh Sat Nhan Dan')
insert into Destination values('04', 'Dai Hoc Tai Chinh Marketing')
insert into Destination values('05', 'Lotte Mart')
insert into Destination values('06', 'Dai Hoc Han Quoc UBOL')
insert into Destination values('07', 'Nguyen Thi Thap')
insert into Destination values('08', 'Cau Phu My')


SELECT TOP 1 * FROM Destination ORDER BY desId DESC