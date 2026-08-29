# ga4-analytics-pipeline
Pipeline de dados ponta a ponta que extrai métricas de aquisição, engajamento e receita do Google Analytics 4 (GA4), orquestra a extração com Apache Airflow, modela os dados em um esquema dimensional no PostgreSQL e apresenta os resultados em um dashboard interativo no Power BI.

O projeto simula um cenário real de analytics de marketing, usando a conta pública de demonstração da Google Merchandise Store como fonte de dados, e reflete um fluxo típico de trabalho de engenharia de dados aplicado a decisões de negócio: da extração via API à visualização final.

**Stack:** Python · Google Analytics Data API · Apache Airflow · PostgreSQL · SQL · Power BI · Docker

## Arquitetura

`GA4 → Airflow (extração e orquestração) → PostgreSQL (staging + modelo dimensional) → Power BI (dashboard)`

## O que o dashboard responde

- Como o tráfego evolui ao longo do tempo?
- Qual canal de aquisição gera mais receita?
- Como a conversão varia por categoria de dispositivo?
