--[[ $%BEGINLICENSE%$
 Copyright (C) 2008 MySQL AB, 2008 Sun Microsystems, Inc

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; version 2 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 $%ENDLICENSE%$ --]]

local proto = assert(require("mysql.proto"))

function connect_server()
	-- emulate a server
	proxy.response = {
		type = proxy.MYSQLD_PACKET_RAW,
		packets = {
			proto.to_challenge_packet({
				server_version = 50120
			})
		}
	}
	return proxy.PROXY_SEND_RESULT
end

function read_query(packet)
	if packet:byte() ~= proxy.COM_QUERY then 
		proxy.response = {
			type = proxy.MYSQLD_PACKET_OK
		}
		return proxy.PROXY_SEND_RESULT
	end

	proxy.response = {
		type = proxy.MYSQLD_PACKET_OK,
		resultset = {
			fields = {
				{ name = "Result", type = proxy.MYSQL_TYPE_STRING },
			},
			rows = { { "1" }  }
		}
	}

	return proxy.PROXY_SEND_RESULT
end

