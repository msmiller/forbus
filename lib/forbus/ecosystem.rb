#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-26 12:37:51
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  class FORbus

    def start_ecobus_monitor(callback)
    end

    def stop_ecobus_monitor
    end

    def push_ecobus_command(payload_hash)
      @local_redis.lpush Forbus.bus_key, payload_hash.to_json
    end

  end

end
