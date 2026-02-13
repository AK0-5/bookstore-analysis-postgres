DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * from Books 
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * from Books
WHERE published_year > 1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers
WHERE country='Canada';

-- 4) Show orders placed in November 2023:
SELECT * from Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) as Total_Stocks from Books;

-- 6) Find the details of the most expensive book:
SELECT * from Books
ORDER BY price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * from Orders where total_amount > 20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre from Books;

-- 10) Find the book with the lowest stock:
SELECT * from Books
ORDER BY stock limit 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) as Revenue 
from Orders;

-- 12) Retrieve the total number of books sold for each genre:
SELECT genre, SUM(Quantity) as Total_Books_sold
FROM Orders
JOIN Books
on Orders.book_id=Books.book_id
GROUP BY Genre;

-- 13) Find the average price of books in the "Fantasy" genre:
SELECT ROUND(AVG(price),2) as Average_Price
FROM Books
WHERE Genre='Fantasy';

-- 14) List customers who have placed at least 2 orders:
SELECT orders.customer_id,customers.name,
COUNT(orders.order_id) as Order_count
FROM ORDERS
JOIN Customers 
ON Orders.customer_id=Customers.customer_id
GROUP BY Orders.customer_id,Customers.name
HAVING COUNT(Orders.order_id)>=2;

-- 15) Find the most frequently ordered book:
SELECT orders.Book_id,Books.title,COUNT(orders.order_id) as ORDER_COUNT
FROM Orders
JOIN Books
ON Orders.book_id=Books.book_id
GROUP BY orders.Book_id,Books.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 16) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * from Books
WHERE Genre='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 17) Retrieve the total quantity of books sold by each author:
SELECT Books.author,SUM(orders.quantity) as Total_Quantity 
from Books
JOIN Orders
ON Books.book_id=Orders.book_id
GROUP BY Books.author;

-- 18) List the cities where customers who spent over $30 are located:

SELECT Customers.name,Customers.city,total_amount
FROM Orders
JOIN Customers ON
Orders.customer_id=Customers.customer_id
WHERE orders.total_amount>30
GROUP BY Customers.name,city,orders.total_amount

-- 19) Find the customer who spent the most on orders:

SELECT customers.name,customers.customer_id,SUM(orders.total_amount) as Total_Spend
FROM Orders
JOIN Customers
ON Orders.customer_id=Customers.customer_id
GROUP by Customers.name,Customers.customer_id
ORDER BY Total_Spend DESC LIMIT 1;

--20) Calculate the stock remaining after fulfilling all orders:

SELECT books.book_id,books.title,books.stock,
COALESCE(SUM(orders.quantity)) AS Order_quantity,
Books.stock-COALESCE(SUM(orders.quantity)) as Remaining_Quantity
FROM Books 
JOIN Orders
on Books.book_id=Orders.book_id
GROUP BY Books.book_id
ORDER BY Books.book_id;