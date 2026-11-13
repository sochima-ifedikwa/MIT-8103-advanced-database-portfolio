-- Test branch isolation
--  Test ran in branch: activity5-development
CREATE TABLE activity5_branch_test (
    test_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description VARCHAR(150) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO activity5_branch_test (description)
VALUES ('Created only in Activity 5 development branch');

SELECT * FROM activity5_branch_test;

-- Test ran in main branch: main which returns false
SELECT EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_name = 'activity5_branch_test'
) AS test_table_exists;

-- Transction consistency ran in branch: activity5-development which returns false assuming it is rolled back
BEGIN;

CREATE TABLE IF NOT EXISTS activity5_transaction_test (
    id INTEGER PRIMARY KEY,
    description TEXT NOT NULL
);

INSERT INTO activity5_transaction_test (id, description)
VALUES (1, 'Temporary transaction record');

ROLLBACK;

SELECT EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_name = 'activity5_transaction_test'
) AS table_exists_after_rollback;


-- Demonstrate commit behavior ran in branch: activity5-development which returns true
BEGIN;

CREATE TABLE activity5_commit_test (
    id INTEGER PRIMARY KEY,
    description TEXT NOT NULL
);

INSERT INTO activity5_commit_test
VALUES (1, 'Committed transaction');

COMMIT;

-- Returns "Committed transaction" as the record was committed to the database
SELECT * FROM activity5_commit_test;