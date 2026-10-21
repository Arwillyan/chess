CREATE DATABASE IF NOT EXISTS chess_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chess_db;

CREATE TABLE users (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(30)  NOT NULL UNIQUE,
  email         VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  rating        SMALLINT UNSIGNED NOT NULL DEFAULT 1200,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE games (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  room_code    CHAR(6) NOT NULL UNIQUE,
  visibility   ENUM('public','private') NOT NULL DEFAULT 'public',
  status       ENUM('waiting','active','finished','abandoned')
               NOT NULL DEFAULT 'waiting',
  white_id     INT UNSIGNED NULL,
  black_id     INT UNSIGNED NULL,
  is_vs_ai     TINYINT(1) NOT NULL DEFAULT 0,
  fen_current  VARCHAR(100) NOT NULL
    DEFAULT 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
  turn         ENUM('w','b') NOT NULL DEFAULT 'w',
  version      INT UNSIGNED NOT NULL DEFAULT 0,
  result       ENUM('white','black','draw') NULL,
  end_reason   VARCHAR(30) NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
               ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (white_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (black_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_status_vis (status, visibility)
) ENGINE=InnoDB;

CREATE TABLE moves (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  game_id    INT UNSIGNED NOT NULL,
  ply        SMALLINT UNSIGNED NOT NULL,
  from_sq    CHAR(2) NOT NULL,
  to_sq      CHAR(2) NOT NULL,
  promotion  CHAR(1) NULL,
  san        VARCHAR(12) NOT NULL,
  fen_after  VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
  UNIQUE KEY uq_game_ply (game_id, ply)
) ENGINE=InnoDB;