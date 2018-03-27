function error() 	
	print( "ERROR" ); 	
end
function success()	print( "SUCCESS" ); end
function read_data()  
	if 	file.open("nbtourwait.data" , "r" ) then 		
		nbtourwait=math.ceil(tonumber(file.readline())); 
		print ("nbtourwait ".. nbtourwait);
	else
		print("fichier nbtourwait.data introuvable, creation");
		sauvegarder(nbtourwait, 'nbtourwait.data');  
	end
	if 	file.open("tarre.data" , "r" ) then 		
		TARRE=math.ceil(tonumber(file.readline())); 
		print ("TARRE ".. TARRE);
	else
		print("fichier tarre.data introuvable, creation");
		sauvegarder(TARRE, 'tarre.data');  
	end
	
end
function moyenne(tab,ratio)
	table.sort (tab)
	-- on va garder ratio% des valeurs , on supprime les 20% les plus petite et les 20% les plus grandes
	nb_ele_delete=math.ceil(table.getn(tab)* (100 - ratio)/200  )
	for i=1, nb_ele_delete do 
		table.remove(tab,table.getn(tab))
		table.remove(tab,1)
	end
	i=0
	total=0
	table.foreach (tab, 
		function() 
			i=i+1 
			total=tab[i]+total
		end 
	)
	return (total/i)
end

function engramme(val)
	return  math.floor( ( val -TARRE)  / HXRATIO )
end
function sauvegarder(valeur,fichier)
	if file.open(fichier) then
	  print(file.read())
	  file.close()
	  file.remove(fichier);
	end
	file.open(fichier , "w" )
	file.writeline(math.ceil(tonumber(valeur)));
	file.close();
    print ("file mis a jour avec "..valeur);
end