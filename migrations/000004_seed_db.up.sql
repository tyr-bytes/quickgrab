-- -- Migration to load initial data into the 'files' table
-- BEGIN;
--   -- Perform the COPY operation to load data
--   COPY files (path)
--   FROM '/var/lib/postgresql/example.txt'  -- Ensure this path is correct and accessible by the PostgreSQL server
--   WITH (FORMAT text);

--   -- Add error handling or additional operations if necessary
-- COMMIT;

CREATE TEMP TABLE staging_folders (
    id SERIAL PRIMARY KEY,
    path TEXT NOT NULL
);

CREATE TEMP TABLE staging_files (
    full_path TEXT NOT NULL
);

-- Assume data is pre-separated and correctly classified when loaded
COPY staging_folders (path) FROM '/var/lib/postgresql/folders_only' WITH (FORMAT text);
COPY staging_files (full_path) FROM '/var/lib/postgresql/files_only' WITH (FORMAT text);

UPDATE staging_folders
SET path = CASE
               WHEN right(path, 1) = '/' THEN path
               ELSE path || '/'
           END
WHERE right(path, 1) != '/';

-- Add additional columns to staging tables
ALTER TABLE staging_files ADD COLUMN folder_path_hash TEXT;
ALTER TABLE staging_folders ADD COLUMN folder_path_hash TEXT;
ALTER TABLE staging_files ADD COLUMN folder_id INT;

UPDATE staging_folders
SET folder_path_hash = MD5(
    reverse(substring(reverse(path) from position('/' in reverse(path)) + 1))
);

UPDATE staging_files
SET folder_path_hash = MD5(
    reverse(substring(reverse(full_path) from position('/' in reverse(full_path)) + 1))
);

UPDATE staging_files sf
SET folder_id = f.id
FROM staging_folders f
WHERE sf.folder_path_hash = f.folder_path_hash;

-- Merging folders
MERGE INTO folders AS target
USING (
    SELECT id, path
    FROM staging_folders
) AS source
ON target.path = source.path
WHEN NOT MATCHED THEN
    INSERT (path)
    VALUES (source.path);

-- Merging files
MERGE INTO files AS target
USING (
    SELECT folder_id, full_path
    FROM staging_files
    WHERE folder_id IS NOT NULL
) AS source
ON target.path = source.full_path
WHEN NOT MATCHED THEN
    INSERT (folder_id, path)
    VALUES (source.folder_id, source.full_path);