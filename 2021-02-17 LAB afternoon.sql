use sakila;

#total business done by each store

#query
select s.store_id, sum(p.amount) from payment as p
join staff as s
using (staff_id)
group by s.store_id;

#stored procedure
drop procedure if exists total_business;

delimiter //
create procedure total_business()
begin
select s.store_id, sum(p.amount) as total_business from payment as p
join staff as s
using (staff_id)
group by s.store_id;
end;
//
delimiter ;

call total_business;

#Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists total_business_input;

delimiter //
create procedure total_business_input(in param1 int)
begin
select sum(p.amount) as total_business, s.store_id from payment as p
join staff as s
using (staff_id)
where store_id=param1
group by s.store_id;
end;
//
delimiter ;

call total_business_input(2);

#Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
#Call the stored procedure and print the results.

drop procedure if exists total_business_output;

delimiter //
create procedure total_business_output(in param1 int, out param2 float, out param3 int)
begin
declare total_sales_value float default 0.0;

select sum(p.amount) into total_sales_value from payment as p
join staff as s
using (staff_id)
where store_id=param1
group by s.store_id;
select total_sales_value into param2;
select param1 into param3;
end;
//
delimiter ;

call total_business_output(2,@x,@z);
select @x as total_sales_value, @z;

#other appoach
drop procedure if exists task4;

delimiter //
create procedure task4 (in param1 int(1), out total_sales_value float(50))
begin
declare store int(1);
	select a.store_id as Store, sum(p.amount) as Amount from payment as p
	join staff as a
	using (staff_id)
    where a.store_id = param1
	group by a.store_id;
end;
// delimiter ;

call task4(1,@x); #just calling not saving
select @x;

#In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
#Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
 
drop procedure if exists flag;

delimiter //
create procedure flag (in param1 int(1), out param2 int, out param3 float(50), out param4 varchar(20))
begin
declare flag varchar(50);
declare total_sales_value float DEFAULT 0.0;

	select round(sum(p.amount),2) into total_sales_value from payment as p
	join staff as a
	using (staff_id)
    where a.store_id = param1
	group by a.store_id;
    
    select total_sales_value;
    case 
		when total_sales_value > 30000 then
			set flag = 'green_flag';
		else
			set flag = 'red_flag';
	end case;
    
    select param1 into param2;
    select total_sales_value into param3;
	select flag into param4;
    
end;
// delimiter ;

call flag(2, @x, @y, @z);
select @x as Store_id, round(@y,2) as total_sales_value, @z as flag;