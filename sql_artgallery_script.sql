
Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> CREATE PLUGGABLE DATABASE thurs_26963_artgallery_db
  2  ADMIN USER Fulgence IDENTIFIED BY Fulgence
  3  FILE_NAME_CONVERT = ('C:\oracle21c\oradata\ORCL\pdbseed',
  4                       'C:\oradata\ORCL\orclpdb\thursd_26963_artgallery_db');

Pluggable database created.

SQL> ALTER PLUGGABLE DATABASE thursd_26963_artgallery_db OPEN READ WRITE;

Pluggable database altered.

SQL> ALTER SESSION SET CONTAINER = thurd_26963_artgallery_db;
SQL> CONNECT sys/Fulgence@localhost:1521/thursd_26963_artgallery_db AS SYSDBA;
Connected.
SQL> GRANT DBA TO Fulgence;

Grant succeeded.

SQL> GRANT CONNECT, RESOURCE TO Fulgence;

Grant succeeded.

SQL> GRANT CREATE SESSION TO Fulgence;

Grant succeeded.


SQL> show pdbs;

    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 ORCLPDB                        MOUNTED
         4 THUR_26963_PDB_ASS1            MOUNTED
         5 THUR_26963_PDB_ASSI            MOUNTED
         6 THUR_26963_ARTGALLERY_DB       MOUNTED
         7 THURS_26963_ARTGALLERY_DB      MOUNTED
         9 THURSD_26963_ARTGALLERY_DB     READ WRITE NO
SQL> ALTER SESSION SET CONTAINER = THURSD_26963_ARTGALLERY_DB;

Session altered.

SQL> CREATE TABLE Artist (
  2      artist_id NUMBER PRIMARY KEY,
  3      full_name VARCHAR2(100) NOT NULL,
  4      bio CLOB,
  5      birth_year NUMBER(4),
  6      contact_email VARCHAR2(100) UNIQUE NOT NULL,
  7      specialization VARCHAR2(50),
  8      created_date DATE DEFAULT SYSDATE
  9  );

Table created.

SQL> CREATE TABLE Curator (
  2      curator_id NUMBER PRIMARY KEY,
  3      full_name VARCHAR2(100) NOT NULL,
  4      email VARCHAR2(100) UNIQUE NOT NULL,
  5      experience_years NUMBER(2) CHECK (experience_years >= 0),
  6      created_date DATE DEFAULT SYSDATE
  7  );

Table created.

SQL> CREATE TABLE Customer (
  2      customer_id NUMBER PRIMARY KEY,
  3      full_name VARCHAR2(100) NOT NULL,
  4      email VARCHAR2(100) UNIQUE NOT NULL,
  5      phone VARCHAR2(20),
  6      address VARCHAR2(200),
  7      created_date DATE DEFAULT SYSDATE
  8  );

Table created.

