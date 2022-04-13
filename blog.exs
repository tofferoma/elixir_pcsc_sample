IO.puts "Listing card readers"
{:ok, readers} = :pcsc_card_db.list_readers()

# use the fist reader
[reader | _] = readers
IO.inspect "Using reader: " <> reader

# connect to the card
{:ok, card} = :pcsc_card.start_link(reader, :shared, [:t1, :t0])
