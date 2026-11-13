-- Execute no Supabase: SQL Editor > New query > Run
-- Prepara a tabela `simulacoes` para simulações vinculadas a cada usuário.

alter table public.simulacoes
  add column if not exists user_id uuid references auth.users(id) default auth.uid();
alter table public.simulacoes
  add column if not exists created_at timestamptz default now();

alter table public.simulacoes enable row level security;

drop policy if exists "usuario insere suas simulacoes" on public.simulacoes;
create policy "usuario insere suas simulacoes" on public.simulacoes
  for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "usuario le suas simulacoes" on public.simulacoes;
create policy "usuario le suas simulacoes" on public.simulacoes
  for select to authenticated
  using (auth.uid() = user_id);

-- Opcional: se existir uma policy antiga permitindo INSERT para o papel `anon`
-- (criada na etapa anterior), remova-a em Authentication > Policies,
-- pois agora só usuários logados devem salvar.
