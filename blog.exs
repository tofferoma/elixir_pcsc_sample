IO.puts "Listing card readers"
{:ok, readers} = :pcsc_card_db.list_readers()

# use the fist reader
[reader | _] = readers
IO.inspect "Using reader: " <> reader

# get ATR
{:ok, atr} = :pcsc_card_db.get_reader_atr(reader)
IO.inspect atr

# decode ATR
atr_info = :iso7816.decode_atr(atr)
IO.inspect atr_info

# connect to the card
{:ok, card} = :pcsc_card.start_link(reader, :shared, [:t1, :t0])

# send select APDU
aid = << 160, 0, 0, 0, 98, 99, 1, 12, 6, 0 >>
{:ok, replies} = :pcsc_card.command(card, #apdu_command{cla = :iso, ins = :select, p1 = 0, p2 = 10, data = aid})
