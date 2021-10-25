#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-25 15:51:22
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  class FORbus

    def set_site_hash(h)
      @local_redis.set( Forbus.site_key, h.to_json )
    end

    def get_site_hash
      json_hash = @remote_redis.get( Forbus.site_key )
      JSON.parse(json_hash)
    end

  end

end
