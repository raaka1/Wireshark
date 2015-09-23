do
     local   http_youtube_proto = Proto("youtube", "User Searched Youtube Keywords");
		http_youtube_proto.fields.keyword = ProtoField.string("youtube.search.keyword", "Youtube keyword")
		

		
		local full_uri = Field.new("http.request.full_uri")
	        
				
		local URL
		
function url_decode(str)
str =string.gsub (str,"+"," ")
str =string.gsub (str,"%%(%x%x)",
function (h) return string.char(tonumber(h,16)) end)
str =string.gsub (str, "\r\n","\n")
return str
end 

		function http_youtube_proto.dissector(tvbuffer,pinfo,treeitem)
if full_uri() then

			local host = full_uri().value		  
			 
			  local rex = require "rex_pcre"
             URL = rex.match(host, "search_query=([^&]+).*&oq([^&]+)")
            
             if URL ~= nil then		
             	local decode = url_decode(URL) 
 
			 local extratree = treeitem:add(http_youtube_proto)
                    extratree:add(http_youtube_proto.fields.keyword, decode)
				
		end
		end
end
		register_postdissector(http_youtube_proto)
		end
