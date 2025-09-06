# Сценарии использования (Use Cases)

## Диаграмма [D4] BIM Management

<!-- puml: ./diagrams/usecase-bim.puml -->
```plantuml
@startuml
!include ./diagrams/usecase-bim.puml
@enduml
```

Источник: diagrams/usecase-bim.puml

Акторы и доступ:
- Gmini (User): загрузка, просмотр статуса, список BIM.
- Gmini (Admin): удаление BIM, также доступ к списку/статусу.

## Диаграмма [D4.2] Classification

<!-- puml: ./diagrams/usecase-classification.puml -->
```plantuml
@startuml
!include ./diagrams/usecase-classification.puml
@enduml
```

Источник: diagrams/usecase-classification.puml

Акторы и доступ:
- Gmini (User): запуск классификации, просмотр статуса.
- Gmini (Admin): просмотр статуса и остановка процесса.

## Диаграмма [D4.3] LLM Management

<!-- puml: ./diagrams/usecase-llm.puml -->
```plantuml
@startuml
!include ./diagrams/usecase-llm.puml
@enduml
```

Источник: diagrams/usecase-llm.puml

Сквозные упоминания:
- Сценарии опираются на [P#]/[C#] из ER-схем [D1]/[D2]; конкретные обращения показаны в последовательностях [D5].
