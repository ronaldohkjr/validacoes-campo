-- Validações de Campo: armazenamento de fotos e arquivos anexados.
-- Para quem já rodou o setup.sql antes: Supabase → SQL Editor → New query → cole este arquivo → Run.
-- Fotos e arquivos anexados às atividades e aos próximos passos (privado: só quem fez login vê).
insert into storage.buckets (id, name, public, file_size_limit)
values ('anexos', 'anexos', false, 26214400)
on conflict (id) do nothing;

drop policy if exists "equipe ve anexos" on storage.objects;
drop policy if exists "equipe envia anexos" on storage.objects;
drop policy if exists "equipe troca anexos" on storage.objects;
drop policy if exists "equipe apaga anexos" on storage.objects;
create policy "equipe ve anexos" on storage.objects for select to authenticated using (bucket_id = 'anexos');
create policy "equipe envia anexos" on storage.objects for insert to authenticated with check (bucket_id = 'anexos');
create policy "equipe troca anexos" on storage.objects for update to authenticated using (bucket_id = 'anexos') with check (bucket_id = 'anexos');
create policy "equipe apaga anexos" on storage.objects for delete to authenticated using (bucket_id = 'anexos');
