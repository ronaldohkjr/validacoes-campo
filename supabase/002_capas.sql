-- Validações de Campo: armazenamento das imagens de capa.
-- Para quem já rodou o setup.sql antes: Supabase → SQL Editor → New query → cole este arquivo → Run.
-- Imagens de capa dos projetos (armazenamento privado: só quem fez login vê).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('capas', 'capas', false, 5242880, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

drop policy if exists "equipe ve capas" on storage.objects;
drop policy if exists "equipe envia capas" on storage.objects;
drop policy if exists "equipe troca capas" on storage.objects;
drop policy if exists "equipe apaga capas" on storage.objects;
create policy "equipe ve capas" on storage.objects for select to authenticated using (bucket_id = 'capas');
create policy "equipe envia capas" on storage.objects for insert to authenticated with check (bucket_id = 'capas');
create policy "equipe troca capas" on storage.objects for update to authenticated using (bucket_id = 'capas') with check (bucket_id = 'capas');
create policy "equipe apaga capas" on storage.objects for delete to authenticated using (bucket_id = 'capas');
