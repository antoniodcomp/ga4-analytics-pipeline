# Projeto: Pipeline de Marketing Analytics (GA4 → Airflow → PostgreSQL → Power BI)

Guia de execução para um dia intensivo, combinando Google Analytics, Airflow, Python, SQL e Power BI.

## Objetivo

Construir um pipeline de dados que extrai métricas do Google Analytics 4 (GA4), orquestra a extração com Airflow, modela os dados em SQL (PostgreSQL) e apresenta os resultados em um dashboard no Power BI. Complementa o projeto de ELT do UCI Energy Dataset, mostrando domínio de analytics/BI além de engenharia de dados pura.

## Stack utilizado

- Python (extração e scripts)
- Google Analytics Data API (GA4)
- Airflow (orquestração)
- PostgreSQL (armazenamento e modelagem)
- SQL (transformações/agregações)
- Power BI (visualização)
- Docker (ambiente local, reaproveitando o stack já existente)

---

## Etapa 1 — Preparar a fonte de dados no GA4

1. Utilize o seu site já existente no GitHub Pages (**antoniodcomp.github.io**) para servir de origem de dados reais.
2. Acesse [analytics.google.com](https://analytics.google.com) com sua conta Google, crie uma nova propriedade GA4 para o site e adicione a tag de rastreamento (Measurement ID) no código do seu GitHub Pages. Acesse o site algumas vezes para gerar tráfego inicial.
3. No [Google Cloud Console](https://console.cloud.google.com), crie (ou reutilize) um projeto e ative a **Google Analytics Data API**.
4. Crie uma **service account** dentro do projeto:
   - Vá em "IAM e administrador" → "Contas de serviço" → "Criar conta de serviço".
   - Gere uma chave no formato JSON e baixe o arquivo (guarde com segurança na pasta `credentials/` que criamos).
5. Adicione a service account como usuário com **acesso de leitura** na propriedade GA4:
   - No GA4: Admin → Acesso à propriedade → Adicionar usuários → cole o e-mail da service account (algo como `nome@projeto.iam.gserviceaccount.com`).
   - Sem esse passo, a API nega o acesso mesmo com credenciais corretas.
6. Anote o **Property ID** (ID numérico) da sua propriedade — vai ser usado nas chamadas da API.

## Etapa 2 — Extrair dados via Python

1. Instale a biblioteca oficial:
   ```bash
   pip install google-analytics-data
   ```
2. Escreva um script que autentica usando o JSON da service account e faz uma chamada `runReport` à API, especificando:
   - **Dimensions**: `date`, `country`, `sessionDefaultChannelGroup`, `deviceCategory`
   - **Metrics**: `sessions`, `totalUsers`, `conversions`, `totalRevenue`
   - **Date range**: por exemplo, últimos 30 dias
3. Salve o resultado bruto (linhas tabulares retornadas pela API) em JSON ou Parquet — isso representa a camada **raw/bronze** do pipeline, no mesmo espírito do Medallion Architecture usado no projeto de energia.
4. Teste o script isoladamente antes de integrá-lo ao Airflow, para garantir que a extração funciona de forma independente.

## Etapa 3 — Orquestrar com Airflow

1. Reaproveite o ambiente Docker já configurado (Airflow + PostgreSQL) do projeto ELT do UCI Energy Dataset.
2. Crie uma nova DAG dedicada a este pipeline, com pelo menos três tasks:
   - **Extração**: executa o script Python que consulta a GA4 Data API.
   - **Validação**: checagem simples de schema e valores nulos nos dados extraídos.
   - **Carga**: insere os dados validados nas tabelas staging do PostgreSQL.
3. Configure o agendamento (`schedule_interval`) — diário ou de poucas em poucas horas, conforme preferir para a demonstração.
4. Rode a DAG manualmente pela interface do Airflow para validar o fluxo ponta a ponta antes de seguir.

## Etapa 4 — Modelar e transformar em SQL

1. No PostgreSQL, crie uma tabela de **staging** que recebe os dados crus vindos da carga do Airflow.
2. A partir da staging, construa um pequeno **modelo dimensional**:
   - Tabela fato: sessões/conversões por dia, canal, dispositivo e país.
   - Tabelas dimensão: data, canal, dispositivo (se fizer sentido separar).
3. Escreva queries SQL de agregação para responder perguntas de negócio, por exemplo:
   - Receita total por canal de aquisição.
   - Taxa de conversão por categoria de dispositivo.
   - Tendência diária de sessões e usuários.
4. Opcional: se quiser reforçar essa camada, use **dbt** (já presente no seu stack) para versionar e testar essas transformações.

## Etapa 5 — Conectar e construir o dashboard no Power BI

1. Abra o Power BI Desktop e use o conector nativo do PostgreSQL para se conectar ao banco.
2. Importe as tabelas fato e dimensão criadas na etapa anterior.
3. Monte um dashboard enxuto, com 2–3 páginas:
   - **Visão geral de tráfego**: sessões, usuários, tendência temporal.
   - **Funil de conversão por canal**: comparação entre canais de aquisição.
   - **Receita**: evolução de receita ao longo do tempo, segmentada por dispositivo/país.
4. Priorize poucos visuais bem escolhidos em vez de muitos gráficos soltos — clareza conta mais do que quantidade.

## Etapa 6 — Documentar e publicar

1. Escreva um README para o repositório do projeto contendo:
   - Diagrama simples da arquitetura: `GA4 → Airflow → PostgreSQL → Power BI`.
   - Principais decisões técnicas (estratégia de coleta/geração de dados no GA4, por que esse modelo dimensional, etc.).
   - Prints do dashboard final no Power BI.
   - Instruções de como rodar o projeto localmente (Docker Compose, variáveis de ambiente, etc.).
2. Suba o projeto para o GitHub.
3. Relacione este projeto ao pipeline ELT do UCI Energy Dataset no seu currículo/portfólio, destacando que juntos eles cobrem tanto engenharia de dados pura quanto analytics/BI orientado a negócio.

## Estrutura de Diretórios Sugerida

Para manter o projeto organizado e facilitar a execução e manutenção, sugere-se a seguinte estrutura de arquivos e pastas:

```text
ga4-analytics-pipeline/
├── dags/
│   ├── ga4_pipeline.py          # DAG do Airflow para orquestração
│   └── scripts/
│       ├── extract_ga4.py       # Script Python de extração via API do GA4
│       └── load_postgres.py     # Script para carregar dados validados
├── sql/
│   ├── staging.sql              # Queries de criação de tabelas staging (camada raw)
│   └── dimensional_model.sql    # Queries para o modelo dimensional e agregações
├── powerbi/
│   └── ga4_dashboard.pbix       # Arquivo final do dashboard do Power BI
├── docker-compose.yml           # (Opcional) Ambiente Docker (Airflow + PostgreSQL)
├── requirements.txt             # Dependências (ex: google-analytics-data)
├── credentials/                 # Service account JSON (NÃO SUBIR PARA O GITHUB)
│   └── .gitkeep
├── .gitignore                   # Ignorar a pasta credentials, __pycache__, etc
└── README.md                    # Documentação principal
```

---

## Checklist rápido

- [ ] Propriedade própria do GA4 criada (com dados reais ou simulados)
- [ ] Service account criada e com permissão de leitura na propriedade
- [ ] Script Python de extração funcionando isoladamente
- [ ] DAG do Airflow criada e testada manualmente
- [ ] Tabelas staging e modelo dimensional criados no PostgreSQL
- [ ] Queries de agregação escritas e validadas
- [ ] Dashboard no Power BI conectado ao PostgreSQL
- [ ] README com arquitetura e prints
- [ ] Projeto publicado no GitHub
