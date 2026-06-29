-- =============================================================
-- 完整导入脚本（PostgreSQL 格式）
-- 包含：建表 + 数据插入
-- 顺序：Question → Option → Blank（遵循外键依赖）
-- =============================================================

BEGIN;

-- -------------------------------------------------------------
-- DDL: 建表
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS "Question" (
    "id"     INTEGER      PRIMARY KEY,
    "type"   VARCHAR(20)  NOT NULL,
    "text"   TEXT         NOT NULL,
    "answer" VARCHAR(50)  NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS "Option" (
    "id"         INTEGER      PRIMARY KEY,
    "label"      VARCHAR(5)   NOT NULL,
    "text"       TEXT         NOT NULL,
    "questionId" INTEGER      NOT NULL REFERENCES "Question"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Blank" (
    "id"         INTEGER      PRIMARY KEY,
    "text"       TEXT         NOT NULL,
    "order"      INTEGER      NOT NULL DEFAULT 0,
    "questionId" INTEGER      NOT NULL REFERENCES "Question"("id") ON DELETE CASCADE
);

-- -------------------------------------------------------------
-- DML: Question
-- -------------------------------------------------------------

INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (43, '单选题', '以下表示数据库管理系统的是（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (44, '单选题', '目前应用最广泛的数据库模型是（ ）', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (45, '单选题', '数据库体系结构是（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (46, '单选题', '数据库的三级模式结构是指（ ）', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (47, '单选题', '数据库领域中主要的逻辑数据模型不包含下列哪种模型（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (48, '单选题', '数据库中，数据的物理独立性是指（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (49, '单选题', '数据库管理系统能实现对数据库中数据的查询、插入、修改和删除等操作，这种功能称为（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (50, '单选题', '将数据库的结构划分成三级模式，是为了提高数据库的（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (51, '单选题', '数据的逻辑独立性是通过（ ）得到保证。', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (52, '单选题', '下面哪个不是数据库管理员（DBA）的职责（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (53, '单选题', '一个关系中的各元组（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (54, '单选题', '在关系代数运算中，专门的关系运算包括以下（ ）4种。', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (55, '单选题', '取出关系中的某些列，并消去重复元组的关系代数运算称为（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (56, '单选题', '设有关系：班级（班号，专业，班长）；学生（学号，姓名，性别，班号）。学生关系中每个元组的班号属性值只能取空值或者是班级关系中的某一个班号。这个要求属于关系的（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (57, '单选题', '设关系R和S的元组个数分别是3和4，关系T是R与S的笛卡尔积，即T=R×S，则关系T的元组个数是（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (58, '单选题', '设关系 R 和 S 具有相同的度，且对应的属性取自相同的域。集合 { t | t∈R ∧ t∈S } 表示的是（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (59, '单选题', '设关系 R 和 S 具有相同的度，且对应的属性取自相同的域。集合 { t | t∈R ∨ t∈S } 表示的是（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (60, '单选题', '数据库的（ ）是指数据的正确性和相容性。', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (61, '单选题', '在关系代数的专门关系运算中，从表中选出满足某种条件的元组的操作称为（ ）', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (62, '单选题', '关系查询操作中的五种基本运算是指（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (63, '单选题', '在数据库系统中，保证数据及语义正确和有效的功能是（ ）', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (64, '单选题', '如果对选课表中学生的选课成绩限定在0~100这个输入范围，应使用（ ）约束。', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (65, '单选题', '关于主键约束以下说法错误的是（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (66, '单选题', '如果在学生表中要求学生的姓名不能重名，应使用（ ）约束。', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (67, '单选题', '在一个已经存在的表中要为表添加约束，可以使用（ ）命令。', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (69, '单选题', '若有两张表：学生（学号，姓名，性别，年龄），选课（学号，课程号，成绩），要使选课表中学号的取值参照学生表中的主键学号的值，可以为选课表中的学号添加（ ）约束。', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (70, '单选题', '强制存取控制策略是TCSEC/TDI哪一级安全级别的特色（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (71, '单选题', 'SQL的Grant和Revoke语句可以用来实现（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (72, '单选题', '在强制存取控制机制中，当主体的许可证级别等于客体的密级时，主体可以对客体进行如下操作（ ）', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (73, '单选题', '在数据加密技术中，原始数据通过某种加密算法变换为不可直接识别的格式，称为（ ）。', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (74, '单选题', '数据库角色实际上是一组与数据库操作相关的各种（ ）。', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (75, '判断题', '在数据库系统中只有一个模式，这个模式只对应一个内模式。（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (76, '判断题', '数据库管理系统的模式/内模式映像保证了数据与程序的逻辑独立性。（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (77, '判断题', '一个数据库系统可以有多个外模式。（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (78, '判断题', '假设有关系R和S，关系代数表达式R-(R-S)表示的是R∩S。（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (79, '填空题', '数据库安全技术包括用户身份鉴别、______、______、______和数据加密等。', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (80, '填空题', '在对用户授予列 Insert 权限时，一定要包含对______的 Insert 权限，否则用户的插入会因为空值被拒绝。除了授权的列，其他列的值或者取______，或者为默认值。', '') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (81, '判断题', '自然连接是构成新关系的有效方法。一般情况下，当对关系R和S使用自然连接时，要求R和S含有一个或多个共有的元组。（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (82, '判断题', '对数据库中的表进行插入操作时，有可能违背参照完整性约束。（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (83, '判断题', '对数据库中的表进行删除操作时，有可能违背用户定义的完整性。（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (84, '判断题', '任何情况下，某个外键的取值除了可以取它所参照的主键表中的某个主键值外，都可以取空值。（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (85, '单选题', '关系规范化中的删除异常是指（ ）', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (86, '单选题', '规范化过程主要为克服数据库逻辑结构中的插入异常，删除异常，修改异常以及（ ）的缺陷。', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (87, '单选题', '满足1NF关系模式的最基本的条件是（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (88, '单选题', '已知关系模式R（A，B，C，D，E）及其函数依赖集合 F = {A→D, B→C, E→A}，该关系模式的候选码是（ ）', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (89, '单选题', 'X→Y，当下列哪一条成立时，称为平凡的函数依赖（ ）。', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (90, '单选题', '设有关系模式R（A，B，C，D），其数据依赖集：F = {(A,B)→C, C→D}，则关系模式的规范化程度最高达到（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (92, '单选题', '消除了非主属性对码的传递函数依赖的关系模式达到了（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (93, '单选题', '在关系数据库设计中，设计关系模式是（ ）的任务。', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (94, '单选题', '储蓄所有多个储户，储户能够在多个储蓄所存取款，储蓄所与储户之间是（ ）', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (95, '单选题', '从E-R图中导出关系模型时，如果实体间的联系是 n:m 的，下列说法中正确的是（ ）。', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (96, '单选题', '公司有多个部门和多名职员，每个职员只能属于一个部门，一个部门有多名职员，职员与部门的联系类型是（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (97, '单选题', '表示数据库的概念模型一般使用（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (98, '单选题', '在数据库设计中，用E-R图来描述结构是数据库设计的（ ）', 'B') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (99, '单选题', '以下描述不正确的是（ ）', 'C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (100, '单选题', '数据库设计中，确定数据库存储结构，即确定关系、索引、聚簇、日志、备份等数据的存储安排和存储结构，这是数据库设计的（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (101, '单选题', '建立数据字典的时机是（ ）', 'A') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (108, '多选题', '给定关系模式R(A，B，C，D)，如果存在依赖：A→B，BC→D，DE→A，则该关系模式的码为（ ）（多选）', 'A,B,D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (110, '多选题', '在概念结构设计阶段，把一个系统中各子系统的分E-R图集成时，要做以下什么事情（ ）（多选）', 'A,B,C') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (112, '多选题', '关于用户外模式的说法正确的是（ ）（多选）', 'A,B,D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (113, '单选题', '若一个表中的某个约束只涉及到一个列时，可以使用（ ）定义该约束。', 'D') ON CONFLICT (id) DO NOTHING;
INSERT INTO "Question" ("id", "type", "text", "answer") VALUES (114, '单选题', '当关系模式R属于3NF，下列说法中（ ）是正确的。', 'D') ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------
-- DML: Option
-- -------------------------------------------------------------

INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2398, 'A', 'DBA', 43) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2399, 'B', 'DBMS', 43) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2400, 'C', 'DB', 43) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2401, 'D', 'DATA', 43) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2402, 'A', '层次模型', 44) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2403, 'B', '网状模型', 44) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2404, 'C', '混合模型', 44) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2405, 'D', '关系模型', 44) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2406, 'A', '两级模式结构和一级映像', 45) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2407, 'B', '三级模式结构和一级映像', 45) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2408, 'C', '三级模式结构和两级映像', 45) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2409, 'D', '三级模式结构和三级映像', 45) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2410, 'A', '外模式、模式、子模式', 46) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2411, 'B', '子模式、模式、概念模式', 46) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2412, 'C', '模式、内模式、存储模式', 46) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2413, 'D', '外模式、模式、内模式', 46) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2414, 'A', '层次模型', 47) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2415, 'B', '网状模型', 47) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2416, 'C', '线性模型', 47) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2417, 'D', '关系模型', 47) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2418, 'A', '数据库与数据库管理系统的相互独立', 48) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2419, 'B', '用户程序与DBMS的相互独立', 48) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2420, 'C', '用户的应用程序与存储在磁盘上数据库中的数据是相互独立的', 48) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2421, 'D', '用户程序与数据库中数据的逻辑结构相互独立', 48) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2422, 'A', '数据定义功能', 49) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2423, 'B', '数据管理功能', 49) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2424, 'C', '数据操纵功能', 49) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2425, 'D', '数据控制功能', 49) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2426, 'A', '数据完整性', 50) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2427, 'B', '数据独立性', 50) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2428, 'C', '管理规范性', 50) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2429, 'D', '数据的共享', 50) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2430, 'A', '模式/内模式映像', 51) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2431, 'B', '外模式/模式映像', 51) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2432, 'C', '模式', 51) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2433, 'D', '外模式', 51) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2434, 'A', '决定数据库中的信息内容和结构', 52) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2435, 'B', '设计和编写应用程序', 52) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2436, 'C', '定义数据的安全性要求和完整性约束条件', 52) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2437, 'D', '数据库的改进和重组、重构', 52) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2438, 'A', '前后顺序不能任意颠倒，一定要按照输入的顺序排列', 53) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2439, 'B', '前后顺序可以任意颠倒，不影响关系', 53) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2440, 'C', '前后顺序可以任意颠倒，但排列顺序不同，统计处理的结果可能不同', 53) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2441, 'D', '前后顺序不能任意颠倒，一定要按照码的属性列顺序排列', 53) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2442, 'A', '并、选择、投影、连接', 54) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2443, 'B', '并、差、交、选择', 54) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2444, 'C', '选择、投影、连接、除', 54) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2445, 'D', '并、差、交、连接', 54) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2446, 'A', '除运算', 55) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2447, 'B', '投影运算', 55) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2448, 'C', '连接运算', 55) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2449, 'D', '选择运算', 55) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2450, 'A', '参照完整性', 56) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2451, 'B', '实体完整性', 56) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2452, 'C', '用户自定义完整性', 56) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2453, 'D', '以上都不是', 56) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2454, 'A', '7', 57) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2455, 'B', '9', 57) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2456, 'C', '12', 57) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2457, 'D', '16', 57) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2458, 'A', 'R∩S', 58) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2459, 'B', 'R－S', 58) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2460, 'C', 'R×S', 58) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2461, 'D', 'R∪S', 58) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2462, 'A', 'R∪S', 59) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2463, 'B', 'R－S', 59) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2464, 'C', 'R×S', 59) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2465, 'D', 'R∩S', 59) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2466, 'A', '安全性', 60) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2467, 'B', '完整性', 60) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2468, 'C', '并发控制', 60) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2469, 'D', '恢复', 60) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2470, 'A', '扫描', 61) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2471, 'B', '投影', 61) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2472, 'C', '连接', 61) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2473, 'D', '选择', 61) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2474, 'A', '交、并、差、笛卡尔积、投影', 62) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2475, 'B', '并、差、笛卡尔积、选择、投影', 62) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2476, 'C', '并、差、笛卡尔积、选择、连接', 62) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2477, 'D', '选择、投影、连接、除、笛卡尔积', 62) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2478, 'A', '并发控制', 63) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2479, 'B', '存取控制', 63) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2480, 'C', '安全控制', 63) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2481, 'D', '完整性控制', 63) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2482, 'A', 'Primary Key', 64) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2483, 'B', 'Foreign Key', 64) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2484, 'C', 'Unique', 64) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2485, 'D', 'Check', 64) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2486, 'A', '一个表中只能设置一个主键约束', 65) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2487, 'B', '允许空值的字段上可以定义主键约束', 65) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2488, 'C', '可以将包含多个字段的字段组合设置为主键', 65) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2489, 'D', '允许空值的字段上不能定义主键约束', 65) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2490, 'A', 'Primary Key', 66) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2491, 'B', 'Foreign Key', 66) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2492, 'C', 'Unique', 66) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2493, 'D', 'Check', 66) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2494, 'A', 'Create table', 67) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2495, 'B', 'Alter table', 67) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2496, 'C', 'Drop table', 67) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2497, 'D', 'Add', 67) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2498, 'A', 'Primary Key', 69) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2499, 'B', 'Foreign Key', 69) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2500, 'C', 'Unique', 69) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2501, 'D', 'Check', 69) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2502, 'A', 'C1', 70) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2503, 'B', 'C2', 70) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2504, 'C', 'B1', 70) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2505, 'D', 'B2', 70) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2506, 'A', '自主存取控制', 71) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2507, 'B', '强制存取控制', 71) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2508, 'C', '数据库角色创建', 71) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2509, 'D', '数据库审计', 71) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2510, 'A', '读取', 72) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2511, 'B', '写入', 72) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2512, 'C', '不可操作', 72) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2513, 'D', '读取、写入', 72) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2514, 'A', '主码', 73) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2515, 'B', '密文', 73) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2516, 'C', '审计', 73) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2517, 'D', '写入', 73) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2518, 'A', '设置', 74) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2519, 'B', '读取', 74) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2520, 'C', '权限', 74) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2521, 'D', '加密', 74) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2522, 'A', '正确', 75) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2523, 'B', '错误', 75) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2524, 'A', '正确', 76) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2525, 'B', '错误', 76) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2526, 'A', '正确', 77) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2527, 'B', '错误', 77) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2528, 'A', '正确', 78) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2529, 'B', '错误', 78) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2530, 'A', '正确', 81) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2531, 'B', '错误', 81) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2532, 'A', '正确', 82) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2533, 'B', '错误', 82) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2534, 'A', '正确', 83) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2535, 'B', '错误', 83) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2536, 'A', '正确', 84) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2537, 'B', '错误', 84) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2538, 'A', '应该删除的数据未被删除', 85) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2539, 'B', '应该插入的数据未被插入', 85) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2540, 'C', '不该插入的数据被插入', 85) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2541, 'D', '不该删除的数据被删除', 85) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2542, 'A', '数据的不一致性', 86) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2543, 'B', '结构不合理', 86) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2544, 'C', '数据丢失', 86) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2545, 'D', '冗余度大', 86) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2546, 'A', '每一个分量都是不可再分的数据项', 87) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2547, 'B', '分量是可以再分的数据项', 87) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2548, 'C', '该关系模式中的命名可以不唯一', 87) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2549, 'D', '以上都不是', 87) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2550, 'A', 'CD', 88) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2551, 'B', 'AB', 88) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2552, 'C', 'DE', 88) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2553, 'D', 'BE', 88) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2554, 'A', 'X∈Y', 89) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2555, 'B', 'Y∈X', 89) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2556, 'C', 'X∩Y = φ', 89) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2557, 'D', 'X∩Y ≠ φ', 89) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2558, 'A', 'BCNF', 90) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2559, 'B', '1NF', 90) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2560, 'C', '2NF', 90) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2561, 'D', '3NF', 90) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2562, 'A', '它一定消除了非主属性对码的部分函数依赖', 114) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2563, 'B', '每个函数依赖的左部都含有候选码', 114) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2564, 'C', '它一定消除了非主属性对码的传递函数依赖', 114) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2565, 'D', '它一定消除了非主属性对码的部分函数依赖并且它一定消除了非主属性对码的传递函数依赖', 114) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2566, 'A', '1NF', 92) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2567, 'B', '2NF', 92) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2568, 'C', '3NF', 92) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2569, 'D', 'BCNF', 92) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2570, 'A', '逻辑设计阶段', 93) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2571, 'B', '概念设计阶段', 93) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2572, 'C', '需求分析阶段', 93) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2573, 'D', '物理设计阶段', 93) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2574, 'A', '一对一的联系', 94) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2575, 'B', '一对多的联系', 94) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2576, 'C', '多对一的联系', 94) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2577, 'D', '多对多的联系', 94) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2578, 'A', '将n方主键和联系的属性纳入m方的属性中', 95) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2579, 'B', '将m方主键和联系的属性纳入n方的属性中', 95) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2580, 'C', '增加一个关系表示联系，其中纳入m方和n方的主键和联系的属性', 95) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2581, 'D', '在m方属性和n方属性中均增加一个表示级别的属性', 95) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2582, 'A', '一对一的联系', 96) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2583, 'B', '一对多的联系', 96) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2584, 'C', '多对一的联系', 96) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2585, 'D', '多对多的联系', 96) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2586, 'A', 'E-R图', 97) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2587, 'B', '数据流图', 97) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2588, 'C', '用户活动图', 97) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2589, 'D', '流程图', 97) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2590, 'A', '需求分析阶段', 98) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2591, 'B', '概念设计阶段', 98) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2592, 'C', '逻辑设计阶段', 98) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2593, 'D', '物理设计阶段', 98) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2594, 'A', '属性是不能具有再分的数理项', 99) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2595, 'B', '一个关系模式可以具有多个候选码', 99) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2596, 'C', '实体和属性之间可以存在联系', 99) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2597, 'D', '联系可以具有属性', 99) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2598, 'A', '物理设计阶段', 100) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2599, 'B', '概念设计阶段', 100) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2600, 'C', '逻辑设计阶段', 100) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2601, 'D', '需求分析阶段', 100) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2602, 'A', '需求分析阶段', 101) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2603, 'B', '数据库物理设计阶段', 101) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2604, 'C', '数据库实施阶段', 101) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2605, 'D', '概念结构设计阶段', 101) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2606, 'A', 'ACE', 108) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2607, 'B', 'BCE', 108) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2608, 'C', 'ABC', 108) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2609, 'D', 'CDE', 108) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2610, 'A', '消除各种冲突', 110) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2611, 'B', '消除冗余的数据', 110) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2612, 'C', '消除冗余的联系', 110) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2613, 'D', '把E-R图转换成关系模型', 110) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2614, 'A', '可以使用更符合用户习惯的别名', 112) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2615, 'B', '可以针对不同级别的用户定义不同的视图', 112) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2616, 'C', '可以保证数据的完整性', 112) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2617, 'D', '可以将复杂的查询定义为视图，简化用户对系统的使用', 112) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2618, 'A', '列级约束', 113) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2619, 'B', '表级约束', 113) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2620, 'C', '元组级约束', 113) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Option" ("id", "label", "text", "questionId") VALUES (2621, 'D', '列级约束和表级约束都可以', 113) ON CONFLICT (id) DO NOTHING;

-- -------------------------------------------------------------
-- DML: Blank
-- -------------------------------------------------------------

INSERT INTO "Blank" ("id", "text", "order", "questionId") VALUES (56, '存取控制', 0, 79) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Blank" ("id", "text", "order", "questionId") VALUES (57, '视图机制', 1, 79) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Blank" ("id", "text", "order", "questionId") VALUES (58, '审计', 2, 79) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Blank" ("id", "text", "order", "questionId") VALUES (59, '主键', 0, 80) ON CONFLICT (id) DO NOTHING;
INSERT INTO "Blank" ("id", "text", "order", "questionId") VALUES (60, '空值', 1, 80) ON CONFLICT (id) DO NOTHING;

COMMIT;
