# Документация BIM Classification System

- 01_data-schemas.md — ER-диаграммы PostgreSQL и ClickHouse с описанием сущностей и связей
- 02_class-diagram.md — Диаграмма классов реализации с описанием сущностей и связей
- 03_mapping.md — Соответствие между классами (Pydantic/SQLAlchemy) и схемами данных (PostgreSQL/ClickHouse)
- 04_use-cases.md — Use Case диаграммы и описание сценариев использования
- 05_data-lifecycle.md — Жизненный цикл ключевых типов данных, последовательности и/или диаграммы состояний
- 06_component-architecture.md — Диаграмма компонентов (архитектура приложения)

Легенда индексов (используются во всех диаграммах):
- [M#] — модели Pydantic/DTO
- [P#] — сущности PostgreSQL (SQLAlchemy)
- [C#] — сущности ClickHouse

Словарь типов (быстрые ссылки):
- [PG.BimInfo](01_data-schemas.md#p1-pgbiminfo)
- [PG.BimPath](01_data-schemas.md#p2-pgbimpath)
- [PG.ClassificationInfo](01_data-schemas.md#p3-pgclassificationinfo)
- [PG.ClassificationStatus](01_data-schemas.md#p4-pgclassificationstatus)
- [PG.Classificatory](01_data-schemas.md#p5-pgclassificatory)
- [PG.CandidateMatch](01_data-schemas.md#p6-pgcandidatematch)
- [PG.LlmInfo](01_data-schemas.md#p7-pgllminfo)
- [CH.BimUpload](01_data-schemas.md#c1-chbimupload)
- [CH.TrainingElemFolderMapping](01_data-schemas.md#c4-chtrainingelemfoldermapping)
- [CH.TrainingLlmElemFolderMapping](01_data-schemas.md#c5-chtrainingllmelemfoldermapping)
- [CH.TrainingElemEmbedding](01_data-schemas.md#c2-chtrainingelemembedding)
- [CH.TrainingFolderEmbedding](01_data-schemas.md#c3-chtrainingfolderembedding)
- [Model.UploadBimSchemas](02_class-diagram.md#modeluploadbimschemas-m2)
- [Model.ClassificationParams](02_class-diagram.md#modelclassificationparams-m5)
- [Model.CandidateMatchSchema](02_class-diagram.md#modelcandidatematchschema-m7)
- [Model.LLMlistResponse](02_class-diagram.md#modelllmlistresponse-m8)
- [Model.BIMElement](02_class-diagram.md#modelbimelement-m9)
