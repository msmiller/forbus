#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:14:40
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-26 10:20:42
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

require_relative "forbus/version"
require_relative "forbus/keys"
require_relative "forbus/site"
require_relative "forbus/channel"
require_relative "forbus/actor"
require_relative "forbus/rpc"
require_relative "forbus/redis_bus"
require_relative "forbus/ecosystem"

require 'securerandom'
require 'json'

module Forbus
  class Error < StandardError; end

  class FORbus

    @local_redis = nil
    @remote_redis = nil
    attr_accessor :local_redis, :remote_redis

    def initialize(local_redis_url=nil, remote_redis_url=nil)
      if local_redis_url.nil?
        @local_redis = Redis.new
      else
        @local_redis = Redis.new(url: local_redis_url)
      end
       if remote_redis_url.nil?
        @remote_redis = Redis.new
      else
        @remote_redis = Redis.new(url: remote_redis_url)
      end
    end

  end

end

class FORbus < Forbus::FORbus
end
