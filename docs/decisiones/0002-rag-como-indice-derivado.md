# ADR-0002 — RAG como índice derivado

## Estado
Aceptado.

## Decisión
Git sigue siendo la fuente de verdad del conocimiento curado. PostgreSQL mantiene hechos e históricos. pgvector/RAG se usa como índice semántico derivado y reconstruible.

## Reglas
- no editar conocimiento directamente en la base vectorial;
- cada chunk debe poder vincularse al documento y versión de origen;
- al cambiar un documento se invalidan o regeneran sus chunks;
- DEV y PROD mantienen índices separados;
- para consultas exactas y agregaciones se usa SQL, no similitud vectorial.
