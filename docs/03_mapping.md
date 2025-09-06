# Соответствие классов и схем данных

Ниже приведено сопоставление между моделями Pydantic/реализации и физическими схемами данных PostgreSQL и ClickHouse.

Ссылки на типы данных (см. 00_index.md): PG.* / CH.* / Model.*

## Маппинг Upload BIM

- Model.UploadBimSchemas.path.nodes -> PG.BimPath.nodes
- Model.UploadBimSchemas.path.properties -> PG.BimPath.properties
- Model.UploadBimSchemas.path.edges -> PG.BimPath.edges
- Model.StatusUploadResponseSchemas.bim_id -> PG.BimInfo.bim_id
- Model.StatusUploadResponseSchemas.name -> PG.BimInfo.name
- Model.StatusUploadResponseSchemas.uploaded_ts -> PG.BimInfo.uploaded_ts
- Model.StatusUploadResponseSchemas.description -> PG.BimInfo.description
- Model.StatusUploadResponseSchemas.percent -> PG.BimInfo.percent
- Model.StatusUploadResponseSchemas.s[03_mapping.md](03_mapping.md)tatus -> PG.BimInfo.status

## Маппинг Classification

- Model.ClassificationInsertInfo.id -> PG.ClassificationInfo.id
- Model.ClassificationInsertInfo.llm_id -> PG.ClassificationInfo.llm_id
- Model.ClassificationInsertInfo.bim_id -> PG.ClassificationInfo.bim_id
- Model.ClassificationInsertInfo.classificator[*] -> PG.Classificatory (item_id, name, parent_id, classification_id)
- Model.Classificatory.id -> PG.Classificatory.item_id
- Model.Classificatory.name -> PG.Classificatory.name
- Model.Classificatory.parent_id -> PG.Classificatory.parent_id

Кандидаты:
- Model.CandidateMatchSchema -> PG.CandidateMatch (bim_id, classification_id, elem_id, folder_id, cluster_id, elem_description, folder_path, distance, approved?, final?, llm_score?, llm_reasoning?)

## Маппинг LLM

- Model.LLMlistResponse.llm_id -> PG.LlmInfo.llm_id
- Model.LLMlistResponse.llm_name -> PG.LlmInfo.llm_name
- Model.LLMlistResponse.llm_description -> PG.LlmInfo.llm_description

## Маппинг ClickHouse (BIM Embeddings)

- Model.BIMElement.pk -> CH.BimUpload.pk
- Model.BIMElement.bim_id -> CH.BimUpload.bim_id
- Model.BIMElement.elem_id -> CH.BimUpload.elem_id
- Model.BIMElement.description -> CH.BimUpload.description
- Model.BIMElement.cluster_id -> CH.BimUpload.cluster_id
- Model.BIMElement.embedding -> CH.BimUpload.embedding

## Маппинг ClickHouse (Training)

- TrainingElemFolderMapping.pk -> CH.TrainingElemFolderMapping.pk
- TrainingElemFolderMapping.training_set_id -> CH.TrainingElemFolderMapping.training_set_id
- TrainingElemFolderMapping.elem_desc -> CH.TrainingElemEmbedding.elem_desc (через *_id)
- TrainingElemFolderMapping.folder_desc -> CH.TrainingFolderEmbedding.folder_desc (через *_id)
- TrainingLlmElemFolderMapping.llm_id -> CH.TrainingLlmElemFolderMapping.llm_id
- TrainingLlmElemFolderMapping.elem_folder_mapping_id -> CH.TrainingLlmElemFolderMapping.elem_folder_mapping_id

Примечание: Для ClickHouse связи выражены через *_id поля; см. ER-диаграмму ClickHouse.
