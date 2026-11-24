-- Практична робота №14. Створення та відкат транзакцій у SQLite
-- Варіант 7: спортивний зал / фітнес-клуб
-- База: lab_work_14.db (копія бази з практичної №13)
-- Таблиці та структура не змінювалися.
--
-- ВАЖЛИВО:
-- Завдання 4 і 5 містять навмисну помилку UNIQUE.
-- Щоб файл можна було виконати без аварійного переривання у DB Browser,
-- команди, які мають спричинити помилку, залишені як коментарі.
-- Для демонстрації помилки виділіть і виконайте їх ОКРЕМО,
-- після попередньої успішної INSERT у відповідній транзакції.
-- Точний текст помилки наведено біля кожної команди.

PRAGMA foreign_keys = ON;

-- =========================================================
-- ЗАВДАННЯ 1. Атомарна пара INSERT + UPDATE
-- Новий продаж місячного абонемента клієнту id=1.
-- Одночасно продовжуємо попередній продаж цього клієнта.
-- Обидві зміни мають бути зафіксовані разом.
BEGIN;

INSERT INTO membership_sales
    (id, membership_id, client_id, purchase_date, expiration_date)
VALUES (11, 3, 1, '2026-10-10', '2026-11-09');

UPDATE membership_sales
SET expiration_date = '2026-10-10'
WHERE id = 9 AND client_id = 1;

SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales
WHERE id IN (9, 11)
ORDER BY id;

COMMIT;

-- Очікуваний результат після COMMIT:
-- (9, 6, 1, '2026-09-09', '2026-10-10')
-- (11, 3, 1, '2026-10-10', '2026-11-09')


-- =========================================================
-- ЗАВДАННЯ 2. Свідомий ROLLBACK
-- Додаємо тестовий продаж, але скасовуємо його.
BEGIN;

INSERT INTO membership_sales
    (id, membership_id, client_id, purchase_date, expiration_date)
VALUES (12, 2, 2, '2026-10-11', '2026-10-18');

SELECT COUNT(*) AS row_visible_inside_transaction
FROM membership_sales
WHERE id = 12;

ROLLBACK;

SELECT COUNT(*) AS row_after_rollback
FROM membership_sales
WHERE id = 12;

-- Очікувані результати: до ROLLBACK = 1; після ROLLBACK = 0.


-- =========================================================
-- ЗАВДАННЯ 3. Проміжний стан усередині транзакції
-- Зміна видима у цій самій сесії до COMMIT.
BEGIN;

UPDATE membership_sales
SET expiration_date = '2026-10-20'
WHERE id = 10;

SELECT id, expiration_date
FROM membership_sales
WHERE id = 10;

ROLLBACK;

-- Очікувано всередині транзакції: id=10, expiration_date=2026-10-20.
-- Після ROLLBACK значення повертається до 2026-12-09.


-- =========================================================
-- ЗАВДАННЯ 4. Свідома помилка всередині транзакції
-- Успішний INSERT у membership_sales, потім дубль email у clients.
-- Виконайте команди послідовно, кожну окремо.
BEGIN;

INSERT INTO membership_sales
    (id, membership_id, client_id, purchase_date, expiration_date)
VALUES (12, 2, 3, '2026-10-12', '2026-10-19');

-- НАВМИСНА ПОМИЛКА: розкоментуйте та виконайте окремо:
-- INSERT INTO clients (id, first_name, last_name, email, phone)
-- VALUES (5, 'Тест', 'Дубль', 'ivan.petrenko@example.com', '+380000000000');
-- Точна помилка SQLite: UNIQUE constraint failed: clients.email

SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales
WHERE id = 12;

ROLLBACK;

SELECT COUNT(*) AS row_after_rollback
FROM membership_sales
WHERE id = 12;

-- Очікувано: перший INSERT видно всередині транзакції (1 рядок),
-- але після ROLLBACK запис відсутній (0 рядків).


-- =========================================================
-- ЗАВДАННЯ 5. Забутий ROLLBACK: COMMIT після помилки
-- Успішний INSERT, далі та сама помилка UNIQUE, але COMMIT.
BEGIN;

INSERT INTO membership_sales
    (id, membership_id, client_id, purchase_date, expiration_date)
VALUES (13, 2, 4, '2026-10-13', '2026-10-20');

-- НАВМИСНА ПОМИЛКА: розкоментуйте та виконайте окремо:
-- INSERT INTO clients (id, first_name, last_name, email, phone)
-- VALUES (6, 'Тест', 'Дубль', 'ivan.petrenko@example.com', '+380000000000');
-- Точна помилка SQLite: UNIQUE constraint failed: clients.email

-- Помилка UNIQUE скасовує лише невдалу INSERT-команду (за типової
-- поведінки ABORT), але не всю транзакцію. Тому наступний COMMIT
-- зафіксує попередній успішний INSERT у membership_sales.
COMMIT;

SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales
WHERE id = 13;

SELECT COUNT(*) AS clients_count FROM clients;

-- Очікувано: продаж id=13 є; кількість клієнтів залишається 4.
