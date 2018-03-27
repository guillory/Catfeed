function feed_on()
	if (lock==0 ) then  --and securitylock==0
		print("FEED");
		lock=1;
		gpio.write(PIN_MOTOR,gpio.HIGH);
		gpio.write(PIN_SENS1,gpio.HIGH);
		gpio.write(PIN_SENS2,gpio.LOW);
		
		nbsecwait=0;
		mytimerfeed = tmr.create();
		mytimerfeed:register(1000, tmr.ALARM_AUTO, function() 
			nbsecwait=nbsecwait+1; 
			print("On attends depuis "..nbsecwait.."s");  
				if (nbsecwait >=nbtourwait ) then 
					print("STOP FEED");
					mytimerfeed:unregister(); 
					gpio.write(PIN_SENS1,gpio.LOW);
					gpio.write(PIN_SENS2,gpio.HIGH);
					tmr.delay(2000000) -- deux seconde a l'envers
					gpio.write(PIN_SENS2,gpio.LOW);
					gpio.write(PIN_MOTOR,gpio.LOW);
					table.insert(mesures, {idx=idxswitch, param="switchlight", switchcmd="Set+Level", level=0} );
					table.insert(mesures, {type='command' , param='udevice', idx=idxmoteur, svalue=nbsecwait, nvalue=0} ) -- counter
					ConnectWifi(postDomoticz, error) ;  
				end
			end)
		mytimerfeed:interval(1000) -- on décompte les secondes jusqu'à nbtourwait
		mytimerfeed:start()
	end
end
