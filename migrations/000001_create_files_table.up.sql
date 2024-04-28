CREATE TABLE IF NOT EXISTS folders (
    folder_id SERIAL PRIMARY KEY,
    path TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS files(
    id bigserial PRIMARY KEY,
    folder_id INT,
    path TEXT UNIQUE NOT NULL,
    CONSTRAINT fk_folder FOREIGN KEY (folder_id) REFERENCES folders (folder_id)
);