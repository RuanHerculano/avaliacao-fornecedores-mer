-- SELECT *
-- FROM scm_sku_purchase_sug_hist
-- WHERE id_integration_gtp = '48932' AND id_company_fk = '2';
--
-- SELECT *
-- FROM UAC_LOG
-- WHERE DESCRIPTION LIKE '%id_company_fk : 2||%'
--    OR DESCRIPTION LIKE '%id_company_pk : 2||id_sku_pk : 1788477640%';
--
--
-- select * from ERP_PURCHASE_ORDER WHERE NUM_ORDER=27915;
select * from erp_supplier;
select * from ADM_COMPANY;

select * from SCM_GROUP_ONE;

select * from ERP_SKU;

select * from SCM_SKU;
select * from SCM_GROUP_CONT; -- dados denormalizado da tabela scm_sku
select * from SCM_PROFILE; -- dados denormalizado da tabela scm_sku && parametros que o gdc cadastra

select * from scm_group_cont where id_company_fk = 1 order by num_group_fk;

-- na tabela scm_sku é que tem o dado normalizado
-- o job nigth pega esse dado da tabela scm_sku e coloca na tabela
-- SCM_GROUP_CONT e SCM_PROFILE,

-- na tabela scm_sku, as colunas cod_group1...cod_group12 refereciam-se a tabela scm_group_cont.

select * from ERP_SUPPLIER;

select * from SCM_GROUP_CONT where COD_GROUP_PK = 'MED'; -- aqui estão as categorias de um fornecedor
select * from SCM_GROUP_NAME;

select * from erp_purchase_order;

select * from SCM_SKU WHERE COD_ITEM_PK = 53662;
select * from SCM_SKU;

select * from scm_estab;

-- select distinct a.id_supplier_pk, c.cod_group1_fk as categoria from
-- erp_supplier a
-- inner join erp_purchase_order b
-- on a.id_company_fk=b.id_company_fk
-- and a.id_supplier_pk=b.id_supplier
-- inner join scm_sku c
-- on c.cod_item_pk = b.cod_item
-- and c.cod_estab_fk=b.cod_estab
-- and c.id_company_fk=b.id_company_fk


-- select * from VW_SCM_AUX_SKU;


-- scm_sku tem id_sku_pk
-- scm_sku_out id_sku_fk
SELECT * FROM SCM_SKU_OUT; -- IN LEVEL 0 ZERO, 1, 2, 3, 4, 5 MUITO ALTO
select * from SCM_SKU_OUT; -- CICLO DE VIDA SKU_LIFE_CICLE

-- na tabela scm_sku tem o campo id_profile que tem as informações de política referenciado na id_profile_pk
select * from SCM_PROFILE;

select * from SCM_SKU where ID_SKU_PK = 1764932140;
select * from SCM_SKU_OUT where ID_SKU_FK = 1764932140;

select * from SCM_SKU; -- status do sistema sit_sku
select * from SCM_SKU; -- status erp sit_sku_erp
select * from SCM_SKU; -- analisada sit_analysed

