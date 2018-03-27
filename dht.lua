function temperature()
	status, temp, humi, temp_dec, humi_dec = dht.read(PIN_DHT)
	if status == dht.OK then
		print ("temp  ".. temp);
		print ("humi  ".. humi);
		if (temp>=5 and humi<=99) then 
		table.insert(mesures, {type='command' ,idx=idxdht, param="udevice", svalue=temp..";"..humi..";0", nvalue=0} )
		else
			print("mesure incorrecte")
		end
	elseif status == dht.ERROR_CHECKSUM then
		print( "  DHT Checksum error." )
	elseif status == dht.ERROR_TIMEOUT then
		print( "  DHT timed out." )
	end
end