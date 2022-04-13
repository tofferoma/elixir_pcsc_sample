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

aid = << 160, 0, 0, 0, 98, 3, 1, 12, 6, 1 >>
select_apdu = {:apdu_cmd, :default, :iso, :select, 4, 0, aid, 0}

# send select APDU
{:ok, replies} = :pcsc_card.command(card, select_apdu)
IO.inspect replies

# send command APDU
command_apdu = {:apdu_cmd, :default, :iso, 0, 0, 0, << >>, 0}
{:ok, replies} = :pcsc_card.command(card, command_apdu)
IO.inspect replies
