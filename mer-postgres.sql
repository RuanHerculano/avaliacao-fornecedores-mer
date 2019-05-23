-- select 'drop table "' || tablename || '" cascade;'
-- from pg_tables
-- where tablename not like 'erp%'
--   AND tablename not like 'adm%'
--   AND tablename not like 'pg%'
--   AND tablename not like 'demo%'
--   AND tablename not like 'sql%';


DO $$
    DECLARE
        r RECORD;
    BEGIN
        --         if the schema you operate on is not "current", you will want to
--         replace current_schema() in query with 'schematodeletetablesfrom'
--         and update the generate 'DROP...' accordingly.
        FOR r IN (
--             SELECT tablename FROM pg_tables WHERE schemaname = current_schema()
            select tablename
            from pg_tables
            where tablename not like 'erp%'
              AND tablename not like 'adm%'
              AND tablename not like 'pg%'
              AND tablename not like 'demo%'
              AND tablename not like 'sql%'
              AND tablename not like 'scm%'

        )
            LOOP
                --
                EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
            END LOOP;
        DROP TYPE IF EXISTS sending_status;
        DROP TYPE IF EXISTS manual_question_type;
        DROP TYPE IF EXISTS tolerance_type;
        DROP TYPE IF EXISTS language;
    END $$;

CREATE TABLE "supplier"
(
    "id"           SERIAL PRIMARY KEY,
    "company_id"   int       NOT NULL,
    "cnpj"         varchar   NOT NULL,
    "trading_name" varchar   NOT NULL,
    "company_name" varchar   NOT NULL,
    "address"      varchar   NOT NULL,
    "created_at"   timestamp NOT NULL,
    "updated_at"   timestamp NOT NULL
);

CREATE TABLE "related_supplier"
(
    "id"                  SERIAL PRIMARY KEY,
    "first_suppliers_id"  int       NOT NULL,
    "second_suppliers_id" int       NOT NULL,
    "created_at"          timestamp NOT NULL,
    "updated_at"          timestamp NOT NULL
);

CREATE TABLE "contact"
(
    "id"          SERIAL PRIMARY KEY,
    "supplier_id" int       NOT NULL,
    "company_id"  int       NOT NULL,
    "name"        varchar   NOT NULL,
    "telephone"   varchar   NOT NULL,
    "email"       varchar   NOT NULL,
    "observation" varchar,
    "created_at"  timestamp NOT NULL,
    "updated_at"  timestamp NOT NULL
);

CREATE TABLE "form"
(
    "id"         SERIAL PRIMARY KEY,
    "name"       varchar   NOT NULL,
    "company_id" int       NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL
);

CREATE TABLE "form_question"
(
    "id"           SERIAL PRIMARY KEY,
    "weight"       float     NOT NULL,
    "tolerance_id" int,
    "question_id"  int       NOT NULL,
    "form_id"      int       NOT NULL,
    "response"     json,
    "created_at"   timestamp NOT NULL,
    "updated_at"   timestamp NOT NULL
);

CREATE TABLE "question"
(
    "id"                 SERIAL PRIMARY KEY,
    "title"              varchar   NOT NULL,
    "company_id"         int       NOT NULL,
    "manual_question_id" int,
    "created_at"         timestamp NOT NULL,
    "updated_at"         timestamp NOT NULL
);

CREATE TABLE "establishment"
(
    "id"          SERIAL PRIMARY KEY,
    "description" varchar   NOT NULL,
    "acronym"     varchar   NOT NULL,
    "company_id"  int       NOT NULL,
    "email"       varchar   NOT NULL,
    "created_at"  timestamp NOT NULL,
    "updated_at"  timestamp NOT NULL
);

CREATE TABLE "purchase_order"
(
    "id"               SERIAL PRIMARY KEY,
    "company_id"       int       NOT NULL,
    "num_order"        int       NOT NULL,
    "establishment_id" int       NOT NULL,
    "supplier_id"      int       NOT NULL,
    "date_order"       timestamp NOT NULL,
    "date_exp"         timestamp NOT NULL,
    "date_real"        timestamp,
    "purchase_req_id"  int       NOT NULL,
    "created_at"       timestamp NOT NULL,
    "updated_at"       timestamp NOT NULL
);

COMMENT ON COLUMN "purchase_order"."num_order" IS 'id do rp do cliente que identifica a ordem de compra';

COMMENT ON COLUMN "purchase_order"."date_order" IS 'dia que a ordem de compra é criada';

COMMENT ON COLUMN "purchase_order"."date_exp" IS 'dia esperado para que chegue os items solicitados na ordem de compra';

COMMENT ON COLUMN "purchase_order"."date_real" IS 'dia que realmente chega os items solicitados na ordem de compra';

