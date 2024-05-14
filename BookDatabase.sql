USE master;
go
DROP DATABASE IF EXISTS BookDatabase;
go
CREATE DATABASE BookDatabase;
go
USE BookDatabase;
go

-- Создаем таблицы узлов
CREATE TABLE Author (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Book (
    id INT NOT NULL PRIMARY KEY,
    title NVARCHAR(100) NOT NULL,
    year_published INT
) AS NODE;

CREATE TABLE Genre (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

-- Создаем таблицы ребер
CREATE TABLE WrittenBy AS EDGE;
CREATE TABLE BelongsToGenre AS EDGE;
CREATE TABLE Knows AS EDGE; 

-- Добавляем ограничение к таблице ребер WrittenBy для связи авторов с книгами
ALTER TABLE WrittenBy
ADD CONSTRAINT EC_WrittenBy CONNECTION (Author TO Book);

-- Добавляем ограничение к таблице ребер BelongsToGenre для связи книг с жанрами
ALTER TABLE BelongsToGenre
ADD CONSTRAINT EC_BelongsToGenre CONNECTION (Book TO Genre);

-- Добавляем ограничение к таблице ребер Knows для связи авторов друг с другом
ALTER TABLE Knows
ADD CONSTRAINT EC_Knows CONNECTION (Author TO Author);

-- Добавляем данные в таблицы узлов
INSERT INTO Author (id, name)
VALUES (1, N'Лев Толстой'),
       (2, N'Фёдор Достоевский'),
       (3, N'Джордж Оруэлл'),
       (4, N'Джейн Остин'),
       (5, N'Габриэль Гарсиа Маркес'),
       (6, N'Александр Пушкин'),
       (7, N'Михаил Булгаков'),
       (8, N'Эрнест Хемингуэй'),
       (9, N'Уильям Шекспир'),
       (10, N'Толкин');
GO
SELECT *
FROM Author;

INSERT INTO Book (id, title, year_published)
VALUES (1, N'Война и мир', 1869),
       (2, N'Преступление и наказание', 1866),
       (3, N'1984', 1949),
       (4, N'Гордость и предубеждение', 1813),
       (5, N'Сто лет одиночества', 1967),
       (6, N'Евгений Онегин', 1833),
       (7, N'Мастер и Маргарита', 1967),
       (8, N'Старик и море', 1952),
       (9, N'Гамлет', 1603),
       (10, N'Властелин колец', 1954);
GO
SELECT *
FROM Book;

INSERT INTO Genre (id, name)
VALUES (1, N'Роман'),
       (2, N'Фантастика'),
       (3, N'Детектив'),
       (4, N'Классика'),
       (5, N'Поэма'),
       (6, N'Мистика'),
       (7, N'Приключения'),
       (8, N'Трагедия'),
       (9, N'Фэнтези'),
       (10, N'Драма');
GO
SELECT *
FROM Genre;

-- Добавляем данные в таблицы ребер
INSERT INTO WrittenBy ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Author WHERE id = 1), (SELECT $node_id FROM Book WHERE id = 1)),
       ((SELECT $node_id FROM Author WHERE id = 2), (SELECT $node_id FROM Book WHERE id = 2)),
       ((SELECT $node_id FROM Author WHERE id = 3), (SELECT $node_id FROM Book WHERE id = 3)),
       ((SELECT $node_id FROM Author WHERE id = 4), (SELECT $node_id FROM Book WHERE id = 4)),
       ((SELECT $node_id FROM Author WHERE id = 5), (SELECT $node_id FROM Book WHERE id = 5)),
       ((SELECT $node_id FROM Author WHERE id = 6), (SELECT $node_id FROM Book WHERE id = 6)),
       ((SELECT $node_id FROM Author WHERE id = 7), (SELECT $node_id FROM Book WHERE id = 7)),
       ((SELECT $node_id FROM Author WHERE id = 8), (SELECT $node_id FROM Book WHERE id = 8)),
       ((SELECT $node_id FROM Author WHERE id = 9), (SELECT $node_id FROM Book WHERE id = 9)),
       ((SELECT $node_id FROM Author WHERE id = 10), (SELECT $node_id FROM Book WHERE id = 10));
	   GO
SELECT *
FROM WrittenBy;


INSERT INTO BelongsToGenre ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Book WHERE id = 1), (SELECT $node_id FROM Genre WHERE id = 1)),
       ((SELECT $node_id FROM Book WHERE id = 2), (SELECT $node_id FROM Genre WHERE id = 3)),
       ((SELECT $node_id FROM Book WHERE id = 3), (SELECT $node_id FROM Genre WHERE id = 2)),
       ((SELECT $node_id FROM Book WHERE id = 4), (SELECT $node_id FROM Genre WHERE id = 1)),
       ((SELECT $node_id FROM Book WHERE id = 5), (SELECT $node_id FROM Genre WHERE id = 1)),
       ((SELECT $node_id FROM Book WHERE id = 6), (SELECT $node_id FROM Genre WHERE id = 5)),
       ((SELECT $node_id FROM Book WHERE id = 7), (SELECT $node_id FROM Genre WHERE id = 6)),
       ((SELECT $node_id FROM Book WHERE id = 8), (SELECT $node_id FROM Genre WHERE id = 7)),
       ((SELECT $node_id FROM Book WHERE id = 9), (SELECT $node_id FROM Genre WHERE id = 8)),
       ((SELECT $node_id FROM Book WHERE id = 10), (SELECT $node_id FROM Genre WHERE id = 9));

	      GO
