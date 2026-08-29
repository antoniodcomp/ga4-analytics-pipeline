# ga4-analytics-pipeline

Pipeline de dados end-to-end para coleta, transformação, modelagem e
visualização de dados do Google Analytics 4 (GA4).

O projeto coleta métricas de aquisição, engajamento e comportamento dos
usuários do meu portfólio pessoal, hospedado no GitHub Pages
(**antoniodcomp.github.io**), por meio da Google Analytics Data API.

A extração dos dados é orquestrada com Apache Airflow, os dados são
armazenados e transformados em PostgreSQL utilizando um modelo dimensional,
e os indicadores de negócio são apresentados em um dashboard interativo
desenvolvido no Power BI.

O projeto simula um fluxo de trabalho de Engenharia de Dados end-to-end,
abrangendo desde a ingestão de dados de uma API até sua disponibilização
para análise e tomada de decisão.

**Stack:** Python · Google Analytics Data API · Apache Airflow · PostgreSQL ·
SQL · Power BI · Docker

## Arquitetura

GA4 → Google Analytics Data API → Airflow → PostgreSQL
→ Modelo Dimensional → Power BI