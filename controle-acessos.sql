#create database Controle_Acesso;
use Controle_Acesso;

CREATE TABLE IF NOT EXISTS  usuarios	(
		usuario_id	INTEGER	UNSIGNED	NOT	NULL	AUTO_INCREMENT,
		usuario_nome	VARCHAR(50)	NOT	NULL,
		PRIMARY	KEY	(usuario_id)
);
CREATE	TABLE IF NOT EXISTS funcoes	(
		funcao_id	INTEGER	UNSIGNED	NOT	NULL	AUTO_INCREMENT,
		funcao_nome	VARCHAR(50)	NOT	NULL,
		PRIMARY	KEY	(funcao_id)
);
CREATE	TABLE IF NOT EXISTS permissoes	(
		perm_id	INTEGER	UNSIGNED	NOT	NULL	AUTO_INCREMENT,
		perm_desc	VARCHAR(50)	NOT	NULL,
		PRIMARY	KEY	(perm_id)
);
CREATE	TABLE IF NOT EXISTS funcao_perm	(
		funcao_id	INTEGER	UNSIGNED	NOT	NULL,
		perm_id	INTEGER	UNSIGNED	NOT	NULL,
		FOREIGN	KEY	(funcao_id)	REFERENCES	funcoes(funcao_id),
		FOREIGN	KEY	(perm_id)	REFERENCES	permissoes(perm_id)
);
CREATE	TABLE	usuario_funcao	(
		usuario_id	INTEGER	UNSIGNED	NOT	NULL,
		funcao_id	INTEGER	UNSIGNED	NOT	NULL,
		FOREIGN	KEY	(usuario_id)	REFERENCES	usuarios(usuario_id),
		FOREIGN	KEY	(funcao_id)	REFERENCES	funcoes(funcao_id)
);

