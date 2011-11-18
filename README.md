Firewall as a Service

Packet inspection for:
- SQL injections
- ???
Mitigation of DoS and DDoS attacks
Deny common attacks

What's needed?

- DNS roundrobin in front of...
- ?x servers 
- iptables for control
- something to inspect every packet?


## Anatomy of a SecRule

Every request is checked by and returns:

- part of the request (REQUEST_FILENAME|ARGS_NAMES|ARGS|XML)
- log of attack blocked
- severity
- 
class Rebuff

  def call(env)
    request = Rack::Request.new(env)
    headers = Rack::Utils::HeaderHash.new
    customer = Customer.find(env.headers.customer_id)
    
    
    if customer.bad_requests.include?(/request.body/)
      [500, {}, []]
    end
    
    env.each do |key, value|
      if key =~ /HTTP_(.*)/
        headers[$1] = value
      end
    end
    
    result = Net::HTTP.start(@host, @port) do |http|
      method = rack_request.request_method
      case method
      when "GET", "HEAD", "DELETE", "OPTIONS", "TRACE"
        req = Net::HTTP.const_get(method.capitalize).new(request.fullpath, headers)
      when "PUT", "POST"
        req = Net::HTTP.const_get(method.capitalize).new(request.fullpath, headers)
      else
        raise "Method not supported: #{method}"
      end
      
      http.request(result)
    end
    
    [result.code, Rack::Utils::HeaderHash.new(result.to_hash), [result.body]]
  end
end


## Issues

* Bandwidth. Who pays for it?
* let's say that Jimmy User does a promotion of some sort that suddenly gets hella hits. all that shit coming from a couple of IPs is so gonna get flagged and ACL'd as a DoS. logic dictates that you're going to be the one that gets the support call.
* How is ssl encryption/decryption handled?