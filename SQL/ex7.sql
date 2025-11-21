
------------------------------------------------------------
-- View 1: View all books with their author information
------------------------------------------------------------
DROP VIEW IF EXISTS AuthorBooks;
DROP VIEW IF EXISTS MemberBorrowHistory;


CREATE VIEW AuthorBooks AS
SELECT
    b.bookID,
    bi.ISBN,
    bi.Title,
    bi.Author,
    b.availableCopies,
    b.adminID
FROM Book AS b
JOIN BookInfo AS bi
    ON b.ISBN = bi.ISBN;


------------------------------------------------------------
-- Example query on View 1:
-- Show all books authored by a CERTAIN AUTHOR.
-- Replace 'Author Smith' with any actual author in your data.
------------------------------------------------------------

SELECT
    bookID,
    ISBN,
    Title,
    Author,
    availableCopies,
    adminID
FROM AuthorBooks
WHERE Author = 'Author Smith';


------------------------------------------------------------
-- View 2: View all books a certain Member has borrowed before
------------------------------------------------------------

CREATE VIEW MemberBorrowHistory AS
SELECT
    br.rentID,
    m.memberID,
    u.firstName,
    u.lastName,
    bi.Title,
    br.startDate,
    br.dueDate
FROM BorrowingInfo AS br
JOIN Member AS m
    ON br.memberID = m.memberID
JOIN User AS u
    ON m.email = u.email
JOIN Book AS b
    ON br.bookID = b.bookID
JOIN BookInfo AS bi
    ON b.ISBN = bi.ISBN;


------------------------------------------------------------
-- Example query on View 2:
-- Show all books borrowed by a CERTAIN MEMBER.
-- Replace 1 with an actual memberID from your data.
------------------------------------------------------------

SELECT
    rentID,
    memberID,
    firstName,
    lastName,
    Title,
    startDate,
    dueDate
FROM MemberBorrowHistory
WHERE memberID = 1;


------------------------------------------------------------
-- Test updatability: try inserting into each view.
-- These statements are EXPECTED to FAIL in a standards-compliant
-- implementation, because both views are defined over joins of
-- multiple base tables.
------------------------------------------------------------
INSERT INTO AuthorBooks (bookID, ISBN, Title, Author, availableCopies, adminID)
VALUES (4002, '979999999999', 'New Test Title', 'New Test Author', 5, 1);

INSERT INTO MemberBorrowHistory
    (rentID, memberID, firstName, lastName, Title, startDate, dueDate)
VALUES
    (9999, 1, 'TestFirst', 'TestLast', 'Test Borrow Title',
     DATE '2024-01-01', DATE '2024-01-15');






