-- COMMIT demo: create a test-only department; remove it afterward.
BEGIN;
INSERT INTO departments(department_code,department_name) VALUES ('TX-COMMIT','Transaction Demo');
COMMIT;
SELECT * FROM departments WHERE department_code='TX-COMMIT';
DELETE FROM departments WHERE department_code='TX-COMMIT';

-- ROLLBACK demo: changes should disappear.
BEGIN;
INSERT INTO departments(department_code,department_name) VALUES ('TX-ROLL','Rollback Demo');
SELECT * FROM departments WHERE department_code='TX-ROLL';
ROLLBACK;
SELECT * FROM departments WHERE department_code='TX-ROLL';

-- SAVEPOINT demo
BEGIN;
INSERT INTO departments(department_code,department_name) VALUES ('TX-SAVE','Savepoint Demo');
SAVEPOINT before_second_insert;
INSERT INTO departments(department_code,department_name) VALUES ('TX-UNDO','Will Be Undone');
ROLLBACK TO SAVEPOINT before_second_insert;
COMMIT;
SELECT department_code FROM departments WHERE department_code IN ('TX-SAVE','TX-UNDO');
DELETE FROM departments WHERE department_code='TX-SAVE';
