def build_item(supplier_id, purchase_id)
  items = [
    'fibrobroncoscopio',
    'lupron depot 11,25mg',
    'placa 1.3 cana de 6 orificios l&g',
    # 'conj. cabo paciente p/ ecg dx 2010 3vias cod. ae-0j002-0',
    # 'protese mamaria 410mf -255g - suport med',
    # 'carregador com 4 pilhas pequenas recarregaveis',
    # 'tomada steck macho/femea',
    # 'fralda geriatrica descartavel',
    # 'haste kuntscher 09 x 38 baumer',
    # 'válvuyla retenção metal 2 1/2',
    # 'pino de posição lcp 4,5 mm synthes',
    # 'lampada tipo baioneta sdk 24v/40ma',
    # 'correia  a46',
    # 'cateter para arterigrafia visceral e.tamussino - hemodinamica',
    # 'dosador amoxil 250mg/5ml susp.oral 6 ml',
    # 'torneira cor azul ibbl',
    # 'parafuso bloqueado tm mercantil',
    # 'dosador carbamazepina 20mg/ml susp.oral 7ml',
    # 'caixa multipla - alumínio - 2x4 ( condulete ) 3/4',
    # 'ventilador para painel elétrico 120x120x39mm vazão 44l/s',
    # 'cunha niveladora n5',
    # 'cateter coronariano judkins left 3,5 - 4f (jl 3,5 4f)',
    # 'sapato de seguranca (preto) n.41',
    # 'vivonex plus 79,5g',
    # 'luva volk p ca 15100',
    # 'espetinho de kafta',
    # 'cetoprofeno gel (tubo c/ 30g)',
    # 'bolsa p/ colostomia 45mm',
    # 'kit cifoplastia p/ balão ortoeste',
    # 'stent fluency sinus- intermedical - hemodinamica'
  ]

  items.each do |item|
    puts "insert into \"item\" (description, erp_item_id, unit_measurement_id, unit_value, created_at, updated_at)
          values (\'#{item}\', #{rand(100000...999999)}, 1, 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
  end

  (1..items.count).each do |item_id|
    puts "insert into \"purchase_order_item\" (qty_parc, qty_rec, purchase_order_id, item_id, created_at, updated_at)"\
         "values (1, NULL, #{purchase_id}, #{item_id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
  end
end

def build_purchases(supplier_id)
  (1..1).each do |purchase_id|
    puts "insert into \"purchase_req\" (num_req, date_req, created_at, updated_at) "\
     "values(#{rand(10000...99999)}, '2018-10-18 18:03:03', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
  
    puts "insert into \"purchase_order\" (company_id, num_order, establishment_id, supplier_id, date_order, date_exp, date_real, "\
                                       "purchase_req_id, created_at, updated_at) "\
         "values (1, #{rand(10000...99999)}, 1, #{supplier_id}, '2017-01-06 00:00:00', '2017-01-06 00:00:00', NULL, #{purchase_id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
    
    build_item(supplier_id, purchase_id)
  end
end

def build_suppliers()
  suppliers = [
    { name: 'Bi Materiais', cnpj: '26074505000194' },
    { name: 'Parma Pizza', cnpj: '08807700000102' },
    { name: 'O Homem da Casa', cnpj: '25391522000192' },
    { name: 'Pemom', cnpj: '18227733000390' },
    { name: 'So Gesso', cnpj: '12580433000142' }
  ]
  
  suppliers.each_with_index do |supplier, index|
    puts "-- Inicio supplier #{index}"
    puts "insert into \"supplier\" (company_id, cnpj, company_name, trading_name, address, created_at, updated_at)"\
         " values (1, \'#{supplier[:cnpj]}\', \'#{supplier[:name]}\', \'#{supplier[:name]}\', 'Rua...', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
  
    build_purchases(index + 1)
    puts "-- Fim supplier #{index}"
    puts ''
  end
end

def build_companies()
  puts "INSERT INTO unit_measurement (company_id, acronym, description, created_at, updated_at)"\
     "VALUES (1, 'un', 'unidade', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"

  puts "insert into company (name, registration_number, key, dtu, maintenance_mode, "\
                            "app_link, avatar, language, created_at, updated_at) "\
        "values ('Hospital Albert Sabin', '12345678901234', '123456', 'VQBiZSBiZ1BYVWrqDurwDkBsV5B7VEXG', 0, 'A', 'avatar.png', "\
        "'pt-BR', current_timestamp, current_timestamp);";

  puts "insert into establishment (description, acronym, company_id, email, created_at, updated_at) "\
      "values ('HNSG', 'HNSG', 1, 'pnx@bionexo.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);";

  puts "insert into email_company (company_id, smtp_server, smtp_user, smtp_pass, smtp_email_address, smtp_port, smtp_ssl, "\
                                  "base_test, created_at, updated_at) "\
        "values (1, 'mail.bionexo.com.br', 'infra@bionexo.com', 'VQXGZSX7Z1BeVWBODurKDkXe', 'infra@bionexo.com', 25, 0, 0, "\
                "CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);";
  
  build_suppliers()
end

build_companies()
