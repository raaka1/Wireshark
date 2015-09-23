

--Developed by Ravi kiran.k  wiresharkonsteroids.blogspot.com
do
     local   heartbleed = Proto("heartbleed", "heartbleed ssl decrypt ");
		heartbleed.fields.keyword = ProtoField.string("heartbleed.user.data", "heartbleed")
		

		
		local full_uri = Field.new("http.request.full_uri")
	        
				
		local URL
		
function url_decode(str)
str =string.gsub (str,"+"," ")
str =string.gsub (str,"%%(%x%x)",
function (h) return string.char(tonumber(h,16)) end)
str =string.gsub (str, "\r\n","\n")
return str
end 

		function heartbleed.dissector(tvbuffer,pinfo,treeitem)
if full_uri() then

			local host = full_uri().value		  
			 
		
     
			function pcre_rex(answer)
			  local rex = require "rex_pcre"

             
answer = rex.match(host, "&q=([^&]+).*&pbx=([^&]+)")

or

 rex.match(host,"&q=([^&]+).*&psj=([^&]+)")

return answer

end

local URL =pcre_rex(URL)

             if URL ~= nil then		
             	local decode = url_decode(URL) 
 
			 local extratree = treeitem:add(heartbleed)
                    extratree:add(heartbleed.fields.keyword, decode)
				
		end
		end
end
		register_postdissector(heartbleed)
		end
