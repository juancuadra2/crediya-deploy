-- ==========================================
-- SCRIPT DE INICIALIZACIÓN UNIFICADO PARA CREDIYA
-- Crea ambas bases de datos usando el usuario principal de PostgreSQL
-- Ultra-simplificado: el usuario principal tiene todos los permisos automáticamente
-- ==========================================

-- Crear base de datos para Auth Service
CREATE DATABASE crediya_auth;

-- Crear base de datos para Requests Service  
CREATE DATABASE crediya_requests;

-- El usuario principal (POSTGRES_USER) automáticamente tiene todos los privilegios
-- No se requieren configuraciones adicionales de permisos

-- ==========================================
-- CONFIGURACIÓN DE AUTH DATABASE
-- ==========================================

\c crediya_auth;

-- Crear tablas para Auth Service
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

-- Insertar datos iniciales para Auth Service
INSERT INTO public.roles (id, name, description) VALUES 
    ('abc5d4c9-dec3-45d3-98b6-d3b7ce764cda', 'CLIENT', 'Usuarios clientes'),
    ('87fd46b7-b23b-48ef-888d-e8f17fa168f9', 'ADMIN', 'Usuarios administrador del sistema'),
    ('62da0fe0-6b4d-43fa-af31-b90c04f9d046', 'ADVISER', 'Usuarios asesores');

INSERT INTO public.users (id, document_number, name, lastname, email, phone, address, birth_date, base_salary, role_id, password) VALUES 
    ('f1ce7cbf-3c8d-4c4a-922d-66c4e278f1cf', '123456789', 'Admin', 'Admin', 'admin@mail.com', '+573333333', '', '2000-01-01', 2000000.00, '87fd46b7-b23b-48ef-888d-e8f17fa168f9', '$2a$10$XlWWJiSvGq3itanmppdyPuy0iQiqrxd9YBYWp.0PaHGIA3MGELDEO');

-- ==========================================
-- CONFIGURACIÓN DE REQUESTS DATABASE
-- ==========================================

\c crediya_requests;

-- Crear tablas para Requests Service
CREATE TABLE IF NOT EXISTS status (
    id          uuid         DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name        varchar(50)  NOT NULL UNIQUE,
    description varchar(255)
);

CREATE TABLE IF NOT EXISTS types (
    id            uuid           DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name          varchar(50)    NOT NULL UNIQUE,
    min_amount    numeric(10,2)  DEFAULT 0 NOT NULL,
    max_amount    numeric(15,2)  DEFAULT 0 NOT NULL,
    interest_rate numeric(10,2)  DEFAULT 0 NOT NULL,
    auto_validate boolean        DEFAULT false NOT NULL
);

CREATE TABLE IF NOT EXISTS requests (
    id        uuid         DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    amount    numeric(10,2) NOT NULL,
    term      integer      NOT NULL,
    email     varchar(100) NOT NULL,
    type_id   uuid         NOT NULL REFERENCES types,
    status_id uuid         NOT NULL REFERENCES status
);

CREATE TABLE IF NOT EXISTS clients (
    id              uuid         NOT NULL PRIMARY KEY,
    document_number varchar(100) NOT NULL UNIQUE,
    name            varchar(100) NOT NULL,
    last_name       varchar(100),
    email           varchar(100) NOT NULL UNIQUE,
    base_salary     numeric(10,2) NOT NULL DEFAULT 0
);

-- Insertar datos iniciales para Requests Service
INSERT INTO public.status (id, name, description) VALUES 
    ('6764c1d3-0b6a-4593-b16c-6b1c337c2c10', 'APPROVED', 'La solicitud fue aprobada y está lista para continuar con el desembolso.'),
    ('344511f5-4cc7-4d8d-b508-8fc46ce9ff01', 'REJECTED', 'La solicitud fue rechazada y no continuará con el proceso.'),
    ('73cf2ad1-fcc7-4c89-8c81-51f6d23d5102', 'MANUAL_REVIEW', 'La solicitud requiere una revisión manual por parte de un analista.'),
    ('fce7abc4-bab2-4e98-b5ee-73f5842c1d02', 'PENDING', 'La solicitud fue registrada y está en espera de ser procesada.');

INSERT INTO public.types (id, name, min_amount, max_amount, interest_rate, auto_validate) VALUES 
    ('6b26e434-bea8-4c6d-8007-7cf809984a44', 'PERSONAL', 500000.00, 50000000.00, 2.08, false),
    ('63968ad2-d3c8-4221-b77c-a82ac56d884c', 'VEHICLE', 5000000.00, 250000000.00, 1.46, false),
    ('658ad4f7-950f-44fd-8b99-cfcf0b8e3206', 'EMERGENCY', 200000.00, 2000000.00, 2.50, false),
    ('cfc1e95f-c369-4f30-a187-10256334b1e8', 'MORTGAGE', 30000000.00, 1000000000.00, 0.92, false),
    ('7d11edbc-5c32-46dc-b0ef-0f39e91aca93', 'BUSINESS', 10000000.00, 2000000000.00, 1.67, false),
    ('1c5126d6-4d07-4455-b5f9-f91634eb8a6a', 'EDUCATION', 1000000.00, 80000000.00, 1.22, false);

-- ==========================================
-- CONFIGURACIÓN FINAL
-- ==========================================

-- Volver a la base de datos por defecto
\c postgres;

-- El usuario principal ya tiene todos los permisos necesarios
-- No se requieren configuraciones adicionales