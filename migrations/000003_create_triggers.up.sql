CREATE TABLE IF NOT EXISTS import_log(
    operation         char(1)   NOT NULL,
    stamp timestamptz NOT NULL DEFAULT NOW(),
    userid            text      NOT NULL,
    fileid           bigserial       NOT NULL,
    folder_id INT NOT NULL,

    path TEXT NOT NULL 
);

CREATE OR REPLACE FUNCTION handle_files_view_operations() RETURNS TRIGGER AS $import_audit$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO import_log 
            SELECT 'I', now(), current_user, n.* FROM new_table n;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO import_log 
            SELECT 'U', now(), current_user, n.* FROM new_table n;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO import_log 
            SELECT 'D', now(), current_user, o.* FROM old_table o;
    END IF;
    RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$import_audit$ LANGUAGE plpgsql;


CREATE TRIGGER emp_audit_ins
    AFTER INSERT ON files
    REFERENCING NEW TABLE AS new_table
    FOR EACH STATEMENT EXECUTE FUNCTION handle_files_view_operations();
CREATE TRIGGER emp_audit_upd
    AFTER UPDATE ON files
    REFERENCING OLD TABLE AS old_table NEW TABLE AS new_table
    FOR EACH STATEMENT EXECUTE FUNCTION handle_files_view_operations();
CREATE TRIGGER emp_audit_del
    AFTER DELETE ON files
    REFERENCING OLD TABLE AS old_table
    FOR EACH STATEMENT EXECUTE FUNCTION handle_files_view_operations();