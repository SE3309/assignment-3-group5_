import random
from datetime import date, timedelta

# ================== CONFIG ==================
NUM_ADMINS = 20          # ~tens
NUM_MEMBERS = 2000       # thousands
NUM_BOOKINFO = 4000      # thousands
NUM_BOOKS = 4000         # thousands
NUM_BORROWINGS = 8000    # thousands
RETURN_RATIO = 0.6       # 60% of borrowings have a return
NUM_DONATIONS = 600      # hundreds

OUTPUT_FILE = "generated_data.sql"
DB_NAME = "group5_library"   # must match your ex2.sql

FIRST_NAMES = [
    "Alice", "Bob", "Carol", "David", "Emma", "Frank", "Grace", "Hannah",
    "Ivan", "Julia", "Kevin", "Lily", "Mike", "Nora", "Oscar", "Paula",
    "Quinn", "Rita", "Sam", "Tina"
]

LAST_NAMES = [
    "Smith", "Johnson", "Brown", "Lee", "Wilson", "Garcia", "Miller",
    "Davis", "Martinez", "Taylor", "Clark", "Walker", "Hall", "Allen", "Young"
]


# ================== HELPERS ==================

def random_name():
    return random.choice(FIRST_NAMES), random.choice(LAST_NAMES)


def random_phone():
    return f"519-{random.randint(100, 999)}-{random.randint(1000, 9999)}"


def random_date(start_year=2022, end_year=2024):
    start = date(start_year, 1, 1)
    end = date(end_year, 12, 31)
    return start + timedelta(days=random.randint(0, (end - start).days))


# ================== MAIN ==================

