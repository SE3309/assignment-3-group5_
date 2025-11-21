------------------------------------------------------------
-- 1) Single-row INSERT
------------------------------------------------------------
INSERT INTO User (email, firstName, lastName, phone, password)
VALUES ('test_single@example.com', 'Single', 'Insert', '519-000-0000', 'pwd123');
------------------------------------------------------------
-- 2) Multi-row INSERT
------------------------------------------------------------
INSERT INTO User (email, firstName, lastName, phone, password)
VALUES
    ('test_multi1@example.com', 'Multi1', 'Insert', '519-111-1111', 'pwd111'),
    ('test_multi2@example.com', 'Multi2', 'Insert', '519-222-2222', 'pwd222');
------------------------------------------------------------
-- 3) INSERT ... SELECT
-- Copy some ISBNs from BookInfo to create Book rows
------------------------------------------------------------
INSERT INTO Book (ISBN, availableCopies, adminID)
SELECT ISBN, 5, 1
FROM BookInfo;
------------------------------------------------------------
-- Show the effect (for screenshots in the report)
------------------------------------------------------------
SELECT email, firstName, lastName, phone, password
FROM User
WHERE email LIKE 'test_%'
ORDER BY email;
SELECT bookID, ISBN, availableCopies, adminID
FROM Book
ORDER BY bookID;

