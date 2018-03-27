require("settings")
dofile('wifi.lua');
dofile('moteur.lua');
dofile('tools.lua');
dofile('postDomoticz.lua');
dofile('webserver.lua');
dofile('balance.lua');
dofile('dht.lua');
lock=0;
	gpio.mode(BUILDINLED,gpio.OUTPUT);gpio.write(BUILDINLED,gpio.HIGH);
	gpio.mode(PIN_SENS1,gpio.OUTPUT);gpio.write(PIN_SENS1,gpio.LOW);
	gpio.mode(PIN_SENS2,gpio.OUTPUT);gpio.write(PIN_SENS2,gpio.LOW);
	gpio.mode(PIN_MOTOR,gpio.OUTPUT);gpio.write(PIN_MOTOR,gpio.LOW);

--gpio.mode(PIN_LED_CONTROL,gpio.OUTPUT);gpio.write(PIN_LED_CONTROL,gpio.LOW);
nb=7 print("5 s") tmr.alarm(0, 1000, 1, function()		
	nb=nb-1  	
	print (".");
	if nb ==0 then  tmr.stop(0); 
		main();
	end 
end)
function main()
	read_data();			
	pesee(1);
	dofile('ir.lua');
end