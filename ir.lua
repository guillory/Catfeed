function pulse(level)
	nbpluse=nbpluse+1;
	print (nbpluse);
end
function reset_nbpluse()
	print ("reset "..nbpluse);
	if (nbpluse>nb_mesure_ir) then
		print ("ya eu du mouvement");
		table.insert(mesures, {type='command', idx=idxir, param="udevice", svalue=nbpluse, nvalue=0} ) -- alert
		ConnectWifi(postDomoticz, error) ;  
	end
	nbpluse=0;
end
nbpluse=0;
gpio.mode(PIN_IR,gpio.INPUT);

gpio.trig(PIN_IR, "down", pulse);
mytimerpresence = tmr.create();
mytimerpresence:register(delai_ir, tmr.ALARM_AUTO, reset_nbpluse);
mytimerpresence:interval(delai_ir) ;
mytimerpresence:start()
