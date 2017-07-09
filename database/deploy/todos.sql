-- Deploy haskell-web-todos:todos to pg

BEGIN;

CREATE TABLE todos (
  _id uuid NOT NULL UNIQUE,
  description text NOT NULL,
  state integer NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL
);

COMMIT;
