

------------------------------------------------------------
-- Task 1:
-- Insert ONE new donation with status 'Pending'.
------------------------------------------------------------

INSERT INTO Donation (donationID, memberID, donationDate, status, ISBN)
VALUES (604, 1, CURRENT_DATE, 'Pending', '978000002317');


------------------------------------------------------------
-- Task 2:
-- Work ONLY on this donation (donationID = 10001):
--   1) Change it to 'Accepted'
--   2) If ISBN already exists in our system → +1 availableCopies
------------------------------------------------------------

-- 2a) Change ONLY this donation from Pending to Accepted
UPDATE Donation
SET status = 'Accepted'
WHERE donationID = 604
  AND status = 'Pending';


-- 2b) Increase availableCopies ONLY if this ISBN already exists in Book
UPDATE Book
SET availableCopies = availableCopies + 1
WHERE ISBN = '978000002317'
  AND EXISTS (
        SELECT 1
        FROM Donation AS d
        WHERE d.donationID = 604
          AND d.status = 'Accepted'
          AND d.ISBN = Book.ISBN
      );


------------------------------------------------------------
-- Task 3:
-- Admin adds a completely NEW book that was not in the system.
------------------------------------------------------------

-- 3a) New BookInfo (brand new ISBN not used before)
INSERT INTO BookInfo (ISBN, Title, Author, Description)
VALUES (
    '988999999999',
    'New Admin Book',
    'Admin Author',
    'Book added manually by an administrator.'
);

-- 3b) New Book row referencing that BookInfo
INSERT INTO Book (bookID,ISBN, availableCopies, adminID)
VALUES (
     '4001',
    '988999999999',
    3,      -- initial number of copies
    1       -- an existing adminID
);


