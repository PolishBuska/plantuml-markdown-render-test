# Архитектура компонентов (Component Diagram)

## Диаграмма [D6.1] Компоненты

<!-- puml: ./diagrams/component-uml.puml -->
```plantuml
@startuml
!include ./diagrams/component-uml.puml
@enduml
```

Источник: diagrams/component-uml.puml

Кратко:

- Web API — фасад, оркестрация и запись метаданных в PG.
- bim_upload — S3, OpenAI, ClickHouse, обновление PG прогресса.
- bim_classification — чтение CH, запись PG и выгрузка результата в S3.
- llm_services — обучение, запись Training* в CH, фиксация в PG через web_api.

Функциональные обязанности и взаимодействия:

- Gmini (User): инициирует пользовательские операции (загрузка BIM, просмотр статуса, получение списков).
- Gmini (Admin): выполняет административные операции (удаление BIM, остановка классификации, запуск обучения LLM).
- Web API (шлюз):
  - Терминирует внешние HTTP-запросы и выполняет валидацию входных данных.
  - Осуществляет запись/чтение в PostgreSQL ([P1], [P2], [P3], [P5], [P7]).
  - Оркестрирует сервисы bim_upload, bim_classification, llm_services через REST.
- Model Management Service (bim_upload):
  - Извлекает исходные файлы из S3, формирует описания элементов, запрашивает эмбеддинги в OpenAI.
  - Сохраняет эмбеддинги и кластеры в ClickHouse ([C1]), обновляет прогресс в PostgreSQL ([P1]).
- Classifier Service (bim_classification):
  - Потребляет эмбеддинги из ClickHouse ([C1]), формирует кандидатов, выполняет LLM-валидацию и разрешение мультиклассовости.
  - Обновляет состояние/результаты в PostgreSQL ([P3]) и выгружает итоговый CSV в S3 (путь фиксируется в [P3].result_path).
- LLM Services (llm_services):
  - Потребляет обучающие данные из S3, вычисляет эмбеддинги/сопоставления для тренировочных наборов, сохраняет в ClickHouse ([C2]-[C5]).
  - По 200 OK от сервиса — Web API фиксирует новую запись LLM в PostgreSQL ([P7]).
- PostgreSQL ([P#]): хранилище метаданных, статусов и путей результатов.
- ClickHouse ([C#]): хранилище эмбеддингов и тренировочных наборов.
- S3: хранилище файлов BIM и результатов классификации.
- OpenAI: внешний провайдер эмбеддингов.

Сквозные потоки (конспект):

- Upload BIM: Web API → [P1]/[P2] → trigger bim_upload → [C1] → update [P1].
- Classification: Web API → [P3]/[P5] → trigger bim_classification → read [C1] → S3 CSV → update [P3].
- LLM Train: Web API → trigger llm_services → write [C2]-[C5] → Web API inserts [P7].

## Диаграмма [D6.2] C4 (контейнеры)

<!-- puml: ./diagrams/c4-diagram.puml -->
```plantuml
@startuml
!include ./diagrams/c4-diagram.puml
@enduml
```

Источник: diagrams/c4-diagram.puml

Акторы: Gmini (User) и Gmini (Admin).

Легенда индексов:

- [M#]: модели Pydantic/DTO
- [P#]: сущности PostgreSQL (SQLAlchemy)
- [C#]: сущности ClickHouse
