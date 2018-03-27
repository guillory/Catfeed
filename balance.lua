function pesee(type)
	if (lock==0) then 
		lock=1;
	  	mesures={};
		temperature();
		hx711.init(HXPIN_clk,HXPIN_data)
		local stable=0
		local nbtry=0
		 while (stable==0 and nbtry<10) do
		 	nbtry=nbtry+1
		  	mesurepoids={};
			for i=1, 10 do 
				poids= - hx711.read(0) or 999
				table.insert(mesurepoids, poids)
				print(poids);
				tmr.delay(100000)
			end
			table.sort (mesurepoids)
			if (engramme(mesurepoids[table.getn(mesurepoids)]) - engramme(mesurepoids[1]) > 200) then
				print("delta mesure  plus de 200g :ca bouge")
				stable=0
			else
				print("delta mesure moins de 200g  : ok")
				stable=1
			end
		 end
		 if (stable==1 ) then
			 if  type=='tarre' then 
		 		TARRE=moyenne(mesurepoids,60)
				print ("TARRE ="..TARRE)
				sauvegarder(TARRE, 'tarre.data');   
				table.insert(mesures, {idx=idxswitch, type='command' , param="switchlight", switchcmd="Set+Level", level=0} );
				ConnectWifi(postDomoticz, error) ;  
			 else
		 		 -- Mesure de poids
		 		poids=engramme(moyenne(mesurepoids,60))
		 		print ("Poids :".. poids.." grammes");
		 		if poids<0 then 
		 			print("tarre");
		 			lock=0;
		 			pesee('tarre');
		 		else
					table.insert(mesures, {type='command' , idx=idxpoids, param="udevice", svalue=poids, nvalue=0} )
					 ConnectWifi(postDomoticz, error) ;  
				end
			 end
		else
		 	poids=0 ;
		 	lock=0;
		end
	end
	
end


mytimerpesee = tmr.create();
mytimerpesee:register(delaipesee_temp, tmr.ALARM_AUTO, function() 	print("pesee")	pesee(1)	end)
mytimerpesee:interval(delaipesee_temp) 
mytimerpesee:start()

