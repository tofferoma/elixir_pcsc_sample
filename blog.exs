IO.puts "Listing card readers"
{:ok, readers} = :pcsc_card_db.list_readers()

# use the fist reader
[reader | _] = readers
IO.inspect "Using reader: " <> reader

# connect to the card
{:ok, card} = :pcsc_card.start_link(reader, :shared, [:t1, :t0])

# send select APDU
aid = << 160, 0, 0, 0, 98, 99, 1, 12, 6, 0 >>
{:ok, replies} = :pcsc_card.command(card, #apdu_command{cla = :iso, ins = :select, p1 = 0, p2 = 10, data = aid})
