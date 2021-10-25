#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-25 15:51:16
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  class FORbus

    # REQUIRES a channel_id param
    def set_actor_imprint_hash(h)
      @local_redis.set( Forbus.actor_imprint_key(h[:actor_id] || h['actor_id']), h.to_json )
    end

    def get_actor_imprint_hash(actor_id)
      json_hash = @remote_redis.get( Forbus.actor_imprint_key(actor_id) )
      JSON.parse(json_hash)
    end

  end

end