CREATE TABLE "evaluation"
(
    "id"                SERIAL PRIMARY KEY,
    "score"             float     NOT NULL,
    "purchase_order_id" int       NOT NULL,
    "form_id"           int       NOT NULL,
    "created_at"        timestamp NOT NULL,
    "updated_at"        timestamp NOT NULL
);

create table "group"
(
    "id"          SERIAL PRIMARY KEY,
    "company_id"  int NOT NULL,
    "acronym"     varchar,
    "description" varchar,
    "created_at"  timestamp,
    "updated_at"  timestamp
);

create table "policy"
(
    "id"          SERIAL PRIMARY KEY,
    "company_id"  int NOT NULL,
    "name"        varchar,
    "description" varchar,
    "created_at"  timestamp,
    "updated_at"  timestamp
);

CREATE TYPE "curve_abc" AS ENUM ('A', 'B', 'C');
CREATE TYPE "curve_pqr" AS ENUM ('P', 'Q', 'R');
CREATE TYPE "curve_xyz" AS ENUM ('X', 'Y', 'Z');
CREATE TYPE "curve_123" AS ENUM ('1', '2', '3');

CREATE TYPE "sku_status_erp" AS ENUM ('active', 'inactive');
CREATE TYPE "sku_status_system" AS ENUM ('active', 'inactive');
CREATE TYPE "sku_status_analyzed" AS ENUM ('active', 'inactive');

CREATE TYPE "sku_life_cicle" AS ENUM ('new', 'mature', 'decaying');

CREATE TABLE "item"
(
    "id"                  SERIAL PRIMARY KEY,
    "description"         varchar             NOT NULL,
    "erp_item_id"         int                 NOT NULL,
    "unit_measurement_id" int                 NOT NULL,
    "unit_value"          float               NOT NULL,
    "curve_abc"           curve_abc           NOT NULL,
    "curve_pqr"           curve_pqr           NOT NULL,
    "curve_xyz"           curve_xyz           NOT NULL,
    "curve_123"           curve_123           NOT NULL,
    "erp_status"          sku_status_erp      NOT NULL,
    "system_status"       sku_status_system   NOT NULL,
    "analyzed_status"     sku_status_analyzed NOT NULL,
    "sku_life_cicle"      sku_life_cicle      NOT NULL,
    "policy_id"           int                 NOT NULL,
    "created_at"          timestamp           NOT NULL,
    "updated_at"          timestamp           NOT NULL
);

CREATE TABLE "group_item"
(
    "id"         SERIAL PRIMARY KEY,
    "item_id"    int NOT NULL,
    "group_id"   int NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL
);

COMMENT ON COLUMN "item"."erp_item_id" IS 'Número que chega do cliente(Erp hospital)';

CREATE TABLE "purchase_order_item"
(
    "id"                SERIAL PRIMARY KEY,
    "qty_parc"          int       NOT NULL,
    "qty_rec"           int,
    "purchase_order_id" int       NOT NULL,
    "item_id"           int       NOT NULL,
    "created_at"        timestamp NOT NULL,
    "updated_at"        timestamp NOT NULL
);

COMMENT ON COLUMN "purchase_order_item"."qty_parc" IS 'quantidade de items previstos na ordem de compra';

COMMENT ON COLUMN "purchase_order_item"."qty_rec" IS 'quantidade de items recebidos na ordem de compra';

CREATE TABLE "purchase_req"
(
    "id"         SERIAL PRIMARY KEY,
    "num_req"    int       NOT NULL,
    "date_req"   timestamp NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL
);

COMMENT ON COLUMN "purchase_req"."num_req" IS 'id que vem da tabela purchase_orders_req';

COMMENT ON COLUMN "purchase_req"."date_req" IS '
      data que a solicitação de compra foi criada na tabela purchase_orders_req
    ';

CREATE TABLE "single_contact"
(
    "id"         SERIAL PRIMARY KEY,
    "email"      varchar   NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL
);

CREATE TABLE "email_template"
(
    "id"          SERIAL PRIMARY KEY,
    "company_id"  int       NOT NULL,
    "title"       varchar   NOT NULL,
    "subject"     varchar   NOT NULL,
    "description" text      NOT NULL,
    "created_at"  timestamp NOT NULL,
    "updated_at"  timestamp NOT NULL
);

CREATE TABLE "email"
(
    "id"         SERIAL PRIMARY KEY,
    "company_id" int       NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL
);

CREATE TYPE "sending_status" AS ENUM ('read', 'received', 'undelivered', 'sent');

CREATE TABLE "contact_email_template"
(
    "id"                SERIAL PRIMARY KEY,
    "email_id"          int            NOT NULL,
    "sending_status"    sending_status NOT NULL,
    "contact_id"        int            NOT NULL,
    "email_template_id" int            NOT NULL,
    "created_at"        timestamp      NOT NULL,
    "updated_at"        timestamp      NOT NULL
);

