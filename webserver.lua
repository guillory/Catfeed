local httpRequest={}
httpRequest["/json.htm"]="json.htm";
httpRequest["/favicon.ico"]="favicon.ico";


local getContentType={};

getContentType["/json.htm"]="application/json";
getContentType["/favicon.ico"]="image/x-icon";
local filePos=0;
local nbline=0;

if srv then srv:close() srv=nil end
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(conn,request)
        print("[New Request]");
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
         _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local formDATA = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "([%w_]+)=([^&]+)&*") do
               print("["..k.."="..v.."]");
                formDATA[k] = v
            end   
        end
       if (formDATA['reboot']=="on"     and lock==0) then  
            node.restart();       end
        if (formDATA['feed']=="on"      and lock==0) then  
            feed_on();     end  
        if (formDATA['tarre']=="on"     and lock==0) then  
            pesee('tarre'); end
        if (formDATA['pesee']=="on"     and lock==0) then  
            pesee(1);       end
        if (formDATA['nbtourwait']      and lock==0) then  
            nbtourwait=0 + math.ceil(tonumber(formDATA['nbtourwait']));  sauvegarder(nbtourwait, 'nbtourwait.data');    end 
       -- if (formDATA['securitylock']  and lock==0) then              mytimererror:stop();            securitylock=0 + math.ceil(tonumber(formDATA['securitylock']));  sauvegarder(securitylock, 'securitylock.data');    end 
                           
        json="{\"securitylock\": "..securitylock..",\"nbtourwait\": "..nbtourwait..", \"poids\": "..poids..", \"TARRE\": "..TARRE..", \"lock\" : "..lock.."}";
        if getContentType[path] then
            requestFile=httpRequest[path];
            print("[Sending file "..requestFile.."]");            
            conn:send("HTTP/1.1 200 OK\r\nContent-Type: "..getContentType[path].."\r\n".."Access-Control-Allow-Origin: *".."\r\n\r\n");   
        else
            print("[File "..path.." not found]");
            conn:send("HTTP/1.1 404 Not Found\r\n\r\n")
            conn:close();
            collectgarbage();
        end
    end)
    conn:on("sent",function(conn)
        if requestFile then
                conn:send(json);
        end
        print("[Connection closed]");
        conn:close();
        collectgarbage();
    end)
end)
