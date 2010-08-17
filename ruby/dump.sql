PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE "messages" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "label" TEXT,
    "text" TEXT NOT NULL
);
INSERT INTO "messages" VALUES(1,NULL,'Non ho capito...');
INSERT INTO "messages" VALUES(2,NULL,'Puoi ripetere?');
INSERT INTO "messages" VALUES(3,'gu_molti','ci sono');
INSERT INTO "messages" VALUES(4,'gu_uno','c''e''');
INSERT INTO "messages" VALUES(5,'gu','Nella zona');
INSERT INTO "messages" VALUES(6,'benv','Benvenuto...');
INSERT INTO "messages" VALUES(7,'rich_benv','Prima di ogni cosa un saluto e'' doveroso!');
INSERT INTO "messages" VALUES(8,'up_true','Ti sei alzato');
INSERT INTO "messages" VALUES(9,'up_false','Sei gia'' in piedi!');
INSERT INTO "messages" VALUES(10,'down_true','Ti sei adagiato per terra');
INSERT INTO "messages" VALUES(11,'down_false','Sei gia'' per terra!');
INSERT INTO "messages" VALUES(12,'non_reg','Il nuo nome non e'' registrato!');
CREATE TABLE "users" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "nick" TEXT NOT NULL
);
INSERT INTO "users" VALUES(1,'amati');
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('messages',12);
INSERT INTO "sqlite_sequence" VALUES('users',1);
COMMIT;
