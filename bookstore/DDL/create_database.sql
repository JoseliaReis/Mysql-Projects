
-- -----------------------------------------------------
-- 1. Create the corresponding database using DDL
-- -----------------------------------------------------


-- Create Database
CREATE SCHEMA IF NOT EXISTS bookstore;
USE bookstore;


-- -------------------------------------------------------------
-- 2. Create all the necessary tables identified above using DDL
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS bookstore.author (
  id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  phone NUMERIC(10) NOT NULL,
  address VARCHAR(100) NOT NULL,
  email VARCHAR(45) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  UNIQUE (phone),
  UNIQUE (email)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS bookstore.publisher (
  id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  phone NUMERIC(10) NOT NULL,
  address VARCHAR(100) NOT NULL,
  email VARCHAR(45) NOT NULL,
  website VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (id),
  UNIQUE (name),
  UNIQUE (phone),
  UNIQUE (email) ,
  UNIQUE  (website)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS bookstore.book (
  id INT NOT NULL,
  ISBN VARCHAR(13) NOT NULL,
  published_date DATE NOT NULL,
  title VARCHAR(100) NOT NULL,
  author_id INT NOT NULL,
  publisher_id INT NOT NULL,
  stock_quantity INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (id),
  UNIQUE (ISBN),
  INDEX fk_book_author_idx (author_id),
  INDEX fk_book_publisher1_idx (publisher_id),
  CONSTRAINT fk_book_author
    FOREIGN KEY (author_id)
    REFERENCES bookstore.author (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_book_publisher1
    FOREIGN KEY (publisher_id)
    REFERENCES bookstore.publisher (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    )ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS bookstore.employee (
  id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  phone NUMERIC(10) NOT NULL,
  email VARCHAR(45) NOT NULL,
  address VARCHAR(100) NOT NULL,
  salary DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (id),
  UNIQUE (email)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS bookstore.customer (
  id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(45) NOT NULL,
  phone NUMERIC(10) NOT NULL,
  address VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (id),
  UNIQUE (email),
  UNIQUE (phone)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS bookstore.orders (
  id INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  purchased_date DATETIME NOT NULL,
  employee_id INT NOT NULL,
  customer_id INT NOT NULL,
  book_id INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (id),
  INDEX fk_order_employee1_idx (employee_id),
  INDEX fk_order_customer1_idx (customer_id),
  INDEX fk_order_book1_idx (book_id),
  CONSTRAINT fk_order_employee1
    FOREIGN KEY (employee_id)
    REFERENCES bookstore.employee (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_order_customer1
    FOREIGN KEY (customer_id)
    REFERENCES bookstore.customer (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_order_book1
    FOREIGN KEY (book_id)
    REFERENCES bookstore.book (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)ENGINE = InnoDB;
