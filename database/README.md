# How to use

To create new database initialization files, add them with an incremented file number, ending in `.sql` (e.g. `00.sql`, `01.sql`, ...). It will be run when the container is re-built.

## Running it

`docker-compose up --build -V`