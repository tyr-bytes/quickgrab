CREATE DATABASE code_analysis_db
CREATE ROLE bigboss WITH LOGIN PASSWORD '';
CREATE EXTENSION IF NOT EXISTS citext;
ALTER DATABASE code_analysis_db OWNER to bigboss;

-- WARNING
-- this tool not being optimal
-- for very high memory systems

-- DB Version: 15
-- OS Type: linux
-- DB Type: dw
-- Total Memory (RAM): 4096 GB
-- CPUs num: 4
-- Data Storage: ssd

ALTER SYSTEM SET
 max_connections = '40';
ALTER SYSTEM SET
 shared_buffers = '1024GB';
ALTER SYSTEM SET
 effective_cache_size = '3072GB';
ALTER SYSTEM SET
 maintenance_work_mem = '2GB';
ALTER SYSTEM SET
 checkpoint_completion_target = '0.9';
ALTER SYSTEM SET
 wal_buffers = '16MB';
ALTER SYSTEM SET
 default_statistics_target = '500';
ALTER SYSTEM SET
 random_page_cost = '1.1';
ALTER SYSTEM SET
 effective_io_concurrency = '200';
ALTER SYSTEM SET
 work_mem = '6710886kB';
ALTER SYSTEM SET
 huge_pages = 'try';
ALTER SYSTEM SET
 min_wal_size = '4GB';
ALTER SYSTEM SET
 max_wal_size = '16GB';
ALTER SYSTEM SET
 max_worker_processes = '4';
ALTER SYSTEM SET
 max_parallel_workers_per_gather = '2';
ALTER SYSTEM SET
 max_parallel_workers = '4';
ALTER SYSTEM SET
 max_parallel_maintenance_workers = '2';

 curl -s https://packagecloud.io/install/repositories/golang-migrate/migrate/script.deb.sh | sudo bash
 apt-get install migrate=4.17.1

 # Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

$ANALYSIS_DB_DSN

sudo cp /home/tyr/Code/quickgrab/docs/example.txt /var/lib/postgresql/
sudo chown postgres:postgres /var/lib/postgresql/example.txt

