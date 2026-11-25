#!/bin/bash
set -e

SQL_DIR=/sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    \i $SQL_DIR/tables.sql
    \i $SQL_DIR/insert.sql
    \i $SQL_DIR/V2__google_sso.sql
    \i $SQL_DIR/V3__rbac.sql
    \i $SQL_DIR/V4__email_unique.sql
    \i $SQL_DIR/V5__restaurant_status.sql
    \i $SQL_DIR/V6__restaurant_owner.sql
    \i $SQL_DIR/V7__invite_tokens.sql
    \i $SQL_DIR/V8__restaurant_pending_status.sql
    \i $SQL_DIR/V9__order_status.sql
    \i $SQL_DIR/V10__customer_favorites.sql
EOSQL
