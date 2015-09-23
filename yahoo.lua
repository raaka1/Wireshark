do
     local   http_yahoo_proto = Proto("yahoo", "User Searched Yahoo Keywords");
		http_yahoo_proto.fields.keyword = ProtoField.string("yahoo.search.keyword", "Yahoo keyword")
		
local URL
		
		local full_uri = Field.new("http.request.full_uri")
	
		
		
		function url_decode(str)
               str =string.gsub (str,"+"," ")
             str =string.gsub (str,"%%(%x%x)",
            function (h) return string.char(tonumber(h,16)) end)
            str =string.gsub (str, "\r\n","\n")
            return str
             end 




		function http_yahoo_proto.dissector(tvbuffer,pinfo,treeitem)
if full_uri() then
			local host = full_uri().value		  
			 -- create a regex function


function pcre_rex(answer)
			  local rex = require "rex_pcre"

             
answer = rex.match(host, "p=([^&]+).*&fr2([^&]+)")

or

 rex.match(host,"&p=([^&]+).*&toggle([^&]+)")

return answer

end

local URL =pcre_rex(URL)


             if URL ~= nil then		

             	  local decode = url_decode(URL) 
			 local extratree = treeitem:add(http_yahoo_proto)
                    extratree:add(http_yahoo_proto.fields.keyword, decode)
		
end		
		end
		end
		register_postdissector(http_yahoo_proto)
		end
