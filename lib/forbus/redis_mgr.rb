#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-11-07 14:40:47
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

# Set up and manage Redis-based buses and connections
module Forbus

  # Helper to create random user/pass for Redis access
  def self.create_random_user_pass
    { username: SecureRandom.alphanumeric(20), password: SecureRandom.alphanumeric(20) }
  end

  def self.create_random_token
    SecureRandom.alphanumeric(20)
  end

  class FORbus

    # Grants access to local Redis server. No opinion on where/how credentials
    # are persisted or generated. This will grant read-only access to the ecosystem_key_root
    # which includes the bus_key which will pass commands and dm's (which aren't tied to a channel)
    #
    # @param user
    # @param pass
    def set_bus_ecosystem_acl(user, pass)
    end

    # Grants access to a channel on the local Redis server. User/pass can be the same
    # as for the ecosystem or different.
    #
    # @param user
    # @param pass
    # @param channel_id The id of the channel on the local app
    def set_bus_channel_acl(user, pass, channel_id)
    end

    #### UTIL FUNCTIONS ####

    # Clears a LIST being used as a bus on the local service
    #
    # @param bus_token The token for the bus to clear
    def clear_bus_channel(bus_token)
      @local_redis.ltrim(Forbus.bus_key(bus_token), 1, -1)
    end

  end

end