def main():
    random.seed(42)

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        # Use your DB - NO CREATE TABLE here
        f.write(f"USE {DB_NAME};\n\n")

        # ---------- 1. User ----------
        print("Generating INSERTs for User...")
        user_rows = []
        admin_emails = []
        member_emails = []

        # Admin users
        for i in range(1, NUM_ADMINS + 1):
            fn, ln = random_name()
            email = f"admin{i}@example.com"
            phone = random_phone()
            pwd = f"admin{i}_pwd"
            admin_emails.append(email)
            user_rows.append((email, fn, ln, phone, pwd))

        # Member users
        for i in range(1, NUM_MEMBERS + 1):
            fn, ln = random_name()
            email = f"member{i}@example.com"
            phone = random_phone()
            pwd = f"member{i}_pwd"
            member_emails.append(email)
            user_rows.append((email, fn, ln, phone, pwd))

        # PK check: email unique
        assert len({u[0] for u in user_rows}) == len(user_rows), "Duplicate emails in User!"

        f.write("-- Insert into User\n")
        for email, fn, ln, phone, pwd in user_rows:
            f.write(
                "INSERT INTO User (email, firstName, lastName, phone, password) "
                f"VALUES ('{email}', '{fn}', '{ln}', '{phone}', '{pwd}');\n"
            )
        f.write("\n")

        # ---------- 2. Admin ----------
        print("Generating INSERTs for Admin...")
        admin_rows = []
        for admin_id, email in enumerate(admin_emails, start=1):
            admin_rows.append((admin_id, email))

        # PK + FK checks
        assert len(set(a[0] for a in admin_rows)) == NUM_ADMINS, "Admin IDs not unique!"
        user_email_set = {u[0] for u in user_rows}
        assert all(email in user_email_set for (_, email) in admin_rows), "Admin email FK broken!"

        f.write("-- Insert into Admin\n")
        for admin_id, email in admin_rows:
            f.write(
                "INSERT INTO Admin (adminID, email) "
                f"VALUES ({admin_id}, '{email}');\n"
            )
        f.write("\n")

        # ---------- 3. Member ----------
        print("Generating INSERTs for Member...")
        member_rows = []
        for member_id, email in enumerate(member_emails, start=1):
            member_rows.append((member_id, email))

        assert len(set(m[0] for m in member_rows)) == NUM_MEMBERS, "Member IDs not unique!"
        assert all(email in user_email_set for (_, email) in member_rows), "Member email FK broken!"

        f.write("-- Insert into Member\n")
        for member_id, email in member_rows:
            f.write(
                "INSERT INTO Member (memberID, email) "
                f"VALUES ({member_id}, '{email}');\n"
            )
        f.write("\n")

        # ---------- 4. BookInfo ----------
        print("Generating INSERTs for BookInfo...")
        isbn_list = []
        f.write("-- Insert into BookInfo\n")
        for i in range(1, NUM_BOOKINFO + 1):
            isbn = f"978{str(i).zfill(9)}"   # e.g. 978000000001
            title = f"Book Title {i}"
            author = f"Author {random.choice(LAST_NAMES)}"
            desc = f"Description for book {i}"
            isbn_list.append(isbn)
            f.write(
                "INSERT INTO BookInfo (ISBN, Title, Author, Description) "
                f"VALUES ('{isbn}', '{title}', '{author}', '{desc}');\n"
            )
        f.write("\n")

        assert len(set(isbn_list)) == NUM_BOOKINFO, "Duplicate ISBNs in BookInfo!"

        # ---------- 5. Book ----------
        print("Generating INSERTs for Book...")
        assert NUM_BOOKS <= NUM_BOOKINFO, "NUM_BOOKS cannot exceed NUM_BOOKINFO!"
        book_rows = []
        f.write("-- Insert into Book\n")
        for book_id in range(1, NUM_BOOKS + 1):
            isbn = isbn_list[book_id - 1]
            copies = random.randint(1, 20)
            admin_id = random.randint(1, NUM_ADMINS)
            book_rows.append((book_id, isbn, copies, admin_id))
            f.write(
                "INSERT INTO Book (bookID, ISBN, availableCopies, adminID) "
                f"VALUES ({book_id}, '{isbn}', {copies}, {admin_id});\n"
            )
        f.write("\n")

        assert len(set(b[0] for b in book_rows)) == NUM_BOOKS, "Book IDs not unique!"

        # ---------- 6. BorrowingInfo ----------
        print("Generating INSERTs for BorrowingInfo...")
        borrow_rows = []  # (rentID, bookID, memberID, startDate, dueDate)
        f.write("-- Insert into BorrowingInfo\n")
        for rent_id in range(1, NUM_BORROWINGS + 1):
            member_id = random.randint(1, NUM_MEMBERS)
            book_id = random.randint(1, NUM_BOOKS)
            start = random_date(2023, 2024)
            due = start + timedelta(days=14)
            borrow_rows.append((rent_id, book_id, member_id, start, due))
            f.write(
                "INSERT INTO BorrowingInfo (rentID, bookID, memberID, startDate, dueDate) "
                f"VALUES ({rent_id}, {book_id}, {member_id}, "
                f"'{start.isoformat()}', '{due.isoformat()}');\n"
            )
        f.write("\n")

        rent_ids = [r[0] for r in borrow_rows]
        assert len(set(rent_ids)) == NUM_BORROWINGS, "Rent IDs not unique in BorrowingInfo!"
        assert all(1 <= r[1] <= NUM_BOOKS for r in borrow_rows), "BorrowingInfo.bookID FK broken!"
        assert all(1 <= r[2] <= NUM_MEMBERS for r in borrow_rows), "BorrowingInfo.memberID FK broken!"

        # ---------- 7. ReturningInfo ----------
        print("Generating INSERTs for ReturningInfo...")
        f.write("-- Insert into ReturningInfo\n")
        return_count = int(NUM_BORROWINGS * RETURN_RATIO)
        returned_borrows = random.sample(borrow_rows, return_count)
        returning_rent_ids = set()

        for rentID, bookID, memberID, startDate, dueDate in returned_borrows:
            due = dueDate
            days_offset = random.randint(-2, 10)
            endDate = due + timedelta(days=days_offset)
            fee = max(0, (endDate - due).days) * 1.0
            returning_rent_ids.add(rentID)

            f.write(
                "INSERT INTO ReturningInfo (rentID, bookID, memberID, endDate, calculatedFee) "
                f"VALUES ({rentID}, {bookID}, {memberID}, "
                f"'{endDate.isoformat()}', {fee:.2f});\n"
            )
        f.write("\n")

        assert len(returning_rent_ids) == return_count, "Duplicate rentID in ReturningInfo!"
        assert returning_rent_ids.issubset(set(rent_ids)), "ReturningInfo.rentID FK broken!"

        # ---------- 8. Donation ----------
        print("Generating INSERTs for Donation...")
        f.write("-- Insert into Donation\n")
        statuses = ["Pending", "Accepted", "Rejected"]
        for donation_id in range(1, NUM_DONATIONS + 1):
            member_id = random.randint(1, NUM_MEMBERS)
            donation_date = random_date(2022, 2024).isoformat()
            status = random.choice(statuses)
            isbn = random.choice(isbn_list)   # always valid ISBN
            f.write(
                "INSERT INTO Donation (donationID, memberID, donationDate, status, ISBN) "
                f"VALUES ({donation_id}, {member_id}, "
                f"'{donation_date}', '{status}', '{isbn}');\n"
            )
        f.write("\n")

    print(f"Done! Generated data-only SQL file: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()


