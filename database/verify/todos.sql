-- Verify haskell-web-todos:todos on pg

BEGIN;

SELECT (
  _id,
  description,
  state,
  created_at,
  updated_at
) FROM todos WHERE FALSE;

ROLLBACK;
