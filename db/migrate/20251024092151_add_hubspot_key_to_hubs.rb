class AddHubspotKeyToHubs < ActiveRecord::Migration[7.0]
  def up
    add_column :hubs, :hubspot_key, :string

    mappings = {
      'Boca Raton' => 'US - Boca Raton',
      'Baia 1' => 'Portugal - Cascais Baía',
      'Baia 2' => 'Portugal - Cascais Baía 2',
      'Braga' => 'Braga',
      'Ofir' => 'Portugal - Esposende',
      'Setúbal' => 'Setúbal',
      'Campolide' => 'Campolide',
      'Expo' => 'Lisbon (Expo)',
      'Restelo' => 'Portugal - Lisbon Restelo',
      'Cascais 1' => 'Cascais',
      'Cascais 2' => 'Portugal - Cascais Centre 2',
      'Parede' => 'Parede',
      'Ericeira 1' => 'Portugal - Ericeira (Pão da Vila)',
      'Santarém' => 'Santarém',
      'Caldas da Rainha' => 'Caldas da Rainha',
      'Leiria' => 'Leiria',
      'Fundão' => 'Portugal - Fundão',
      'Funchal' => 'Portugal - Funchal',
      'Tavira' => 'Portugal - Tavira',
      'Vila Sol' => 'Portugal - Vila Sol',
      'Lagoa' => 'Lagoa',
      'Lagos 1' => 'Lagos',
      'Lagos 2' => 'Portugal - Lagos (Batatas)',
      'Loulé' => 'Loulé',
      'Marbella' => 'Spain - Marbella',
      'Valencia' => 'Spain - Valencia',
      'Nelspruit' => 'South Africa - Nelspruit',
      'Tygervalley' => 'South Africa - Bellville',
      'Windhoek' => 'Namibia - Windhoek',
      'Walvis Bay' => 'Namibia - Walvis Bay',
      'Sommerschield' => 'Mozambique - Maputo',
      'Tofo' => 'Mozambique - Inhambane',
      'Guincho' => 'Guincho',
      'Kilifi' => 'Kenya - Kilifi',
      'CCB' => 'CCB',
      'Coimbra' => 'Coimbra',
      'Bern' => 'Switzerland - BGA x The British School Bern',
      'DHS' => 'BGA x DHS (Durban High School)',
      'WBHS' => 'South Africa - BGA x WBHS (Westville Boys\' High School)',
      'HHS' => 'BGA x Huguenot High School',
      'Paarl' => 'South Africa - Paarl',
      'Ipswich' => 'UK - BGA x IHS (Ipswich High School)',
      'Anje' => 'Porto (Foz)'
    }

    mappings.each do |hub_name, hubspot_key|
      hub = Hub.find_by(name: hub_name)
      hub.update!(hubspot_key: hubspot_key) if hub
    end

    add_index :hubs, :hubspot_key, unique: true
  end

  def down
    remove_column :hubs, :hubspot_key
  end
end
