-- voip.lua
--tshark -X lua_script:voip.lua

do

          packets, packets_invite, packets_invite_flood, packets_register,packets_register_fs  = 0, 0, 0, 0, 0

          attack_log = io.open("fairview/assets/logs/attacks.json","a")
          ids_status_log = io.open("fairview/assets/logs/ids_status","a")
          local map_json = require "cjson"


        local tcp_src_f = Field.new("tcp.srcport")
        local tcp_dst_f = Field.new("tcp.dstport")
        local udp_src_f = Field.new("udp.srcport")
        local udp_dst_f = Field.new("udp.dstport")
        local sip_method =Field.new("sip.Method")                        --SIP METHOD
        local sip_cseq_seq_f = Field.new("sip.CSeq.seq")
        local sip_status_code_f = Field.new("sip.Status-Code")           --STATUS CODE
        local sip_contact_addr_f = Field.new("sip.contact.host")         -- SIP ?????????
        local sip_request_line_f = Field.new("sip.Request-Line")
        local sip_display_info_f = Field.new("sip.display.info")         -- DISPLAY INFO
        local sip_from_addr_f = Field.new("sip.from.addr")               -- SIP From Addr
        local sdp_connection_info_address_f = Field.new("sdp.connection_info.address")
        local raw_sip_line_f = Field.new("raw_sip.line")
        local sip_user_agent_f =Field.new("sip.User-Agent")             -- USER AGENT
        local sip_to_user_f =Field.new("sip.to.user")                   -- TO USER
        local sip_max_forwards_f =Field.new("sip.Max-Forwards")         -- MAX FORWARDS
        local function init_listener()

                 local tap = Listener.new("ip","sip")
                 function tap.packet(pinfo,tvb,ip)
                        local ip_src, ip_dst = tostring(ip.ip_src), tostring(ip.ip_dst)
                        local sip_contact_addr, sip_request_line, sip_from_addr = sip_contact_addr_f(), sip_request_line_f(), sip_from_addr_f()
                        local frame = tostring(pinfo.number)                  -- Frame number
                        local sip_to_user,sip_forwards = sip_to_user_f(),sip_max_forwards_f()
                        local sip_m, sip_display_info, sip_user_agent = sip_method(), sip_display_info_f(), sip_user_agent_f()
                        local sip_status = sip_status_code_f()

                       sipToUser = tostring(sip_to_user)                  -- SIP TO USER
                       sipMethod = tostring(sip_m)                        --SIP METHOD
                       sipAgent  =  tostring(sip_user_agent)              --SIP USER AGENT
                       sipDisplayInfo = tostring(sip_display_info)        --DISPLAY INFO


                   --Class="Password Cracking"
                   --Class="DOS"
                   --Class="Scan"



                     --------------------------------RULES-----------------------------------

                 if (sipMethod == "INVITE" and sipAgent ~= "Elite 1.0 Brcm Callctrl/1.5.1.0 MxSF/v.3.2.6.26") then
                     packets_invite = packets_invite + 1
                        if packets_invite > 20 then
                        value_invtflood = { "Attack", {NofPackets = packets, Messege ="INVITEFLOOD", Class="DOS", AttackerIP = ip_src, AttackerUserAgent = sipAgent, VictimName = sipToUser ,VictimIpaddres=ip_dst, time =os.date("%c") } }
                        messege_invite_flood_json = map_json.encode(value_invtflood)
                        attack_log:write(messege_invite_flood_json..",".."\n")
                        end
                          end


                 if (sipMethod == "INVITE" and sipAgent =="Elite 1.0 Brcm Callctrl/1.5.1.0 MxSF/v.3.2.6.26") then
                    packets_invite_flood =packets_invite_flood + 1
                        if packets_invite_flood > 20 then
                        value_invtflood = { "Attack", {NofPackets =packets_invite_flood, Messege ="INVITEFLOOD", Class="DOS", AttackerIP = ip_src, AttackerUserAgent = sipAgent, VictimName = sipToUser ,VictimIpaddres=ip_dst, time =os.date("%c") } }
                        messege_invite_flood_json = map_json.encode(value_invtflood)
                        attack_log:write(messege_invite_flood_json..",".."\n")
                         end
                           end

                if (sipMethod == "REGISTER"  and sipAgent == "Nmap NSE") then  -- User compromise alert
                    packets_register = packets_register + 1
                       if packets_register > 5  then
                       value_brutenmap = { "Attack", { NofPackets = packets_register, Messege ="BRUTE FORCE ATTACK NMAP", Class="Password Cracking", AttackerIP = ip_src, AttackerUserAgent =sipAgent,VictimName = sipToUser ,VictimIpaddres=ip_dst, time =os.date("%c")} }
                       messege_sip_brute_nmap_json = map_json.encode(value_brutenmap)
                       attack_log:write(messege_sip_brute_nmap_json..",".."\n")
                      end
                        end

                if (sipMethod == "REGISTER" and sipAgent == "friendly-scanner") then  --User compromise alert
                    packets_register_fs = packets_register_fs + 1
                       if packets_register_fs > 10  then
                       value_svcrack = { "Attack", { NofPackets = packets_register_fs, Messege="BRUTE FORCE ATTACK SVCRACK", Class="Password Cracking", AttackerIP = ip_src, AttackerUserAgent =sipAgent,VictimName = sipToUser ,VictimIpaddres=ip_dst, time =os.date("%c")} }
                       messege_sip_brute_svcrack_json = map_json.encode(value_svcrack)
                       attack_log:write(messege_sip_brute_svcrack_json..",".."\n")
                      end
                        end

               if (sipMethod  == ("INVITE" ) and sipDisplayInfo  == "\"sipvicious\"" and sipAgent == "friendly-scanner" ) then
                      value_svmapI = { "Attack", {NofPackets = packets, Messege="FINGER PRINTING WITH SVMAP - REGISTER option", Class="Scan", AttackerIP = ip_src, AttackerUserAgent =sipAgent, VictimName = sipToUser, VictimIpaddres=ip_dst, time =os.date("%c")} }
                      messege_sipvicious_svmap_json  =   map_json.encode(value_svmapI)
                      attack_log:write(messege_sipvicious_svmap_json ..",".."\n")
                       end

                if (sipMethod  == ("REGISTER" ) and sipDisplayInfo  == "\"sipvicious\"" and sipAgent == "friendly-scanner" ) then
                       value_svmapR = { "Attack", {NofPackets = packets, Messege="FINGER PRINTING WITH SVMAP - REGISTER option", Class="Scan", AttackerIP = ip_src, AttackerUserAgent =sipAgent, VictimName = sipToUser, VictimIpaddres=ip_dst, time =os.date("%c")} }
                       messege_sipvicious_svmap_json  =   map_json.encode(value_svmapR)
                       attack_log:write(messege_sipvicious_svmap_json ..",".."\n")
                       end

               if (sip_status  == "407") then
                         packets = packets + 1
                       if packets > 20  then
                       value_proxyflood = { "Attack", {NofPackets = packets, Messege ="SIP 407 ProxyAuthentication Required Flood", Class="DOS", AttackerIP = ip_src, AttackerUserAgent =sipAgent, VictimName = sipToUser, ProxyDestination=ip_dst, time =os.date("%c")} }
                       messege_ProxyAuthentication_flood_json  =   map_json.encode(value_proxyflood)
                       attack_log:write(messege_sipvicious_svmap_json ..",".."\n")
                      end
                        end

                         end --2  --packet




                 --------------------------------RULES-----------------------------------
                function tap.draw()
                   ids_status_log:write(" --IDS started  "..os.date("%c"), "\n")
                end


        end -- listner
        init_listener()
end --do
