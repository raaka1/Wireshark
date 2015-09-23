                         
local f_ipsrc = Field.new("ip.src")
local f_rqst = Field.new("ftp.request.command")
local f_arg = Field.new("ftp.request.arg")    
local tap = Listener.new(nil, "ftp.request.command eq USER || ftp.request.command eq PASS && ip")
function ftp_call()

local td ={}	
td.win =TextWindow.new("Ftp logins")	
td.text =""

function remove_tap()
if tap and tap.remove then
tap:remove()
end
end

td.win:set_atclose(remove_tap)

 function tap.packet(pinfo,tvb,tapdata)
 


local fipsrc =f_ipsrc()
local fr =f_rqst()
local fa =f_arg()

local text = "FTP Logins: "..fr.value.."   "..fa.value.."   "..tostring(fipsrc)

td.text = td.text .."\n"..text
 
 
 end
 
  function tap.draw()
        td.win:set(td.text)
        
    end


end
register_menu("SpyShark/FTP logins",ftp_call,MENU_ANALYZE)
