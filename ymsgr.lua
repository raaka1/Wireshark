

local f_value = Field.new("ymsg.content-line.value")
local f_ipsrc = Field.new("ip.src")

local tap = Listener.new(nil, "ymsg.service eq Message && ip")

function ymsg_call()

local td ={}	
td.win =TextWindow.new("YahooMessenger! Chat Extracts")	
td.text =""

function remove_tap()
if tap and tap.remove then
tap:remove()
end
end

td.win:set_atclose(remove_tap)

 function tap.packet(pinfo,tvb,tapdata)
 
 local fv = f_value()
 local fipsrc =f_ipsrc()
 local z = {f_value()}

 local get_chat = tostring(z[5])
 local recp = tostring(z[2])


local text = "Yahoo Messenger: "..fv.value.." :("..tostring(fipsrc.value)..") --> "..recp..":  "..get_chat


td.text = td.text .."\n"..text
 
 
 end
 
  function tap.draw()
        td.win:set(td.text)
        
    end


end
register_menu("SpyShark/YahooMessenger Extracts",ymsg_call,MENU_ANALYZE)
