DROP DATABASE IF EXISTS group5_library;
CREATE DATABASE group5_library;
USE group5_library;
CREATE TABLE User (
    email       VARCHAR(100) PRIMARY KEY,
    firstName   VARCHAR(50)  NOT NULL,
    lastName    VARCHAR(50)  NOT NULL,
    phone       VARCHAR(20),
    password    VARCHAR(255) NOT NULL
);
CREATE TABLE Admin (
    adminID INT NOT NULL,
    email   VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (adminID),
    CONSTRAINT fk_admin_user
        FOREIGN KEY (email)
        REFERENCES User(email)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE Member (
    memberID INT NOT NULL,
    email    VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (memberID),
    CONSTRAINT fk_member_user
        FOREIGN KEY (email)
        REFERENCES User(email)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE BookInfo (
    ISBN        VARCHAR(20),
    Title       VARCHAR(200) NOT NULL,
    Author      VARCHAR(100) NOT NULL,
    Description TEXT,
    PRIMARY KEY (ISBN)
);
CREATE TABLE Book (
    bookID          INT NOT NULL,
    ISBN            VARCHAR(20) NOT NULL,
    availableCopies INT         NOT NULL DEFAULT 0,
    adminID         INT NULL,
    PRIMARY KEY (bookID),
    CONSTRAINT fk_book_bookinfo
        FOREIGN KEY (ISBN)
        REFERENCES BookInfo(ISBN)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_book_admin
        FOREIGN KEY (adminID)
        REFERENCES Admin(adminID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
CREATE TABLE BorrowingInfo (
    rentID    INT NOT NULL,
    bookID    INT NOT NULL,
    memberID    INT NOT NULL,   
    startDate DATE NOT NULL,
    dueDate   DATE NOT NULL,
    PRIMARY KEY (rentID),
    KEY idx_borrow_book (bookID),
    KEY idx_borrow_member (memberID),
    CONSTRAINT fk_borrow_book
        FOREIGN KEY (bookID)
        REFERENCES Book(bookID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_borrow_member
        FOREIGN KEY (memberID)
        REFERENCES Member(memberID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
CREATE TABLE ReturningInfo (
    rentID        INT,
    bookID        INT NOT NULL,
    memberID        INT NOT NULL,
    endDate       DATE        NOT NULL,
    calculatedFee DECIMAL(6,2) DEFAULT 0,
    PRIMARY KEY (rentID),
    CONSTRAINT fk_return_rent
        FOREIGN KEY (rentID)
        REFERENCES BorrowingInfo(rentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_return_book
        FOREIGN KEY (bookID)
        REFERENCES Book(bookID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_return_member
        FOREIGN KEY (memberID)
        REFERENCES Member(memberID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
CREATE TABLE Donation (
    donationID   INT        Not NUll,
    memberID     INT        NOT NULL,
    donationDate DATE       NOT NULL,
    status       ENUM('Pending','Accepted','Rejected')
                 NOT NULL DEFAULT 'Pending',
    ISBN         VARCHAR(20) NULL,
    PRIMARY KEY (donationID),
    CONSTRAINT fk_donation_member
        FOREIGN KEY (memberID)
        REFERENCES Member(memberID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_donation_bookinfo
        FOREIGN KEY (ISBN)
        REFERENCES BookInfo(ISBN)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);



