-- Project TASK
-- ### 2. CRUD Operations

select * from books;

select * from branch;

select * from employees;

select * from issued_status;

select * from return_status;

select * from members;

-- Task 1. Create a New Book Record
-- '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO
    books (
        isbn,
        book_title,
        category,
        rental_price,
        status,
        author,
        publisher
    )
VALUES (
        '978-1-60129-456-2',
        'To Kill a Mockingbird',
        'Classic',
        6.00,
        'yes',
        'Harper Lee',
        'J.B. Lippincott & Co.'
    );

-- Task 2: Update an Existing Member's Address
update members
set
    member_address = '23 Joshi Colony,Kj'
where
    member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.

delete from issued_status where issued_id = 'IS136';

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status where issued_emp_id = 'E104';

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
select
    issued_emp_id,
    count(*) as total_books_issued
from issued_status
group by
    issued_emp_id
having
    total_books_issued > 1;

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

drop table if exists book_issued_count;

create table book_issued_count as
select b.isbn, b.book_title, count(i.issued_id) as issued_count
from issued_status as i
    join books as b on i.issued_book_isbn = b.isbn
group by
    b.isbn,
    b.book_title;

select * from book_issued_count;

-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:
select * from books where category = 'horror';

-- Task 8: Find Total Rental Income by Category:
select category, sum(rental_price) as total_rental_income
from books
group by
    category;

-- Task 9. **List Members Who Registered in the Last 1 year**:

select *
from members
where
    reg_date >= date_sub(CURRENT_DATE, interval 1 year);

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:
select e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name as manager_name
from
    employees as e1
    join branch as b on e1.branch_id = b.branch_id
    join employees as e2 on b.manager_id = e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold
create table expensive_books as
select *
from books
where
    rental_price > 7;

select * from expensive_books;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT *
FROM
    issued_status as i
    LEFT JOIN return_status as r ON r.issued_id = i.issued_id
WHERE
    r.return_id IS NULL;

select * from return_status;

### Advanced SQL Operations

-- Task 13: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
create table branch_report as
SELECT
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM
    issued_status as ist
    JOIN employees as e ON e.emp_id = ist.issued_emp_id
    JOIN branch as b ON e.branch_id = b.branch_id
    LEFT JOIN return_status as rs ON rs.issued_id = ist.issued_id
    JOIN books as bk ON ist.issued_book_isbn = bk.isbn
GROUP BY
    1,
    2;

select * from branch_report;

-- Task 14: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 6 months.

create table active_members as
select *
from members
where
    member_id in (
        select distinct
            issued_member_id
        from issued_status
        where
            issued_date >= DATE_SUB(CURRENT_DATE, INTERVAL 24 DAY)
    );

select * from active_members;

-- Task 15: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

SELECT e.emp_name, b.branch_id, COUNT(i.issued_id) as most_book_issued
FROM
    issued_status as i
    JOIN employees as e ON e.emp_id = i.issued_emp_id
    JOIN branch as b ON e.branch_id = b.branch_id
GROUP BY
    e.emp_name,
    b.branch_id
order by most_book_issued desc
limit 3;

select * from branch;

