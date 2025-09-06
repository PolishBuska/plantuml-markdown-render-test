# Схемы данных (ER-диаграммы)

Ниже — inline-рендер через PlantUML include и подробные описания. Введём постоянную нумерацию сущностей по диаграммам:

PostgreSQL (P#):
- [P1] PG.BimInfo, [P2] PG.BimPath, [P3] PG.ClassificationInfo, [P4] PG.ClassificationStatus, [P5] PG.Classificatory, [P6] PG.CandidateMatch, [P7] PG.LlmInfo.

ClickHouse (C#):
- [C1] CH.BimUpload, [C2] CH.TrainingElemEmbedding, [C3] CH.TrainingFolderEmbedding, [C4] CH.TrainingElemFolderMapping, [C5] CH.TrainingLlmElemFolderMapping.

## Диаграмма [D1] PostgreSQL ER

<!-- puml: ./diagrams/er-postgres.puml -->
```plantuml
@startuml
!include ./diagrams/er-postgres.puml
@enduml
```

Источник: diagrams/er-postgres.puml

Что изображено:
1. Основные таблицы PostgreSQL для метаданных, классификаций и кандидатов сопоставления.
2. Логические связи по полям bim_id, classification_id, llm_id.
3. Группировка: Core, Classification, LLM.

Сущности и поля (ключевые, по [P#]):
- [P1] BimInfo: bim_id, name, uploaded_ts, description, percent, status.
- [P2] BimPath: id, bim_id, nodes, properties, edges.
- [P3] ClassificationInfo: id, status, result_path, progress, bim_id, llm_id, message.
- [P4] ClassificationStatus: id, classification_id, status.
- [P5] Classificatory: id, item_id, name, parent_id, classification_id.
- [P6] CandidateMatch: id, classification_id, bim_id, elem_id, folder_id, cluster_id, elem_description, folder_path, distance, approved, final, llm_score, llm_reasoning.
- [P7] LlmInfo: llm_id, llm_name, llm_description.

Связи:
- [P2].bim_id -> [P1].bim_id.
- [P3].(bim_id, llm_id) -> ([P1].bim_id, [P7].llm_id).
- [P4].classification_id -> [P3].id.
- [P5].classification_id -> [P3].id.
- [P6].(bim_id, classification_id) -> ([P1].bim_id, [P3].id).

Сквозные упоминания:
- Диаграмма классов [D3]: [M3] ↔ [P1], [M7] ↔ [P6], [M8] ↔ [P7].
- Последовательности [D5]: статус/прогресс читается/обновляется в [P1]/[P3]/[P4]; result_path в [P3].

<h3 id="pgbiminfo"></h3>
<a id="pgbiminfo"></a>
### [P1] PG.BimInfo
Метаданные BIM-модели и статус обработки (percent/status nullable).

<h3 id="pgbimpath"></h3>
<a id="pgbimpath"></a>
### [P2] PG.BimPath
Пути к файлам nodes/properties/edges для BIM-модели.

<h3 id="pgclassificationinfo"></h3>
<a id="pgclassificationinfo"></a>
### [P3] PG.ClassificationInfo
Запись классификации (status/progress, result_path nullable).

<h3 id="pgclassificationstatus"></h3>
<a id="pgclassificationstatus"></a>
### [P4] PG.ClassificationStatus
Флаговое состояние процесса (status nullable).

<h3 id="pgclassificatory"></h3>
<a id="pgclassificatory"></a>
### [P5] PG.Classificatory
Каталог (item_id/name/parent_id) для конкретной классификации.

<h3 id="pgcandidatematch"></h3>
<a id="pgcandidatematch"></a>
### [P6] PG.CandidateMatch
Кандидаты сопоставления элементов BIM с каталогом (approved/final/llm_* nullable).

<h3 id="pgllminfo"></h3>
<a id="pgllminfo"></a>
### [P7] PG.LlmInfo
Справочник LLM (описание nullable).

## Диаграмма [D2] ClickHouse ER

<!-- puml: ./diagrams/er-clickhouse.puml -->
```plantuml
@startuml
!include ./diagrams/er-clickhouse.puml
@enduml
```

Источник: diagrams/er-clickhouse.puml

Что изображено:
1. Таблицы для эмбеддингов элементов BIM и тренировочных наборов.
2. Связи по *_id полям между маппингами и эмбеддингами.

Сущности и поля (по [C#]):
- [C1] BimUpload: pk, bim_id, elem_id, description, cluster_id, embedding.
- [C2] TrainingElemEmbedding: pk, elem_desc, embedding.
- [C3] TrainingFolderEmbedding: pk, folder_desc, embedding.
- [C4] TrainingElemFolderMapping: pk, training_set_id, elem_desc_id, folder_desc_id, label, comment.
- [C5] TrainingLlmElemFolderMapping: pk, llm_id, elem_folder_mapping_id.

Сквозные упоминания:
- Диаграмма классов [D3]: [M9] ↔ [C1] (BimUpload).
- Последовательности [D5]: BIM Upload пишет [C1]; Classification читает [C1]; LLM Train пишет [C2]-[C5].

<h3 id="chbimupload"></h3>
<a id="chbimupload"></a>
### [C1] CH.BimUpload
Эмбеддинги и кластеры элементов BIM (ClickHouse).

<h3 id="chtrainingelemembedding"></h3>
<a id="chtrainingelemembedding"></a>
### [C2] CH.TrainingElemEmbedding
Эмбеддинги обучающих описаний элементов.

<h3 id="chtrainingfolderembedding"></h3>
<a id="chtrainingfolderembedding"></a>
### [C3] CH.TrainingFolderEmbedding
Эмбеддинги обучающих описаний папок.

<h3 id="chtrainingelemfoldermapping"></h3>
<a id="chtrainingelemfoldermapping"></a>
### [C4] CH.TrainingElemFolderMapping
Мэппинг elem_desc_id/folder_desc_id с метками label/comment.

<h3 id="chtrainingllmelemfoldermapping"></h3>
<a id="chtrainingllmelemfoldermapping"></a>
### [C5] CH.TrainingLlmElemFolderMapping
Связь llm_id с конкретной записью [C4].
