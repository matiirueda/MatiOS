-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create tables
CREATE TABLE IF NOT EXISTS foods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    calories DECIMAL(10, 2),
    protein DECIMAL(10, 2),
    carbs DECIMAL(10, 2),
    fat DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS meal_logs (
    id SERIAL PRIMARY KEY,
    food_id INTEGER REFERENCES foods(id),
    quantity DECIMAL(10, 2),
    unit VARCHAR(50),
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS preferences (
    id SERIAL PRIMARY KEY,
    user_preference VARCHAR(255) NOT NULL,
    embedding vector(1536),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_meal_logs_food_id ON meal_logs(food_id);
CREATE INDEX IF NOT EXISTS idx_meal_logs_logged_at ON meal_logs(logged_at);
CREATE INDEX IF NOT EXISTS idx_preferences_embedding ON preferences USING ivfflat (embedding vector_cosine_ops);
