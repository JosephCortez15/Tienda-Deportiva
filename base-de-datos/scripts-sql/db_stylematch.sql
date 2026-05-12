CREATE DATABASE IF NOT EXISTS db_stylematch;
USE db_stylematch;

CREATE TABLE biometric_profiles (
    id_perfil INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    height DECIMAL(5,2) NOT NULL, -- Ej: 175.50 (cm)
    weight DECIMAL(5,2) NOT NULL, -- Ej: 75.50 (kg)
    body_type VARCHAR(50) NOT NULL,
    CONSTRAINT biometric_profiles_pk PRIMARY KEY (id_perfil)
);

CREATE TABLE category (
    id_category INT NOT NULL AUTO_INCREMENT,
    name_category VARCHAR(50) NOT NULL,
    description VARCHAR(50) NOT NULL,
    CONSTRAINT category_pk PRIMARY KEY (id_category)
);

CREATE TABLE detail_outfit (
    id_outfit INT NOT NULL,
    id_variant INT NOT NULL,
    CONSTRAINT detail_outfit_pk PRIMARY KEY (id_outfit, id_variant)
);

CREATE TABLE discount (
    id_discount INT NOT NULL AUTO_INCREMENT,
    promotion_code VARCHAR(30) NOT NULL, -- Ej: VERANO2026
    percentage DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    active BOOLEAN NOT NULL,
    CONSTRAINT discount_pk PRIMARY KEY (id_discount)
);

CREATE TABLE historical_sales (
    id_historical INT NOT NULL AUTO_INCREMENT,
    id_product INT NOT NULL,
    mount_year DATE NOT NULL,
    total_sold_quantity INT NOT NULL,
    CONSTRAINT historical_sales_pk PRIMARY KEY (id_historical)
);

CREATE TABLE order_tracking (
    id_tracking INT NOT NULL AUTO_INCREMENT,
    id_order INT NOT NULL,
    current_status VARCHAR(50) NOT NULL,
    actualization_date DATE NOT NULL,
    gps_coordinates VARCHAR(100) NOT NULL, -- Ej: "-16.5000, -68.1193"
    CONSTRAINT order_tracking_pk PRIMARY KEY (id_tracking)
);

CREATE TABLE orders (
    id_order INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    id_discount INT NOT NULL,
    date_order DATE NOT NULL,
    total_paid DECIMAL(10,2) NOT NULL, -- Para montos exactos de dinero
    state_paid VARCHAR(20) NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY (id_order)
);

CREATE TABLE product (
    id_product INT NOT NULL AUTO_INCREMENT,
    id_category INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    general_description VARCHAR(100) NOT NULL,
    id_supplier INT NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY (id_product)
);

CREATE TABLE product_variant (
    id_variant INT NOT NULL AUTO_INCREMENT,
    id_product INT NOT NULL,
    size VARCHAR(10) NOT NULL,
    color VARCHAR(20) NOT NULL,
    current_stock INT NOT NULL, -- Corregido a número entero
    CONSTRAINT product_variant_pk PRIMARY KEY (id_variant)
);

CREATE TABLE requested_detail (
    id_detail INT NOT NULL AUTO_INCREMENT,
    id_order INT NOT NULL,
    id_variant INT NOT NULL,
    amount INT NOT NULL, -- Cantidad de ropa
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT requested_detail_pk PRIMARY KEY (id_detail)
);

CREATE TABLE reviews_ranting (
    id_review INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    id_product INT NOT NULL,
    star INT NOT NULL, -- Estrellas del 1 al 5
    coment VARCHAR(150) NOT NULL,
    date DATE NOT NULL,
    CONSTRAINT reviews_ranting_pk PRIMARY KEY (id_review)
);

CREATE TABLE role (
    id_role INT NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    description VARCHAR(80) NOT NULL,
    CONSTRAINT role_pk PRIMARY KEY (id_role)
);

CREATE TABLE sistem_logs (
    id_log INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    action_performed VARCHAR(50) NOT NULL,
    date_time DATETIME NOT NULL,
    table_affected VARCHAR(50) NOT NULL,
    CONSTRAINT sistem_logs_pk PRIMARY KEY (id_log)
);

CREATE TABLE style_preference (
    id_preference INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    id_category INT NOT NULL,
    interest_level INT NOT NULL,
    CONSTRAINT style_preference_pk PRIMARY KEY (id_preference)
);

CREATE TABLE suggested_outfits (
    id_outfit INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    name_outfit VARCHAR(50) NOT NULL,
    creation_date DATE NOT NULL,
    CONSTRAINT suggested_outfits_pk PRIMARY KEY (id_outfit)
);

CREATE TABLE supplier (
    id_supplier INT NOT NULL AUTO_INCREMENT,
    company_name VARCHAR(80) NOT NULL,
    contact_name VARCHAR(80) NOT NULL,
    phone_number VARCHAR(20) NOT NULL, -- Corregido para números telefónicos
    email VARCHAR(50) NOT NULL,
    CONSTRAINT supplier_pk PRIMARY KEY (id_supplier)
);

