class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new # defaults to Rails.cache
    # Always allow requests from localhost
    # (blocklist & throttles are skipped)
  Rack::Attack.safelist('allow from localhost') do |req|
    # Requests are allowed if the return value is truthy
    '127.0.0.1' == req.ip || '::1' == req.ip
  end
  
  # Block requests from 1.2.3.4
  Rack::Attack.blocklist('block 1.2.3.4') do |req|
    # Requests are blocked if the return value is truthy
    '1.2.3.4' == req.ip
  end

  # Block logins from a bad user agent
  Rack::Attack.blocklist('block bad UA logins') do |req|
    req.path == '/login' && req.post? && req.user_agent == 'BadUA'
  end
  
  # Block suspicious requests for '/etc/password' or wordpress specific paths.
  # After 3 blocked requests in 10 minutes, block all requests from that IP for 5 minutes.
  Rack::Attack.blocklist('fail2ban pentesters') do |req|
    # `filter` returns truthy value if request fails, or if it's from a previously banned IP
    # so the request is blocked
    Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", :maxretry => 3, :findtime => 10.minutes, :bantime => 5.minutes) do
      # The count for the IP is incremented if the return value is truthy
      CGI.unescape(req.query_string) =~ %r{/etc/passwd} ||
      req.path.include?('/etc/passwd') ||
      req.path.include?('wp-admin') ||
      req.path.include?('wp-login')
    end
  end
  
  # Lockout IP addresses that are hammering your login page.
  # After 20 requests in 1 minute, block all requests from that IP for 1 hour.
  Rack::Attack.blocklist('allow2ban login scrapers') do |req|
    # `filter` returns false value if request is to your login page (but still
    # increments the count) so request below the limit are not blocked until
    # they hit the limit.  At that point, filter will return true and block.
    Rack::Attack::Allow2Ban.filter(req.ip, :maxretry => 20, :findtime => 1.minute, :bantime => 1.hour) do
      # The count for the IP is incremented if the return value is truthy.
      req.path == '/login' and req.post?
    end
  end

  # Throttle requests to 5 requests per second per ip
  #Rack::Attack.throttle('req/ip', :limit => 5, :period => 100.second) do |req|
    # If the return value is truthy, the cache key for the return value
    # is incremented and compared with the limit. In this case:
    #   "rack::attack:#{Time.now.to_i/1.second}:req/ip:#{req.ip}"
    #
    # If falsy, the cache key is neither incremented nor checked.
   # req.ip
  #end

  # Throttle login attempts for a given email parameter to 6 reqs/minute
  # Return the email as a discriminator on POST /login requests
  #Rack::Attack.throttle('logins/email', :limit => 6, :period => 60.seconds) do |req|
   # req.params['email'] if req.path == '/login' && req.post?
  #end

  # You can also set a limit and period using a proc. For instance, after
  # Rack::Auth::Basic has authenticated the user:
  #limit_proc = proc {|req| req.env["REMOTE_USER"] == "admin" ? 100 : 1}
  #period_proc = proc {|req| req.env["REMOTE_USER"] == "admin" ? 1.second : 1.minute}
  #Rack::Attack.throttle('req/ip', :limit => limit_proc, :period => period_proc) do |req|
   # req.ip
  #end

  # Track requests from a special user agent.
  Rack::Attack.track("special_agent") do |req|
    req.user_agent == "SpecialAgent"
  end

  # Supports optional limit and period, triggers the notification only when the limit is reached.
  Rack::Attack.track("special_agent", :limit => 6, :period => 60.seconds) do |req|
    req.user_agent == "SpecialAgent"
  end

  # Track it using ActiveSupport::Notification
  ActiveSupport::Notifications.subscribe("rack.attack") do |name, start, finish, request_id, req|
    if req.env['rack.attack.matched'] == "special_agent" && req.env['rack.attack.match_type'] == :track
      Rails.logger.info "special_agent: #{req.path}"
      STATSD.increment("special_agent")
    end
  end

  Rack::Attack.blocklisted_response = lambda do |env|
    # Using 503 because it may make attacker think that they have successfully
    # DOSed the site. Rack::Attack returns 403 for blocklists by default
    [ 503, {}, ['Blocked']]
  end

  #Rack::Attack.throttled_response = lambda do |env|
    # NB: you have access to the name and other data about the matched throttle
    #  env['rack.attack.matched'],
    #  env['rack.attack.match_type'],
    #  env['rack.attack.match_data']

    # Using 503 because it may make attacker think that they have successfully
    # DOSed the site. Rack::Attack returns 429 for throttling by default
   # [ 503, {}, ["Server Error\n"]]
  #end

  #Rack::Attack.throttled_response = lambda do |env|
   # now = Time.now
    #match_data = env['rack.attack.match_data']

    #headers = {
     # 'X-RateLimit-Limit' => match_data[:limit].to_s,
      #'X-RateLimit-Remaining' => '0',
      #'X-RateLimit-Reset' => (now + (match_data[:period] - now.to_i % match_data[:period])).to_s
    #}

    #[ 429, headers, ["Throttled\n"]]
  #end

  #ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
   # puts req.inspect
  #end
end