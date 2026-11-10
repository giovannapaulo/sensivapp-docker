CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    tipo_perfil VARCHAR(50) DEFAULT 'Paciente', 
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categorias_gatilhos (
    id SERIAL PRIMARY KEY,
    nome_gatilho VARCHAR(100) NOT NULL, 
    descricao_gatilho TEXT
);

CREATE TABLE IF NOT EXISTS sintomas (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
    gatilho_id INT REFERENCES categorias_gatilhos(id) ON DELETE SET NULL,
    intensidade VARCHAR(50) NOT NULL,
    descricao TEXT,
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS configuracoes_usuario (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
    modo_alto_contraste BOOLEAN DEFAULT FALSE,
    notificacoes_ativas BOOLEAN DEFAULT TRUE,
    limite_alerta_intensidade VARCHAR(50) DEFAULT 'Intenso'
);

CREATE TABLE IF NOT EXISTS notificacoes (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
    mensagem TEXT NOT NULL,
    lida BOOLEAN DEFAULT FALSE,
    enviada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS logs_auditoria (
    id SERIAL PRIMARY KEY,
    acao VARCHAR(100) NOT NULL,
    detalhes TEXT,
    nivel_severidade VARCHAR(20) DEFAULT 'INFO',
    data_acao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usuarios (nome, email, tipo_perfil) VALUES 
('Giovanna Brandão', 'giovanna@sensivapp.com', 'Paciente'),
('Camila Pereira', 'camila@sensivapp.com', 'Cuidador');

INSERT INTO categorias_gatilhos (nome_gatilho, descricao_gatilho) VALUES 
('Ruído Excessivo', 'Sons altos, multidões ou frequências agudas.'),
('Luz Intensa', 'Luzes fluorescentes fortes ou claridade solar direta.'),
('Sobrecarga Visual', 'Ambientes muito poluídos visuais ou telas piscando.');

INSERT INTO sintomas (usuario_id, gatilho_id, intensidade, descricao) VALUES 
(1, 1, 'Leve', 'Leve desconforto sensorial ao final do expediente de estudos.'),
(1, 2, 'Intenso', 'Crise de sobrecarga sensorial após exposição repentina a ruídos altos.');

INSERT INTO configuracoes_usuario (usuario_id, modo_alto_contraste, notificacoes_ativas) VALUES 
(1, TRUE, TRUE),
(2, FALSE, TRUE);

INSERT INTO notificacoes (usuario_id, mensagem) VALUES 
(1, 'Lembrete: Registre seu nível de conforto sensorial de hoje.');

INSERT INTO logs_auditoria (acao, detalhes, nivel_severidade) VALUES 
('INIT_DB', 'Banco de dados relacional completo inicializado com sucesso para o SensivApp.', 'INFO');
