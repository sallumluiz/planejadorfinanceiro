# Planejador Financeiro por Etapas da Vida

Produto web leve em **um único arquivo `index.html`** (HTML + CSS + JavaScript puro, sem dependências, sem build, sem instalação). Basta abrir no navegador.

## Tela 1 – Entrada inicial
- Campos: **Nome** e **Idade atual**.
- Botão **Continuar** abre a Tela 2 exibindo apenas as etapas da vida RESTANTES:
  - **Etapa 1:** até 35 anos. Duração = 35 − idade atual.
  - **Etapa 2:** dos 35 aos 60 anos. Duração = 25 anos (ou 60 − idade atual se a pessoa entrar direto nela).
  - **Etapa 3:** dos 60 aos 85 anos. Duração = 25 anos (ou 85 − idade atual se a pessoa entrar direto nela).
- Idade < 35 → etapas 1, 2, 3; 35 a 59 → etapas 2, 3; 60 a 84 → etapa 3; 85+ → nenhuma etapa restante (aviso).

## Tela 2 – Calculadora com etapas em cascata
- Topo da página: apenas a saudação com o nome. **Não há cotação global**; cada etapa tem a sua.
- Cada etapa restante é um **card amplo** com fluxo contábil **ABERTURA → PREMISSAS/APORTES → FECHAMENTO**:
  - **Topo do card:** avatar SVG (Jovem até 35; Adulto grisalho 35–60; Sênior 60+), título do período e badge de duração em anos. Sem painel de consolidado aqui.
  - **Bloco 1 — Abertura do Período:**
    - Primeira etapa ativa: campos editáveis **Patrimônio Atual em Ações (R$)** e **em Renda Fixa (R$)**.
    - Etapas seguintes: campos bloqueados (somente leitura) herdados do Fechamento da etapa anterior, separados em Ações BR (R$), Renda Fixa BR (R$), Ações EUA (US$) e Renda Fixa EUA (US$).
  - **Bloco 2 — Premissas e Poupança Mensal da Etapa:**
    - **Cotação do Dólar nesta etapa (R$)**, editável, padrão 5,50. O saldo em USD herdado continua rendendo em dólar; apenas os novos aportes mensais em R$ destinados ao exterior são convertidos com a cotação desta etapa.
    - Total Poupança Líquida Mensal (R$)
    - % Investido em Dólar (0–100%, passo 10) e % Investido em R$ (travado = 100 − % Dólar)
    - % do Dólar em Ações EUA (passo 10) e % em Renda Fixa EUA (travado = 100 − Ações)
    - % do R$ em Ações Brasil (passo 10) e % em Renda Fixa Brasil (travado = 100 − Ações)
  - **Bloco 3 — Fechamento do Período (só no rodapé do card):** painel de destaque "Fechamento do Período — Consolidado ao Final da Etapa" com Patrimônio Consolidado em R$ e em USD. Os saldos finais alimentam a Abertura da etapa seguinte.

## Premissas de rentabilidade anual (juros compostos mês a mês)
- Renda Fixa Brasil: 10% a.a.
- Ações Brasil: 12% a.a.
- Renda Fixa EUA (USD): 6% a.a.
- Ações EUA (USD): 8% a.a.

Taxa mensal = (1 + taxa anual)^(1/12) − 1.

## Convenções de cálculo
- Todo cálculo atualiza em tempo real a cada alteração de qualquer campo.
- A cada mês: saldos rendem e, ao final do mês, entra o aporte. Parcela em dólar do aporte = (aporte × %Dólar) ÷ cotação da etapa, investida em USD.
- Patrimônio inicial informado na 1ª etapa é tratado como R$ (Brasil).
- Fechamento: Consolidado R$ = saldos R$ + saldos USD × cotação da etapa; Consolidado USD = Consolidado R$ ÷ cotação da etapa. Os saldos herdados passam à etapa seguinte nas suas moedas de origem (R$ e USD separados).
- Simulação ilustrativa, não é recomendação de investimento.

## Autenticação e banco (Supabase)
- Biblioteca `@supabase/supabase-js` via CDN. Projeto: `https://wrdxqdprndpqnbveeoxn.supabase.co` (Publishable Key no `index.html`).
- Tela de acesso antes do planejador: abas "Entrar" e "Criar Conta" (Nome, E-mail, Senha) com `signInWithPassword`, `signUp` e `signOut`; mensagens de erro em português.
- Barra do usuário no topo: nome/e-mail, "Minhas Simulações" e "Sair".
- "Salvar Simulação" grava em `simulacoes` com `user_id` do usuário logado, `nome`, `contato`, `patrimonio_final_brl` e `dados_simulacao` (JSON completo).
- "Minhas Simulações" faz `select` filtrado por `user_id`, do mais recente ao mais antigo; clicar numa carrega todos os valores nos campos.
- Pré-requisito no banco: rodar `supabase-setup.sql` (coluna `user_id`, `created_at` e policies RLS).

## Publicação (Git/GitHub)
- Repositório remoto: https://github.com/sallumluiz/planejadorfinanceiro.git (remote `origin`, branch `main`).
- **Sempre que o usuário pedir para atualizar ou publicar o site, fazer commit e push direto para a branch `main`** (sem criar branch nem PR).
- Git instalado em `C:\Program Files\Git\cmd\git.exe` (pode não estar no PATH de sessões já abertas).
