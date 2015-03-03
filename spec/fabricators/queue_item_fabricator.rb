Fabricator(:queue_item) do
  list_order { (1..10).to_a.sample }
end