SELECT *
FROM BelongsToGenre;
INSERT INTO Knows ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Author WHERE id = 1), (SELECT $node_id FROM Author WHERE id = 2)), -- Лев Толстой - Фёдор Достоевский
       ((SELECT $node_id FROM Author WHERE id = 1), (SELECT $node_id FROM Author WHERE id = 3)), -- Лев Толстой - Джордж Оруэлл
       ((SELECT $node_id FROM Author WHERE id = 2), (SELECT $node_id FROM Author WHERE id = 4)), -- Фёдор Достоевский - Джейн Остин
       ((SELECT $node_id FROM Author WHERE id = 3), (SELECT $node_id FROM Author WHERE id = 5)), -- Джордж Оруэлл - Габриэль Гарсиа Маркес
       ((SELECT $node_id FROM Author WHERE id = 4), (SELECT $node_id FROM Author WHERE id = 6)), -- Джейн Остин - Александр Пушкин
       ((SELECT $node_id FROM Author WHERE id = 5), (SELECT $node_id FROM Author WHERE id = 7)), -- Габриэль Гарсиа Маркес - Михаил Булгаков
       ((SELECT $node_id FROM Author WHERE id = 6), (SELECT $node_id FROM Author WHERE id = 8)), -- Александр Пушкин - Эрнест Хемингуэй
       ((SELECT $node_id FROM Author WHERE id = 7), (SELECT $node_id FROM Author WHERE id = 9)), -- Михаил Булгаков - Уильям Шекспир
       ((SELECT $node_id FROM Author WHERE id = 8), (SELECT $node_id FROM Author WHERE id = 10)); -- Эрнест Хемингуэй - Толкин
	   GO
SELECT *
FROM Knows;

-- Найти все романы, написанные после 1800 года
SELECT Book.title
FROM Book, BelongsToGenre, Genre
WHERE MATCH(Book-(BelongsToGenre)->Genre)
  AND Book.year_published > 1800
  AND Genre.name = N'Роман';

--Получить все книги определенного жанра (например, "Детектив")
  SELECT Book.title
FROM Book, BelongsToGenre, Genre
WHERE MATCH(Book-(BelongsToGenre)->Genre)
  AND Genre.name = N'Детектив';

 -- Найти книги, написанные друзьями Льва Толстого
SELECT Book.title
FROM Author AS Tolstoy, Knows, Author, WrittenBy, Book
WHERE MATCH(Tolstoy-(Knows)->Author-(WrittenBy)->Book)
  AND Tolstoy.name = N'Лев Толстой';

--Получить всех с кем знаком автор с именем Фёдор Достоевский
SELECT Author1.name AS PersonName
 , Author2.name AS FriendName
FROM Author AS Author1
 , Knows AS FriendOf
 , Author AS Author2
WHERE MATCH(Author1-(FriendOf)->Author2)
 AND Author1.name = N'Фёдор Достоевский';


-- Найти жанры книг, которые написаны авторами, друзьями друзей Льва Толстого
SELECT Author1.name AS PersonName,
       Author3.name AS FriendOfFriend,
       Genre.name AS GenreName
FROM Author AS Author1,
     Knows AS FriendOf,
     Author AS Author2,
     Knows  AS FriendOfFriendRel,
     Author AS Author3,
     WrittenBy  AS WrittenByRel,
     Book AS Book1,
     BelongsToGenre  AS GenreRel,
     Genre
WHERE MATCH(Author1-(FriendOf)->Author2-(FriendOfFriendRel)->Author3-(WrittenByRel)->Book1-(GenreRel)->Genre)
  AND Author1.name = N'Лев Толстой';


--Найти друзей друзей Михаила Булгакова
SELECT Author1.name AS PersonName
 , STRING_AGG(Author2.name, '->') WITHIN GROUP (GRAPH PATH) AS Friends
FROM Author AS Author1
 , Knows FOR PATH AS k
 , Author FOR PATH AS Author2
WHERE MATCH(SHORTEST_PATH(Author1(-(k)->Author2){1,2}))
 AND Author1.name = N'Михаил Булгаков';


--Найти самую короткую связь от Джейн Остин до Толкин
DECLARE @PersonFrom AS NVARCHAR(30) = N'Джейн Остин';
DECLARE @PersonTo AS NVARCHAR(30) = N'Толкин';

WITH T1 AS (
    SELECT Author1.name AS PersonName,
           STRING_AGG(Author2.name, '->') WITHIN GROUP (GRAPH PATH) AS Friends,
           LAST_VALUE(Author2.name) WITHIN GROUP (GRAPH PATH) AS LastNode
    FROM Author AS Author1
    , Knows FOR PATH AS k
    , Author FOR PATH AS Author2
    WHERE MATCH(SHORTEST_PATH(Author1(-(k)->Author2)+))
    AND Author1.name = @PersonFrom
)
SELECT PersonName, Friends
FROM T1
WHERE LastNode = @PersonTo;
