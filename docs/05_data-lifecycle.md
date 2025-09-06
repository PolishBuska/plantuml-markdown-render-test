# Жизненный цикл данных и последовательности

Ниже — inline-рендер диаграмм состояний и последовательностей, шаги и сквозные ссылки на [P#]/[C#]/[M#].

## Диаграмма [D5.1] Состояния BIM (PG.BimInfo.status)

<!-- puml: ./diagrams/state-bim.puml -->
```plantuml
@startuml
!include ./diagrams/state-bim.puml
@enduml
```

Источник: diagrams/state-bim.puml

Описание:
1. IN_PROGRESS — загрузка и обработка (описания элементов, эмбеддинги, кластеризация).
2. COMPLETED — PG.BimInfo.percent=100.
3. ERROR — ошибка процесса.

Сквозные сущности: [P1], [C1].

## Диаграмма [D5.2] Состояния классификации (PG.ClassificationInfo.status)

<!-- puml: ./diagrams/state-classification.puml -->
```plantuml
@startuml
!include ./diagrams/state-classification.puml
@enduml
```

Источник: diagrams/state-classification.puml

Описание:
1. IN_PROGRESS — процесс запущен.
2. COMPLETED — CSV загружен в S3, путь в [P3].result_path.
3. STOPPED — остановка инициирована Gmini (Admin).
4. ERROR — ошибка выполнения.

Сквозные сущности: [P3], [P4], [C1].

## Последовательности (Sequence)

### Диаграмма [D5.3] BIM Upload

<!-- puml: ./diagrams/sequence-bim-upload.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-bim-upload.puml
@enduml
```

Ключевые шаги:
1. [M2] UploadBimSchemas с путями → запись [P2] BimPath.
2. Формирование [M3] StatusUploadResponseSchemas → запись/обновление [P1] BimInfo (status/percent).
3. Генерация описаний элементов → эмбеддинги ([M9] BIMElement) → запись [C1] BimUpload.
4. Кластеризация и обновления прогресса → обновление [P1].

Реализация (модули/функции):
- Веб-вход: web_api/api/routers/bim.py::upload_bim_model → web_api/use_cases/bim.py::upload_bim → db/postgres/dao/bim.py::insert_bim_info
- Запуск обработки: web_api/utils/utils.py::send_start_bim_upload → bim_upload/api/routers/bim.py::upload_bim_model → start_upload_bim (bim_upload/use_cases/bim.py)
- Заполнение CH [C1]: bim_upload/dao/bim_dao.py::DaoBimClick.insert_bim_data / update_bim_data

### Диаграмма [D5.4] BIM Delete (Gmini Admin)

<!-- puml: ./diagrams/sequence-bim-delete.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-bim-delete.puml
@enduml
```

Удаление данных [C1] (BimUpload) и метаданных [P1]/[P2].

Реализация (модули/функции):
- Web API: web_api/api/routers/bim.py::delete_bim_model → web_api/utils/utils.py::send_delete_bim → bim_upload/api/routers/bim.py::delete_bim_model
- Удаление PG: web_api/use_cases/bim.py::dell_bim → db/postgres/dao/bim.py::delete_bim_info
- Удаление CH: bim_upload/dao/bim_dao.py::DaoBimClick.delete_data

### Диаграмма [D5.5] BIM Status

<!-- puml: ./diagrams/sequence-bim-status.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-bim-status.puml
@enduml
```

Чтение статуса из [P1].

Реализация:
- Web API: web_api/api/routers/bim.py::uploading_status → web_api/use_cases/bim.py::get_bim → db/postgres/dao/bim.py::get_all_bim_info

### Диаграмма [D5.6] BIM List

<!-- puml: ./diagrams/sequence-bim-list.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-bim-list.puml
@enduml
```

Список моделей из [P1].

Реализация:
- Web API: web_api/api/routers/bim.py::get_bim_models → web_api/use_cases/bim.py::get_bim → db/postgres/dao/bim.py::get_all_bim_info

### Диаграмма [D5.7] Classification Start

<!-- puml: ./diagrams/sequence-classification-start.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-classification-start.puml
@enduml
```

Шаги:
1. Параметры [M5] ClassificationParams/[M6] ClassificationInsertInfo → INSERT в [P3] ClassificationInfo (IN_PROGRESS, progress=0).
2. Если передан classificator: INSERT в [P5] Classificatory.
3. Сервис классификации читает [C1] BimUpload, считает и обновляет progress/status в [P3].
4. Итоговый CSV загружается в S3; путь сохраняется в [P3].

Реализация (модули/функции):
- Старт: web_api/api/routers/classification.py::start_classification → web_api/use_cases/classification.py::start_classifications → db/postgres/dao/classification.py::DaoClassification.insert_classification
- Запуск внешней обработки: web_api/utils/utils.py::send_start_classification → bim_classification/use_cases/classifications_use_cases.py::classification_start
- Обновления PG: DaoClassification.update_result / stop_progress_with_error / load_classify_proces (через bim_classification.utils.utils)

### Диаграмма [D5.8] Classification Status

<!-- puml: ./diagrams/sequence-classification-status.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-classification-status.puml
@enduml
```

Чтение статуса/пути из [P3].

Реализация:
- Web API: web_api/api/routers/classification.py::get_classification_status → web_api/use_cases/classification.py::get_classification_by_id → db/postgres/dao/classification.py::DaoClassification.get_classification

Результаты классификации (формат CSV):
- Файл результатов содержит поля:
  - folder_id: str — идентификатор папки из каталога
  - element_id: str — идентификатор элемента BIM-модели
  - element_desc: str — текстовое описание элемента
  - confidence: float — уверенность классификатора [0..1]
  - folder_desc: str — текстовое описание папки
- CSV выкладывается в S3, путь фиксируется в [P3].result_path.

### Диаграмма [D5.9] Classification Stop (Gmini Admin)

<!-- puml: ./diagrams/sequence-classification-stop.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-classification-stop.puml
@enduml
```

Установка STOPPED в [P3].

Реализация:
- Web API: web_api/api/routers/classification.py::stop_classification → web_api/use_cases/classification.py::stop_classifications → db/postgres/dao/classification.py::DaoClassification.stop_progress / set_status

### Диаграмма [D5.10] LLM List

<!-- puml: ./diagrams/sequence-llm-list.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-llm-list.puml
@enduml
```

Чтение списка из [P7].

Реализация:
- Web API: web_api/use_cases/llm.py (list) → db/postgres/dao/llm.py (list) → PG [P7]

### Диаграмма [D5.11] LLM Train (Gmini Admin)

<!-- puml: ./diagrams/sequence-llm-train.puml -->
```plantuml
@startuml
!include ./diagrams/sequence-llm-train.puml
@enduml
```

Шаги:
1. Gmini (Admin) отправляет [base_llm_id, training_data_path].
2. llm_services читает из S3, вычисляет эмбеддинги и связи → вставки в [C2]-[C5].
3. По 200 OK — web_api создаёт запись в [P7] LlmInfo.

Реализация:
- Web API → LLM Services: web_api/utils/utils.py::send_start_llm_raining → llm_services/api/routers/llm_services.py::start_classifications → llm_services/use_cases/training_llm.py::process_training_data
- Вставки CH [C2]-[C5]: внутри process_training_data (ClickHouse)
- Вставка PG [P7]: web_api/use_cases/llm.py (create) → db/postgres/dao/llm.py
