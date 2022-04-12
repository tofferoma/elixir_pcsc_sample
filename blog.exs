IO.puts "Listing card readers"
{:ok, readers} = :pcsc_card_db.list_readers()
IO.inspect readers
