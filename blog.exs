# list card readers
{:ok, readers} = :pcsc_card_db.list_readers()

# use the fist reader
[reader | _] = readers
IO.puts("Using reader: " <> reader)

# connect to the card
{:ok, card} = :pcsc_card.start_link(reader, :shared, [:t1, :t0])

aid = << 160, 0, 0, 0, 98, 3, 1, 12, 6, 1 >>
select_apdu = {:apdu_cmd, :default, :iso, :select, 4, 0, aid, :none}

# send select APDU
{:ok, replies} = :pcsc_card.command(card, select_apdu)
IO.inspect replies

# send command APDU
command_apdu = {:apdu_cmd, :default, :iso, 0, 0, 0, :none, :none}
{:ok, replies} = :pcsc_card.command(card, command_apdu)
IO.inspect replies

# get the first reply only
[reply | _] = replies
case reply do
	{:apdu_reply, _, :ok, msg} -> IO.puts(msg)
	{:apdu_reply, _, :error, _} -> IO.puts("Failed")
end
