CREATE TABLE IF NOT EXISTS file_metadata (
  id bigserial PRIMARY KEY,
  file_id bigserial REFERENCES files(id),
  version integer NOT NULL DEFAULT 1,
  import_id integer NOT NULL default 1,
  added_at timestamp(0) with time zone NOT NULL DEFAULT NOW(),
  downloaded_at timestamp(0) with time zone,
  parsed_at timestamp(0) with time zone,
  -- Additional columns for storing other metadata
  UNIQUE (file_id, version)
);