SQL> CREATE TABLE Artwork (
  2      artwork_id NUMBER PRIMARY KEY,
  3      title VARCHAR2(200) NOT NULL,
  4      artist_id NUMBER NOT NULL,
  5      category VARCHAR2(50),
  6      price NUMBER(10,2) CHECK (price > 0),
  7      creation_year NUMBER(4),
  8      status VARCHAR2(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Sold', 'Reserved')),
  9      description CLOB,
 10      created_date DATE DEFAULT SYSDATE,
 11      FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
 12  );

Table created.

SQL> CREATE TABLE Exhibition (
  2      exhibition_id NUMBER PRIMARY KEY,
  3      title VARCHAR2(200) NOT NULL,
  4      start_date DATE NOT NULL,
  5      end_date DATE NOT NULL,
  6      location VARCHAR2(100),
  7      curator_id NUMBER NOT NULL,
  8      created_date DATE DEFAULT SYSDATE,
  9      FOREIGN KEY (curator_id) REFERENCES Curator(curator_id),
 10      CHECK (end_date > start_date)
 11  );

Table created.

SQL> CREATE TABLE Sale (
  2      sale_id NUMBER PRIMARY KEY,
  3      customer_id NUMBER NOT NULL,
  4      artwork_id NUMBER NOT NULL,
  5      sale_date DATE DEFAULT SYSDATE,
  6      final_price NUMBER(10,2) NOT NULL CHECK (final_price > 0),
  7      payment_method VARCHAR2(20) DEFAULT 'Cash',
  8      created_date DATE DEFAULT SYSDATE,
  9      FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
 10      FOREIGN KEY (artwork_id) REFERENCES Artwork(artwork_id)
 11  );

Table created.

SQL> CREATE TABLE Exhibition_Artwork (
  2      exhibition_id NUMBER NOT NULL,
  3      artwork_id NUMBER NOT NULL,
  4      display_position VARCHAR2(50),
  5      featured CHAR(1) DEFAULT 'N' CHECK (featured IN ('Y', 'N')),
  6      PRIMARY KEY (exhibition_id, artwork_id),
  7      FOREIGN KEY (exhibition_id) REFERENCES Exhibition(exhibition_id),
  8      FOREIGN KEY (artwork_id) REFERENCES Artwork(artwork_id)
  9  );

Table created.

SQL> CREATE TABLE Public_Holidays (
  2      holiday_id NUMBER PRIMARY KEY,
  3      holiday_name VARCHAR2(100) NOT NULL,
  4      holiday_date DATE NOT NULL,
  5      month_year VARCHAR2(7) NOT NULL -- Format: MM-YYYY
  6  );

Table created.

SQL> CREATE TABLE Audit_Log (
  2      audit_id NUMBER PRIMARY KEY,
  3      user_id VARCHAR2(50),
  4      table_name VARCHAR2(50),
  5      operation VARCHAR2(10),
  6      operation_date DATE DEFAULT SYSDATE,
  7      status VARCHAR2(20),
  8      details CLOB
  9  );

Table created.

SQL> CREATE SEQUENCE artist_seq START WITH 1 INCREMENT BY 1;

Sequence created.

SQL> CREATE SEQUENCE curator_seq START WITH 1 INCREMENT BY 1;

Sequence created.

SQL> CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;

Sequence created.

SQL> CREATE SEQUENCE artwork_seq START WITH 1 INCREMENT BY 1;

Sequence created.

SQL> CREATE SEQUENCE exhibition_seq START WITH 1 INCREMENT BY 1;

Sequence created.

SQL> CREATE SEQUENCE sale_seq START WITH 1 INCREMENT BY 1;

Sequence created.

SQL> CREATE SEQUENCE holiday_seq START WITH 1 INCREMENT BY 1;

Sequence created.

SQL> CREATE SEQUENCE audit_seq START WITH 1 INCREMENT BY 1;

Sequence created.

SQL> -- Insert Sample Artists
SQL> INSERT INTO Artist VALUES (artist_seq.NEXTVAL, 'Vincent van Gogh', 'Dutch post-impressionist painter known for vivid colors and emotional honesty', 1853, 'vincent@example.com', 'Post-Impressionism', SYSDATE);

1 row created.

SQL> INSERT INTO Artist VALUES (artist_seq.NEXTVAL, 'Pablo Picasso', 'Spanish painter, sculptor, and co-founder of Cubism', 1881, 'pablo@example.com', 'Cubism', SYSDATE);

1 row created.

SQL> INSERT INTO Artist VALUES (artist_seq.NEXTVAL, 'Claude Monet', 'French impressionist painter and founder of French Impressionist painting', 1840, 'claude@example.com', 'Impressionism', SYSDATE);

1 row created.

SQL> INSERT INTO Artist VALUES (artist_seq.NEXTVAL, 'Leonardo da Vinci', 'Italian Renaissance polymath in multiple fields', 1452, 'leonardo@example.com', 'Renaissance', SYSDATE);

1 row created.

SQL> INSERT INTO Artist VALUES (artist_seq.NEXTVAL, 'Frida Kahlo', 'Mexican artist known for self-portraits and surrealist works', 1907, 'frida@example.com', 'Surrealism', SYSDATE);

1 row created.

SQL>
SQL> -- Insert Sample Curators
SQL> INSERT INTO Curator VALUES (curator_seq.NEXTVAL, 'Sarah Johnson', 'sarah.johnson@gallery.com', 15, SYSDATE);

1 row created.

SQL> INSERT INTO Curator VALUES (curator_seq.NEXTVAL, 'Michael Chen', 'michael.chen@gallery.com', 8, SYSDATE);

1 row created.

SQL> INSERT INTO Curator VALUES (curator_seq.NEXTVAL, 'Elena Rodriguez', 'elena.rodriguez@gallery.com', 12, SYSDATE);

1 row created.

SQL>
SQL> -- Insert Sample Customers
SQL> INSERT INTO Customer VALUES (customer_seq.NEXTVAL, 'John Smith', 'john.smith@email.com', '+1-555-0123', '123 Main St, New York', SYSDATE);

1 row created.

SQL> INSERT INTO Customer VALUES (customer_seq.NEXTVAL, 'Emma Wilson', 'emma.wilson@email.com', '+1-555-0124', '456 Oak Ave, Los Angeles', SYSDATE);

1 row created.

SQL> INSERT INTO Customer VALUES (customer_seq.NEXTVAL, 'David Brown', 'david.brown@email.com', '+1-555-0125', '789 Pine Rd, Chicago', SYSDATE);

1 row created.

SQL> INSERT INTO Customer VALUES (customer_seq.NEXTVAL, 'Lisa Garcia', 'lisa.garcia@email.com', '+1-555-0126', '321 Elm St, Miami', SYSDATE);

1 row created.

SQL> INSERT INTO Customer VALUES (customer_seq.NEXTVAL, 'Robert Taylor', 'robert.taylor@email.com', '+1-555-0127', '654 Maple Dr, Seattle', SYSDATE);

1 row created.

SQL>
SQL> -- Insert Sample Artworks
SQL> INSERT INTO Artwork VALUES (artwork_seq.NEXTVAL, 'Starry Night', 1, 'Painting', 15000.00, 1889, 'Available', 'Famous painting depicting swirling night sky', SYSDATE);

1 row created.

SQL> INSERT INTO Artwork VALUES (artwork_seq.NEXTVAL, 'The Persistence of Memory', 2, 'Painting', 25000.00, 1931, 'Available', 'Surrealist painting with melting clocks', SYSDATE);

1 row created.

SQL> INSERT INTO Artwork VALUES (artwork_seq.NEXTVAL, 'Water Lilies', 3, 'Painting', 18000.00, 1919, 'Available', 'Series of oil paintings depicting Monet garden', SYSDATE);

1 row created.

SQL> INSERT INTO Artwork VALUES (artwork_seq.NEXTVAL, 'Mona Lisa Study', 4, 'Drawing', 50000.00, 1503, 'Available', 'Preparatory study for the famous portrait', SYSDATE);

1 row created.

SQL> INSERT INTO Artwork VALUES (artwork_seq.NEXTVAL, 'Self-Portrait with Thorn Necklace', 5, 'Painting', 12000.00, 1940, 'Sold', 'Self-portrait showing Kahlo with hummingbird pendant', SYSDATE);

1 row created.

SQL> INSERT INTO Artwork VALUES (artwork_seq.NEXTVAL, 'Guernica Study', 2, 'Sketch', 8000.00, 1937, 'Available', 'Preliminary sketch for the famous anti-war painting', SYSDATE);

1 row created.

SQL> INSERT INTO Artwork VALUES (artwork_seq.NEXTVAL, 'Sunflowers', 1, 'Painting', 22000.00, 1888, 'Reserved', 'Vibrant painting of sunflowers in a vase', SYSDATE);

1 row created.

SQL> INSERT INTO Artwork VALUES (artwork_seq.NEXTVAL, 'The Last Supper Sketch', 4, 'Drawing', 75000.00, 1495, 'Available', 'Original preparatory drawing', SYSDATE);

1 row created.

SQL>
SQL> -- Insert Sample Exhibitions
SQL> INSERT INTO Exhibition VALUES (exhibition_seq.NEXTVAL, 'Masters of Impressionism', DATE '2025-06-01', DATE '2025-08-31', 'Main Gallery Hall', 1, SYSDATE);

1 row created.

SQL> INSERT INTO Exhibition VALUES (exhibition_seq.NEXTVAL, 'Modern Art Revolution', DATE '2025-07-15', DATE '2025-09-15', 'Contemporary Wing', 2, SYSDATE);

1 row created.

SQL> INSERT INTO Exhibition VALUES (exhibition_seq.NEXTVAL, 'Renaissance Masters', DATE '2025-08-01', DATE '2025-10-31', 'Classical Gallery', 3, SYSDATE);

1 row created.

SQL>
SQL> -- Insert Sample Sales
SQL> INSERT INTO Sale VALUES (sale_seq.NEXTVAL, 1, 5, DATE '2025-05-15', 12000.00, 'Credit Card', SYSDATE);

1 row created.

SQL> INSERT INTO Sale VALUES (sale_seq.NEXTVAL, 2, 5, DATE '2025-05-10', 11500.00, 'Cash', SYSDATE);

1 row created.

SQL>
SQL> -- Insert Exhibition-Artwork Relationships
SQL> INSERT INTO Exhibition_Artwork VALUES (1, 1, 'Center Wall', 'Y');

1 row created.

SQL> INSERT INTO Exhibition_Artwork VALUES (1, 3, 'Left Wall', 'N');

1 row created.

SQL> INSERT INTO Exhibition_Artwork VALUES (2, 2, 'Main Display', 'Y');

1 row created.

SQL> INSERT INTO Exhibition_Artwork VALUES (2, 6, 'Corner Display', 'N');

1 row created.

SQL> INSERT INTO Exhibition_Artwork VALUES (3, 4, 'Premium Section', 'Y');

1 row created.

SQL> INSERT INTO Exhibition_Artwork VALUES (3, 8, 'Study Corner', 'N');

1 row created.

SQL>
SQL> -- Insert Holiday Data for June 2025
SQL> INSERT INTO Public_Holidays VALUES (holiday_seq.NEXTVAL, 'Independence Day', DATE '2025-06-04', '06-2025');

1 row created.

SQL> INSERT INTO Public_Holidays VALUES (holiday_seq.NEXTVAL, 'Labor Day', DATE '2025-06-15', '06-2025');

1 row created.

SQL> INSERT INTO Public_Holidays VALUES (holiday_seq.NEXTVAL, 'National Art Day', DATE '2025-06-25', '06-2025');

1 row created.

SQL>
SQL> COMMIT;

Commit complete.

SQL> CREATE OR REPLACE PROCEDURE get_artist_details(
  2      p_artist_id IN NUMBER,
  3      p_artist_name OUT VARCHAR2,
  4      p_artwork_count OUT NUMBER,
  5      p_total_sales OUT NUMBER
  6  ) AS
  7      CURSOR artist_cursor IS
  8          SELECT a.full_name,
  9                 COUNT(aw.artwork_id) as artwork_count,
 10                 NVL(SUM(s.final_price), 0) as total_sales
 11          FROM Artist a
 12          LEFT JOIN Artwork aw ON a.artist_id = aw.artist_id
 13          LEFT JOIN Sale s ON aw.artwork_id = s.artwork_id
 14          WHERE a.artist_id = p_artist_id
 15          GROUP BY a.full_name;
 16  BEGIN
 17      FOR rec IN artist_cursor LOOP
 18          p_artist_name := rec.full_name;
 19          p_artwork_count := rec.artwork_count;
 20          p_total_sales := rec.total_sales;
 21      END LOOP;
 22  EXCEPTION
 23      WHEN NO_DATA_FOUND THEN
 24          p_artist_name := 'Artist not found';
 25          p_artwork_count := 0;
 26          p_total_sales := 0;
 27      WHEN OTHERS THEN
 28          RAISE_APPLICATION_ERROR(-20001, 'Error fetching artist details: ' || SQLERRM);
 29  END;
 30  /

Procedure created.

SQL> CREATE OR REPLACE PROCEDURE process_artwork_sale(
  2      p_customer_id IN NUMBER,
  3      p_artwork_id IN NUMBER,
  4      p_final_price IN NUMBER,
  5      p_payment_method IN VARCHAR2 DEFAULT 'Cash'
  6  ) AS
  7      v_artwork_status VARCHAR2(20);
  8      v_sale_id NUMBER;
  9  BEGIN
 10      -- Check if artwork is available
 11      SELECT status INTO v_artwork_status
 12      FROM Artwork
 13      WHERE artwork_id = p_artwork_id;
 14
 15      IF v_artwork_status != 'Available' THEN
 16          RAISE_APPLICATION_ERROR(-20002, 'Artwork is not available for sale');
 17      END IF;
 18
 19      -- Insert sale record
 20      INSERT INTO Sale VALUES (
 21          sale_seq.NEXTVAL, p_customer_id, p_artwork_id,
 22          SYSDATE, p_final_price, p_payment_method, SYSDATE
 23      );
 24
 25      -- Update artwork status
 26      UPDATE Artwork
 27      SET status = 'Sold'
 28      WHERE artwork_id = p_artwork_id;
 29
 30      COMMIT;
 31
 32      DBMS_OUTPUT.PUT_LINE('Sale processed successfully for artwork ID: ' || p_artwork_id);
 33  EXCEPTION
 34      WHEN NO_DATA_FOUND THEN
 35          RAISE_APPLICATION_ERROR(-20003, 'Artwork not found');
 36      WHEN OTHERS THEN
 37          ROLLBACK;
 38          RAISE_APPLICATION_ERROR(-20004, 'Error processing sale: ' || SQLERRM);
 39  END;
 40  /

Procedure created.

SQL> CREATE OR REPLACE PROCEDURE get_exhibition_analytics(
  2      p_exhibition_id IN NUMBER
  3  ) AS
  4      CURSOR exhibition_cursor IS
  5          SELECT e.title, e.start_date, e.end_date,
  6                 COUNT(ea.artwork_id) as artwork_count,
  7                 COUNT(CASE WHEN a.status = 'Sold' THEN 1 END) as sold_count,
  8                 NVL(SUM(s.final_price), 0) as total_revenue
  9          FROM Exhibition e
 10          LEFT JOIN Exhibition_Artwork ea ON e.exhibition_id = ea.exhibition_id
 11          LEFT JOIN Artwork a ON ea.artwork_id = a.artwork_id
 12          LEFT JOIN Sale s ON a.artwork_id = s.artwork_id
 13                            AND s.sale_date BETWEEN e.start_date AND e.end_date
 14          WHERE e.exhibition_id = p_exhibition_id
 15          GROUP BY e.title, e.start_date, e.end_date;
 16  BEGIN
 17      FOR rec IN exhibition_cursor LOOP
 18          DBMS_OUTPUT.PUT_LINE('Completed artwork operation at: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
 19          DBMS_OUTPUT.PUT_LINE('Total records processed: ' || audit_records.COUNT);
 20
 21          -- Clear the collection for next operation
 22          audit_records.DELETE;
 23      END AFTER STATEMENT;
 24
 25  END artwork_audit_compound;
 26  /

Warning: Procedure created with compilation errors.

SQL> CREATE OR REPLACE TRIGGER update_artwork_on_sale
  2      AFTER INSERT ON Sale
  3      FOR EACH ROW
  4  BEGIN
  5      UPDATE Artwork
  6      SET status = 'Sold'
  7      WHERE artwork_id = :NEW.artwork_id;
  8
  9      DBMS_OUTPUT.PUT_LINE('Artwork ' || :NEW.artwork_id || ' marked as sold');
 10  END;
 11  /
CREATE OR REPLACE TRIGGER update_artwork_on_sale
                          *
ERROR at line 1:
ORA-04089: cannot create triggers on objects owned by SYS


SQL>
SQL> -- Trigger to prevent deletion of artworks that have been sold
SQL> CREATE OR REPLACE TRIGGER prevent_sold_artwork_deletion
  2      BEFORE DELETE ON Artwork
  3      FOR EACH ROW
  4  DECLARE
  5      v_sale_count NUMBER;
  6  BEGIN
  7      SELECT COUNT(*) INTO v_sale_count
  8      FROM Sale
  9      WHERE artwork_id = :OLD.artwork_id;
 10
 11      IF v_sale_count > 0 THEN
 12          RAISE_APPLICATION_ERROR(-20014, 'Cannot delete artwork that has been sold');
 13      END IF;
 14  END;
 15  /
CREATE OR REPLACE TRIGGER prevent_sold_artwork_deletion
                          *
ERROR at line 1:
ORA-04089: cannot create triggers on objects owned by SYS


SQL> CREATE OR REPLACE TRIGGER update_artwork_on_sale
  2  AFTER INSERT ON Sale
  3  FOR EACH ROW
  4  BEGIN
  5    UPDATE Artwork
  6    SET status = 'Sold'
  7    WHERE artwork_id = :NEW.artwork_id;
  8
  9    DBMS_OUTPUT.PUT_LINE('Artwork ' || :NEW.artwork_id || ' marked as sold');
 10  END;
 11  /
CREATE OR REPLACE TRIGGER update_artwork_on_sale
                          *
ERROR at line 1:
ORA-04089: cannot create triggers on objects owned by SYS


SQL> CREATE OR REPLACE PROCEDURE process_artwork_sale(
  2      p_customer_id IN NUMBER,
  3      p_artwork_id IN NUMBER,
  4      p_final_price IN NUMBER,
  5      p_payment_method IN VARCHAR2 DEFAULT 'Cash'
  6  ) AS
  7      v_artwork_status VARCHAR2(20);
  8      v_sale_id NUMBER;
  9  BEGIN
 10      -- Check if artwork is available
 11      SELECT status INTO v_artwork_status
 12      FROM Artwork
 13      WHERE artwork_id = p_artwork_id;
 14
 15      IF v_artwork_status != 'Available' THEN
 16          RAISE_APPLICATION_ERROR(-20002, 'Artwork is not available for sale');
 17      END IF;
 18
 19      -- Insert sale record
 20      INSERT INTO Sale VALUES (
 21          sale_seq.NEXTVAL, p_customer_id, p_artwork_id,
 22          SYSDATE, p_final_price, p_payment_method, SYSDATE
 23      );
 24
 25      -- Update artwork status
 26      UPDATE Artwork
 27      SET status = 'Sold'
 28      WHERE artwork_id = p_artwork_id;
 29
 30      COMMIT;
 31
 32      DBMS_OUTPUT.PUT_LINE('Sale processed successfully for artwork ID: ' || p_artwork_id);
 33  EXCEPTION
 34      WHEN NO_DATA_FOUND THEN
 35          RAISE_APPLICATION_ERROR(-20003, 'Artwork not found');
 36      WHEN OTHERS THEN
 37          ROLLBACK;
 38          RAISE_APPLICATION_ERROR(-20004, 'Error processing sale: ' || SQLERRM);
 39  END;
 40  /

Procedure created.

SQL> CREATE OR REPLACE PROCEDURE get_artist_details(
  2      p_artist_id IN NUMBER,
  3      p_artist_name OUT VARCHAR2,
  4      p_artwork_count OUT NUMBER,
  5      p_total_sales OUT NUMBER
  6  ) AS
  7      CURSOR artist_cursor IS
  8          SELECT a.full_name,
  9                 COUNT(aw.artwork_id) as artwork_count,
 10                 NVL(SUM(s.final_price), 0) as total_sales
 11          FROM Artist a
 12          LEFT JOIN Artwork aw ON a.artist_id = aw.artist_id
 13          LEFT JOIN Sale s ON aw.artwork_id = s.artwork_id
 14          WHERE a.artist_id = p_artist_id
 15          GROUP BY a.full_name;
 16  BEGIN
 17      FOR rec IN artist_cursor LOOP
 18          p_artist_name := rec.full_name;
 19          p_artwork_count := rec.artwork_count;
 20          p_total_sales := rec.total_sales;
 21      END LOOP;
 22  EXCEPTION
 23      WHEN NO_DATA_FOUND THEN
 24          p_artist_name := 'Artist not found';
 25          p_artwork_count := 0;
 26          p_total_sales := 0;
 27      WHEN OTHERS THEN
 28          RAISE_APPLICATION_ERROR(-20001, 'Error fetching artist details: ' || SQLERRM);
 29  END;
 30  /

Procedure created.

SQL> CREATE OR REPLACE PROCEDURE get_exhibition_analytics(
  2      p_exhibition_id IN NUMBER
  3  ) AS
  4      CURSOR exhibition_cursor IS
  5          SELECT e.title, e.start_date, e.end_date,
  6                 COUNT(ea.artwork_id) as artwork_count,
  7                 COUNT(CASE WHEN a.status = 'Sold' THEN 1 END) as sold_count,
  8                 NVL(SUM(s.final_price), 0) as total_revenue
  9          FROM Exhibition e
 10          LEFT JOIN Exhibition_Artwork ea ON e.exhibition_id = ea.exhibition_id
 11          LEFT JOIN Artwork a ON ea.artwork_id = a.artwork_id
 12          LEFT JOIN Sale s ON a.artwork_id = s.artwork_id
 13                            AND s.sale_date BETWEEN e.start_date AND e.end_date
 14          WHERE e.exhibition_id = p_exhibition_id
 15          GROUP BY e.title, e.start_date, e.end_date;
 16  BEGIN
 17      FOR rec IN exhibition_cursor LOOP
 18          DBMS_OUTPUT.PUT_LINE('Completed artwork operation at: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
 19          DBMS_OUTPUT.PUT_LINE('Total records processed: ' || audit_records.COUNT);
 20
 21          -- Clear the collection for next operation
 22          audit_records.DELETE;
 23      END AFTER STATEMENT;
 24
 25  END artwork_audit_compound;
 26  /

Warning: Procedure created with compilation errors.

SQL> CREATE OR REPLACE TRIGGER update_artwork_on_sale
  2      AFTER INSERT ON Sale
  3      FOR EACH ROW
  4  BEGIN
  5      UPDATE Artwork
  6      SET status = 'Sold'
  7      WHERE artwork_id = :NEW.artwork_id;
  8
  9      DBMS_OUTPUT.PUT_LINE('Artwork ' || :NEW.artwork_id || ' marked as sold');
 10  END;
 11  /
CREATE OR REPLACE TRIGGER update_artwork_on_sale
                          *
ERROR at line 1:
ORA-04089: cannot create triggers on objects owned by SYS


SQL> GRANT CONNECT, RESOURCE TO Fulgence;

Grant succeeded.

SQL> CREATE OR REPLACE TRIGGER update_artwork_on_sale
  2      AFTER INSERT ON Sale
  3      FOR EACH ROW
  4  BEGIN
  5      UPDATE Artwork
  6      SET status = 'Sold'
  7      WHERE artwork_id = :NEW.artwork_id;
  8
  9      DBMS_OUTPUT.PUT_LINE('Artwork ' || :NEW.artwork_id || ' marked as sold');
 10  END;
 11  /
CREATE OR REPLACE TRIGGER update_artwork_on_sale
                          *
ERROR at line 1:
ORA-04089: cannot create triggers on objects owned by SYS


SQL> CREATE OR REPLACE FUNCTION generate_audit_report(
  2      p_start_date DATE,
  3      p_end_date DATE,
  4      p_table_name VARCHAR2 DEFAULT NULL
  5  ) RETURN SYS_REFCURSOR
  6  AS
  7      audit_cursor SYS_REFCURSOR;
  8      v_sql VARCHAR2(4000);
  9  BEGIN
 10      v_sql := 'SELECT audit_id, user_id, table_name, operation,
 11                       operation_date, status, details
 12                FROM Audit_Log
 13                WHERE operation_date BETWEEN :1 AND :2';
 14
 15      IF p_table_name IS NOT NULL THEN
 16          v_sql := v_sql || ' AND table_name = :3';
 17          OPEN audit_cursor FOR v_sql USING p_start_date, p_end_date, p_table_name;
 18      ELSE
 19          OPEN audit_cursor FOR v_sql USING p_start_date, p_end_date;
 20      END IF;
 21
 22      RETURN audit_cursor;
 23  END;
 24  /

Function created.

SQL> CREATE OR REPLACE PROCEDURE cleanup_audit_logs(p_days_old NUMBER DEFAULT 90)
  2  AS
  3      v_deleted_count NUMBER;
  4  BEGIN
  5      DELETE FROM Audit_Log
  6      WHERE operation_date < SYSDATE - p_days_old;
  7
  8      v_deleted_count := SQL%ROWCOUNT;
  9      COMMIT;
 10
 11      DBMS_OUTPUT.PUT_LINE('Deleted ' || v_deleted_count || ' old audit records');
 12  EXCEPTION
 13      WHEN OTHERS THEN
 14          ROLLBACK;
 15          RAISE_APPLICATION_ERROR(-20015, 'Error cleaning audit logs: ' || SQLERRM);
 16  END;
 17  /

Procedure created.

SQL> CREATE OR REPLACE PACKAGE security_audit_pkg AS
  2      PROCEDURE generate_security_report(
  3          p_start_date DATE,
  4          p_end_date DATE
  5      );
  6
  7      FUNCTION get_blocked_operations_count(
  8          p_start_date DATE,
  9          p_end_date DATE
 10      ) RETURN NUMBER;
 11
 12      PROCEDURE add_holiday(
 13          p_holiday_name VARCHAR2,
 14          p_holiday_date DATE
 15      );
 16
 17  END security_audit_pkg;
 18  /

Package created.

SQL> CREATE OR REPLACE PACKAGE BODY security_audit_pkg AS
  2
  3      PROCEDURE generate_security_report(
  4          p_start_date DATE,
  5          p_end_date DATE
  6      ) AS
  7          CURSOR security_cursor IS
  8              SELECT table_name, operation, status, COUNT(*) as operation_count
  9              FROM Audit_Log
 10              WHERE operation_date BETWEEN p_start_date AND p_end_date
 11              GROUP BY table_name, operation, status
 12              ORDER BY table_name, operation, status;
 13      BEGIN
 14          DBMS_OUTPUT.PUT_LINE('=== SECURITY AUDIT REPORT ===');
 15          DBMS_OUTPUT.PUT_LINE('Period: ' || TO_CHAR(p_start_date, 'YYYY-MM-DD') ||
 16                             ' to ' || TO_CHAR(p_end_date, 'YYYY-MM-DD'));
 17          DBMS_OUTPUT.PUT_LINE('================================');
 18
 19          FOR rec IN security_cursor LOOP
 20              DBMS_OUTPUT.PUT_LINE('Table: ' || rec.table_name ||
 21                                 ', Operation: ' || rec.operation ||
 22                                 ', Status: ' || rec.status ||
 23                                 ', Count: ' || rec.operation_count);
 24          END LOOP;
 25      END generate_security_report;
 26
 27      FUNCTION get_blocked_operations_count(
 28          p_start_date DATE,
 29          p_end_date DATE
 30      ) RETURN NUMBER AS
 31          v_count NUMBER;
 32      BEGIN
 33          SELECT COUNT(*) INTO v_count
 34          FROM Audit_Log
 35          WHERE operation_date BETWEEN p_start_date AND p_end_date
 36          AND status = 'DENIED';
 37
 38          RETURN v_count;
 39      END get_blocked_operations_count;
 40
 41      PROCEDURE add_holiday(
 42          p_holiday_name VARCHAR2,
 43          p_holiday_date DATE
 44      ) AS
 45          v_month_year VARCHAR2(7);
 46      BEGIN
 47          v_month_year := TO_CHAR(p_holiday_date, 'MM-YYYY');
 48
 49          INSERT INTO Public_Holidays VALUES (
 50              holiday_seq.NEXTVAL,
 51              p_holiday_name,
 52              p_holiday_date,
 53              v_month_year
 54          );
 55          COMMIT;
 56
 57          DBMS_OUTPUT.PUT_LINE('Holiday added: ' || p_holiday_name || ' on ' || TO_CHAR(p_holiday_date, 'YYYY-MM-DD'));
 58      END add_holiday;
 59
 60  END security_audit_pkg;
 61  /

Package body created.

SQL> -- Test security and auditing features
SQL> BEGIN
  2      -- Add more holidays for testing
  3      security_audit_pkg.add_holiday('Gallery Foundation Day', DATE '2025-06-30');
  4
  5      -- Generate security report
  6      security_audit_pkg.generate_security_report(DATE '2025-05-01', SYSDATE);
  7
  8      -- Show blocked operations
  9      DBMS_OUTPUT.PUT_LINE('Blocked operations in May 2025: ' ||
 10                          security_audit_pkg.get_blocked_operations_count(DATE '2025-05-01', DATE '2025-05-31'));
 11  END;
 12  /

PL/SQL procedure successfully completed.

SQL>
SQL> -- Test trigger functionality (this will likely fail due to restrictions)
SQL> -- Only run this on weekends or non-holidays
SQL> BEGIN
  2      INSERT INTO Artwork VALUES (
  3          artwork_seq.NEXTVAL, 'Test Artwork', 1, 'Test', 1000.00,
  4          2025, 'Available', 'Test description', SYSDATE
  5      );
  6      COMMIT;
  7  EXCEPTION
  8      WHEN OTHERS THEN
  9          DBMS_OUTPUT.PUT_LINE('Expected error due to restrictions: ' || SQLERRM);
 10  END;
 11  /

PL/SQL procedure successfully completed.

SQL> CREATE OR REPLACE TRIGGER trg_prevent_sold_artwork_deletion
  2  BEFORE DELETE ON Artwork
  3  FOR EACH ROW
  4  DECLARE
  5      v_exists NUMBER;
  6  BEGIN
  7      SELECT COUNT(*) INTO v_exists
  8      FROM Sale
  9      WHERE artwork_id = :OLD.artwork_id;
 10
 11      IF v_exists > 0 THEN
 12          RAISE_APPLICATION_ERROR(-20014, 'Cannot delete artwork that has already been sold.');
 13      END IF;
 14  END;
 15  /
CREATE OR REPLACE TRIGGER trg_prevent_sold_artwork_deletion
                          *
ERROR at line 1:
ORA-04089: cannot create triggers on objects owned by SYS


SQL>
SQL> ALTER USER FULGENCE QUOTA UNLIMITED ON USERS;
ALTER USER FULGENCE QUOTA UNLIMITED ON USERS
*
ERROR at line 1:
ORA-00959: tablespace 'USERS' does not exist


SQL> GRANT UNLIMITED TABLESPACE TO Fulgence;
GRANT UNLIMITED TABLESPACE TO Fulgence
      *
ERROR at line 1:
ORA-00990: missing or invalid privilege


SQL> GRANT UNLIMITED TABLESPACE TO Fulgence;
GRANT UNLIMITED TABLESPACE TO Fulgence
      *
ERROR at line 1:
ORA-00990: missing or invalid privilege


SQL> -- Comprehensive system validation
SQL> DECLARE
  2      v_total_artists NUMBER;
  3      v_total_artworks NUMBER;
  4      v_total_sales NUMBER;
  5      v_total_revenue NUMBER;
  6      v_audit_records NUMBER;
  7  BEGIN
  8      -- System statistics
  9      SELECT COUNT(*) INTO v_total_artists FROM Artist;
 10      SELECT COUNT(*) INTO v_total_artworks FROM Artwork;
 11      SELECT COUNT(*) INTO v_total_sales FROM Sale;
 12      SELECT SUM(final_price) INTO v_total_revenue FROM Sale;
 13      SELECT COUNT(*) INTO v_audit_records FROM Audit_Log;
 14
 15      DBMS_OUTPUT.PUT_LINE('=== SYSTEM VALIDATION REPORT ===');
 16      DBMS_OUTPUT.PUT_LINE('Total Artists: ' || v_total_artists);
 17      DBMS_OUTPUT.PUT_LINE('Total Artworks: ' || v_total_artworks);
 18      DBMS_OUTPUT.PUT_LINE('Total Sales: ' || v_total_sales);
 19      DBMS_OUTPUT.PUT_LINE('Total Revenue: PUT_LINE('Exhibition: ' || rec.title);
 20          DBMS_OUTPUT.PUT_LINE('Period: ' || rec.start_date || ' to ' || rec.end_date);
 21          DBMS_OUTPUT.PUT_LINE('Total Artworks: ' || rec.artwork_count);
 22          DBMS_OUTPUT.PUT_LINE('Sold During Exhibition: ' || rec.sold_count);
 23          DBMS_OUTPUT.PUT_LINE('Revenue Generated: $' || rec.total_revenue);
 24      END LOOP;
 25  EXCEPTION
 26      WHEN OTHERS THEN
 27          RAISE_APPLICATION_ERROR(-20005, 'Error getting exhibition analytics: ' || SQLERRM);
 28  END;
 29  /
ERROR:
ORA-01756: quoted string not properly terminated


SQL> -- Function to calculate total gallery revenue
SQL> CREATE OR REPLACE FUNCTION calculate_total_revenue
  2  RETURN NUMBER
  3  AS
  4      v_total_revenue NUMBER := 0;
  5  BEGIN
  6      SELECT NVL(SUM(final_price), 0)
  7      INTO v_total_revenue
  8      FROM Sale;
  9
 10      RETURN v_total_revenue;
 11  EXCEPTION
 12      WHEN OTHERS THEN
 13          RETURN 0;
 14  END;
 15  /

Function created.

SQL>
SQL> -- Function to get artist ranking by sales
SQL> CREATE OR REPLACE FUNCTION get_artist_ranking(p_artist_id IN NUMBER)
  2  RETURN NUMBER
  3  AS
  4      v_ranking NUMBER;
  5  BEGIN
  6      WITH artist_sales AS (
  7          SELECT a.artist_id, NVL(SUM(s.final_price), 0) as total_sales
  8          FROM Artist a
  9          LEFT JOIN Artwork aw ON a.artist_id = aw.artist_id
 10          LEFT JOIN Sale s ON aw.artwork_id = s.artwork_id
 11          GROUP BY a.artist_id
 12      ),
 13      ranked_artists AS (
 14          SELECT artist_id,
 15                 RANK() OVER (ORDER BY total_sales DESC) as rank
 16          FROM artist_sales
 17      )
 18      SELECT rank INTO v_ranking
 19      FROM ranked_artists
 20      WHERE artist_id = p_artist_id;
 21
 22      RETURN v_ranking;
 23  EXCEPTION
 24      WHEN NO_DATA_FOUND THEN
 25          RETURN 0;
 26      WHEN OTHERS THEN
 27          RETURN -1;
 28  END;
 29  /

Function created.

SQL>
SQL> -- Function to check artwork availability
SQL> CREATE OR REPLACE FUNCTION is_artwork_available(p_artwork_id IN NUMBER)
  2  RETURN BOOLEAN
  3  AS
  4      v_status VARCHAR2(20);
  5  BEGIN
  6      SELECT status INTO v_status
  7      FROM Artwork
  8      WHERE artwork_id = p_artwork_id;
  9
 10      RETURN (v_status = 'Available');
 11  EXCEPTION
 12      WHEN NO_DATA_FOUND THEN
 13          RETURN FALSE;
 14      WHEN OTHERS THEN
 15          RETURN FALSE;
 16  END;
 17  /

Function created.

SQL> CREATE OR REPLACE FUNCTION get_artist_ranking(p_artist_id IN NUMBER)
  2  RETURN NUMBER
  3  AS
  4      v_ranking NUMBER;
  5  BEGIN
  6      WITH artist_sales AS (
  7          SELECT a.artist_id, NVL(SUM(s.final_price), 0) as total_sales
  8          FROM Artist a
  9          LEFT JOIN Artwork aw ON a.artist_id = aw.artist_id
 10          LEFT JOIN Sale s ON aw.artwork_id = s.artwork_id
 11          GROUP BY a.artist_id
 12      ),
 13      ranked_artists AS (
 14          SELECT artist_id,
 15                 RANK() OVER (ORDER BY total_sales DESC) as rank
 16          FROM artist_sales
 17      )
 18      SELECT rank INTO v_ranking
 19      FROM ranked_artists
 20      WHERE artist_id = p_artist_id;
 21
 22      RETURN v_ranking;
 23  EXCEPTION
 24      WHEN NO_DATA_FOUND THEN
 25          RETURN 0;
 26      WHEN OTHERS THEN
 27          RETURN -1;
 28  END;
 29  /

Function created.

SQL> CREATE OR REPLACE FUNCTION is_artwork_available(p_artwork_id IN NUMBER)
  2  RETURN BOOLEAN
  3  AS
  4      v_status VARCHAR2(20);
  5  BEGIN
  6      SELECT status INTO v_status
  7      FROM Artwork
  8      WHERE artwork_id = p_artwork_id;
  9
 10      RETURN (v_status = 'Available');
 11  EXCEPTION
 12      WHEN NO_DATA_FOUND THEN
 13          RETURN FALSE;
 14      WHEN OTHERS THEN
 15          RETURN FALSE;
 16  END;
 17  /

Function created.

SQL> -- Create Gallery Management Package
SQL> CREATE OR REPLACE PACKAGE gallery_management_pkg AS
  2      -- Procedures
  3      PROCEDURE add_new_artist(
  4          p_name VARCHAR2,
  5          p_bio CLOB,
  6          p_birth_year NUMBER,
  7          p_email VARCHAR2,
  8          p_specialization VARCHAR2
  9      );
 10
 11      PROCEDURE schedule_exhibition(
 12          p_title VARCHAR2,
 13          p_start_date DATE,
 14          p_end_date DATE,
 15          p_location VARCHAR2,
 16          p_curator_id NUMBER
 17      );
 18
 19      -- Functions
 20      FUNCTION get_available_artworks_count RETURN NUMBER;
 21      FUNCTION get_monthly_sales(p_month NUMBER, p_year NUMBER) RETURN NUMBER;
 22
 23  END gallery_management_pkg;
 24  /

Package created.

SQL>
SQL> CREATE OR REPLACE PACKAGE BODY gallery_management_pkg AS
  2
  3      PROCEDURE add_new_artist(
  4          p_name VARCHAR2,
  5          p_bio CLOB,
  6          p_birth_year NUMBER,
  7          p_email VARCHAR2,
  8          p_specialization VARCHAR2
  9      ) AS
 10      BEGIN
 11          INSERT INTO Artist VALUES (
 12              artist_seq.NEXTVAL, p_name, p_bio, p_birth_year,
 13              p_email, p_specialization, SYSDATE
 14          );
 15          COMMIT;
 16          DBMS_OUTPUT.PUT_LINE('Artist added successfully: ' || p_name);
 17      EXCEPTION
 18          WHEN DUP_VAL_ON_INDEX THEN
 19              RAISE_APPLICATION_ERROR(-20006, 'Artist email already exists');
 20          WHEN OTHERS THEN
 21              ROLLBACK;
 22              RAISE_APPLICATION_ERROR(-20007, 'Error adding artist: ' || SQLERRM);
 23      END add_new_artist;
 24
 25      PROCEDURE schedule_exhibition(
 26          p_title VARCHAR2,
 27          p_start_date DATE,
 28          p_end_date DATE,
 29          p_location VARCHAR2,
 30          p_curator_id NUMBER
 31      ) AS
 32      BEGIN
 33          IF p_end_date <= p_start_date THEN
 34              RAISE_APPLICATION_ERROR(-20008, 'End date must be after start date');
 35          END IF;
 36
 37          INSERT INTO Exhibition VALUES (
 38              exhibition_seq.NEXTVAL, p_title, p_start_date,
 39              p_end_date, p_location, p_curator_id, SYSDATE
 40          );
 41          COMMIT;
 42          DBMS_OUTPUT.PUT_LINE('Exhibition scheduled: ' || p_title);
 43      EXCEPTION
 44          WHEN OTHERS THEN
 45              ROLLBACK;
 46              RAISE_APPLICATION_ERROR(-20009, 'Error scheduling exhibition: ' || SQLERRM);
 47      END schedule_exhibition;
 48
 49      FUNCTION get_available_artworks_count RETURN NUMBER AS
 50          v_count NUMBER;
 51      BEGIN
 52          SELECT COUNT(*) INTO v_count
 53          FROM Artwork
 54          WHERE status = 'Available';
 55
 56          RETURN v_count;
 57      END get_available_artworks_count;
 58
 59      FUNCTION get_monthly_sales(p_month NUMBER, p_year NUMBER) RETURN NUMBER AS
 60          v_sales NUMBER;
 61      BEGIN
 62          SELECT NVL(SUM(final_price), 0) INTO v_sales
 63          FROM Sale
 64          WHERE EXTRACT(MONTH FROM sale_date) = p_month
 65          AND EXTRACT(YEAR FROM sale_date) = p_year;
 66
 67          RETURN v_sales;
 68      END get_monthly_sales;
 69
 70  END gallery_management_pkg;
 71  /

Package body created.

SQL> -- Test procedures and functions
SQL> DECLARE
  2      v_artist_name VARCHAR2(100);
  3      v_artwork_count NUMBER;
  4      v_total_sales NUMBER;
  5      v_total_revenue NUMBER;
  6      v_ranking NUMBER;
  7  BEGIN
  8      -- Test artist details procedure
  9      get_artist_details(1, v_artist_name, v_artwork_count, v_total_sales);
 10      DBMS_OUTPUT.PUT_LINE('Artist: ' || v_artist_name ||
 11                          ', Artworks: ' || v_artwork_count ||
 12                          ', Total Sales: $' || v_total_sales);
 13
 14      -- Test revenue function
 15      v_total_revenue := calculate_total_revenue();
 16      DBMS_OUTPUT.PUT_LINE('Total Gallery Revenue: $' || v_total_revenue);
 17
 18      -- Test artist ranking
 19      v_ranking := get_artist_ranking(1);
 20      DBMS_OUTPUT.PUT_LINE('Artist Ranking: ' || v_ranking);
 21
 22      -- Test package functions
 23      DBMS_OUTPUT.PUT_LINE('Available Artworks: ' || gallery_management_pkg.get_available_artworks_count());
 24      DBMS_OUTPUT.PUT_LINE('May 2025 Sales: $' || gallery_management_pkg.get_monthly_sales(5, 2025));
 25  END;
 26  /

PL/SQL procedure successfully completed.

SQL>