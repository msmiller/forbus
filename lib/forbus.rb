#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:14:40
# @Last Modified by:   msmiller
# @Last Modified time: 2021-11-07 10:59:37
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

require_relative 'forbus/version'
require_relative 'forbus/keys'
require_relative 'forbus/site'
require_relative 'forbus/channel'
require_relative 'forbus/actor'
require_relative 'forbus/rpc'
require_relative 'forbus/redis_mgr'
require_relative 'forbus/ecosystem'
require_relative 'forbus/api'

require 'securerandom'
require 'json'

module Forbus
  class Error < StandardError; end
  class ForbusError < StandardError; end

  class FORbus
    @local_redis = nil
    @remote_redis = nil
    @list_size = 1000
    attr_accessor :local_redis, :remote_redis, :list_size

    def initialize(local_redis_url = nil, remote_redis_url = nil)
      # TODO: Re-do this part once we get to ACL stuff
      @local_redis = Redis.new(url: local_redis_url)
      @remote_redis = Redis.new(url: remote_redis_url)
      @list_size = 1000
    end
  end
end

class FORbus < Forbus::FORbus
end

