USE group5_library;

------------------------------------------------------------
-- Query 1:
-- List all books with their title, author, and available copies
-- (JOIN Book ↔ BookInfo)
------------------------------------------------------------
SELECT 
    b.bookID,
    b.ISBN,
    bi.Title,
    bi.Author,
    b.availableCopies
FROM Book b
JOIN BookInfo bi ON b.ISBN = bi.ISBN;

------------------------------------------------------------
-- Query 2:
-- Show all borrowing events with member name and book title
-- (JOIN BorrowingInfo ↔ Member ↔ User ↔ Book ↔ BookInfo)
------------------------------------------------------------
SELECT 
    br.rentID,
    m.memberID,
    u.firstName,
    u.lastName,
    bi.Title,
    br.startDate,
    br.dueDate
FROM BorrowingInfo br
JOIN Member m      ON br.memberID = m.memberID
JOIN User u        ON m.email     = u.email
JOIN Book b        ON br.bookID   = b.bookID
JOIN BookInfo bi   ON b.ISBN      = bi.ISBN;


------------------------------------------------------------
-- Query 3:
-- Find overdue borrowings that have NOT yet been returned
-- (dueDate < today AND no ReturningInfo row)
------------------------------------------------------------
SELECT 
    br.rentID,
    m.memberID,
    u.firstName,
    u.lastName,
    bi.Title,
    br.dueDate
FROM BorrowingInfo br
JOIN Member m      ON br.memberID = m.memberID
JOIN User u        ON m.email     = u.email
JOIN Book b        ON br.bookID   = b.bookID
JOIN BookInfo bi   ON b.ISBN      = bi.ISBN
LEFT JOIN ReturningInfo r ON r.rentID = br.rentID
WHERE br.dueDate < CURDATE()
  AND r.rentID IS NULL;
  
  
------------------------------------------------------------
-- 4 Count how many books each member has borrowed
------------------------------------------------------------
SELECT 
    m.memberID,
    u.firstName,
    u.lastName,
    COUNT(br.rentID) AS totalBorrowed
FROM Member AS m
JOIN User AS u ON m.email = u.email
LEFT JOIN BorrowingInfo AS br ON br.memberID = m.memberID
GROUP BY m.memberID, u.firstName, u.lastName
ORDER BY totalBorrowed DESC, m.memberID;


------------------------------------------------------------
-- 5) Accepted donations with member name and book title (if known)
------------------------------------------------------------
SELECT 
    d.donationID,
    m.memberID,
    u.firstName,
    u.lastName,
    bi.Title,
    d.status,
    d.donationDate
FROM Donation AS d
JOIN Member AS m  ON d.memberID = m.memberID
JOIN User AS u  ON m.email    = u.email
LEFT JOIN BookInfo AS bi ON d.ISBN = bi.ISBN
WHERE d.status = 'Accepted';

------------------------------------------------------------
-- 6) For each book title, how many times has it been borrowed
------------------------------------------------------------

SELECT 
    bi.Title,
    COUNT(br.rentID) AS timesBorrowed
FROM BookInfo AS bi
JOIN Book AS b
    ON bi.ISBN = b.ISBN
LEFT JOIN BorrowingInfo AS br
    ON br.bookID = b.bookID
GROUP BY bi.Title
ORDER BY timesBorrowed DESC, bi.Title;
------------------------------------------------------------
-- 7)List the BookInfo (Title, Author, ISBN) of books that have NEVER been borrowed
------------------------------------------------------------

SELECT 
    bi.ISBN,
    bi.Title,
    bi.Author
FROM BookInfo AS bi
WHERE NOT EXISTS (
    SELECT 1
    FROM Book AS b
    JOIN BorrowingInfo AS br
        ON br.bookID = b.bookID
    WHERE b.ISBN = bi.ISBN
);