CREATE TABLE "single_contact_email_template"
(
    "id"                SERIAL PRIMARY KEY,
    "email_id"          int            NOT NULL,
    "sending_status"    sending_status NOT NULL,
    "email_template_id" int            NOT NULL,
    "single_contact_id" int            NOT NULL,
    "created_at"        timestamp      NOT NULL,
    "updated_at"        timestamp      NOT NULL
);

CREATE TYPE "language" AS ENUM ('pt-BR');

CREATE TABLE "company"
(
    "id"                  SERIAL PRIMARY KEY,
    "name"                varchar   NOT NULL,
    "registration_number" varchar   NOT NULL,
    "key"                 varchar   NOT NULL,
    "dtu"                 varchar   NOT NULL,
    "maintenance_mode"    int       NOT NULL,
    "app_link"            varchar   NOT NULL,
    "avatar"              varchar,
    "language"            language  NOT NULL,
    "created_at"          timestamp NOT NULL,
    "updated_at"          timestamp NOT NULL
);

CREATE TABLE "email_company"
(
    "id"                 SERIAL PRIMARY KEY,
    "company_id"         int       NOT NULL UNIQUE,
    "smtp_server"        varchar   NOT NULL,
    "smtp_user"          varchar   NOT NULL,
    "smtp_pass"          varchar   NOT NULL,
    "smtp_email_address" varchar   NOT NULL,
    "smtp_port"          int       NOT NULL,
    "smtp_ssl"           int       NOT NULL,
    "base_test"          int       NOT NULL,
    "created_at"         timestamp NOT NULL,
    "updated_at"         timestamp NOT NULL
);

CREATE TYPE "manual_question_type" AS ENUM ('open field', 'selectable list');

CREATE TABLE "manual_question"
(
    "id"                SERIAL PRIMARY KEY,
    "question"          varchar              NOT NULL,
    "observation"       varchar,
    "type"              manual_question_type NOT NULL,
    "template_response" json,
    "created_at"        timestamp,
    "updated_at"        timestamp
);

CREATE TYPE "tolerance_type" AS ENUM ('day', 'percentage');

CREATE TABLE "tolerance"
(
    "id"         SERIAL PRIMARY KEY,
    "type"       tolerance_type,
    "min"        int NOT NULL,
    "max"        int NOT NULL,
    "created_at" timestamp,
    "updated_at" timestamp
);

CREATE TABLE "unit_measurement"
(
    "id"          SERIAL PRIMARY KEY,
    "company_id"  int       NOT NULL,
    "acronym"     varchar   NOT NULL,
    "description" varchar,
    "created_at"  timestamp NOT NULL,
    "updated_at"  timestamp NOT NULL
);

CREATE TABLE "grouping"
(
    "id"         SERIAL PRIMARY KEY,
    "company_id" int       NOT NULL,
    "name"       varchar   NOT NULL,
    "created_at" timestamp NOT NULL,
    "updated_at" timestamp NOT NULL
);

CREATE TABLE "group"
(
    "id"          SERIAL PRIMARY KEY,
    "company_id"  int       NOT NULL,
    "grouping_id" int       NOT NULL,
    "name"        varchar   NOT NULL,
    "created_at"  timestamp NOT NULL,
    "updated_at"  timestamp NOT NULL
);

CREATE TABLE "group_item"
(
    "id"          SERIAL PRIMARY KEY,
    "company_id"  int       NOT NULL,
    "grouping_id" int       NOT NULL,
    "group_id"    int       NOT NULL,
    "item_id"     int       NOT NULL,
    "created_at"  timestamp NOT NULL,
    "updated_at"  timestamp NOT NULL
);

CREATE UNIQUE INDEX unique_group_per_grouping
    ON teste (grouping_id, item_id);

ALTER TABLE "supplier"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "related_supplier"
    ADD FOREIGN KEY ("first_suppliers_id") REFERENCES "supplier" ("id");

ALTER TABLE "related_supplier"
    ADD FOREIGN KEY ("second_suppliers_id") REFERENCES "supplier" ("id");

ALTER TABLE "contact"
    ADD FOREIGN KEY ("supplier_id") REFERENCES "supplier" ("id");

ALTER TABLE "contact"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "form"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "form_question"
    ADD FOREIGN KEY ("tolerance_id") REFERENCES "tolerance" ("id");

ALTER TABLE "form_question"
    ADD FOREIGN KEY ("question_id") REFERENCES "question" ("id");

ALTER TABLE "form_question"
    ADD FOREIGN KEY ("form_id") REFERENCES "form" ("id");

ALTER TABLE "question"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "question"
    ADD FOREIGN KEY ("manual_question_id") REFERENCES "manual_question" ("id");

