do


local http_virustotal_proto = Proto("VirusTotal","VirusTotal Scanned Result")
http_virustotal_proto.fields.scan = ProtoField.string("virustotal.scan.url","*")
http_virustotal_proto.fields.result = ProtoField.string("virustotal.scan.result","*")



local http_url = Field.new("http.request.full_uri")
local url = "http://www.virustotal.com/vtapi/v2/url/scan"
local url2 = "http://www.virustotal.com/vtapi/v2/url/report"
local p ={}
local data

----

require("json")
local httpd = require('socket.http')


----


function http_virustotal_proto.dissector(tvbuffer,pinfo,treeitem)
if http_url() then

----------------
local http_url_scan = http_url().value
local extratree = treeitem:add(http_virustotal_proto)
----------------

p[1] ='url'
p[2] ='='
p[3] = http_url_scan
p[4] ='&'
p[5] ='apikey'
p[6] = '='
p[7] ='d9f09941d4bc02611adf2bdf7f7f47c938b5ff455e1ae6183b3768fcd6790e3a'



local concatstr = p[1]..p[2]..p[3]..p[4]..p[5]..p[6]..p[7]

geturl = httpd.request(url,concatstr)
updata =json.decode(geturl)
-----------------------------------------------------
p[1] ='resource'
local concat_result = p[1]..p[2]..p[3]..p[4]..p[5]..p[6]..p[7]

local get_result =httpd.request(url2,concat_result)
data = json.decode(get_result)

------------------------------------------------------
xdate = os.date()
extratree:add(http_virustotal_proto.fields.scan,(updata.verbose_msg.." "..xdate))
extratree:add(http_virustotal_proto.fields.scan,updata.url)

if data.response_code == 1 then
extratree:add(http_virustotal_proto.fields.scan,("Scaning done"))
extratree:add(http_virustotal_proto.fields.scan,data.permalink)
end

if data.positives >1 then

extratree:add(http_virustotal_proto.fields.result,("Infected"))
else
extratree:add(http_virustotal_proto.fields.result,("Clean"))

end
end
end

register_postdissector(http_virustotal_proto)
end

