-- Drop triggers
DROP TRIGGER IF EXISTS emp_audit_ins ON files;
DROP TRIGGER IF EXISTS emp_audit_upd ON files;
DROP TRIGGER IF EXISTS emp_audit_del ON files;

-- Drop function
DROP FUNCTION IF EXISTS handle_files_view_operations;

-- Optionally, drop the import_log table if it's not used elsewhere
DROP TABLE IF EXISTS import_log;