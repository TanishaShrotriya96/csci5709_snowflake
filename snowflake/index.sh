#! bash file
snowsql -c $1 -f "raw_schema/create_raw_schema.sql" 
snowsql -c $1 -f "raw_schema/load_raw_data.sql" 
snowsql -c $1 -f "curated_schema/create_curated_schema.sql" 
snowsql -c $1 -f "curated_schema/load_curated_data.sql" 
