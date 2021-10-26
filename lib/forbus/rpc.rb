#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2021-10-25 15:25:00
# @Last Modified by:   msmiller
# @Last Modified time: 2021-10-26 12:31:06
#
# Copyright (c) Sharp Stone Codewerks / Mark S. Miller

# frozen_string_literal: true

module Forbus

  class FORbus

    # Push the response to an RPC request to the local bus with a 5 minute timeout
    #
    # @param request_id The id that was passed by the remote server
    # @param response_hash The data that the request will be waiting to receive
    def push_rpc_response(request_id, response_hash)
      response_hash[:lastupdate] = Time.now
      @local_redis.set( Forbus.rpc_key(request_id), response_hash.to_json, ex: 300 )
    end

    def await_rpc_response(request_id)
    end

    # Payload should include a 'type' or 'kind' as needed
    def make_rpc_request(payload)
      # push onto local bus as command
    end

  end

end