ALTER TABLE "purchase_order"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "purchase_order"
    ADD FOREIGN KEY ("supplier_id") REFERENCES "supplier" ("id");

ALTER TABLE "purchase_order"
    ADD FOREIGN KEY ("purchase_req_id") REFERENCES "purchase_req" ("id");

ALTER TABLE "evaluation"
    ADD FOREIGN KEY ("purchase_order_id") REFERENCES "purchase_order" ("id");

ALTER TABLE "evaluation"
    ADD FOREIGN KEY ("form_id") REFERENCES "form" ("id");

ALTER TABLE "purchase_order_item"
    ADD FOREIGN KEY ("purchase_order_id") REFERENCES "purchase_order" ("id");

ALTER TABLE "purchase_order_item"
    ADD FOREIGN KEY ("item_id") REFERENCES "item" ("id");

ALTER TABLE "email_template"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "email"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "contact_email_template"
    ADD FOREIGN KEY ("email_id") REFERENCES "email" ("id");

ALTER TABLE "contact_email_template"
    ADD FOREIGN KEY ("contact_id") REFERENCES "contact" ("id");

ALTER TABLE "contact_email_template"
    ADD FOREIGN KEY ("email_template_id") REFERENCES "email_template" ("id");

ALTER TABLE "single_contact_email_template"
    ADD FOREIGN KEY ("email_id") REFERENCES "email" ("id");

ALTER TABLE "single_contact_email_template"
    ADD FOREIGN KEY ("email_template_id") REFERENCES "email_template" ("id");

ALTER TABLE "single_contact_email_template"
    ADD FOREIGN KEY ("single_contact_id") REFERENCES "single_contact" ("id");

ALTER TABLE "email_company"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "establishment"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "establishment"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "unit_measurement"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "item"
    ADD FOREIGN KEY ("unit_measurement_id") REFERENCES "unit_measurement" ("id");

ALTER TABLE "policy"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "item"
    ADD FOREIGN KEY ("policy_id") REFERENCES "policy" ("id");

ALTER TABLE "grouping"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "group"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "group"
    ADD FOREIGN KEY ("grouping_id") REFERENCES "grouping" ("id");

ALTER TABLE "group_item"
    ADD FOREIGN KEY ("company_id") REFERENCES "company" ("id");

ALTER TABLE "group_item"
    ADD FOREIGN KEY ("grouping_id") REFERENCES "grouping" ("id");

ALTER TABLE "group_item"
    ADD FOREIGN KEY ("group_id") REFERENCES "group" ("id");

ALTER TABLE "group_item"
    ADD FOREIGN KEY ("item_id") REFERENCES "item" ("id");

-- insert into company ("name", "registration_number", "key", "dtu", "maintenance_mode", "app_link", "avatar", "language",
--                      "created_at", "updated_at")
-- values ('Hospital Albert Sabin', '12345678901234', '123456', 'VQBiZSBiZ1BYVWrqDurwDkBsV5B7VEXG', 0, 'A', 'avatar.png',
--         'pt-BR', current_timestamp, current_timestamp);
--
--
-- insert into establishment (description, acronym, company_id, email, created_at, updated_at)
-- values ('HNSG', 'HNSG', 1, 'pnx@bionexo.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
--
-- insert into "email_company" (company_id, smtp_server, smtp_user, smtp_pass, smtp_email_address, smtp_port, smtp_ssl,
--                              base_test, created_at, updated_at)
-- values (1, 'mail.bionexo.com.br', 'infra@bionexo.com', 'VQXGZSX7Z1BeVWBODurKDkXe', 'infra@bionexo.com', 25, 0, 0,
--         CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- insert into "supplier" (company_id, cnpj, company_name, trading_name, address, created_at, updated_at)
-- values (1, '26074505000194', 'Bi Materiais', 'Bi Materiais', 'Rua...', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
--
-- insert into "purchase_req" (num_req, date_req, created_at, updated_at)
-- values(53780, '2018-10-18 18:03:03', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
--
-- insert into "purchase_order" (company_id, num_order, establishment_id, supplier_id, date_order, date_exp, date_real,
--                               purchase_req_id, created_at, updated_at)
-- values (1, 103019, 1, 1, '2017-01-06 00:00:00', '2017-01-06 00:00:00', NULL, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
--
-- INSERT INTO unit_measurement (company_id, acronym, description, created_at, updated_at)
-- VALUES (1, 'un', 'unidade', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
--
-- insert into "item" (description, erp_item_id, unit_measurement, unit_value, created_at, updated_at)
-- values ('fibrobroncoscopio ', 165372, 1, 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
--
-- insert into "purchase_order_item" (qty_parc, qty_rec, purchase_order_id, item_id, created_at, updated_at)
-- values (1, NULL, 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


----------------------------------------------
