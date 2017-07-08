-- Revert haskell-web-todos:todos from pg

BEGIN;

DROP TABLE IF EXISTS todos;

COMMIT;