CREATE TABLE users (
    id_user INT NOT NULL AUTO_INCREMENT,
    id_role INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(60) NULL,
    password VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL,
    CONSTRAINT users_pk PRIMARY KEY (id_user)
);

CREATE TABLE user_images_IA (
    id_image INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    file_path VARCHAR(255) NOT NULL, -- Rutas de archivos en texto
    AI_tags_detected VARCHAR(255) NOT NULL, -- Etiquetas separadas por comas
    CONSTRAINT user_images_IA_pk PRIMARY KEY (id_image)
);

CREATE TABLE visual_attributes (
    id_attribute INT NOT NULL AUTO_INCREMENT,
    id_product INT NOT NULL,
    label_style VARCHAR(60) NOT NULL,
    color_hex VARCHAR(30) NOT NULL,
    fabric_type VARCHAR(30) NOT NULL,
    CONSTRAINT visual_attributes_pk PRIMARY KEY (id_attribute)
);

CREATE TABLE wish_list (
    id_wish INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    id_product INT NOT NULL,
    date_add DATE NOT NULL,
    CONSTRAINT wish_list_pk PRIMARY KEY (id_wish)
);

ALTER TABLE biometric_profiles ADD CONSTRAINT fk_biometric_user
    FOREIGN KEY (id_user) REFERENCES users (id_user);

ALTER TABLE detail_outfit ADD CONSTRAINT fk_detail_variant
    FOREIGN KEY (id_variant) REFERENCES product_variant (id_variant);

ALTER TABLE detail_outfit ADD CONSTRAINT fk_detail_outfit
    FOREIGN KEY (id_outfit) REFERENCES suggested_outfits (id_outfit);

ALTER TABLE historical_sales ADD CONSTRAINT fk_historical_product
    FOREIGN KEY (id_product) REFERENCES product (id_product);

ALTER TABLE order_tracking ADD CONSTRAINT fk_tracking_order
    FOREIGN KEY (id_order) REFERENCES orders (id_order);

ALTER TABLE orders ADD CONSTRAINT fk_orders_discount
    FOREIGN KEY (id_discount) REFERENCES discount (id_discount);

ALTER TABLE orders ADD CONSTRAINT fk_orders_user
    FOREIGN KEY (id_user) REFERENCES users (id_user);

ALTER TABLE product ADD CONSTRAINT fk_product_category
    FOREIGN KEY (id_category) REFERENCES category (id_category);

ALTER TABLE product ADD CONSTRAINT fk_product_supplier
    FOREIGN KEY (id_supplier) REFERENCES supplier (id_supplier);

ALTER TABLE product_variant ADD CONSTRAINT fk_variant_product
    FOREIGN KEY (id_product) REFERENCES product (id_product);

ALTER TABLE requested_detail ADD CONSTRAINT fk_req_detail_order
    FOREIGN KEY (id_order) REFERENCES orders (id_order);

ALTER TABLE requested_detail ADD CONSTRAINT fk_req_detail_variant
    FOREIGN KEY (id_variant) REFERENCES product_variant (id_variant);

ALTER TABLE reviews_ranting ADD CONSTRAINT fk_reviews_product
    FOREIGN KEY (id_product) REFERENCES product (id_product);

ALTER TABLE reviews_ranting ADD CONSTRAINT fk_reviews_user
    FOREIGN KEY (id_user) REFERENCES users (id_user);

ALTER TABLE sistem_logs ADD CONSTRAINT fk_logs_user
    FOREIGN KEY (id_user) REFERENCES users (id_user);

ALTER TABLE style_preference ADD CONSTRAINT fk_style_category
    FOREIGN KEY (id_category) REFERENCES category (id_category);

ALTER TABLE style_preference ADD CONSTRAINT fk_style_user
    FOREIGN KEY (id_user) REFERENCES users (id_user);

ALTER TABLE suggested_outfits ADD CONSTRAINT fk_outfits_user
    FOREIGN KEY (id_user) REFERENCES users (id_user);

ALTER TABLE user_images_IA ADD CONSTRAINT fk_images_user
    FOREIGN KEY (id_user) REFERENCES users (id_user);

ALTER TABLE users ADD CONSTRAINT fk_user_role
    FOREIGN KEY (id_role) REFERENCES role (id_role);

ALTER TABLE visual_attributes ADD CONSTRAINT fk_visual_product
    FOREIGN KEY (id_product) REFERENCES product (id_product);

ALTER TABLE wish_list ADD CONSTRAINT fk_wish_product
    FOREIGN KEY (id_product) REFERENCES product (id_product);

ALTER TABLE wish_list ADD CONSTRAINT fk_wish_user
    FOREIGN KEY (id_user) REFERENCES users (id_user);