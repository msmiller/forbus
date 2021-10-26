#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-26 10:59:33
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  class FORbus

    # REQUIRES a channel_id param
    def set_channel_imprint_hash(h)
      h[:lastupdate] = Time.now
      @local_redis.set( Forbus.channel_imprint_key(h[:channel_id] || h['channel_id']), h.to_json )
    end

    def get_channel_imprint_hash(channel_id)
      json_hash = @remote_redis.get( Forbus.channel_imprint_key(channel_id) )
      JSON.parse(json_hash)
    end

    def set_marker(channel_id, caret)
      @local_redis.set( Forbus.marker_key(channel_id), caret )
      @local_redis.set( Forbus.marker_key('lastupdate'), Time.now )
    end

    def get_marker(channel_id)
      @remote_redis.get( Forbus.marker_key(channel_id) ).to_i
    end

    def get_marker_lastupdate
      @remote_redis.get( Forbus.marker_key('lastupdate') )
    end

    def get_markers_all
      result = {}
      @remote_redis.scan_each(:match => "#{Forbus.markers_key_root}:*?").each do |key|
        channel_id = key.split(":").last.to_i
        result[channel_id] = @remote_redis.get(key).to_i
      end
      return result
    end

  end

end
