CREATE TABLE IF NOT EXISTS roles (
    id          uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name        varchar(255) NOT NULL UNIQUE,
    description varchar(255)
);

CREATE TABLE IF NOT EXISTS users (
    id              uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    document_number varchar(20) NOT NULL UNIQUE,
    name            varchar(60) NOT NULL,
    lastname        varchar(60) NOT NULL,
    email           varchar(100) NOT NULL UNIQUE,
    phone           varchar(20),
    address         varchar(255),
    birth_date      date,
    base_salary     numeric(10, 2),
    role_id         uuid REFERENCES roles(id),
    password        varchar(255)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO jcuadrado_auth;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO jcuadrado_auth;

INSERT INTO public.roles (id, name, description) VALUES ('abc5d4c9-dec3-45d3-98b6-d3b7ce764cda', 'CLIENT', 'Usuarios clientes');
INSERT INTO public.roles (id, name, description) VALUES ('87fd46b7-b23b-48ef-888d-e8f17fa168f9', 'ADMIN', 'Usuarios administrador del sistema');
INSERT INTO public.roles (id, name, description) VALUES ('62da0fe0-6b4d-43fa-af31-b90c04f9d046', 'ADVISER', 'Usuarios asesores');

INSERT INTO public.users (id, document_number, name, lastname, email, phone, address, birth_date, base_salary, role_id, password) VALUES ('f1ce7cbf-3c8d-4c4a-922d-66c4e278f1cf', '123456789', 'Admin', 'Admin', 'admin@mail.com', '+573333333', '', '2000-01-01', 2000000.00, '87fd46b7-b23b-48ef-888d-e8f17fa168f9', '$2a$10$XlWWJiSvGq3itanmppdyPuy0iQiqrxd9YBYWp.0PaHGIA3MGELDEO');
