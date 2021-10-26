#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-26 10:33:15
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  class FORbus

    # Push the response to an RPC request to the local bus with a 5 minute timeout
    def push_rpc_response(response_id, response_hash)
      @local_redis.set( Forbus.rpc_key(response_id), response_hash.to_json, ex: 300 )
    end

  end

end
