#GA4 Analytics Pipeline

Pipeline de dados **end-to-end** que extrai métricas reais de tráfego do meu portfólio pessoal ([antoniodcomp.github.io](https://antoniodcomp.github.io)) via Google Analytics 4, orquestra a ingestão com Apache Airflow, modela os dados em um esquema dimensional com dbt e apresenta os resultados em um dashboard interativo no Power BI.

> Projeto desenvolvido com o intuito de praticar e demonstrar técnicas de **Engenharia de Dados**, cobrindo desde a ingestão de dados de uma API até sua disponibilização para análise e tomada de decisão.

---

## Arquitetura

```mermaid
flowchart LR
    A["antoniodcomp.github.io"] --> B["Google Analytics 4"]
    B --> C["Python\n(Google Analytics Data API)"]
    C --> D["Apache Airflow\n(Orquestração)"]
    D --> E["PostgreSQL\n(Data Warehouse)"]
    E --> F["dbt\n(Transformação)"]
    F --> G["Power BI\n(Dashboard)"]
```

| Camada | Descrição |
|--------|-----------|
| **Fonte** | Tráfego real coletado do GitHub Pages via tag do GA4 |
| **Extração** | Script Python consulta a Google Analytics Data API (dimensões + métricas) |
| **Orquestração** | DAG do Airflow automatiza a extração e a carga dos dados |
| **Armazenamento** | PostgreSQL como Data Warehouse (schema `bronze` para dados brutos) |
| **Transformação** | dbt organiza os dados em staging → modelo dimensional (fato + dimensões) |
| **Visualização** | Dashboard no Power BI conectado ao PostgreSQL |

---

## Stack

| Tecnologia | Uso no Projeto |
|------------|----------------|
| **Python** | Extração de dados via API |
| **Google Analytics Data API** | Fonte de dados (métricas e dimensões do GA4) |
| **Apache Airflow** | Orquestração do pipeline |
| **PostgreSQL** | Data Warehouse |
| **dbt** | Transformação e modelagem dimensional |
| **SQL** | Criação de tabelas, agregações e análises |
| **Power BI** | Visualização e dashboard |
| **Docker / Docker Compose** | Ambiente local reproduzível |



---

##Fluxo do Pipeline

### 1. Extração (Python)
O script [`extract_ga4.py`](dags/scripts/extract_ga4.py) autentica via Service Account e consulta a Google Analytics Data API, extraindo as seguintes métricas dos últimos 7 dias:

| Dimensões | Métricas |
|-----------|----------|
| `date` | `activeUsers` |
| `country` | `sessions` |
| `sessionDefaultChannelGroup` | `totalUsers` |
| `deviceCategory` | `conversions` |
| | `totalRevenue` |

Os dados são salvos em formato **Parquet** na pasta `data/raw/ga4/`.

### 2. Orquestração (Airflow)
A DAG [`ga4_pipeline`](dags/ga4_pipeline.py) automatiza a execução do script de extração. O ambiente roda em Docker (Airflow standalone) com o PostgreSQL como Data Warehouse.

### 3. Armazenamento (PostgreSQL)
Os dados brutos são carregados na tabela `bronze.ga4_raw`, seguindo o conceito de **Medallion Architecture**.

### 4. Transformação (dbt)
O dbt organiza a transformação em duas camadas:

- **Staging** (`stg_ga4`): view que padroniza os dados vindos da camada bronze.
- **Marts** (modelo dimensional):
  - `fact_ga4` — tabela fato com métricas agregadas por data, país, canal e dispositivo.
  - `dim_date`, `dim_country`, `dim_channel`, `dim_device` — tabelas dimensão.

### 5. Visualização (Power BI)
Dashboard conectado diretamente ao PostgreSQL, consumindo as tabelas do modelo dimensional para apresentar:
- Visão geral de tráfego (sessões, usuários, tendência temporal)
- Comparativo de canais de aquisição
- Segmentação por dispositivo e país

---

## Como Rodar o Projeto

### Pré-requisitos
- Docker e Docker Compose instalados
- Credenciais da Google Analytics Data API (Service Account em JSON)
- Property ID da sua propriedade GA4

### Passo a passo

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/antoniodcomp/ga4-analytics-pipeline.git
   cd ga4-analytics-pipeline
   ```

2. **Coloque o JSON da Service Account** na pasta `credentials/`.

3. **Suba o ambiente com Docker Compose:**
   ```bash
   docker compose up -d --build
   ```

4. **Crie a tabela bronze no PostgreSQL:**
   ```bash
   docker compose exec postgres_dw psql -U admin -d data_warehouse -f /opt/airflow/sql/bronze/ga4_raw.sql
   ```

5. **Acesse o Airflow** em `http://localhost:8080` e execute a DAG `ga4_pipeline`.

6. **Rode as transformações do dbt:**
   ```bash
   docker compose exec airflow bash -c "cd /opt/airflow/dbt/ga4_analytics && dbt run"
   ```

7. **Conecte o Power BI** ao PostgreSQL (`localhost:5433`, database `data_warehouse`).

---

## Decisões Técnicas

| Decisão | Justificativa |
|---------|---------------|
| **GitHub Pages como fonte de dados** | Garante dados reais de tráfego, sem depender de mocks ou datasets estáticos. A conta de demonstração do GA4 não permite acesso via API. |
| **Parquet como formato intermediário** | Formato colunar eficiente, com tipagem e compressão nativa — ideal para pipelines analíticos. |
| **Medallion Architecture (Bronze → Staging → Marts)** | Separação clara entre dado bruto, dado padronizado e dado modelado para consumo. |
| **Modelo dimensional (Star Schema)** | Facilita consultas analíticas e a integração com ferramentas de BI como o Power BI. |
| **Docker Compose** | Garante que qualquer pessoa consiga rodar o projeto localmente com um único comando. |

---

## Contato

**Antonio** — [GitHub](https://github.com/antoniodcomp) · [Portfólio](https://antoniodcomp.github.io)