-- Validações de Campo: banco de dados no Supabase.
-- Como usar: Supabase → SQL Editor → New query → cole este arquivo inteiro → Run.
-- Pode rodar de novo sem problema (não apaga dados).

-- Projetos: cada linha é um projeto; os campos ficam em "data" (JSON).
create table if not exists public.projects (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id) on delete set null
);
alter table public.projects enable row level security;

-- Só quem fez login vê e edita. Visitantes sem login não veem nada.
drop policy if exists "equipe le" on public.projects;
drop policy if exists "equipe cria" on public.projects;
drop policy if exists "equipe edita" on public.projects;
drop policy if exists "equipe exclui" on public.projects;
create policy "equipe le" on public.projects for select to authenticated using (true);
create policy "equipe cria" on public.projects for insert to authenticated with check (true);
create policy "equipe edita" on public.projects for update to authenticated using (true) with check (true);
create policy "equipe exclui" on public.projects for delete to authenticated using (true);

-- Salva só os campos alterados, para uma pessoa não apagar o que outra mudou.
create or replace function public.merge_project(p_id text, p_patch jsonb)
returns boolean
language plpgsql
security invoker
set search_path = public
as $$
begin
  update public.projects
     set data = data || p_patch, updated_at = now(), updated_by = auth.uid()
   where id = p_id;
  return found;
end
$$;
revoke execute on function public.merge_project(text, jsonb) from public, anon;
grant execute on function public.merge_project(text, jsonb) to authenticated;

-- Nomes das pessoas (aparecem no histórico).
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nome text not null default '',
  email text
);
alter table public.profiles enable row level security;
drop policy if exists "equipe ve perfis" on public.profiles;
drop policy if exists "cada um edita o seu" on public.profiles;
create policy "equipe ve perfis" on public.profiles for select to authenticated using (true);
create policy "cada um edita o seu" on public.profiles for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

-- Cria o perfil automaticamente quando um usuário é cadastrado.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, nome, email)
  values (new.id, coalesce(new.raw_user_meta_data->>'nome', split_part(new.email, '@', 1)), new.email)
  on conflict (id) do nothing;
  return new;
end
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Perfis para usuários que já existiam antes deste script.
insert into public.profiles (id, nome, email)
select id, split_part(email, '@', 1), email from auth.users
on conflict (id) do nothing;

-- Atualização em tempo real entre as pessoas.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
     where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'projects'
  ) then
    alter publication supabase_realtime add table public.projects;
  end if;
end
$$;
