#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-26 12:48:35
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  class FORbus

    # Starts a thread to monitor the ecosystem bus LIST and when a new item appears,
    # pass it to the supplied callback function
    def start_ecobus_monitor(callback, delay=50)
    end

    def stop_ecobus_monitor
    end

    # Push a command onto the ecosystem bus
    def push_ecobus_command(payload_hash)
      @local_redis.lpush Forbus.bus_key, payload_hash.to_json
      @local_redis.ltrim Forbus.bus_key, @list_size
    end

  end

end
