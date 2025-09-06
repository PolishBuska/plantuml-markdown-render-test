# Диаграмма классов реализации

Нумерация моделей (M#):
- [M1] PathBimModel, [M2] UploadBimSchemas, [M3] StatusUploadResponseSchemas, [M4] Classificatory, [M5] ClassificationParams, [M6] ClassificationInsertInfo, [M7] CandidateMatchSchema, [M8] LLMlistResponse, [M9] BIMElement.

## Диаграмма [D3] Классы (Pydantic и SQLAlchemy)

<!-- puml: ./diagrams/class-diagram.puml -->
```plantuml
@startuml
!include ./diagrams/class-diagram.puml
@enduml
```

Источник диаграммы: diagrams/class-diagram.puml

Что изображено:
1. Pydantic-модели запросов/ответов (Model.*) для веб-API.
2. SQLAlchemy-модели (PG.*) для хранения в PostgreSQL.
3. Логические соответствия между DTO и таблицами (maps to ...).

Ключевые соответствия (по [M#] → [P#]/[C#]):
- [M2].path ↔ [P2] (nodes, properties, edges).
- [M3] ↔ [P1] (статус загрузки/percent и т.д.).
- [M6]/[M5] ↔ [P3] + [P5].
- [M7] ↔ [P6].
- [M8] ↔ [P7].
- [M9] ↔ [C1] (BimUpload).

Сквозные упоминания:
- ER-схемы: [D1] (PostgreSQL), [D2] (ClickHouse).
- Последовательности [D5]: операции обращаются к указанным сущностям по номерам.

<h3 id="modeluploadbimschemas"></h3>
<a id="modeluploadbimschemas"></a>
### Model.UploadBimSchemas ([M2])
DTO загрузки BIM: содержит path (nodes/properties/edges), bucket, name, description.

<h3 id="modelclassificationparams"></h3>
<a id="modelclassificationparams"></a>
### Model.ClassificationParams ([M5])
Параметры запуска классификации: llm_id, classificator (опционально).

<h3 id="modelcandidatematchschema"></h3>
<a id="modelcandidatematchschema"></a>
### Model.CandidateMatchSchema ([M7])
Кандидаты сопоставления: bim_id, classification_id, elem_id, cluster_id, folder_id, elem_description, folder_path, distance, approved/final/llm_score/llm_reasoning (опционально).

<h3 id="modelllmlistresponse"></h3>
<a id="modelllmlistresponse"></a>
### Model.LLMlistResponse ([M8])
Справочник LLM: llm_id (опц.), llm_name, llm_description.

<h3 id="modelbimelement"></h3>
<a id="modelbimelement"></a>
### Model.BIMElement ([M9])
Эмбеддинг элемента BIM для CH: pk (опц.), bim_id, elem_id, description, cluster_id, embedding.
