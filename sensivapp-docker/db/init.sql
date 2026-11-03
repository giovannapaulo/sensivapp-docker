CREATE TABLE IF NOT EXISTS sintomas (
    id SERIAL PRIMARY KEY,
    intensidade VARCHAR(50) NOT NULL,
    descricao TEXT
);

INSERT INTO sintomas (intensidade, descricao) VALUES 
('Leve', 'Leve desconforto sensorial ao final do dia.'),
('Intenso', 'Crise de sobrecarga sensorial após exposição a ruídos.');