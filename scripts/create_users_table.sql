-- Create the users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    firstName VARCHAR(100),
    lastName VARCHAR(100),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    postalCode VARCHAR(20),
    country VARCHAR(100),
    role VARCHAR(50) DEFAULT 'customer',
    status VARCHAR(50) DEFAULT 'active',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    createdBy INT,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INT,
    isDeleted BOOLEAN DEFAULT FALSE,
    deletedBy INT,
    deletedAt TIMESTAMP,
    isLocked BOOLEAN DEFAULT FALSE,
    lockedBy INT,
    lockedAt TIMESTAMP,
    lastLogin TIMESTAMP,
    emailVerified BOOLEAN DEFAULT FALSE,
    phoneVerified BOOLEAN DEFAULT FALSE
);

-- Optional: Adding foreign key references if `createdBy`, etc., refer to the same table.
ALTER TABLE users
ADD FOREIGN KEY (createdBy) REFERENCES users(id),
ADD FOREIGN KEY (updatedBy) REFERENCES users(id),
ADD FOREIGN KEY (deletedBy) REFERENCES users(id),
ADD FOREIGN KEY (lockedBy) REFERENCES users(id);

-- Create indexes for performance
CREATE INDEX idx_users_username ON users (username);
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_is_deleted ON users (isDeleted);
CREATE INDEX idx_users_is_locked ON users (isLocked);
CREATE INDEX idx_users_created_at ON users (createdAt);

-- Create a trigger function to update timestamps
CREATE OR REPLACE FUNCTION update_timestamps()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updatedAt = CURRENT_TIMESTAMP; -- Set the updatedAt field to the current timestamp
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger that calls the function before an update
CREATE TRIGGER trg_update_users_updatedAt
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_timestamps();

-- Create a trigger function for tracking created records
CREATE OR REPLACE FUNCTION set_created_by()
RETURNS TRIGGER AS $$
BEGIN
    NEW.createdBy = CURRENT_USER; -- Assuming CURRENT_USER is the creator
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger that calls the function before an insert
CREATE TRIGGER trg_set_created_by
BEFORE INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION set_created_by();

-- Create a trigger function for tracking deleted records
CREATE OR REPLACE FUNCTION set_deleted_info()
RETURNS TRIGGER AS $$
BEGIN
    NEW.isDeleted = TRUE; -- Mark as deleted
    NEW.deletedAt = CURRENT_TIMESTAMP; -- Set the deletion timestamp
    NEW.deletedBy = CURRENT_USER; -- Assuming CURRENT_USER is the deleter
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger that calls the function before a delete
CREATE TRIGGER trg_set_deleted_info
BEFORE DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION set_deleted_info();
