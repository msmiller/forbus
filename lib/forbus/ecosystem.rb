#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-11-07 11:36:38
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  class FORbus

    # Starts a thread to monitor the ecosystem bus LIST and when a new item appears,
    # pass it to the supplied callback function
    def start_ecobus_monitor(subscriber_token, callback, delay=50)
    end

    def stop_ecobus_monitor(subscriber_token)
    end

    def ecobus_length(subscriber_token)
      @local_redis.llen Forbus.bus_key(subscriber_token)
    end

    # Push a command onto the ecosystem bus
    def push_ecobus_command(subscriber_token, payload_hash)
      @local_redis.lpush Forbus.bus_key(subscriber_token), Marshal.dump(payload_hash)
      @local_redis.ltrim Forbus.bus_key(subscriber_token), 0, @list_size
    end

    def pull_ecobus_command(subscriber_token)
      result = @local_redis.lpop Forbus.bus_key(subscriber_token)
      Marshal.load(result)
    end

  end

end
